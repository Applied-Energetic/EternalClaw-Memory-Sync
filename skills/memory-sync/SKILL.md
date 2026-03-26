---
slug: memory-sync
display_name: EternalClaw Memory Sync
description: Backup and restore Openclaw memory locally or from encrypted remote blobs, with future cloud sync alignment.
author: Applied-Energetic
version: 1.2.0
tags: [memory, sync, backup, restore, encryption, agent-state]
license: MIT-0
---

# EternalClaw Memory Sync

中文默认，英文简述见文末。

## 当前能力

- 本地加密备份
- 从加密远程 URL 恢复
- 与 EternalClawMemory 网站和后续云同步路线保持一致

## 备份记忆

在仓库根目录执行：

```bash
python scripts/backup_secure.py --password "<YOUR_PASSWORD>"
```

它会读取配置中的记忆文件，在本地加密，并在 `backups/` 下生成 `.blob` 文件。

## 从加密 URL 恢复

```bash
python skills/memory-sync/scripts/restore_secure.py --url "<YOUR_BACKUP_URL>" --password "<YOUR_PASSWORD>"
```

它会下载密文 blob，在本地解密，然后恢复记忆文件。

## 依赖

```bash
pip install cryptography requests argon2-cffi
```

## 典型 Openclaw 提示词

- "Backup my current memory with password `secret123`."
- "Restore my memory from this backup link with password `secret123`."
- "Sync Agent 2 from my account."

第三个例子对应未来的账号化云同步流程，仍需要后续网站和后端能力补齐。

## 安全说明

- 加密应在本地发生
- 解密应在本地发生
- 如果启用加密，云端只应接触密文
- 如果 Skill 行为变化，请同步更新 ClawHub 发布页

## English Summary

This skill helps Openclaw users back up memory locally with encryption and restore it
from encrypted remote URLs. The longer-term product direction is account-based cloud
sync, while keeping encryption and decryption on the client side.
