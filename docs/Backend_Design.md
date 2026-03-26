# 后端技术方案

[English Version](Backend_Design.en.md)

## 1. 目标

后端的职责不是帮用户解密记忆，而是提供：

- 账号注册和登录
- 会话与安全验证
- Agent 槽位管理
- 密文上传、下载与记录管理
- 审计和同步事件记录

后端的安全边界应明确为：管理访问权限和密文，不处理明文记忆。

## 2. 建议技术栈

推荐第一版采用：

- Runtime: Vercel
- Web / API: Next.js App Router + Route Handlers
- Database: PostgreSQL
- Blob Storage: Vercel Blob 或 S3 兼容对象存储
- ORM / Migration: Drizzle ORM
- Auth: Auth.js 或自建 credentials auth
- Password Hashing: Argon2id

推荐原因：

- 与 Vercel 部署路径一致
- PostgreSQL 适合做关系建模和约束
- Drizzle 便于把 schema 和 migration 一起纳入版本控制
- Auth.js 可以减少登录和 session 基础设施的重复工作

## 3. 模块拆分

### 3.1 认证模块

负责：

- 用户注册
- 用户登录
- 会话签发
- 邮箱验证
- 密码重置
- 限流和风控

### 3.2 槽位模块

负责：

- 创建 Agent 槽位
- 修改名称和描述
- 限制每个账号最多 3 个槽位

### 3.3 记忆管理模块

负责：

- 申请上传
- 记录密文元数据
- 生成下载地址
- 列出历史版本

### 3.4 审计模块

负责：

- 记录登录事件
- 记录上传下载事件
- 记录删除和替换事件

## 4. API 设计建议

建议第一版接口：

- `POST /api/auth/register`
- `POST /api/auth/login`
- `POST /api/auth/logout`
- `POST /api/auth/forgot-password`
- `POST /api/auth/reset-password`
- `GET /api/me`
- `GET /api/agent-slots`
- `POST /api/agent-slots`
- `PATCH /api/agent-slots/:id`
- `GET /api/memory-records`
- `POST /api/memory-records/upload-request`
- `POST /api/memory-records`
- `GET /api/memory-records/:id/download`
- `DELETE /api/memory-records/:id`

## 5. 安全设计

### 认证

- 登录密码只用于账号认证
- 本地解密密码只用于本地加解密
- 两者不混用

### 会话

- HTTP-only secure cookie
- SameSite=Lax 或更严格
- CSRF 防护
- 登录限流

### 数据

- 数据库存元数据
- blob 存密文
- 服务端不保存解密密码

## 6. 开发顺序建议

1. 先落数据库 schema
2. 再落 migration 和 ORM
3. 再实现 auth
4. 再实现槽位管理
5. 再实现 upload / download API
6. 最后接 dashboard 和 Openclaw 工作流
