# csd Backend — Driving Codex/Pi Workers

Operational manual for `alp:team` when `--harness codex|pi` (or the codex pool of `--mixed`) is active.
The lead drives workers through the vendored `csd` CLI instead of native Agent Teams tools.

> **One controller per worker.** Concurrent control of the same worker collides. The lead is the
> single controller for every csd worker it launches.

## Entry point

```
CSD=skills/team/csd-runtime/csd          # wrapper (pins paths to vendored tree)
```

Always pre-flight first; STOP if it fails:

```
skills/team/scripts/csd-env-check.sh     # last line: CSD_ENV: PASS | FAIL
```

`FAIL` → tell user the missing prerequisite (commonly `tmux` or `~/.codex`) and abort csd mode.
Do NOT silently fall back (except the `--mixed` read-only degrade rule in `team` SKILL).

## CLI surface

### Top-level (run via `$CSD`)
| Command | Purpose |
|---------|---------|
| `launch [--harness <claude\|codex\|pi>] <name> <cwd> [-- harness-args...]` | Bootstrap a worker. Prints **shim path** on stdout: `/tmp/csd-workers/bin/<name>` |
| `list [--all] [<pattern>]` | Enumerate workers |
| `prune` | Remove state of dead (`gone`) workers |
| `grant-consent` | One-time consent to run workers with permissions bypassed |
| `adopt <name> <cwd> <session-id>` | **Claude-only** re-adopt; codex/pi have no resume-by-id |

### Per-worker (run via the shim `/tmp/csd-workers/bin/<name>`)
| Command | Purpose |
|---------|---------|
| `converse [--with-turn] <prompt> [timeout=120]` | Send prompt **and wait** for the turn to finish |
| `send <prompt>` | Send without waiting |
| `wait-for-turn [timeout=60] [--after-line N]` | Block until current turn completes |
| `status` | `idle` \| `working` \| `terminated` \| `gone` \| `unknown` |
| `read-turn [--full]` | Last turn as markdown |
| `read-events [--last N] [--type T] [--follow]` | Lifecycle event stream |
| `stop` | Terminate worker + remove shim/state |
| `handoff` | Attach instructions for human takeover |
| `session-id` / `events-file` | Introspection |

Event types: `session_start`, `user_prompt_submit`, `pre_tool_use`, `post_tool_use`, `stop`, `session_end`.
(Codex/Pi emit both `pre_`+`post_tool_use`; Claude emits `pre_tool_use` only.)

## Driving loop (live steering)

```
$CSD launch --harness codex dev1 /path/to/worktree     # -> /tmp/csd-workers/bin/dev1
SHIM=/tmp/csd-workers/bin/dev1
$SHIM converse "Implement X. Write report to plans/reports/...md" 300   # codex: MUST converse first
# monitor mid-task:
$SHIM read-events --type pre_tool_use --follow &        # or poll: $SHIM status
# intervene if needed:
$SHIM send "Stop — you're editing the wrong module. Focus on src/auth/."
# collect:
$SHIM read-turn --full                                  # prose ONLY for context, NOT proof
$CSD --worker dev1 stop  ||  $SHIM stop
$CSD prune
```

## Hard rules (do not violate)

1. **Codex/Pi are not queryable until the first `converse` completes.** Launch ≠ ready. Always
   `converse` first; never `send`-then-immediately-monitor on a fresh worker.
2. **Verify artifacts on disk, never trust worker prose.** Workers can report success falsely. Read the
   actual report/code files the task was supposed to produce before declaring done.
3. **No peer messaging.** csd workers share only disk + event streams with the lead — they cannot talk
   to each other. The lead relays ALL cross-worker information (see debug template below).
4. **No crash recovery for codex/pi.** They mint their own session ids and offer no resume-by-id
   (`adopt` is claude-only). A dead worker = relaunch from zero. Report the lost work honestly.
5. **After a `converse` timeout, call `status` before `wait-for-turn`** to avoid spurious blocking.
6. **Coordination lives in the lead's context.** There is no shared `TaskList`. Maintain a table:
   `name | harness | cwd | status | report-path`.
7. **Always tear down:** `stop` every worker + `$CSD prune`; verify `$CSD list` shows none. No orphan
   tmux sessions / `/tmp/csd-workers` residue.

## Per-template adaptation (csd mode)

- **research / review** — fan-out N workers (1:1 driven). Each writes its report to
  `{ALP_REPORTS_PATH}`. Lead reads files on disk, synthesizes. Highest-value, lowest-risk csd use.
- **debug** — workers cannot challenge each other → **lead-mediated adversarial loop**: read worker A's
  turn → forward it as a prompt to worker B to disprove → iterate. Convergence is lead-driven.
- **cook** — csd has **no built-in worktree isolation**. Use `alp:worktree` to create N worktrees, then
  `launch ... <worktree-cwd>` per dev. Lead merges branches sequentially after (mirror native cook
  merge step). Keep mandatory test + docs-sync gates.

## Codex specifics

- Staged home at `/tmp/csd-workers/homes/<name>/` (auth copied from `~/.codex`).
- Model override: `CSD_CODEX_MODEL` (else csd default).
- Permissions bypassed, tools auto-executed (that's the point — throughput).
