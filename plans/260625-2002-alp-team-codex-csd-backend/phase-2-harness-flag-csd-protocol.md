# Phase 2 — `--harness` flag + csd-mode driving protocol

**Status:** pending · **Effort:** L · **BlockedBy:** Phase 1 · **Blocks:** Phase 3

## Objective
Teach `alp:team` SKILL.md to select a backend via `--harness`, and define the full csd-mode driving
protocol for `research`/`review`/`debug`/`cook`. Native path untouched.

## Files
- `skills/team/SKILL.md` (edit)
- `skills/team/references/csd-backend-driving.md` (new)

## Steps

1. **Flag + backend selection (SKILL.md).** Update `argument-hint` and add a **Backend Selection** section:
   - `--harness claude` (default) → existing native Agent Teams path. Unchanged.
   - `--harness codex|pi` → **csd backend**. Lead drives all workers via vendored `csd`.
   - Pre-flight: call `csd-env-check.sh`; if FAIL, STOP with the missing-prereq message (mirror the
     existing native pre-flight STOP pattern).
   - **One run = one backend** (except `--mixed`, Phase 3). Never interleave native + csd here.

2. **New reference `csd-backend-driving.md`** — the operational manual the skill points to:
   - **CLI surface:** `csd launch --harness <h> <name> <cwd>` → shim `/tmp/csd-workers/bin/<name>`;
     per-worker: `converse [--with-turn] <prompt> [timeout]`, `send`, `wait-for-turn`,
     `status` (idle|working|terminated|gone|unknown), `read-turn [--full]`,
     `read-events [--last N] [--type T] [--follow]`, `stop`, `handoff`, `session-id`, `events-file`;
     teardown `csd stop` each + `csd prune`.
   - **Codex sequencing gotcha:** not queryable until first `converse` completes (launch ≠ ready) →
     always `converse` first, never `send`+immediate-monitor.
   - **No peer messaging:** csd workers share only disk + event streams with the lead. Lead holds a
     manual task table in its own context (replaces `TaskList`); lead relays all cross-worker info.
   - **No resume-by-id:** dead worker = relaunch from zero (`adopt` is Claude-only). No crash recovery.
   - **Verify on disk:** collect results by reading artifact/report files, NOT `read-turn` prose.
   - **Live steering loop:** `read-events --follow` (or poll `status` + `wait-for-turn`) to monitor;
     intervene via `converse`/`send`. After a `converse` timeout, call `status` before `wait-for-turn`
     to avoid spurious blocking (csd README caveat).

3. **Per-template csd adaptation** (in SKILL.md, branch each template on backend):
   - **research / review:** fan-out N csd workers (1:1 driven), each writes report to `{ALP_REPORTS_PATH}`;
     lead reads files on disk, synthesizes. (review = primary `--mixed` target later.)
   - **debug:** no peer cross-talk → **lead-mediated adversarial loop**: read worker A turn → forward as
     prompt to worker B to challenge → iterate. Document explicitly that convergence is lead-driven.
   - **cook:** worktree isolation is manual (csd has none) → reuse `alp:worktree` to create N worktrees,
     `csd launch ... <worktree-cwd>` per dev, lead merges branches sequentially after (mirror native
     cook step 6). Keep mandatory test + docs-sync gates.

4. **Model-requirement note:** clarify "Opus-only" applies to **native** Agent Teams teammates only;
   csd workers run their own harness/model (cost-savings lever; `CSD_CODEX_MODEL` for codex).

5. **Teardown discipline:** every csd-mode template ends with `csd stop` (all) + `csd prune`; verify
   `csd list` empty. No orphan tmux / `/tmp/csd-workers` residue.

## Acceptance
- SKILL.md parses `--harness`, gates csd mode on env-check, branches all 4 templates by backend.
- `csd-backend-driving.md` is self-contained (a teammate could drive a worker from it alone).
- `--harness codex` research run works end-to-end (manual verify), results read from disk, clean teardown.
- Native `--harness claude` path diff = additive only (no behavior change).

## Risks
- **SKILL.md bloat** — already large. Keep csd mechanics in the reference doc; SKILL.md holds only
  branch points + pointers. Watch the 200-line modularization guidance for prose density.
- **Lead token cost** during live steering/polling — note it; hard cap added in Phase 3.

## Unresolved
- Default per-worker `converse` timeout for long codex tasks (propose 300s, revisit).
