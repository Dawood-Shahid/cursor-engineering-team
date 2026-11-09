# How to write a new `.mdc` rule

Each rule is one `.mdc` file. The YAML frontmatter says when the rule runs. The markdown below it says what the agent should do.

```markdown
---
description: One sentence that says what this rule enforces and when it matters.
alwaysApply: false
globs:
  - "app/**/*.tsx"
---

# Rule title

- One instruction that can be followed or checked.
- Another instruction.
```

Name the file after the job, for example `react-native.mdc` or `nextjs.mdc`. Use a `00-` prefix only for a rule that should sort first, such as `00-orchestration.mdc`.

## When the rule runs

Pick one mode.

| Goal | Frontmatter | When it applies |
|---|---|---|
| Workflow for the whole app | `alwaysApply: true` | Every chat |
| Specific files or folders | `alwaysApply: false` and `globs` | When a matching file is in context |
| Let the agent decide | `alwaysApply: false`, a `description`, and no `globs` | When the description matches the task |
| Only when mentioned | `alwaysApply: false`, with no `description` and no `globs` | When you type `@file-name` in chat |

When `alwaysApply` is `true`, `globs` and `description` are ignored. Do not add globs to a rule that should run for the whole app.

## Globs for the project

Write `globs` against the project's real folders. The rule applies when a pattern matches.

| Pattern | Matches |
|---|---|
| `*.ts` | `.ts` files in the project root only |
| `**/*.ts` | `.ts` files in every folder |
| `**/*.tsx` | `.tsx` files in every folder |
| `app/**/*` | Every file under `app/` |
| `src/app/**/*` | Every file under `src/app/` |
| `components/**/*.tsx` | `.tsx` files under `components/` |

Put multiple patterns on separate lines. A single comma-separated string also works: `globs: "app/**/*, src/app/**/*"`.

React Native source usually lives outside `app/`, so use `**/*.ts` and `**/*.tsx`.

Keep a Next.js rule on the app and UI:

```yaml
globs:
  - "app/**/*"
  - "src/app/**/*"
  - "components/**/*"
  - "src/components/**/*"
```

If the Next.js project uses `src/app/` and has no top-level `app/`, drop the first line. Do not add a glob for a folder the project does not have.

## What to put in the body

Each line should be an instruction the agent can check.

- Follow the existing navigation, folder structure, and API client.
- Do not put a new API call inside a UI component.
- Do not put a server secret in a `NEXT_PUBLIC` variable.
- Treat Android and iOS differences separately.

Leave out:

- "Write good code" or "use clean architecture." Those cannot be checked.
- A full style guide. A linter owns formatting.
- Every command in `package.json`. The agent already knows common commands.
- One app's product flow, screen list, or API base URL. Put that in that app's `AGENTS.md`.
- Text already covered by another rule. Keep the orchestration workflow in [`00-orchestration.mdc`](00-orchestration.mdc).

Keep a rule under 500 lines. Give each file one job: workflow, React Native, or Next.js.

## Examples

Workflow rule for the whole app:

```markdown
---
description: Planning and verification workflow for every non-trivial change.
alwaysApply: true
---

# Engineering workflow

- Inspect the existing implementation before editing.
- Keep the change limited to the requested task.
- Run the project's lint, typecheck, and tests when those commands exist.
```

File rule for a React Native project:

```markdown
---
description: React Native and Expo conventions.
globs:
  - "**/*.ts"
  - "**/*.tsx"
alwaysApply: false
---

# React Native

- Follow the existing Expo or React Native CLI setup.
- Use the navigation pattern already in the project.
- Keep API calls outside UI components.
- Use Zustand for client state and TanStack Query for server state when the project already uses them.
- Handle Android and iOS differences explicitly.
- Do not change native project configuration without a stated reason.
```

File rule for a Next.js project:

```markdown
---
description: Next.js App Router conventions.
globs:
  - "app/**/*"
  - "src/app/**/*"
  - "components/**/*"
  - "src/components/**/*"
alwaysApply: false
---

# Next.js

- Follow the installed Next.js version.
- Prefer Server Components.
- Add "use client" only when the component needs interactivity or a browser API.
- Keep secrets and privileged checks on the server.
- Validate untrusted input on the server.
- Use TanStack Query only where client-side server state is already the project pattern.
```

## Before creating the file

1. Decide whether it runs on every chat or only on some files.
2. If it runs on files, write `globs` from that project's real folders.
3. Write `description` as one sentence stating what the rule enforces.
4. Keep only instructions that are true for this project's stack. If the project does not use Zustand, do not mention Zustand.
5. Create the file in `templates/`, then copy it to that project's `.cursor/rules/`.
