# my-plan — 可读性优化版（Codex Skill）

一套轻量、可审查的 Coding Agent 开发流程：**生成 Plan → 人工审查 → 执行指定 Plan → 验证 → 生成真实 Build Log**。

本版重点改进：生成的文档**更容易读懂**，但保留工程实施需要的文件、函数、边界和测试信息。

- **先说人话，再讲实现**：开头 30 秒看懂“为什么改、改完怎样”。
- **图文配合**：重要改动用 Before/After 简图；复杂流程用小型 ASCII/Mermaid 图，且每图有一句读图重点。
- **控制术语密度**：重要新概念第一次出现时解释；短句、明确动词、逐层展开。
- **事实清楚**：Plan 写“计划怎么改”，Build Log 写“实际改了什么”；无证据不声称成功。

## 安装

将解压出的整个 `my-plan/` 文件夹放到以下位置之一：

- **项目级（推荐）**：`<项目根目录>/.agents/skills/my-plan/`
- **全局级**：`~/.codex/skills/my-plan/`（或 `$CODEX_HOME/skills/my-plan/`）

如果以前装过 `my-plan`，用新文件夹**完整替换旧版本**。无需安装依赖。若 Codex 未识别，重新启动会话。

## 使用

**1. 只生成 Plan，不改业务代码：**

```text
$my-plan create 给任务执行器增加超时和取消机制
```

生成 `docs/plans/YYYY-MM-DD-NN-xxx.md`。先阅读并修改其中的方案、简图和验收条件。

**2. 人工确认后，执行指定 Plan：**

```text
$my-plan execute docs/plans/2026-11-04-01-task-timeout.md
```

执行后生成同名 `docs/build-logs/YYYY-MM-DD-NN-xxx.md`，用通俗但准确的文字记录真实改动、关键实现、测试结果、风险和人工操作。

`create` / `execute` 是本 Skill 约定的调用参数，**不是 Codex 自带的 CLI 子命令**。示例日期和文件名仅演示格式，实际以生成的路径为准。

## 约束

- `create` 阶段只写 Plan；**绝不自动执行**。
- `execute` 必须由用户明确发起并指定 Plan；以磁盘上**最新版本**为准。
- 尊重原有未提交改动，不擅自 reset / stash / commit / push / deploy。
- 测试未运行就写“未运行”，失败就写失败；不可伪造结果。
- 重大范围或破坏性变更必须先获额外批准。
- 简图只画有依据的流程，不能为了好看虚构模块。

## 文件结构

```text
my-plan/
├── SKILL.md
├── README.md
└── assets/
    ├── writing-guide.md         # 新增：写作与绘图规则、好坏示例
    ├── plan-template.md         # 更易读的 Plan 模板
    └── build-log-template.md    # 更易读的实施记录模板
```
