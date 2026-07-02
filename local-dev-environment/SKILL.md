---
name: local-dev-environment
description: Collect and summarize the user's local development environment before running, debugging, or setting up projects. Use when the user asks an agent to understand this machine's Python, Java, Node.js, Git, shell, editor, PATH, package managers, SDKs, or project runtime configuration, or when a project fails because local tooling may differ from assumptions.
---

# Local Dev Environment

Use this skill to inspect the local machine before changing how a project is run, built, tested, or debugged.

## Workflow

1. Run the environment collector from the skill folder:

```powershell
powershell -File "$env:CLAUDE_SKILL_DIR\scripts\collect-env.ps1" -OutputPath "$env:CLAUDE_SKILL_DIR\env-summary.md"
```

2. Read the generated summary (`env-summary.md`) and prefer discovered paths/versions over assumptions.
3. If the user has filled in `references/local-profile.md`, read it after the generated summary and treat it as user preference, not as proof that the current machine state matches.
4. Before installing, upgrading, or deleting tools, explain the mismatch and ask for approval.

## What To Capture

Summarize only information useful for coding tasks:

- OS, shell, username, home directory, current directory
- PATH entries and detected executable paths
- Python, pip, virtualenv, conda, uv, poetry
- Anaconda environments under `D:\software\Anaconda3\envs`
- Java, Maven, Gradle
- Node.js, npm, pnpm, yarn, bun
- Git and GitHub CLI
- Docker and common cloud CLIs
- VS Code, Cursor, IntelliJ IDEA, and other editor launchers if present
- Manually placed developer tools under `D:\software`
- Installed desktop/developer applications under `D:\application`
- Project-local hints such as `.python-version`, `.node-version`, `.nvmrc`, `package.json`, `pom.xml`, `build.gradle`, `pyproject.toml`, `requirements.txt`

## Safety

Never print or preserve raw secrets. Redact environment variables whose names contain:

`TOKEN`, `SECRET`, `PASSWORD`, `PASS`, `KEY`, `CREDENTIAL`, `COOKIE`, `AUTH`, `PRIVATE`.

If exact values are needed to debug authentication, ask the user to inspect them locally instead of requesting or echoing them.

## Interpreting Results

- Prefer project-local configuration over global defaults.
- On this machine, check `D:\software` for manually unpacked runtimes and SDKs, including `D:\software\Anaconda3\envs` for conda environments, and check `D:\application` for installed applications before concluding a tool is unavailable.
- If multiple versions exist, name all detected versions and choose the one selected by the project's version manager or PATH.
- If a command is missing, say it is not detected rather than assuming it is absent from the machine.
- On Windows, distinguish PowerShell, Git Bash, WSL, and native Windows paths when reporting commands to run.
- Keep the final environment summary concise: list the active toolchain first, then notable alternatives and missing tools.
