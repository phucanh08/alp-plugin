# alp-plugin

Personal engineering plugin for [Claude Code](https://claude.ai/code) and [OpenCode](https://opencode.ai) — skills, agents, and workflows for daily development.

## Install

### Claude Code

```bash
/plugin marketplace add phucanh08/alp-marketplace
/plugin install alp@phucanh08-alp-marketplace
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

| Command | Description |
|---------|-------------|
| `/alp:plan` | Create implementation plans with research, red-team review, and task hydration |
| `/alp:cook` | Execute an implementation plan |
| `/alp:ask` | Technical and architectural consultation |
| `/alp:watzup` | Review recent branch changes |
| `/alp:docs` | Update project documentation |
| `/alp:test` | Run tests |
| `/alp:journal` | Write a development journal entry |
| `/alp:kanban` | View task board |
| `/alp:ck-help` | Full command reference |

## Skills

Skills are invoked automatically by Claude during workflows. Key skills:

| Skill | Purpose |
|-------|---------|
| `ck-plan` | Planning engine — research, scope challenge, red-team, validation |
| `ck-debug` | Systematic debugging workflow |
| `ck-loop` | Autonomous task loop |
| `cook` | Implementation execution |
| `scout` | Parallel codebase exploration |
| `bootstrap` | Project kickoff workflow |

## Agents

17+ specialized agents including: Planner, Researcher, Tester, Code Reviewer, Debugger, Docs Manager, Git Manager, UI/UX Designer, and more.

## Requirements

- Claude Code or OpenCode CLI
- Node.js 18+
- Git

## License

MIT
