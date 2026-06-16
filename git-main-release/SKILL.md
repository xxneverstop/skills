---
name: git-main-release
description: Publish the current repository state by committing the current dev work, merging it into main, pushing dev and main to both GitHub and GitLab, creating a release tag only after the user explicitly confirms the tag name, and switching back to dev. Use when the user asks to release the current version to GitHub and GitLab main, add a tag, and return the local checkout to dev.
---

# Git Main Release

Follow this workflow exactly.

## Inspect First

Run these checks before mutating anything:
- `git status --short --branch`
- `git remote -v`
- `git branch -a`
- `git tag --list`

Assume the intended remotes are:
- `origin` = GitHub
- `gitlab` = GitLab

If either remote is missing or clearly points somewhere unexpected, stop and ask.

## Confirm The Tag

Do not invent a release tag.
Ask the user for the exact tag name unless they already provided it in the current request.
Treat tag confirmation as mandatory approval before creating the tag.

If the tag already exists, stop and ask whether to retarget it.
Do not force-update an existing release tag unless the user explicitly approves that correction.

## Exclude Local Tool Artifacts

Before committing, keep obvious local-only tool directories out of the release when they appear, especially:
- `mmdp-frontend/.agents/`
- similar local helper or cache directories that are clearly not product code

Leave them untracked unless the user explicitly asks to include them.

## Publish Flow

1. Stage the intended release contents.
2. Remove excluded local tool artifacts from staging.
3. Commit on `dev` with a release-appropriate commit message if there are uncommitted changes.
4. `git checkout main`
5. `git merge --no-ff dev -m "merge: release <tag>"`
6. `git tag "<tag>"`
7. Push to GitHub:
   - `git push origin dev`
   - `git push origin main`
   - `git push origin "<tag>"`
8. Push to GitLab:
   - `git push gitlab dev`
   - `git push gitlab main`
   - `git push gitlab "<tag>"`
9. `git checkout dev`

## Error Handling

If GitLab push of `main` fails with a transient server-side storage or packfile error, retry once.
If the retry fails, report exactly which ref failed and stop.

If GitHub or GitLab authentication fails, preserve the current repo state and explain what credential or remote issue blocked completion.

## Final Verification

Before finishing, verify:
- the new tag points at the merged `main` release commit
- local checkout is back on `dev`
- working tree is clean except for intentionally excluded local-only paths such as `.agents/`

Report:
- `dev` release commit SHA
- `main` merge commit SHA
- tag name
- whether GitHub and GitLab both succeeded
