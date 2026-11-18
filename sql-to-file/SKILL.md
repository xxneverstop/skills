---
name: sql-to-file
description: Generate SQL migration files for all database changes instead of executing them directly. Use when Claude needs to create, alter, or modify database schemas, tables, indexes, views, triggers, stored procedures, or any DDL/DML/DCL operations. Triggers on keywords: database, SQL, table, schema, migration, DDL, DML, DCL, column, index, constraint, view, trigger, procedure, function, alter table, create table, insert into, update, delete from.
---

# SQL to File

当 Claude 在项目中涉及数据库改动时，**绝不直接执行 SQL 命令**，而是将所有 SQL 写入独立的 `.sql` 迁移文件，由用户手动在 Navicat 中执行。

## 核心规则

1. **不执行 SQL。** 永远不通过命令行、数据库客户端等方式直接执行 SQL 语句
2. **写入文件。** 所有数据库改动 SQL 必须写入 `/database-migrations/` 目录下的 `.sql` 文件
3. **手动执行。** 用户自行在 Navicat 中打开 SQL 文件并执行

## 触发条件

以下任何情况都必须遵循此规则：

- 创建/修改/删除表（CREATE TABLE / ALTER TABLE / DROP TABLE）
- 创建/修改/删除索引（CREATE INDEX / DROP INDEX）
- 创建/修改/删除视图（CREATE VIEW / DROP VIEW）
- 创建/修改/删除触发器（CREATE TRIGGER / DROP TRIGGER）
- 创建/修改/删除存储过程/函数（CREATE PROCEDURE / FUNCTION）
- 数据迁移/修复（INSERT / UPDATE / DELETE 用于数据变更）
- 权限变更（GRANT / REVOKE）
- 任何其他 DDL、DML、DCL 语句

## 文件命名规范

格式：`YYYY-MM-DD-{功能描述}.sql`

- 日期为当天日期
- 功能描述用英文、kebab-case、简洁明了
- 如果当天有多个迁移，可以加序号：`2026-08-01-add-user-table.sql`、`2026-08-01-update-order-index.sql`

示例：
```
database-migrations/
├── 2026-08-01-create-user-table.sql
├── 2026-08-01-add-email-index.sql
├── 2026-08-02-alter-order-add-status.sql
└── 2026-08-03-update-permissions.sql
```

## SQL 文件格式

每个 SQL 文件必须包含清晰的注释：

```sql
-- ============================================
-- 迁移: 创建用户表
-- 日期: 2026-08-01
-- 描述: 新建 users 表，包含基本用户信息字段
-- ============================================

CREATE TABLE users (
    id          BIGINT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE COMMENT '用户名',
    email       VARCHAR(100) NOT NULL COMMENT '邮箱',
    password    VARCHAR(255) NOT NULL COMMENT '密码哈希',
    status      TINYINT      NOT NULL DEFAULT 1 COMMENT '状态: 1=启用, 0=禁用',
    created_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='用户表';

-- 如果需要回滚，执行以下 SQL：
-- DROP TABLE IF EXISTS users;
```

## 执行步骤

1. **检测数据库改动。** 判断用户的请求是否涉及上述任何 DDL/DML/DCL 操作

2. **确认目录。** 确保项目根目录下存在 `database-migrations/` 目录。如果不存在，创建它

3. **生成 SQL 文件。**
   - 按照命名规范生成文件名
   - 文件头部包含迁移注释块（迁移名、日期、描述）
   - 写出完整的 SQL 语句
   - 如有对应的回滚 SQL，以注释形式附加在末尾

4. **通知用户。** 完成后告知用户：
   - 文件路径
   - 文件中包含的 SQL 操作摘要
   - 提醒用户在 Navicat 中手动执行

## 多表改动

如果一次请求涉及多个不相关的数据库改动（如同时创建用户表和订单表），合并到一个 SQL 文件还是拆分成多个文件，遵循以下原则：

- **拆分为多个文件**：当改动涉及不同的业务领域、可以独立回滚、或用户明确要求分开时
- **合并为一个文件**：当改动相互依赖（如创建外键关联的表）、属于同一功能模块的完整迁移

## 重要提醒

- SQL 文件中的 SQL 语句可以直接在 Navicat 中执行，无需修改
- 所有表名、字段名加上反引号（MySQL）或双引号（PostgreSQL），避免关键字冲突
- 确保 SQL 语句以分号 `;` 结尾，Navicat 通常按分号分割执行
- 如果涉及生产数据库，额外添加 `-- ⚠️ 生产环境注意` 的警告注释
