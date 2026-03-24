# EternalClawMemory - 架构设计文档

## 1. 项目概述
本项目旨在为 Openclaw 提供**永久记忆存储与安全同步**方案。确保在系统重装、迁移或意外挂掉时，能够通过**加密**的方式快速恢复关键记忆文件（如 `Agent.md`, `memory.md`, `Soul.md` 等）。核心机制包括本地 JSON 打包、高强度加密以及便捷的 Skill 集成。

## 2. 系统架构

### 2.1 整体架构图

```mermaid
graph TD
    subgraph "Openclaw Local Environment"
        Op[Openclaw Agent]
        Files[Memory Files<br/>(Agent.md, Soul.md...)]
        Skill[Memory Sync Skill]
        
        subgraph "Secure Core (Python)"
            Packer[JSON Packer]
            Crypto[AES-256 Encrypt/Decrypt]
            Unpacker[JSON Unpacker]
        end
        
        Op -->|Uses| Skill
        Skill -->|Invokes| Packer
        Files -->|Read| Packer
        Packer -->|JSON| Crypto
        Crypto -->|Encrypted Blob| LocalStorage[Local File<br/>.blob]
        Crypto -->|Decrypted JSON| Unpacker
        Heading[Cloud URL] -->|Download| Crypto
        Unpacker -->|Write| Files
    end

    subgraph "Cloud Service (Vercel)"
        API_Backup[POST /api/backup]
        API_Restore[GET /api/restore]
    end

    subgraph "Storage Layer"
        GitHub[(GitHub Private Repo)]
        BlobStore[Vercel Blob (Optional)]
    end

    %% Data Flow
    LocalStorage -.->|Manual/Auto Upload| API_Backup
    API_Backup -->|Store Encrypted| GitHub
    GitHub -->|Serve Encrypted| API_Restore
```

## 3. 核心机制

### 3.1 打包与数据结构 (packing)
所有记忆文件被打包为一个单一的 JSON 对象。
```json
{
  "timestamp": "2026-03-23T10:00:00Z",
  "version": "1.0",
  "files": {
    "Agent.md": "Raw Content...",
    "Soul.md": "Raw Content..."
  }
}
```

### 3.2 安全加密层 (Security Layer)
为了保证数据在云端存储和传输过程中的绝对安全，采用以下加密方案：
- **算法**: AES-256-GCM (Galois/Counter Mode) 提供保密性和完整性校验。
- **密钥派生**: 使用 **Argon2id** 算法将用户输入的密码转换为 32 字节的加密密钥。
- **盐值 (Salt) 与 Nonce**: 随机生成并在密文中携带，防止彩虹表攻击和重放攻击。
- **流程**:
  - **加密**: `Raw JSON` -> `Compress (Optional)` -> `Encrypt (Password)` -> `Base64 Blob`.
  - **解密**: `Base64 Blob` -> `Decrypt (Password)` -> `Verify Identity` -> `Restore Files`.

**隐私承诺**: 即使是云端管理员（Vercel/GitHub 拥有者）也无法查看记忆内容，因为私钥（密码）仅掌握在用户手中。

### 3.3 Skill 集成 (Memory Sync Skill)
为了方便 Openclaw 直接调用，我们封装了 `memory-sync` Skill。
- **功能**:
  1. **Get Memory**: `python scripts/restore_secure.py --url <URL> --password <PWD>`
  2. **Push Memory**: `python scripts/backup_secure.py --password <PWD>`
- **优势**: Openclaw 可以理解用户的自然语言指令（如“从我的云端备份恢复记忆”），并自动调用底层加密脚本执行操作。

## 4. 部署方案

### 方案 A: 本地安全备份 (Local Secure)
- 用户手动运行脚本，生成加密的 `.blob` 文件。
- 用户自行保存该文件（U盘、NAS、网盘）。

### 方案 B: 云端托管 (Cloud Managed)
- **前端**: Next.js 提供的 Web UI，允许用户上传 `.blob` 文件或查看历史版本。
- **后端**: Vercel Serverless Functions 接收加密数据并存储至 GitHub。
- **恢复**: 用户在 Openclaw 中提供文件的直接链接 (Raw URL)，Agent 自动下载并解密。

## 5. 技术栈
- **Core Logic**: Python 3.x (`cryptography`, `requests`)
- **Integration**: VS Code Skills (Markdown defined)
- **Cloud**: Next.js (App Router), Vercel
- **Storage**: GitHub API / Vercel Blob
