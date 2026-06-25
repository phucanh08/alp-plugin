---
name: alp:team
description: "Orchestrate Agent Teams for parallel multi-session collaboration. Use for research, implementation, review, and debug workflows requiring independent teammates. Supports --harness codex|pi and --mixed (multi-model ensemble) via vendored claude-session-driver."
argument-hint: "<template> <context> [--devs|--researchers|--reviewers N] [--delegate] [--harness claude|codex|pi] [--mixed claude,codex,...]"
metadata:
  author: anhlpkit
  version: "3.1.0"
---

# Agent Teams - CK-Native Orchestration Engine

Coordinate multiple independent Claude Code sessions. Each teammate has own context window, loads project context (CLAUDE.md, skills, agents), communicates via shared task list and messaging.

**Requires (native, default):** Agent Teams enabled — set `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in
settings.json env.
**Requires (native):** CLI terminal — `TaskCreate`/`TaskUpdate`/`TaskGet`/`TaskList` and
`TeamCreate`/`TeamDelete` are **disabled in VSCode extension** (`isTTY` check). Native Agent Teams
CANNOT run in VSCode.
**Requires (csd backend, `--harness codex|pi`/`--mixed`):** Node `>=22.12`, `tmux`, and the worker
harness CLI authed (Codex: `~/.codex`; Pi: `~/.pi/agent`). Verify with
`skills/team/scripts/csd-env-check.sh`. csd mode DOES run in VSCode (workers are external processes).
**Model requirement:** **Native** Agent Teams teammates must run Opus 4.6 (Agent Teams constraint).
This does NOT apply to csd workers (`--harness codex|pi`) -- they run their own harness/model (the
cost-savings lever; codex model via `CSD_CODEX_MODEL`). csd-mode also runs where native cannot
(incl. VSCode), since workers are external processes.

## Usage

```
/alp:team <template> <context> [flags]
```

**Templates:** `alp:research`, `alp:cook`, `alp:code-review`, `alp:debug`

**Flags:**
- `--devs N` | `--researchers N` | `--reviewers N` | `--debuggers N` -- team size
- `--plan-approval` / `--no-plan-approval` -- plan gate (default: on for cook)
- `--delegate` -- lead only coordinates, never touches code
- `--worktree` -- use git worktrees for implementation isolation (default: on for cook)
- `--harness claude|codex|pi` -- worker backend (default: `claude` = native Agent Teams)
- `--mixed claude,codex,...` -- run native + csd backends simultaneously (research/review only)

## Backend Selection

`alp:team` has TWO backends. The flag picks the **whole** backend for a run -- do NOT interleave.

| Flag | Backend | Workers driven via |
|------|---------|--------------------|
| `--harness claude` (default) | **Native Agent Teams** | `TeamCreate`/`TaskCreate`/`Agent`/`SendMessage` (unchanged) |
| `--harness codex` \| `--harness pi` | **csd** (vendored) | `csd` CLI + JSONL event streams |
| `--mixed claude,codex,...` | **Both, concurrently** | native pool + csd pool (see `## --mixed Mode`) |

**csd pre-flight (MANDATORY when `--harness` != claude OR `--mixed` includes a non-claude harness):**
1. Run `skills/team/scripts/csd-env-check.sh`. Last line is `CSD_ENV: PASS` or `CSD_ENV: FAIL`.
2. `PASS` → proceed. `FAIL` → STOP and tell user the missing prerequisite (commonly `tmux` or
   `~/.codex`), e.g. *"csd backend needs tmux: `brew install tmux`."* Do NOT silently continue.
   (Exception: `--mixed` read-only degrade rule in `## --mixed Mode`.)
3. Then follow **`references/csd-backend-driving.md`** for ALL worker operations (launch/converse/
   wait-for-turn/read-events/status/stop/prune). It is self-contained.

**csd backend invariants** (full detail in the reference doc -- enforce all):
- Codex/Pi not queryable until first `converse` completes (launch ≠ ready).
- **Verify artifacts on disk, never trust worker prose.**
- csd workers **cannot peer-message** -- lead relays all cross-worker info.
- No crash recovery for codex/pi (no resume-by-id) -- dead worker = relaunch from zero.
- Coordination lives in lead context (no shared TaskList); keep a `name|harness|cwd|status|report` table.
- Always tear down: `stop` each + `csd prune`; verify `csd list` empty.

## --mixed Mode (native + csd concurrently)

Runs a **native pool** (claude via Agent Teams) AND a **csd pool** (codex/pi) in one run, then
cross-checks results across models. Strongest bias-reduction; highest complexity (two monitoring loops).

**Scope gate (KISS):** `--mixed` is allowed for **`research` and `review` ONLY**. On `cook`/`debug`,
**REJECT** with: *"--mixed supports research/review only (cook/debug need single backend)."*

**Parse** `--mixed claude,codex,codex` → two pools:
- `native[]` = claude entries → Agent Teams (`TeamCreate`/`TaskCreate`/`Agent`, monitor via `TaskCompleted`).
- `csd[]` = codex/pi entries → `csd` CLI (monitor via `read-events --follow` / `status`).

**Rules:**
1. **csd worker cap = 3** in mixed mode (bound lead polling/relay overhead). Exceed → cap + warn.
2. **Separate tracking namespaces.** Native = `TaskList`. csd = lead-maintained table. Never conflate.
3. **Env-check degrade:** if `csd-env-check` FAILs in `--mixed`, do NOT hard-stop — **warn and continue
   native-only** (research/review tolerate a missing pool). Report which pool was dropped.
4. **Wait for BOTH pools** before synthesis. Lead reads all reports on disk (native + csd).
5. **Synthesis must note model agreement/disagreement** (that's the ensemble value).
6. **Partial failure:** if one pool dies (e.g. codex worker gone, no recovery), report partial synthesis
   honestly + name the failed pool. Never silently drop a pool.
7. **Teardown BOTH:** native → `shutdown_request` + `TeamDelete`; csd → `stop` each + `csd prune`.
   Verify `TaskList` cleared AND `csd list` empty.

Cost note: codex workers are cheap, but the Opus lead keeps spending while live-steering/polling both
pools. `--mixed` buys ensemble quality, not token savings.

## Execution Protocol

**Pre-flight (MANDATORY -- merged into step 2 of every template):**
1. Step 2 of every template calls `TeamCreate(team_name: "...", ...)`. Do NOT check whether the tool exists first -- just call it.
2. If the call SUCCEEDS: continue with the template.
3. If the call returns an ERROR or is unrecognized: **STOP. Tell user:** "Agent Teams requires `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` in settings.json. Team mode is not available."
4. Do NOT fall back to subagents. `/alp:team` MUST use Agent Teams or abort.
5. Ensure `TeamCreate` was called before spawning teammates -- team association happens via session context.

When activated, IMMEDIATELY execute the matching template sequence below.
Do NOT ask for confirmation. Do NOT explain what you're about to do.
Execute the tool calls in order. Report progress after each major step.

**Backend branch (READ FIRST):** The template steps below describe the **native** Agent Teams backend.
If the run is csd (`--harness codex|pi`) or `--mixed`:
- Run the csd pre-flight (see `## Backend Selection`) and STOP on `FAIL`.
- For the csd pool, **replace** `TeamCreate`/`TaskCreate`/`Agent`/`SendMessage` steps with the
  equivalent `csd` operations + per-template adaptation in `references/csd-backend-driving.md`
  (research/review = fan-out + read-on-disk; debug = lead-mediated cross-talk; cook = manual
  `alp:worktree` isolation). The synthesis/report/journal steps at the end of each template stay the same.
- `--mixed` runs BOTH pools concurrently -- see `## --mixed Mode`.

### --delegate Mode

When `--delegate` flag is passed:
- Lead enters delegate mode (`Shift+Tab` after TeamCreate)
- Lead ONLY: spawns teammates, manages tasks, sends messages, synthesizes reports
- Lead NEVER: edits files, runs tests, executes git commands directly
- For cook Step 6 MERGE: spawn a dedicated merge teammate instead of lead doing it
- For all templates: lead coordinates and reports, delegates ALL implementation work

---

## Tool Reference (Quick)

### Agent Tool (spawn teammates)

```
Agent(
  subagent_type: "researcher" | "fullstack-developer" | "code-reviewer" | "debugger" | "tester" | ...,
  description: "short task summary",
  prompt: "full instructions + CK Context Block",
  model: "opus",                    # Required for Agent Teams teammates
  run_in_background: true,          # Non-blocking spawn
  isolation: "worktree"             # Git worktree isolation (cook devs)
)
```

**Note:** `Task` was renamed to `Agent` in v2.1.63. Both names work; prefer `Agent` for new code.

### Team Management Tools

| Tool | Purpose | Params |
|------|---------|--------|
| `TeamCreate` | Create team + task list | `team_name`, `description` |
| `TeamDelete` | Remove team resources | *none* -- just call it |
| `TaskCreate` | Create work item | `subject`, `description`, `priority`, `addBlockedBy`, `addBlocks` |
| `TaskUpdate` | Claim/complete task | `taskId`, `status`, `owner`, `metadata` |
| `TaskGet` | Full task details | `taskId` |
| `TaskList` | All tasks (minimal fields) | *none* |
| `SendMessage` | Inter-agent messaging | `type`, `to`/`recipient`, `message` |

### SendMessage Types

| Type | Purpose |
|------|---------|
| `message` | DM to one teammate (requires `recipient`) |
| `broadcast` | Send to ALL teammates (use sparingly) |
| `shutdown_request` | Ask teammate to gracefully exit |
| `shutdown_response` | Teammate approves/rejects shutdown (requires `request_id`) |
| `plan_approval_response` | Lead approves/rejects teammate plan (requires `request_id`) |

---

## CK Context Block

Every teammate spawn prompt MUST include this context at the end:

```
CK Context:
- Work dir: {CK_PROJECT_ROOT or CWD}
- Reports: {ALP_REPORTS_PATH or "plans/reports/"}
- Plans: {CK_PLANS_PATH or "plans/"}
- Branch: {CK_GIT_BRANCH or current branch}
- Naming: {CK_NAME_PATTERN or "YYMMDD-HHMM"}
- Active plan: {CK_ACTIVE_PLAN or "none"}
- Commits: conventional (feat:, fix:, docs:, refactor:, test:, chore:)
- Refer to teammates by NAME, not agent ID
```

---

## ON `/alp:team research <topic>` [--researchers N]:

*Wraps /alp:research skill -- scope, gather, analyze, report.*

IMMEDIATELY execute in order:

1. **Derive N angles** from `<topic>` (default N=3):
   - Angle 1: Architecture, patterns, proven approaches
   - Angle 2: Alternatives, competing solutions, trade-offs
   - Angle 3: Risks, edge cases, failure modes, security
   - (If N>3, derive additional angles from topic context)

2. **CALL** `TeamCreate(team_name: "<topic-slug>")`

3. **CALL** `TaskCreate` x N -- one per angle:
   - Subject: `Research: <angle-title>`
   - Description: `Investigate <angle> for topic: <topic>. Save report to: {ALP_REPORTS_PATH}/researcher-{N}-{CK_NAME_PATTERN}-{topic-slug}.md. Format: Executive summary, key findings, evidence, recommendations. Mark task completed when done. Send findings summary to lead.`

4. **SPAWN** teammates x N via `Agent` tool:
   - `subagent_type: "researcher"`, `model: "opus"`
   - `run_in_background: true` (non-blocking -- spawn all N concurrently)
   - `name: "researcher-{N}"`
   - Prompt: task description + CK Context Block

5. **MONITOR** via TaskCompleted hook events + TaskList fallback:
   - TaskCompleted events auto-notify when researchers finish
   - Fallback: Check TaskList if no event received in 60s
   - If stuck >5 min, message teammate directly

6. **READ** all researcher reports from `{ALP_REPORTS_PATH}/`

7. **SYNTHESIZE** into: `{ALP_REPORTS_PATH}/research-summary-{CK_NAME_PATTERN}-{topic-slug}.md`
   Format: exec summary, key findings, comparative analysis, recommendations, unresolved questions.

8. **SHUTDOWN**: `SendMessage(type: "shutdown_request")` to each teammate

9. **CLEANUP**: `TeamDelete` (no parameters -- just call it)

10. **REPORT**: Tell user `Research complete. Summary: {path}. N reports generated.`
11. **JOURNAL**: Run `/alp:journal` to write a concise technical journal entry upon completion

---

## ON `/alp:team cook <plan-path-or-description>` [--devs N]:

*Wraps /alp:cook skill -- plan, code, test, review, finalize.*

IMMEDIATELY execute in order:

1. **READ** plan (if path provided) OR create via planner teammate:
   - If description only: spawn `Agent(subagent_type: "planner")` to create plan first
   - Parse plan into N independent task groups with file ownership boundaries

2. **CALL** `TeamCreate(team_name: "<feature-slug>")`

3. **CALL** `TaskCreate` x (N + 1) -- N dev tasks + 1 tester task:
   - Dev tasks: include `File ownership: <glob patterns>` -- NO overlap between devs
   - Tester task: `addBlockedBy` all dev task IDs
   - Each task description includes: implementation scope, file ownership, acceptance criteria

4. **SPAWN** developer teammates x N via `Agent` tool:
   - `subagent_type: "fullstack-developer"`, `model: "opus"`
   - `isolation: "worktree"` -- each dev gets isolated git worktree (no file conflicts)
   - `run_in_background: true`
   - `name: "dev-{N}"`
   - Prompt: task description + plan context + CK Context Block
   - If `--plan-approval`: include instruction to plan first, await approval
   - REVIEW and APPROVE each developer's plan via `plan_approval_response`

5. **MONITOR** dev completion via TaskCompleted events:
   - TaskCompleted hook notifies when each dev task finishes
   - When all N dev tasks show completed, spawn tester immediately
   - TeammateIdle events confirm devs are available for shutdown
   - Fallback: Check TaskList if no events received in 60s
   - Spawn tester: `Agent(subagent_type: "tester", model: "opus", name: "tester")`
   - Tester runs full test suite, reports pass/fail

6. **MERGE** worktree branches (if `isolation: "worktree"` was used):
   - Discover branches: check Agent result for branch names, or `git worktree list`
   - For each dev branch: `git merge <dev-branch> --no-ff`
   - If conflict: resolve manually (lead owns shared files), then `git add . && git merge --continue`
   - Cleanup: `git worktree remove <path>` for each worktree
   - Verify: `git log --oneline --graph` to confirm merge topology

7. **DOCS SYNC EVAL** (MANDATORY for cook -- from /alp:cook finalize):
   ```
   Docs impact: [none|minor|major]
   Action: [no update needed -- <reason>] | [updated <page>] | [needs separate PR]
   ```

8. **SHUTDOWN** all teammates via `SendMessage(type: "shutdown_request")`
9. **CLEANUP**: `TeamDelete` (no parameters -- just call it)

10. **REPORT**: Tell user what was cooked, test results, docs impact.
11. **JOURNAL**: Run `/alp:journal` to write a concise technical journal entry upon completion

---

## ON `/alp:team review <scope>` [--reviewers N]:

*Wraps /alp:code-review skill -- scout, review, synthesize with evidence gates.*

IMMEDIATELY execute in order:

1. **DERIVE** N review focuses from `<scope>` (default N=3):
   - Focus 1: Security -- vulnerabilities, auth, input validation, OWASP
   - Focus 2: Performance -- bottlenecks, memory, complexity, scaling
   - Focus 3: Test coverage -- gaps, edge cases, error paths
   - (If N>3, derive from scope: architecture, DX, accessibility, etc.)

2. **CALL** `TeamCreate(team_name: "review-<scope-slug>")`

3. **CALL** `TaskCreate` x N -- one per focus:
   - Subject: `Review: <focus-title>`
   - Description: `Review <scope> for <focus>. Output severity-rated findings only. Format: [CRITICAL|IMPORTANT|MODERATE] <finding> -- <evidence> -- <recommendation>. No "seems" or "probably" -- concrete evidence only. Save to: {ALP_REPORTS_PATH}/reviewer-{N}-{CK_NAME_PATTERN}-{scope-slug}.md. Mark task completed when done.`

4. **SPAWN** reviewers x N via `Agent` tool:
   - `subagent_type: "code-reviewer"`, `model: "opus"`
   - `run_in_background: true`
   - `name: "reviewer-{N}"`
   - Prompt: task description + CK Context Block

5. **MONITOR** via TaskCompleted hook events + TaskList fallback:
   - TaskCompleted events auto-notify when reviewers finish
   - Fallback: Check TaskList if no event received in 60s

6. **SYNTHESIZE** into: `{ALP_REPORTS_PATH}/review-{scope-slug}.md`
   - Deduplicate findings across reviewers
   - Prioritize by severity: CRITICAL > IMPORTANT > MODERATE
   - Create action items list with owners

7. **SHUTDOWN** all teammates via `SendMessage(type: "shutdown_request")`
8. **CLEANUP**: `TeamDelete` (no parameters -- just call it)

9. **REPORT**: Tell user `Review complete. {X} findings ({Y} critical). Report: {path}.`
10. **JOURNAL**: Run `/alp:journal` to write a concise technical journal entry upon completion

---

## ON `/alp:team debug <issue>` [--debuggers N]:

*Wraps /alp:fix skill -- root-cause-first, adversarial hypotheses, disprove to converge.*

IMMEDIATELY execute in order:

1. **GENERATE** N competing hypotheses from `<issue>` (default N=3):
   - Each hypothesis must be independently testable
   - Each must predict different observable symptoms
   - Frame as: "If <cause>, then we should see <evidence>"

2. **CALL** `TeamCreate(team_name: "debug-<issue-slug>")`

3. **CALL** `TaskCreate` x N -- one per hypothesis:
   - Subject: `Debug: Test hypothesis -- <theory>`
   - Description: `Investigate hypothesis: <theory>. For issue: <issue>. ADVERSARIAL: actively try to disprove other theories. Message other debuggers to challenge findings. Report evidence FOR and AGAINST your theory. Save findings to: {ALP_REPORTS_PATH}/debugger-{N}-{CK_NAME_PATTERN}-{issue-slug}.md. Mark task completed when done.`

4. **SPAWN** debugger teammates x N via `Agent` tool:
   - `subagent_type: "debugger"`, `model: "opus"`
   - `run_in_background: true`
   - `name: "debugger-{N}"`
   - Prompt: task description + CK Context Block

5. **MONITOR** via TaskCompleted events. Debuggers should message each other -- let them converge.
   - TaskCompleted events notify as each hypothesis is tested
   - TeammateIdle events indicate debugger awaiting peer input
   - Fallback: Check TaskList if no events in 60s

6. **READ** all debugger reports. Identify surviving theory as root cause.

7. **WRITE** root cause report: `{ALP_REPORTS_PATH}/debug-{issue-slug}.md`
   Format: Root cause, evidence chain, disproven hypotheses, recommended fix.

8. **SHUTDOWN** all teammates via `SendMessage(type: "shutdown_request")`
9. **CLEANUP**: `TeamDelete` (no parameters -- just call it)

10. **REPORT**: Tell user `Debug complete. Root cause: <summary>. Report: {path}.`
11. **JOURNAL**: Run `/alp:journal` to write a concise technical journal entry upon completion

---

## When to Use Agent Teams vs Subagents

| Scenario | Subagents (Agent tool) | Agent Teams |
|----------|----------------------|-------------|
| Focused task (test, lint, single review) | **Yes** | Overkill |
| Sequential chain (plan -> code -> test) | **Yes** | No |
| 3+ independent parallel workstreams | Maybe | **Yes** |
| Competing debug hypotheses | No | **Yes** |
| Cross-layer work (FE + BE + tests) | Maybe | **Yes** |
| Workers need to discuss/challenge findings | No | **Yes** |
| Token budget is tight | **Yes** | No (high cost) |

## Token Budget

| Template | Estimated Tokens | Notes |
|----------|-----------------|-------|
| Research (3) | ~150K-300K | Read-only, moderate cost |
| Cook (4) | ~400K-800K | Highest cost -- code generation |
| Review (3) | ~100K-200K | Read-only, moderate cost |
| Debug (3) | ~200K-400K | Mixed read/execute |

## Agent Memory

Teammates with `memory: project` in their agent definition retain learnings across team sessions. Memory persists in `.claude/agent-memory/<name>/` (gitignored). Useful for:
- Code reviewer remembering project conventions
- Debugger recalling past failure patterns
- Tester tracking flaky tests and coverage gaps
- Researcher accumulating domain knowledge

Memory persists after team cleanup -- it's in `.claude/agent-memory/`, not `~/.claude/teams/`.

## Worktree Isolation (Cook Template)

For implementation teams, `isolation: "worktree"` on the Agent tool gives each dev:
- **Own git worktree** -- isolated working directory, staging area, HEAD
- **Own branch** -- auto-created, returned in agent result
- **No file conflicts** -- devs can edit same files independently
- **Safe parallel editing** -- `.git` dir shared, everything else isolated

After all devs complete, lead merges branches sequentially. This is the safest pattern for parallel code changes.

## Error Recovery

1. **Check status**: `Shift+Up/Down` (in-process) or click pane (split)
2. **Redirect**: Send direct message with corrective instructions
3. **Replace**: Shut down failed teammate, spawn replacement for same task
4. **Reassign**: `TaskUpdate` stuck task to unblock dependents

## Abort Team

```
Shut down all teammates. Then call TeamDelete (no parameters).
```

If unresponsive: close terminal or kill session. Clean orphaned configs at `~/.claude/teams/` manually.

## Display Modes

- **auto** (default): split panes if in tmux, otherwise in-process
- **in-process**: all in one terminal. `Shift+Up/Down` navigate. `Ctrl+T` task list.
- **tmux/split**: each teammate own pane. Requires tmux or iTerm2.

## csd Backend Safeguards (checklist)

When `--harness codex|pi` or `--mixed`:
- [ ] Pre-flight `csd-env-check.sh` PASS (or documented degrade for `--mixed`).
- [ ] `converse` before any monitoring on a fresh codex/pi worker (launch ≠ ready).
- [ ] Verify produced artifacts **on disk** before accepting any worker's "done".
- [ ] Relaunch (not resume) on codex/pi worker death — report lost work.
- [ ] `--mixed`: csd worker cap = 3; separate native/csd tracking namespaces.
- [ ] Teardown: `stop` every worker + `csd prune`; confirm `csd list` empty (no orphan tmux /
      `/tmp/csd-workers`).
- [ ] **Upgrade fragility:** csd shims embed the absolute (versioned) plugin path. **Finish + tear down
      running csd teams BEFORE upgrading the plugin**; an upgrade invalidates live workers → relaunch.

## Rules Reference

See `.claude/rules/team-coordination-rules.md` for teammate behavior rules (incl. the
"csd-Backend Workers" section). csd mechanics: `references/csd-backend-driving.md`. Vendored runtime
provenance + re-vendoring: `csd-runtime/VENDORED.md`.

> v3.0.0: Agent tool migration, worktree isolation for cook devs, run_in_background spawning, updated model requirements.
> v3.1.0: csd backend — `--harness codex|pi` + `--mixed` (multi-model ensemble) via vendored
> claude-session-driver (MIT). See `references/csd-backend-driving.md`, `csd-runtime/VENDORED.md`.
