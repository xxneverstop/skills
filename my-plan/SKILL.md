---
name: my-plan
description: Create easy-to-understand, reviewable implementation plans with concise diagrams, then execute an explicitly selected plan with real verification and a detailed, readable build log. Use for "$my-plan create ..." and "$my-plan execute docs/plans/...md". Never implement in create mode.
---

# my-plan — Plan → Review → Execute → Verify → Build Log

This skill has two modes. `create` and `execute` are arguments to the skill, **not built-in Codex CLI subcommands**:

- `$my-plan create <需求>`: inspect the repository and **only generate a Plan**.
- `$my-plan execute <docs/plans/xxx.md>`: implement the **specified, user-reviewed Plan**, verify the result and write a Build Log.

If the mode is missing, ask which mode the user wants. Never treat `create` as permission to implement. Work from the repository root and follow applicable `AGENTS.md` / repository instructions.

## 0. Output language and readability (mandatory for both modes)

Read **`assets/writing-guide.md` before writing a Plan or Build Log**, and follow it together with the appropriate template. The default document language is **clear, accurate Simplified Chinese** unless the user requests otherwise. Keep code identifiers, paths, flags and API names exactly as in the repository.

**Priority order: understandable → accurate → complete → concise.** Do not increase readability by hiding important constraints or inventing details.

1. **Explain the point before the mechanism.** For every major section answer, in order: **为什么要改 → 改完是什么样 → 具体怎么做**. Start the document with a 30-second overview understandable without reading code.
2. **One idea per paragraph/bullet.** Prefer short sentences, common verbs and direct cause-and-effect statements. Avoid long strings of technical nouns, compressed slash-separated jargon, slogans and redundant background discussion.
3. **Explain terms at first use.** Example: `检查点（checkpoint）：把当前任务进度保存下来，重启后可以接着执行。` Thereafter use the technical term normally. Do not explain common developer terms unnecessarily.
4. **Make abstract changes visible.** Show one grounded `改动前 → 改动后` diagram for every nontrivial Plan. For multi-step behavior or multiple modules, add a **small execution/data-flow diagram** where it genuinely helps. Add state/exception diagrams only where they clarify real complexity. For simple changes, a short ASCII flow is enough. Diagrams must describe actual/proposed code, not decorative concepts.
5. **Keep diagrams small and accompanied by prose.** Normally 3–8 nodes, preferably no more than 10. Use `text`/ASCII for simple flows; Mermaid when branches or relationships make plain text unclear. Immediately below each diagram, explain in 1–3 sentences **what changed**. Label critical edges and make success/failure branches distinguishable. Do not repeat a diagram's content verbatim in paragraphs.
6. **Use concrete facts.** Refer to confirmed files, functions, observed behavior and real commands where available. Separate `已确认` from `待确认`. Do not present proposed behavior as existing behavior.
7. **Layer the detail.** Summary first, then user-visible behavior, then technical design, then file edits and tests. Avoid introducing low-level classes/types in the executive summary. Keep details necessary for implementation in later sections.
8. **Avoid table overload.** Use a table only for real comparison or a short file/test checklist; prefer a few bullets for explanations. Do not create long cells or tables with many columns.
9. **Every statement of benefit must be testable.** Prefer “失败后保留进度，重新启动能继续执行” over “提升可靠性”. Don't claim measured performance without evidence.

**Readability self-check before saving:**
- Can a developer unfamiliar with this submodule state the goal, behavior change and scope after reading section 1?
- Does each nontrivial diagram match the described flow and avoid ungrounded components?
- Are the new terms explained, vague slogans removed, and important branches/boundaries preserved?
- Are paths, tests, acceptance criteria and unknowns still precise enough for a new agent session to execute?
If not, revise the document before finishing.

## 1. Files and naming

- Plan: `docs/plans/YYYY-MM-DD-NN-short-kebab-title.md`
- Build Log: `docs/build-logs/YYYY-MM-DD-NN-short-kebab-title.md`
- **Use the same basename** for the Plan and Build Log. The log must link to the Plan.
- Use the environment's local date. `NN` is the next unused two-digit sequence for that date across both directories; do not overwrite existing files. For later execution, reuse the Plan's original basename/date for the log.
- All references to repository files use repository-relative paths. Don't rename or relocate existing artifacts silently.

## 2. Create mode — plan only

1. **Inspect first.** Read the request, relevant code entry points, current behavior, tests, `AGENTS.md`, and Git status where available. Distinguish repository observations from assumptions. Never fabricate file paths, APIs, test commands or diagrams. Do not edit application code or tests in create mode.
2. **Define the change.** State the goal, observable before/after behavior, what's included and excluded, implementation approach, important design reasons, phases, affected files, tests, risks, rollback and manual steps. Prefer a small coherent solution.
3. **Sketch before detailing.** Create a grounded before/after diagram. For nontrivial flows, add a separate compact main-flow/exception-flow diagram **near the explanation it supports**, not as an appendix of decorative diagrams.
4. **Write the plan.** Read `assets/plan-template.md` and use its section order. Use clear Chinese and fill with actual repository knowledge; do not output raw template placeholders. Mark a genuine unknown as `待确认` and say how it will be verified. Put `status: draft` and the intended build-log path in frontmatter; **never mark approved automatically**.
5. **Finish and stop.** Return the created Plan path, the one-sentence core approach and any blocking review question. **Do not implement, commit, install dependencies, migrate data, deploy or generate a fake Build Log.**

A Plan must remain usable by a new session with repository access. The clear-language rule does **not** excuse missing function-level responsibilities, boundaries, steps or test criteria.

## 3. Review gate

The user may review/edit the Markdown or request revisions. **Only** `$my-plan execute <specific-plan-path>` or an equally unambiguous user request to implement that same plan authorizes execution. Changing `status` to `approved` alone does not.

On execution, always re-read the **current on-disk Plan**, including user edits. If a blocking ambiguity, destructive operation or new high-impact architectural decision lacks approval, ask for that decision before proceeding with the affected action.

## 4. Execute mode — implement, verify, log

1. **Reopen and baseline.** Confirm the Plan exists and is actionable. Read current repository instructions and relevant code. If Git is available, record branch, `HEAD`, status and pre-existing edits/untracked files. Do not erase, reset, stash or misattribute prior work. If changes overlap and cannot be separated safely, stop and ask.
2. **Follow the approved scope.** Implement in the Plan's phases and keep its acceptance criteria. Small necessary deviations are allowed **only when documented**. New architecture, destructive edits, incompatible schema/API changes and external side effects outside the Plan require approval; do not self-authorize.
3. **Implement and check incrementally.** Make the smallest consistent edits. Run relevant focused checks after meaningful phases where possible. Do not automatically commit, push, deploy, rotate credentials or run destructive migrations without explicit permission.
4. **Verify using evidence.** Run prescribed tests/build/lint where feasible. Record **actual commands, actual results**, and significant failure messages. For checks not run, write `未运行` plus reason. Compare final diff/status against baseline and exclude unrelated pre-existing modifications.
5. **Write the actual Build Log.** Read `assets/build-log-template.md` and `assets/writing-guide.md`. Create the matching log even for partial/failed execution if file writes remain possible. Start with a plain-language outcome; then explain **per material file** what changed, why, how the key logic works and what effect it has. Use a small diagram for a real flow change when helpful. Record Plan deviations, failed/unrun tests, risks and manual follow-up. **Never just rephrase the Plan or paste a huge diff.**
6. **Close honestly.** Update only the Plan status, link to Build Log and optionally completion checkboxes (`completed` / `partial` / `blocked` / `failed`); preserve the user's design/review notes. If logging fails, clearly state the blocker. Return both paths, verified outcome and remaining work.

## 5. Non-negotiable evidence rules

- **Plan = intent; Build Log = facts.** “预计实现” is never “已经实现”.
- **Per-file accountability.** For each material file, record operation (新增/修改/删除), concrete changed logic/symbol, why, and impact. Lockfiles/generated assets may be grouped with explanation.
- **Test honesty.** `PASS` only for commands actually executed successfully; `FAIL` and `未运行` must be explicit, including relevant limitations.
- **No fake code evidence.** If file paths/functions/commands aren't confirmed, label `待确认` (Plan) or `无法核实` (Log) instead of making them up.
- **No implicit side effects.** Keep users' existing edits; never discard work or perform unapproved production actions.
- **No secrets.** Never include tokens, credentials, PII or secret environment values in either document.

## References (read from this skill directory)

- `assets/writing-guide.md` — mandatory style rules, diagram patterns and before/after writing examples
- `assets/plan-template.md` — Plan structure
- `assets/build-log-template.md` — factual implementation record
