-- EternalClawMemory PostgreSQL schema
-- Cloud stores account data, metadata, and ciphertext references.
-- Plaintext memory and local decryption passwords must stay on the client side.

create extension if not exists pgcrypto;

do $$
begin
    if not exists (select 1 from pg_type where typname = 'user_status') then
        create type user_status as enum ('active', 'pending_verification', 'disabled');
    end if;
    if not exists (select 1 from pg_type where typname = 'memory_encryption_mode') then
        create type memory_encryption_mode as enum ('plaintext', 'client_encrypted');
    end if;
    if not exists (select 1 from pg_type where typname = 'memory_source') then
        create type memory_source as enum ('local_upload', 'skill_upload', 'dashboard_upload', 'system_import');
    end if;
    if not exists (select 1 from pg_type where typname = 'sync_event_type') then
        create type sync_event_type as enum ('register', 'login', 'logout', 'slot_created', 'slot_updated', 'memory_uploaded', 'memory_downloaded', 'memory_deleted');
    end if;
end $$;

create table if not exists users (
    id uuid primary key default gen_random_uuid(),
    email text not null unique,
    password_hash text not null,
    display_name text,
    status user_status not null default 'pending_verification',
    email_verified_at timestamptz,
    last_login_at timestamptz,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create table if not exists sessions (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    session_token_hash text not null unique,
    ip_address inet,
    user_agent text,
    expires_at timestamptz not null,
    created_at timestamptz not null default now()
);

create index if not exists idx_sessions_user_id on sessions(user_id);
create index if not exists idx_sessions_expires_at on sessions(expires_at);

create table if not exists email_verification_tokens (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    token_hash text not null unique,
    expires_at timestamptz not null,
    used_at timestamptz,
    created_at timestamptz not null default now()
);

create table if not exists password_reset_tokens (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    token_hash text not null unique,
    expires_at timestamptz not null,
    used_at timestamptz,
    created_at timestamptz not null default now()
);

create table if not exists agent_slots (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    slot_index smallint not null,
    agent_name text not null,
    description text,
    is_active boolean not null default true,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now(),
    constraint chk_agent_slot_index_range check (slot_index between 1 and 3),
    constraint uq_agent_slots_user_slot unique (user_id, slot_index)
);

create index if not exists idx_agent_slots_user_id on agent_slots(user_id);

create table if not exists memory_records (
    id uuid primary key default gen_random_uuid(),
    user_id uuid not null references users(id) on delete cascade,
    agent_slot_id uuid not null references agent_slots(id) on delete cascade,
    title text not null,
    current_version integer not null default 1,
    encryption_mode memory_encryption_mode not null,
    source memory_source not null,
    is_deleted boolean not null default false,
    created_at timestamptz not null default now(),
    updated_at timestamptz not null default now()
);

create index if not exists idx_memory_records_user_id on memory_records(user_id);
create index if not exists idx_memory_records_agent_slot_id on memory_records(agent_slot_id);

create table if not exists memory_versions (
    id uuid primary key default gen_random_uuid(),
    memory_record_id uuid not null references memory_records(id) on delete cascade,
    version_number integer not null,
    blob_storage_key text not null,
    blob_checksum_sha256 text,
    size_bytes bigint not null default 0,
    uploaded_by_user_id uuid references users(id) on delete set null,
    uploaded_at timestamptz not null default now(),
    notes text,
    constraint uq_memory_versions_record_version unique (memory_record_id, version_number)
);

create index if not exists idx_memory_versions_record_id on memory_versions(memory_record_id);

create table if not exists sync_events (
    id uuid primary key default gen_random_uuid(),
    user_id uuid references users(id) on delete cascade,
    agent_slot_id uuid references agent_slots(id) on delete set null,
    memory_record_id uuid references memory_records(id) on delete set null,
    event_type sync_event_type not null,
    ip_address inet,
    user_agent text,
    metadata jsonb not null default '{}'::jsonb,
    created_at timestamptz not null default now()
);

create index if not exists idx_sync_events_user_id on sync_events(user_id);
create index if not exists idx_sync_events_created_at on sync_events(created_at desc);

create or replace function set_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

drop trigger if exists trg_users_updated_at on users;
create trigger trg_users_updated_at
before update on users
for each row execute function set_updated_at();

drop trigger if exists trg_agent_slots_updated_at on agent_slots;
create trigger trg_agent_slots_updated_at
before update on agent_slots
for each row execute function set_updated_at();

drop trigger if exists trg_memory_records_updated_at on memory_records;
create trigger trg_memory_records_updated_at
before update on memory_records
for each row execute function set_updated_at();
