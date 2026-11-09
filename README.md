# cursor-engineering-team

Shared Cursor setup for React Native and Next.js work. This repository is the library. It is not the app. After you pull it, you install the agents and skills onto your machine, then copy the rule into each real app.

Do not paste this repository into an app. An app keeps only its own `AGENTS.md` and `.cursor/rules/`.

**You are welcome to extend this library.** Open a pull request against this repository for new agents, skills, rule templates, scripts, or documentation. If you are not ready to implement yet, open an issue and describe the workflow you want—especially team-wide patterns for orchestration, delegation, or org-specific conventions.

## Contributing

This repo is meant to be shared. **Feel free to open a PR** (or start with an issue) when you want to add or improve something for everyone on the team.

### What you can contribute

| Area | Examples |
|------|----------|
| `agents/` | New specialists (e.g. backend, DevOps), readonly reviewers, or tighter prompts for existing roles |
| `skills/` | New workflows, checklists, and optional `reference.md` files for deep detail |
| `templates/` | New `.mdc` rules, updates to `00-orchestration.mdc`, stack rules, or `AGENTS.md` starter |
| `scripts/` | Installer improvements, validation checks, or docs in `scripts/README.md` |
| `README.md` | Clearer setup steps, new stack support, or contribution notes like this section |

### How to submit a change

1. Fork or branch from `master`, make focused changes (one theme per PR when possible).
2. Run `./scripts/validate-library.sh` from the repository root.
3. Open a **pull request** against this repo with:
   - What you added or changed and **why** (which task or team pain it solves).
   - Whether agents/skills are **on-demand** or may run on normal prompts (match existing patterns to save tokens).
4. After merge, others run `git pull` and reinstall or re-run `./scripts/install.sh` (symlink) / `Install-CursorTeam.ps1` (copy).

### PR guidelines

- Keep agent bodies short; put long checklists in **skills** with a clear `description` (what + when).
- Opt-in for expensive passes: tests, code review, security, architecture—unless the user explicitly invokes them.
- Do not commit secrets, real API keys, or project-specific URLs that only one app should use (put those in each app's `AGENTS.md`, not in shared agents).
- New rules belong in `templates/`; explain globs and when they run in the PR, using [`templates/README.md`](templates/README.md).

Issues are fine for **suggestions only**: describe the agent, skill, or rule you want and how you would use it in daily work. A maintainer or another contributor can pick it up in a follow-up PR.

## What is in this repository

### `agents/`

Subagent prompts. Cursor does not load them from this folder. The installer copies each `.md` file to `~/.cursor/agents/`, which makes them available in every project on that machine.

| Agent | What it does | Edits files |
|---|---|---|
| `react-native-specialist` | Implements React Native and Expo features | Yes |
| `nextjs-specialist` | Implements Next.js and App Router features | Yes |
| `debugger` | Finds a root cause and applies the smallest safe fix | Yes |
| `qa-tester` | Runs tests and reports pass, fail, and gaps. Starts only when you ask | Does not change feature code |
| `code-reviewer` | Reviews the diff, then applies only clearly safe optimizations. Starts only when you ask | Yes, limited to those optimizations |
| `architect` | Proposes architecture and does not change files. Starts only when you ask | No (`readonly: true`) |
| `security-reviewer` | Reviews auth, tokens, secrets, and API security. Starts only when you ask | No (`readonly: true`) |

Do not duplicate skill checklists in agent files. When a specialist or debugger runs, it may reference the matching skill in its description or workflow so the agent loads that checklist on demand.

### `skills/`

Repeatable workflows. Each skill is a folder with one `SKILL.md`. The installer copies those folders to `~/.cursor/skills/`. `nextjs-development/reference.md` and `react-native-development/reference.md` are extra detail. The skill reads them only when it needs them. You do not invoke a reference file.

| Skill | When it applies |
|---|---|
| `react-native-development` | Implementing a React Native feature |
| `nextjs-development` | Implementing a Next.js feature |
| `systematic-debugging` | Crashes, runtime errors, API failures, and build failures |
| `production-code-review` | Production checklist. Runs only when you type `/production-code-review` |

## What runs on a normal prompt

On a normal prompt, Cursor may delegate only these implementation agents and skills:

- `nextjs-specialist` and `nextjs-development`
- `react-native-specialist` and `react-native-development`
- `debugger` and `systematic-debugging`

These five do not run unless you invoke them:

- `/architect`
- `/security-reviewer`
- `/qa-tester`
- `/code-reviewer`
- `/production-code-review`

`production-code-review` is a skill. The other four are agents.

### `templates/`

`.mdc` rules for a real app. `00-orchestration.mdc` has `alwaysApply: true`, so after you copy it into an app it runs on every non-trivial task: inspect the repo, plan, delegate implementation when useful, and stay in scope. It does not start `architect`, `security-reviewer`, `qa-tester`, `code-reviewer`, or `production-code-review` unless you ask.

Also in `templates/`:

| File | Use |
|---|---|
| `nextjs.mdc` | Copy into a Next.js app's `.cursor/rules/`. Applies when `app/` or `components/` files are in context. |
| `react-native.mdc` | Copy into a React Native app's `.cursor/rules/`. Applies to `.ts` and `.tsx` files. |
| `fintech-security.mdc` | Optional. Copy only into apps that have auth or payment folders. Applies to those paths, not every chat. |
| `AGENTS.md` | Copy to the app root and fill in that app's commands and folders. |
| `LEAN_GLOBAL_USER_RULE.md` | Not a project rule. Paste the text below the line into Cursor Settings, Rules, User Rules. |
| `README.md` | How to write another `.mdc` file. Do not copy it into `.cursor/rules/`. |

### `scripts/`

`Install-CursorTeam.ps1` copies `agents/` and `skills/` into `~/.cursor/` (with manifest-based orphan cleanup). On Mac and Linux, `scripts/install.sh` can symlink instead so `git pull` updates agents and skills without reinstalling. `scripts/validate-library.sh` checks frontmatter and file size. Neither installer copies `templates/` or `AGENTS.md`. `scripts/README.md` has run instructions.

## How to use this repository

Complete steps 1 and 2 once per machine. Repeat them after you pull agent or skill changes. Complete steps 3 and 4 once per app.

### 1. Pull the library

```bash
git clone https://github.com/YOUR_USERNAME/cursor-engineering-team.git
cd cursor-engineering-team
git pull
```

A pull only updates files on disk. Cursor does not see new agents or skills until step 2.

### 2. Install agents and skills

Windows, from the repository root:

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\scripts\Install-CursorTeam.ps1
```

`Set-ExecutionPolicy -Scope Process Bypass` applies only to that PowerShell window. `.\` is required. PowerShell will not run a script by name alone.

Mac and Linux (recommended symlink install):

```bash
./scripts/install.sh
```

Or copy install with PowerShell 7:

```bash
pwsh ./scripts/Install-CursorTeam.ps1
```

Platform notes are in `scripts/README.md`. Check the library before installing:

```bash
./scripts/validate-library.sh
```

The script writes:

```text
~/.cursor/agents/*.md
~/.cursor/skills/<skill-name>/SKILL.md
```

Restart Cursor, or refresh the Agent context. An already open chat does not pick up the new files.

### 3. Copy the rule into the app

Open the real app, not this library. Copy only the `.mdc` files that belong to that app.

Windows, from the app root:

```powershell
New-Item -ItemType Directory -Force -Path .cursor\rules | Out-Null
$Lib = "$HOME\Projects\cursor-engineering-team"
Copy-Item "$Lib\templates\00-orchestration.mdc" `
  -Destination .cursor\rules\00-orchestration.mdc -Force
# Next.js app:
Copy-Item "$Lib\templates\nextjs.mdc" -Destination .cursor\rules\nextjs.mdc -Force
# React Native app:
Copy-Item "$Lib\templates\react-native.mdc" -Destination .cursor\rules\react-native.mdc -Force
# Only if the app has auth or payment folders:
Copy-Item "$Lib\templates\fintech-security.mdc" -Destination .cursor\rules\fintech-security.mdc -Force
```

Mac or Linux, from the app root:

```bash
mkdir -p .cursor/rules
LIB="$HOME/Projects/cursor-engineering-team"
cp "$LIB/templates/00-orchestration.mdc" .cursor/rules/00-orchestration.mdc
# Next.js app:
cp "$LIB/templates/nextjs.mdc" .cursor/rules/nextjs.mdc
# React Native app:
cp "$LIB/templates/react-native.mdc" .cursor/rules/react-native.mdc
# Only if the app has auth or payment folders:
cp "$LIB/templates/fintech-security.mdc" .cursor/rules/fintech-security.mdc
```

Change the library path if you cloned it somewhere else. Commit `.cursor/rules/00-orchestration.mdc` in the app repository so the rest of the team gets the same rule. Do not merge it into `AGENTS.md`. Cursor reads those as two different files.

### 4. Write the app's `AGENTS.md`

Copy `templates/AGENTS.md` to the app root and fill in real commands from `package.json`, folders, and constraints.

To shorten Cursor's global User Rules, paste `templates/LEAN_GLOBAL_USER_RULE.md` into Settings, Rules, User Rules. That file stays on your machine. It is not copied into the app.

### 5. Work in the app

Open the app folder in Cursor. The app's `AGENTS.md` and `.cursor/rules/00-orchestration.mdc` describe that project. The installed agents and skills are already on the machine.

For a normal task, describe the change. Cursor can choose an implementation specialist and an implementation skill from their descriptions. It will not start `architect` or `security-reviewer` unless you ask.

To choose them yourself:

```text
/nextjs-specialist Add the settings form with the existing API client.
Follow the nextjs-development skill.
```

```text
/react-native-specialist Add the device list using the existing navigation.
Follow the react-native-development skill.
```

```text
/debugger Reproduce this crash and apply the smallest safe fix.
```

A subagent starts with a clean context. Put the task, the relevant files, and the acceptance criteria in that message.

`architect` and `security-reviewer` do not run on every prompt. Start them only when you want that pass.

Architecture plan:

```text
/architect Propose a plan for this feature. Do not edit files.
```

Security review, for auth, payments, or sensitive data:

```text
/security-reviewer Review auth and token storage. Do not edit files.
```

Testing, code review, and the production checklist do not run after every prompt. Run them yourself, in this order, and only when you are ready for that step.

1. Testing:

```text
/qa-tester Verify this implementation. Run the tests. Report what passed, what failed, and what was not tested. Do not change feature code.
```

2. After you are satisfied with the tests, code review and safe optimizations:

```text
/code-reviewer Review the current diff. Then apply only the optimizations that are clearly safe.
```

3. After that review is finished, the production checklist:

```text
/production-code-review Review the finished change against the production checklist. Do not edit files.
```

### 6. Update later

When an agent or skill changes:

```bash
git pull
```

Run `Install-CursorTeam.ps1` again, then refresh Cursor. Files with the same name are overwritten.

On Mac or Linux, `./scripts/install.sh` symlinks agents and skills, so a later `git pull` updates them without reinstalling. The Windows copy script does not. Run `.\scripts\Install-CursorTeam.ps1` again after a pull.

When a file in `templates/` changes, copy that `.mdc` into each app's `.cursor/rules/` again and commit it there. Pulling this library does not update an app by itself. `templates/AGENTS.md` is only a starter. Do not overwrite an app's filled-in `AGENTS.md` with the blank starter.
