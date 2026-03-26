# Getting Started

[English Version](Getting_Started.en.md)

这份文档说明 EternalClawMemory 当前怎么使用，以及后续云同步流程会如何工作。

## 1. 项目能做什么

EternalClawMemory 用来帮助 Openclaw 在不同设备、不同会话之间保留长期记忆。

目前支持：

- 本地导出
- 本地恢复
- 加密备份
- 从加密 URL 恢复
- 后续的账号化云同步规划

## 2. 安装依赖

先安装 Python 依赖：

```bash
pip install cryptography requests argon2-cffi
```

## 3. 准备记忆文件

当前脚本默认围绕这些文件工作：

- `Agent.md`
- `memory.md`
- `Soul.md`

把这些文件放在你要执行备份脚本的工作目录中。

## 4. 不加密的本地导出

如果你想要一个可直接阅读的 JSON 备份：

```bash
python scripts/backup_local.py
```

恢复方式：

```bash
python scripts/restore_local.py backups/backup_YYYYMMDD_HHMMSS.json
```

## 5. 加密本地导出

如果你希望在离开本地设备之前就完成加密：

```bash
python scripts/backup_secure.py --password "your-password"
```

这会在 `backups/` 下生成一个加密 `.blob` 文件。

注意：

- 请妥善保存加密密码
- 当前产品方向是零知识存储
- 如果你忘记加密密码，云端不应有能力帮你恢复明文

## 6. 从加密 URL 恢复

如果你已经把加密 blob 放在可访问的地址：

```bash
python scripts/restore_secure.py --url "https://example.com/backup.blob" --password "your-password"
```

下载在前，解密在本地进行。

## 7. 在 Openclaw 中使用

`memory-sync` Skill 已发布：

https://clawhub.ai/applied-energetic/eternalmemory-sync

典型提示词：

- "Backup my current memory with password `secret123`."
- "Restore my memory from this backup link with password `secret123`."
- "Sync Agent 2 from my account."

如果 Skill 的接口或行为变化，请同步更新 ClawHub 发布版本。

## 8. 规划中的云工作流

Vercel 站点已经部署：

https://eternal-claw-memory-sync-2m748uwcd.vercel.app/

预期中的云流程：

1. 用户在网站注册账号
2. 完成登录和安全验证
3. 管理最多 3 个 Agent 记忆槽位
4. 上传加密记忆 blob
5. 选择要同步或恢复的记忆
6. 把密文下载到本地设备
7. 在本地用用户自己的密码解密

## 9. 安全边界

项目希望明确分离三件事：

- 网站负责账号认证
- 本地设备负责解密
- 云端在加密流程中只存储密文，不存储明文记忆

这意味着网站可以管理访问权限和记录，但不应该成为记忆明文的持有者。

## 10. 每账号限制

当前产品计划是每个账号最多管理 3 个 Agent 记忆。

这样既能满足常见使用场景，也能在早期版本保持：

- 数据模型清晰
- UI 易于管理
- 存储和权限边界更容易控制

## 11. 当前推荐流程

在账号系统完成之前，最安全的实际工作流是：

1. 本地加密导出
2. 保存 `.blob`
3. 上传到自己控制的存储
4. 需要时通过 URL 恢复

## 12. 下一里程碑

下一阶段的目标是基于 Vercel 的账号化密文同步，包括注册、登录、槽位选择和安全密文存储。
