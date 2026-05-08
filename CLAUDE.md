# alp-plugin

Personal Claude Code / Codex plugin, converted from claudekit-engineer.

## Structure

- `skills/` — 32 skill modules (SKILL.md format with YAML frontmatter)
- `agents/` — 16 specialized agents
- `commands/` — 13 slash commands
- `hooks/` — automation hooks (scout-block, modularization)
- `workflows/` — workflow definitions

## Adding new skills

Create a directory `skills/<name>/` containing `SKILL.md`:

```yaml
---
name: <name>
description: <when Claude should use this skill — trigger conditions>
---

# Skill content...
```

## Conventions

- Kebab-case for file and directory names
- Each skill file < 200 lines
- Skill `description` must clearly state trigger conditions so Claude knows when to load it

## Source

Based on https://github.com/gnoah1379/claudekit-engineer
