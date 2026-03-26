# Getting Started

[中文版本](Getting_Started.md)

This guide explains how to use EternalClawMemory today and how the planned cloud flow
will work next.

## 1. What the project does

EternalClawMemory helps you preserve Openclaw agent memory across machines and sessions.
It supports:

- local export
- local restore
- encrypted backup
- restore from encrypted URL
- future account-based cloud sync

## 2. Install dependencies

```bash
pip install cryptography requests argon2-cffi
```

## 3. Prepare your memory files

The current scripts are built around files such as:

- `Agent.md`
- `memory.md`
- `Soul.md`

## 4. Local export without encryption

```bash
python scripts/backup_local.py
```

Restore:

```bash
python scripts/restore_local.py backups/backup_YYYYMMDD_HHMMSS.json
```

## 5. Local export with encryption

```bash
python scripts/backup_secure.py --password "your-password"
```

This creates an encrypted `.blob` under `backups/`.

## 6. Restore from an encrypted URL

```bash
python scripts/restore_secure.py --url "https://example.com/backup.blob" --password "your-password"
```

## 7. Use in Openclaw

Skill page:

https://clawhub.ai/applied-energetic/eternalmemory-sync

Typical prompts:

- "Backup my current memory with password `secret123`."
- "Restore my memory from this backup link with password `secret123`."
- "Sync Agent 2 from my account."

## 8. Planned cloud workflow

1. Register on the website
2. Complete login and security checks
3. Manage up to 3 agent memory slots
4. Upload encrypted memory blobs
5. Select a memory to sync or restore
6. Download ciphertext locally
7. Decrypt locally with the user's own password
