---
description: Read-only Q&A mode — answer the question directly, reading files as needed, but never modifying anything. Use when user invokes /just-answer.
argument-hint: [question]
arguments: question
---

直接回答 `$question` 的问题。

## 核心规则

**只读不改。** 可以按需读取文件、搜索代码来确保回答准确，但绝不编辑、不写入、不删除、不执行任何会改动系统状态的操作。回答完问题就结束。
