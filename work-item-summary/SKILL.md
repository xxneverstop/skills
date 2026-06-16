---
name: work-item-summary
description: Turn the current conversation context or user-provided material into a concise three-part work summary using `O（object，待办版本，对应后面完成事项）` / `完成事项` / `下步计划`. Use when the user asks to "总结成一项工作", "整理成工作项", "按 O/完成事项/下步计划 输出", "润色成周报格式", or wants an existing discussion rewritten into a short project-management style item. Prefer this skill for lightweight formatting and summarization of already-known context, not for deep repo mining or multi-day forensic work reconstruction.
---

# Work Item Summary

## Overview

Convert the current context into a short project-management summary with three fixed sections:

1. `O（object，待办版本，对应后面完成事项）：`
2. `完成事项：`
3. `下步计划：`

Default to one work item only unless the user explicitly asks for multiple items.

## Workflow

### 1. Decide the evidence scope

Use the lightest reliable scope first.

Default evidence scope:

1. the current conversation
2. user-provided reference text in the current turn
3. immediately relevant files or outputs already discussed in the thread

Do not proactively dig through large amounts of repo history, git logs, or many files unless the user explicitly asks for a broader work recap.

### 2. Extract the real work theme

Collapse the available context into one concrete work theme.

Good examples:

1. completed ZED + IMU integration requirement clarification
2. completed deployment plan refinement and standardization
3. completed task model and data asset design analysis

Avoid turning one small request into multiple fragmented work items unless the user explicitly asks for a split.

### 3. Write the three required sections

Always use exactly these sections in this order:

1. `O（object，待办版本，对应后面完成事项）：`
2. `完成事项：`
3. `下步计划：`

Rules:

1. `O` is phrased as a planned task.
2. `完成事项` is phrased as a completed outcome corresponding to the `O` item above.
3. `下步计划` is phrased as the immediate next push, not a long roadmap.

When the user asks for "一项即可", keep each section to one numbered item.

## Writing Rules

### Keep it concise

This skill is for compact formatting, not long reporting.

Prefer:

1. one work item
2. one corresponding completion item
3. one next-step item

### Preserve evidence boundaries

Do not invent:

1. launch results
2. external collaboration outcomes
3. completed implementation that is not shown in context
4. outcomes that were never discussed in the current thread

If the current context shows only requirement clarification, solution design, document drafting, review preparation, or troubleshooting, write it that way.

### Match the user’s requested granularity

If the user asks for:

1. “一项工作” -> produce one item only
2. “几项” or “拆成多项” -> split by independent work theme
3. “参考这个格式” -> keep the same headings and numbering style

### Prefer management language over implementation detail

Do not summarize by file list, command list, or exact chat chronology.

Prefer wording such as:

1. 完成……需求梳理与标准化整理
2. 完成……方案设计与边界明确
3. 继续推进……对齐与落地实施

## Output Template

Use this exact structure:

```text
O（object，待办版本，对应后面完成事项）：

1. 完成……


完成事项：

1. 完成了……


下步计划：

1. 继续推进……
```

## Style Checklist

Before responding, verify:

1. the output has exactly the three required sections
2. the `O` item and `完成事项` item clearly correspond
3. the wording reflects the actual work scope without exaggeration
4. the result is short and directly reusable in weekly syncs, task records, or project management notes
