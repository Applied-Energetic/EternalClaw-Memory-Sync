# Backend Design

[中文版本](Backend_Design.md)

## Goal

The backend should not decrypt user memory. It should provide:

- registration and login
- secure sessions
- agent slot management
- ciphertext upload/download
- audit and sync event records

## Recommended stack

- Vercel
- Next.js App Router + Route Handlers
- PostgreSQL
- Vercel Blob or S3-compatible storage
- Drizzle ORM
- Auth.js or custom credentials auth
- Argon2id password hashing
