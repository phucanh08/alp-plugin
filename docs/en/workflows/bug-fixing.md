---
lang: en
version: 1
last_updated: 2026-05-08
---

# Bug Fixing Workflow

> Reproduce, debug, fix, and verify with evidence.

## When to use
Use for runtime bugs, regressions, and failing tests.

## Prerequisites
- Reproduction details (error message/log or failing case)

## Step-by-step
1. Reproduce and summarize issue context
2. Run debug flow: `/alp:debug "<issue>"` or `/alp:plan "fix <issue>"`
3. Implement minimal fix
4. Run validation tests: `/alp:test`
5. Confirm no regressions via review: `/alp:review:codebase "check bug fix impact"`

## Command sequence
- `/alp:debug "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:debug "login API returns 500 when token is expired"`

## Expected output
- Root-cause hypothesis
- Verified fix with passing tests

## Common mistakes
- Fixing without reproduction
- Not testing adjacent paths

## Related docs
- [Code Review Workflow](./code-review.md)
- [Docs Update Workflow](./docs-update.md)
