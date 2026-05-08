---
lang: en
version: 1
last_updated: 2026-05-08
---

# Docs Update Workflow

> Keep documentation synchronized with code changes.

## When to use
Use after implementing features, fixes, or architectural changes.

## Prerequisites
- Code changes complete enough to document

## Step-by-step
1. Identify changed behavior and affected files
2. Update relevant docs files
3. Run docs summary/update helper if needed: `/alp:docs:update`
4. Verify links and command examples

## Command sequence
- `/alp:docs:update`

## Example prompt(s)
- `/alp:docs:update`

## Expected output
- Updated docs aligned with current code behavior

## Common mistakes
- Updating README only, ignoring workflow docs
- Leaving stale command examples

## Related docs
- [Code Review Workflow](./code-review.md)
- [New Feature Workflow](./new-feature.md)
