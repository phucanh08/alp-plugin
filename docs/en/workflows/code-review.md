---
lang: en
version: 1
last_updated: 2026-05-08
---

# Code Review Workflow

> Validate quality and readiness before merge or deploy.

## When to use
Use before finalizing any meaningful change set.

## Prerequisites
- Changes implemented
- Tests executed at least once

## Step-by-step
1. Run test pass: `/alp:test`
2. Run review pass: `/alp:review:codebase "review pending changes"`
3. Address findings and re-run tests
4. Re-run review for clean result

## Command sequence
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:review:codebase "security + maintainability pass"`

## Expected output
- Actionable review notes
- Merge-ready state after fixes and re-check

## Common mistakes
- Treating first review pass as final
- Merging without re-running tests after fixes

## Related docs
- [Bug Fixing Workflow](./bug-fixing.md)
- [Docs Update Workflow](./docs-update.md)
