# Architecture

[中文版本](Architecture.md)

## Goal

EternalClawMemory is designed to preserve Openclaw agent memory across device changes,
system reinstalls, and workspace resets.

It must achieve both:

1. convenient backup / restore / sync
2. ciphertext-only cloud storage when encryption is enabled

## Layers

### Local client layer

- reads memory files
- packages JSON
- encrypts locally
- decrypts locally
- restores files locally

### Cloud service layer

- registration and login
- authorization and sessions
- metadata management
- encrypted memory upload/download
- up to 3 agent slots per account

### Storage layer

- relational database
- encrypted blob storage
- audit / sync events
