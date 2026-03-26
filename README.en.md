# EternalClawMemory

[中文版本](README.md)

EternalClawMemory is a memory backup and synchronization project for Openclaw agents.
Its goal is simple: let users export, encrypt, upload, restore, and synchronize an
agent's long-term memory without ever exposing plaintext memory to the cloud.

The local device is responsible for reading memory files, packaging them, and
optionally encrypting them. The cloud only stores ciphertext, metadata, and account
information required for management and synchronization.

## Live Links

- Website: https://eternal-claw-memory-sync-2m748uwcd.vercel.app/
- GitHub: https://github.com/Applied-Energetic/EternalClaw-Memory-Sync
- ClawHub Skill: https://clawhub.ai/applied-energetic/eternalmemory-sync

## Current Project Position

The repository is currently in a transition stage between "local secure backup
prototype" and "full cloud sync product."

Already available:

- Local plaintext export flow
- Local encrypted export flow
- Local restore flow
- Restore from URL with password
- Initial Openclaw skill packaging
- Static landing page deployed on Vercel

In progress / next major milestone:

- Vercel backend for account and memory management
- User registration and login
- Secure cloud-side ciphertext storage
- Per-account management of up to 3 agent memories
- Website-based onboarding and sync selection flow

## Core Product Idea

EternalClawMemory is built around four principles:

1. Local-first encryption
2. Zero-knowledge cloud storage
3. Flexible import and export
4. Agent-oriented memory management

## Documentation

- [中文入门文档](docs/Getting_Started.md)
- [English Getting Started](docs/Getting_Started.en.md)
- [中文架构设计](docs/Architecture.md)
- [English Architecture](docs/Architecture.en.md)
- [中文后端方案](docs/Backend_Design.md)
- [English Backend Design](docs/Backend_Design.en.md)
- [中文产品规划](docs/Product_Plan.md)
- [English Product Plan](docs/Product_Plan.en.md)
- [中文路线图](docs/Roadmap.md)
- [English Roadmap](docs/Roadmap.en.md)
