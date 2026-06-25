# alp-plugin

Personal engineering plugin for [Claude Code](https://claude.ai/code) and [OpenCode](https://opencode.ai) — 79 skills, 15 agents, hooks, and workflows for daily development.

## Install

### Claude Code

```bash
/plugin marketplace add phucanh08/alp-marketplace
/plugin install alp@alp-personal
```

Or load locally for a single session:

```bash
claude --plugin-dir ~/alp-plugin
```

### OpenCode

```bash
opencode-marketplace install https://github.com/phucanh08/alp-plugin
```

Or load locally:

```bash
opencode --plugin-dir ~/alp-plugin
```

## Commands

Commands are exposed as skills under the `alp:` namespace. Core ones:

| Command | Description |
|---------|-------------|
| `/alp:plan` | Create implementation plans with research, red-team review, and task hydration |
| `/alp:cook` | End-to-end feature implementation with auto workflow detection |
| `/alp:fix` | Analyze and fix bugs, test failures, CI, type/lint/UI issues |
| `/alp:debug` | Systematic root-cause debugging |
| `/alp:ask` | Technical and architectural consultation |
| `/alp:brainstorm` | Explore solutions with trade-off analysis |
| `/alp:test` | Run tests and analyze results |
| `/alp:review` | Code review with edge-case detection |
| `/alp:docs` | Init / update / summarize project documentation |
| `/alp:watzup` | Review recent branch changes and wrap up work |
| `/alp:journal` | Write a development journal entry |
| `/alp:bootstrap` | Bootstrap a new project end-to-end |
| `/alp:deploy` | Deploy to any platform with auto-detection |
| `/alp:git` | Conventional commits, push, PRs |
| `/alp:alp-help` | Full command and skill reference |

See `guide/COMMANDS.md` for the complete catalog.

## Skills

79 skills are invoked automatically by the agent during workflows, or directly via `/alp:<skill>`. Highlights:

| Skill | Purpose |
|-------|---------|
| `alp-plan` | Planning engine — research, scope challenge, red-team, validation |
| `cook` | Implementation execution with workflow detection |
| `alp-debug` | Systematic debugging workflow |
| `alp-loop` | Autonomous iterative optimization loop |
| `scout` | Parallel codebase exploration |
| `bootstrap` | Project kickoff workflow |
| `design` / `ui-ux-pro-max` | Design systems, branding, UI/UX intelligence |
| `frontend-development` / `backend-development` | Full-stack build skills |
| `skill-creator` | Create or update skills |

Browse `skills/` for the full set (backend, frontend, mobile, databases, devops, payments, media, docs, security, and more).

## Agents

15 specialized subagents in `agents/`:

`brainstormer`, `code-reviewer`, `code-simplifier`, `debugger`, `docs-manager`, `fullstack-developer`, `git-manager`, `journal-writer`, `mcp-manager`, `planner`, `project-manager`, `researcher`, `tester`, `ui-ux-designer`, `watzup`.

## Other Components

- **Hooks** (`hooks/`) — session init, privacy block, scout context optimization, descriptive naming, dev-rules reminders, task/team coordination.
- **Output styles** (`output-styles/`) — coding-level explanations from ELI5 to "god" (set via `/alp:coding-level`).
- **Rules** (`rules/`) — primary workflow, development rules, orchestration and team-coordination protocols.

## Requirements

- Claude Code or OpenCode CLI
- Node.js 18+
- Git

## License

MIT
