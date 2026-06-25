# Brainstorm: Add Codex support to `alp:team` via claude-session-driver (csd)

- Date: 2026-06-25 20:02
- Skill: `/alp:brainstorm`
- Status: brainstorm complete, no plan yet (user chose summary-only)

## Problem statement

User wants `alp:team` to orchestrate **Codex** workers (not just Claude Code).
Motivation (user-stated): **cost savings** (cheap parallel grunt work) + **model ensemble** (cross-model check, reduce bias).
Desired control level: **live steering** (monitor + intervene mid-task, not just fan-out-collect).
Dep tolerance: **OK to vendor csd**. Packaging: **extend `alp:team` with `--harness`**.

## Key finding: mechanically incompatible engines

`alp:team` (v3.0.0) is built **entirely on Claude Code in-process Agent Teams**:
`TeamCreate`, `TaskCreate/Update/Get/List`, `Agent(run_in_background, isolation:worktree)`,
`SendMessage`, monitored by `TaskCompleted` hook events. **None of these primitives exist in Codex.**
=> Cannot "add a Codex flag" to existing mechanism. Codex orchestration requires a
different model: spawn **separate OS processes**, drive by prompt, observe via **disk + event files**.

`claude-session-driver` (csd) = exactly that. Harness-agnostic (claude/codex/pi) via **tmux + JSONL events**.
Identical controller CLI across harnesses: `launch / converse / wait-for-turn / read-events / status / stop`.
License: **MIT, © 2025 Jesse Vincent** — safe to vendor with attribution. TypeScript, ships `dist/`.

Codex specifics (from csd README):
- mints own session-id; **not queryable until first `converse` completes** (launch ≠ ready)
- **no resume-by-id** => no crash recovery (`adopt` is Claude-only) => dead worker = relaunch from zero
- staged home `/tmp/csd-workers/homes/<name>/`; model override `CSD_CODEX_MODEL`
- emits both `pre_tool_use` + `post_tool_use`
- workers share only disk + event streams with controller; **workers CANNOT message each other**

## Approaches evaluated

| | A. Vendor csd as backend | B. Thin `codex exec` driver | C. Separate new skill |
|---|---|---|---|
| Effort | wrap existing TS tool | small bash driver | new skill, own model |
| New deps | Node/TS `dist` + tmux | tmux optional / none | depends |
| Live steering | ✅ full (`read-events`/`converse`) | ❌ fan-out→collect only | depends |
| Fits markdown-skill plugin | ❌ heavy subproject | ✅ KISS | medium |
| `alp:team` stays clean | leaky (2 models, 1 skill) | leaky | ✅ clean |

- **B rejected**: no live steering (user requires it).
- **C rejected**: user wants single skill (`--harness`).
- **A chosen**: live steering + OK-with-deps justify vendoring csd.

## Final recommended solution (per user decisions)

Extend `alp:team`:

```
/alp:team <template> <context> [--harness claude|codex|pi] [--mixed claude,codex,codex]
```

- `--harness claude` (default) => existing native Agent Teams path. **Untouched.**
- `--harness codex|pi` => csd backend; lead drives all workers via `csd` CLI.
- `--mixed ...` => **simultaneous native + csd** (user's explicit choice; see risk note).

### Backend mechanics (csd path)
- Lead launches workers: `csd launch --harness codex <name> <cwd>` => shim `/tmp/csd-workers/bin/<name>`.
- Drive 1:1: `converse` / `wait-for-turn` / `read-events --follow` / `status`.
- **Coordination lives in lead's context** (no shared TaskList/SendMessage for csd workers).
- Inter-worker challenge (debug template) => **lead relays manually** (read worker A turn -> send to worker B).
- Collect results = **read artifacts/report files on disk** (NOT worker prose).
- Teardown: `csd stop` each + `csd prune`.

### Vendoring
- Vendor **prebuilt `dist/` + `csd` script, version-pinned** at `skills/team/vendor/csd/` + MIT LICENSE.
- **Do NOT** add a TS build toolchain to the plugin.

## Risks / hard truths (must design around)

1. **csd workers can't talk to each other** => `debug` adversarial cross-talk degrades; lead mediates (slower, more lead tokens).
2. **Coordination moves into lead's head** (no shared task list); csd rule = one controller per worker.
3. **Cost-savings partly self-defeating**: codex workers cheap, but **Opus lead keeps burning tokens** polling/relaying during live steering.
4. **`cook` worktree isolation is manual** for csd (no `isolation:worktree`); reuse `alp:worktree`, launch each worker in its worktree cwd, lead merges after.
5. **Codex: not queryable until first `converse`; no crash recovery; relaunch on death.**
6. **Shim embeds absolute skill path** => plugin lives at versioned cache path (`.../alp/<ver>/...`); **upgrade breaks running workers** => finish teams before upgrading (document).
7. **Verify on disk, not prose** (codex can falsely report success); keep review/test gates mandatory in csd mode.
8. **Vendoring/build is the heaviest cost** — mitigate with prebuilt pinned `dist`.

### Risk note on chosen `--mixed` (native + csd simultaneously)
User chose to run Agent Teams (claude) AND csd (codex) **concurrently in one run** — advisor flagged this as
**not recommended** (highest complexity, most failure-prone). Strongest ensemble for bias-reduction, but lead must run **two monitoring loops at once**:
- native teammates => `TaskCompleted` hook events
- csd workers => `read-events --follow` / `status` polling

Mitigations if pursued:
- Keep the two worker pools in **separate task-tracking namespaces** in lead context (native = TaskList; csd = lead-maintained table).
- For `cook`: native devs use `isolation:worktree`; csd devs use manual `alp:worktree` worktrees — **two isolation mechanisms**, merge both branch sets sequentially.
- Add a hard cap on csd worker count in mixed mode to bound lead overhead.
- Recommend `--mixed` only for `research`/`review` (read-only fan-out + cross-check), avoid for `cook`/`debug` initially.

## Success metrics / validation
- `--harness codex` launches, drives, collects, tears down a worker end-to-end (research template).
- Artifacts verified on disk; lead does not trust prose.
- `--mixed claude,codex` produces a cross-model synthesis for `research`/`review`.
- No orphaned tmux sessions / `/tmp/csd-workers` after teardown (`csd prune`).
- Native-only path (`--harness claude`) regression-free.

## Next steps / dependencies
- Confirm csd `dist` vendoring strategy + pinned version + attribution placement.
- Decide `--mixed` rollout scope (recommend research/review first).
- (Deferred) Run `/alp:plan` to produce phased implementation plan.

## Unresolved questions
1. **`--mixed` scope**: gate to `research`/`review` only at first, or allow `cook`/`debug` immediately? (advisor: gate first.)
2. **Vendoring**: prebuilt `dist` checked-in vs git submodule vs pin upstream tag? (advisor: checked-in prebuilt + pin.)
3. **Codex auth**: csd stages from `~/.codex` — confirm user has Codex CLI authed locally + in any CI target.
4. **Lead token budget cap** for mixed/live-steering runs — set a default ceiling?
