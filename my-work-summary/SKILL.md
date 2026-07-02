---
name: my-work-summary
description: Summarize the user's actual completed work when they ask to review yesterday's work, the last few days, or the current phase. Use this skill to inspect current project changes, git log, git diff, recent files, commit history, README, AGENTS.md, CLAUDE.md, task notes, deployment and configuration files, SQL changes, Docker and environment configuration, script updates, terminal traces, and the current session, then group the evidence into concise to-do style objects, corresponding completed items, and next-step plans. Do not summarize by file, by chat history, or by commit list. Do not fabricate outcomes that are not supported by evidence.
---

# My Work Summary

Use this skill when the user says things like:

- “总结一下昨天做了什么”
- “总结一下前两天工作”
- “回顾一下最近的工作”
- “这段时间我干了什么”
- “总结昨天工作”
- “总结最近几天工作”
- “总结本阶段工作”

The task is not to generate a daily report, weekly report, chat recap, or commit digest.

The task is to summarize what work the user actually completed.

The final output should be concise and suitable for a project management tool.

## Core Goal

Turn scattered technical evidence into grouped work items.

Do not summarize by:

- file
- commit
- chat turn
- command chronology

Summarize by:

- work item
- technical package
- problem-solving thread
- phase outcome

But present the final answer in a short list format rather than a long report.

For each completed work item, also generate a matching planned-object phrasing that can be recorded as a to-do and then marked completed.

Example:

Bad:

- modified `application.yml`
- modified `docker-compose.yml`
- modified `nginx.conf`

Good:

- completed deployment configuration and environment management optimization
- consolidated environment variable management rules
- optimized Docker deployment structure
- improved Nginx reverse proxy and service routing configuration
- unified service startup and deployment coordination

## Evidence Sources

When the user asks for a work summary, automatically inspect as many of these sources as are available:

1. current project code changes
2. `git log`
3. `git diff`
4. recently modified files
5. commit history
6. project documents
7. `README`
8. `AGENTS.md`
9. `CLAUDE.md`
10. current session
11. task records
12. deployment files
13. configuration files
14. SQL changes
15. Docker configuration
16. environment configuration
17. script changes
18. terminal logs, command traces, and error output when accessible

If some sources are unavailable, continue with the accessible evidence and soften unsupported claims.

## Required Behavior

When the user gives a brief request such as “总结昨天工作”, do this automatically:

1. infer the date range from the system date and the user's wording
2. inspect repository changes and recent history
3. inspect high-signal project docs and task records
4. inspect available terminal traces and error logs
5. combine with the current session context
6. merge related small changes into work items
7. generate the final summary directly

Do not ask the user to manually整理材料 first unless a missing date range makes the request materially ambiguous.

## Time Range Defaults

Use these defaults unless the user gives exact dates:

- “昨天”: previous calendar day
- “前两天”: the two full calendar days before today
- “最近几天”: recent visible work, usually the last several days supported by repo evidence
- “本阶段” or “这段时间”: current visible work period inferred from recent commits, modified files, docs, and current session

If the visible evidence only partially covers the requested period, still produce the summary and reflect the uncertainty conservatively in the wording.

## Summary Principles

### 1. Summarize actual work, not raw traces

Do not write:

- a file list
- a commit list
- a terminal replay
- a chat transcript

Write what the user actually advanced, adjusted, designed, verified, troubleshot, or consolidated.

### 2. Merge small changes automatically

Multiple small edits must be merged into one meaningful work item when they belong to the same objective, such as:

- deployment and environment management optimization
- configuration governance and sensitive information cleanup
- SQL or data structure adjustment
- front-end and back-end interface alignment
- script and automation refinement
- logging, dependency, and error troubleshooting

### 3. Emphasize work value

Each work item should make the work visible through:

- workload
- technical depth
- advancement process
- problem-solving ability

Do not focus on number of changed files.

### 4. Use evidence-proportional wording

If the evidence shows implementation and verification, describe it clearly.

If the evidence only shows design, investigation, or discussion, write it as:

- completed xx solution research and technical route design
- completed preliminary architecture planning
- carried out troubleshooting and verification for xx issue
- formed an initial deployment or configuration adjustment scheme

Do not present uncertain work as already online, fully released, or fully completed.

### 5. Never fabricate

Do not invent:

- launch results
- external collaboration outcomes
- production effects
- completed business milestones
- resolved issues without supporting evidence

## Output Structure

Always use the structure in [summary_template.md](./summary_template.md).

Required sections:

- `O（object，待办版本，对应后面完成事项）：`
- numbered items written as plan / to-do statements
- `完成事项：`
- numbered items corresponding to the `O` items above
- `下步计划：`
- numbered items for next steps

Do not expand into separate sections such as “遇到的问题 / 解决过程 / 当前成果” unless the user explicitly asks for a detailed version.

### O section rules

The `O` section is for project-management entry. Each item should be phrased like a planned task, for example:

- 完成部署配置与环境管理优化
- 推进前后端接口字段对齐与联调修正
- 开展日志问题排查与依赖兼容性修复

Then the `完成事项` section should describe the same item as an actually completed or completed-in-this-phase outcome, for example:

- 完成了部署配置与环境管理优化，梳理了环境变量、Docker 编排和服务启动配置

The `O` items and `完成事项` items should correspond in order as much as possible.

## Writing Guidance

The tone should be professional and direct. The summary should read like a real work report, not like an AI recap.

Preferred focus:

- what was pushed forward
- what technical work was actually done
- what problems were found
- how they were analyzed and handled
- what current results or reusable outputs were formed

Avoid exaggerated language. Avoid empty formal phrasing. Avoid sounding like release notes.

Keep each item compact, but let the wording reflect real workload and technical depth.

The `O` section should be even shorter than the `完成事项` section.

## Final Limitation Note

If the available evidence is incomplete, append this line at the end:

`本总结基于当前仓库可见改动、当前会话上下文和可访问日志整理，可能不包含未记录在仓库或当前上下文中的外部讨论。`

## Output Checklist

Before sending the final summary, verify:

- it is organized by work item rather than files or commits
- related small changes have been merged
- each completed item is concise but still reflects workload and technical depth
- claims are proportional to evidence
- uncertain work is described as design, planning, research, verification, or troubleshooting when appropriate
- no unsupported上线 or完成 assertions are present
- the final output contains only `O（object，待办版本，对应后面完成事项）`、`完成事项` and `下步计划` unless the user asks for more detail
- the `O` items correspond clearly to the completed items below them
