# EternalClawMemory (ECM) - Openclaw 永久记忆存储项目

## 项目简介
**EternalClawMemory** 是一个针对 Openclaw 智能体设计的永久记忆备份与恢复系统。即便在系统重装、环境迁移或意外崩溃的情况下，也能通过本工具快速恢复关键记忆文件（如 `Agent.md`, `memory.md`, `Soul.md` 等），确保智能体的连续性与个性不丢失。

该项目采用 **加密 + Skill** 双重保障策略：
1. **端到端加密**: 记忆内容在上传前即被加密（AES-256 + Argon2id），仅持有密码者可解密，云端管理员也无法查看。
2. **Openclaw Skill**: 提供 `memory-sync` Skill，让智能体能够通过自然语言指令自主完成记忆的备份与恢复。

---

## 快速导航
- [架构设计文档 (Architecture)](docs/Architecture.md) - 查看详细加密流程与 Skill 架构
- [开发路线图 (Roadmap)](docs/Roadmap.md) - 查看实施计划

## 核心功能
1. **一键加密快照**: 自动读取并打包所有关键记忆文件，生成加密 Blob。
2. **云端同步**: 通过 URL 上传/下载加密数据。
3. **秒级且安全恢复**: 从 URL 拉取 Blob，在本地解码并还原。

## 目录结构规划
```
EternalClawMemory/
├── docs/                 # 项目文档 (Architecture, Roadmap)
├── scripts/              # 本地 Python 核心工具
│   ├── backup_secure.py  # 加密打包工具
│   ├── restore_secure.py # 下载解密还原工具
│   └── crypto_utils.py   # 安全算法库
├── skills/               # Openclaw Skill
│   └── memory-sync/      # Skill 定义文件
├── web/                  # Next.js 云端服务前端
│   ├── app/              # App Router 页面
│   └── api/              # Serverless API (连接 GitHub)
└── README.md             # 本文件
```

## Skill 快速上手
Openclaw 用户在安装项目后，可以通过以下指令操作记忆：

- **恢复记忆**: "Openclaw，从这个链接恢复我的记忆：`https://example.com/mem.blob`，密码是 `mypassword`"
- **备份记忆**: "Openclaw，把当前记忆加密备份，密码设为 `secret123`"
