---
lang: en
version: 1
last_updated: 2026-05-08
---

# New Feature Workflow

> Build a feature from idea to validated implementation.

## When to use
Use when adding a new feature with planning and verification.

## Prerequisites
- Plugin is loaded (`/alp:watzup` works)
- Feature scope is clear

## Step-by-step
1. Create a plan: `/alp:plan "implement <feature>"`
2. Execute implementation using the approved plan
3. Run tests: `/alp:test`
4. Run review: `/alp:review:codebase "review this feature"`

## Command sequence
- `/alp:plan "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:plan "add audit logging to payment flow"`

## Expected output
- Plan artifacts created
- Tests executed with pass/fail report
- Review summary with issues and recommendations

## Common mistakes
- Skipping plan review before implementation
- Claiming done before test/review results

## Related docs
- [Quick Start](../quick-start.md)
- [Code Review Workflow](./code-review.md)
