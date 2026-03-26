# EternalClawMemory

[English Version](README.en.md)

EternalClawMemory 是一个面向 Openclaw 的记忆备份、恢复与同步项目。
项目的核心目标是：让用户可以在本地导出、加密、上传、恢复和同步 Agent
的长期记忆，同时尽量不让云端接触任何明文记忆内容。

本地设备负责读取记忆文件、打包、可选加密与解密；云端负责账号、元数据、
密文存储和同步管理。只要用户启用了加密，云端就只应保存密文。

## 在线地址

- Website: https://eternal-claw-memory-sync-2m748uwcd.vercel.app/
- GitHub: https://github.com/Applied-Energetic/EternalClaw-Memory-Sync
- ClawHub Skill: https://clawhub.ai/applied-energetic/eternalmemory-sync

## 当前项目阶段

当前仓库正处在“本地安全备份原型”向“完整云同步产品”过渡的阶段。

已经具备：

- 本地明文导出
- 本地加密导出
- 本地恢复
- 通过 URL 恢复加密备份
- 初版 Openclaw Skill
- 已部署的 Vercel 静态站点

正在推进：

- Vercel 后端与账号系统
- 用户注册、登录和安全验证
- 云端密文存储
- 每个账号最多 3 个 Agent 记忆槽位
- 网站化的引导、管理与同步流程

## 核心产品思想

项目围绕四个原则展开：

1. 本地优先加密
   明文记忆只在用户本地处理；如果启用加密，加密也在本地完成。
2. 零知识云存储
   服务器只保存密文和必要元数据，不保存用户记忆明文，也不应持有解密密码。
3. 灵活导入导出
   用户既可以只做本地导出，也可以上传到云端；既可以从本地恢复，也可以从云端或 URL 恢复。
4. 面向 Agent 的记忆管理
   每个账号可管理最多 3 个独立 Agent 的记忆，便于区分主助手、实验助手和备用助手。

## 支持的使用模式

### 1. 本地导出

- 把记忆文件导出成 JSON
- 可选导出成加密 `.blob`
- 保存到本地、NAS、网盘或其他介质

### 2. 本地恢复

- 从本地 JSON 恢复
- 从本地加密包解密后恢复

### 3. 远程恢复

- 通过 URL 下载加密 blob
- 在本地用密码解密
- 恢复目标记忆文件

### 4. 规划中的云同步

- 用户登录网站
- 上传加密记忆或管理已有记录
- 在最多 3 个 Agent 槽位中选择一个
- 由 Openclaw 或用户拉取所选密文，在本地完成恢复

## 仓库结构

```text
EternalClawMemory/
|-- docs/
|   |-- Architecture.md
|   |-- Architecture.en.md
|   |-- Backend_Design.md
|   |-- Backend_Design.en.md
|   |-- Getting_Started.md
|   |-- Getting_Started.en.md
|   |-- Product_Plan.md
|   |-- Product_Plan.en.md
|   `-- Roadmap.md
|-- database/
|   `-- schema.sql
|-- scripts/
|   |-- backup_local.py
|   |-- backup_secure.py
|   |-- restore_local.py
|   |-- restore_secure.py
|   `-- crypto_utils.py
|-- skills/
|   `-- memory-sync/
|-- web/
|   `-- landing/
|       |-- index.html
|       |-- index.en.html
|       |-- getting-started.html
|       |-- getting-started.en.html
|       `-- vercel.json
|-- README.md
`-- README.en.md
```

## 本地脚本

### 明文导出

```bash
python scripts/backup_local.py
```

### 加密导出

```bash
python scripts/backup_secure.py --password "your-password"
```

### 明文恢复

```bash
python scripts/restore_local.py backups/backup_YYYYMMDD_HHMMSS.json
```

### 从 URL 恢复加密记忆

```bash
python scripts/restore_secure.py --url "https://example.com/backup.blob" --password "your-password"
```

## Openclaw 使用方向

`memory-sync` Skill 已经发布在 ClawHub，目标是给 Openclaw 提供自然语言入口。

典型用法：

- “Backup my current memory with password `secret123`.”
- “Restore my memory from this link and use password `secret123`.”
- “Sync the memory of Agent B from my cloud account.”

如果后续 Skill 接口或文案有变化，记得同步更新 ClawHub 发布页。

## 安全模型

- 加密应发生在客户端
- 服务端只接收密文和非敏感元数据
- 密码不能以明文上传
- 云端不应具备重构用户明文记忆的能力
- 账号认证与会话控制负责保护访问权限
- 后续云同步会把“账号密码”和“本地解密密码”分离

详见：

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

## 近期优先级

1. 完成面向用户的网站文档和双语入口
2. 落地 Vercel 后端与安全登录流程
3. 落地数据库 schema 与三 Agent 限制
4. 实现密文上传、下载与同步 API
5. 把网站工作流与本地脚本、Openclaw Skill 接起来

## 说明

仓库仍在快速演进中。当前文档已经按目标产品形态进行了补齐，部分能力仍处于设计或待开发状态。
