# EternalClawMemory - 项目实施路线图 (Roadmap)

## 第一阶段：本地核心机制与安全 (Secure Core)
目标：实现基于 Python 的本地加密备份与恢复工具。

- [x] **1.1. 安全算法库 (Security Lib)**
  - 实现 `scripts/crypto_utils.py`：封装 AES-256-GCM + Argon2id。
  - 确保加密/解密流程的正确性和安全性。

- [ ] **1.2. JSON 打包与加密 (Packer)**
  - 完善 `scripts/backup_secure.py`。
  - 读取指定 Markdown 文件 -> JSON -> Crypt -> Blob。

- [ ] **1.3. 解密与还原 (Unpacker)**
  - 完善 `scripts/restore_secure.py`。
  - 从本地路径或 URL 获取 Blob -> Decrypt -> Restore Files。

## 第二阶段：智能体 Skill 集成 (Agent Skills)
目标：让 Openclaw 能够自主操作记忆备份。

- [x] **2.1. Skill 文档编写**
  - 创建 `skills/memory-sync/SKILL.md`。
  - 定义 `restore_secure.py` 和 `backup_secure.py` 的自然语言调用接口。

- [ ] **2.2. 本地测试**
  - 在 VS Code 中安装 Skill。
  - 测试命令："把记忆备份并设置密码为 123456"。

## 第三阶段：云端服务开发 (Cloud Service - Vercel)
目标：搭建 Vercel 服务作为云端中转与管理界面。

- [ ] **3.1. Next.js 项目初始化**
  - 创建 `web/` 目录，初始化项目。
  - 实现文件上传组件（接收 `.blob` 文件）。

- [ ] **3.2. GitHub 存储集成**
  - API `/api/backup` (POST): 接收 Blob 并提交到 GitHub。
  - API `/api/restore` (GET): 提供 Blob 的下载链接。

## 第四阶段：全流程联调 (Integration)
目标：实现 "本地加密 -> 云端存储 -> 异地恢复" 的闭环。

- [ ] **4.1. 跨设备测试**
  - 在设备 A 上生成加密备份。
  - 上传至 Vercel/GitHub。
  - 在设备 B 上通过 URL + 密码恢复。
