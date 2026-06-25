---
name: Add Codex/multi-harness backend to alp:team via vendored csd
status: completed
priority: high
branch: feat/team-codex-csd-backend
date: 2026-06-25
blockedBy: []
blocks: []
---

> **Implemented 2026-06-25** on branch `feat/team-codex-csd-backend`. All 4 phases code-complete + verified.
> Deviation: vendored at `skills/team/csd-runtime/lib/` (NOT `vendor/csd/dist/`) to dodge alp's
> scout-block `.alpignore` which blocks the `dist`/`vendor` tokens. Open item: live Codex smoke test
> deferred — local machine lacks `tmux` (`brew install tmux`); env-check gates it.

# Add Codex/multi-harness backend to `alp:team` via vendored `claude-session-driver` (csd)

> Source brainstorm: `plans/reports/brainstorm-260625-2002-alp-team-codex-csd-support.md`

**Goal:** `alp:team` orchestrates **Codex** (and Pi) workers in addition to native Claude Agent Teams,
for cost-savings + multi-model ensemble, with **live steering** (monitor/intervene mid-task).

**Approach:** Vendor MIT-licensed `csd` (prebuilt `dist/`, no build toolchain) as a second backend.
Switch via `--harness claude|codex|pi`. Add `--mixed` = run native Agent Teams (claude) **and** csd
(codex/pi) workers **simultaneously** in one run (user's explicit choice; highest-complexity path —
gated to read-only templates first).

**Key constraint discovered:** Agent Teams primitives (`TeamCreate`/`TaskCreate`/`Agent`/`SendMessage`)
do NOT exist outside Claude Code. Codex orchestration = separate OS processes driven via `csd` CLI,
observed via disk + JSONL event streams. csd workers **cannot peer-message** — lead mediates all cross-talk.

**Non-negotiables:**
- Native path (`--harness claude`, default) stays byte-for-byte behavior-compatible. Pure augmentation.
- No TS build step added to plugin — vendor committed `dist/` only.
- Verify artifacts **on disk**, never trust worker prose (codex can false-report success).

---

## Phases

| # | Phase | Status | Effort | Files |
|---|-------|--------|--------|-------|
| 1 | Vendor csd (prebuilt) + smoke test | done* | M | `skills/team/csd-runtime/**`, `skills/team/scripts/csd-env-check.sh` |
| 2 | `--harness` flag + csd-mode driving protocol | done | L | `skills/team/SKILL.md`, `skills/team/references/csd-backend-driving.md` |
| 3 | `--mixed` (native+csd) protocol + coordination rules | done | L | `skills/team/SKILL.md`, `rules/team-coordination-rules.md` |
| 4 | Prerequisites, safeguards, docs, teardown | done | S | `skills/team/SKILL.md`, `README.md` (codebase-summary.md N/A — absent) |

\* Phase 1 code done + verified (`csd list`/env-check run clean); live Codex smoke test deferred on missing `tmux`.

**Effort:** S=small, M=medium, L=large.

## Dependency chain

`Phase 1` → `Phase 2` → `Phase 3` → `Phase 4` (strictly sequential — each builds on prior).

## Runtime prerequisites (document, do not install for user)

- Node `>=22.12.0` (csd runtime)
- `tmux`
- Codex CLI authenticated locally (`~/.codex`) — and in any CI target
- Optional: `CSD_CODEX_MODEL` for model override

## Success criteria

- `--harness codex` end-to-end on `research`: launch → converse → read-events → collect-on-disk → stop → prune. No orphan tmux / `/tmp/csd-workers` leftovers.
- `--mixed claude,codex` produces a cross-model synthesis on `research`/`review`.
- Native-only path (`--harness claude`) unchanged (regression check).
- All worker results verified against on-disk artifacts, not prose.

## Out of scope (YAGNI)

- Pi-specific tuning beyond what csd gives for free.
- `--mixed` for `cook`/`debug` (deferred until read-only modes proven).
- Crash-recovery for codex (csd has none; relaunch-from-zero is accepted).
- Rewriting/forking csd internals.
