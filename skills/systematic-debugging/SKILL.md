---
name: systematic-debugging
description: Structured root-cause workflow for runtime, API, and build failures—reproduce, trace, minimal fix, regression check. Use when debugging crashes, errors, or flaky behavior (with the debugger agent when delegated).
---

# Systematic debugging

1. Capture the exact error and stack (no paraphrasing).
2. Identify the failing module and last known good behavior.
3. Reproduce with the smallest steps; record environment (OS, branch, env vars names only).
4. Trace execution: data in → decision points → data out.
5. Confirm root cause with evidence (log, breakpoint, isolated test)—list ruled-out hypotheses.
6. Apply the smallest fix that addresses the cause, not symptoms.
7. Run the narrowest relevant checks; add or recommend a regression test.
8. Document cause, fix, and what was not verified.

Never randomly change config.
Never suppress errors without understanding them.
