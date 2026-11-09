---
name: production-code-review
description: Production readiness checklist on a finished change—security, errors, performance, tests. Use only when the user invokes /production-code-review.
disable-model-invocation: true
---

# Production review

Do not edit files.

Run only after explicit invocation:

1. Inspect the git diff and intended behavior.
2. Review architecture fit for the change size.
3. Check business logic edge cases.
4. Check security (auth, secrets, input validation).
5. Check performance (N+1, bundle, unnecessary client work).
6. Check error handling and observability.
7. Check test coverage and missing scenarios.
8. Report prioritized findings (actionable bugs over style).
