---
lang: en
version: 1
last_updated: 2026-05-08
---

# Project Kickoff Workflow

> Bootstrap a new project with structure, docs, and first plan.

## When to use
Use at the start of a new repo or major module.

## Prerequisites
- Repo initialized
- Basic goals defined

## Step-by-step
1. Capture high-level scope and constraints
2. Start kickoff guidance: `/alp:bootstrap "<project description>"`
3. Review generated planning artifacts
4. Approve implementation sequence before coding

## Command sequence
- `/alp:bootstrap "..."`
- `/alp:plan "..."` (if needed for focused phase)

## Example prompt(s)
- `/alp:bootstrap "SaaS admin panel with auth, billing, and audit logs"`

## Expected output
- Structured project setup guidance
- Phased plan ready for execution

## Common mistakes
- Starting coding before plan approval
- Mixing unrelated scopes into first phase

## Related docs
- [New Feature Workflow](./new-feature.md)
- [Quick Start](../quick-start.md)
