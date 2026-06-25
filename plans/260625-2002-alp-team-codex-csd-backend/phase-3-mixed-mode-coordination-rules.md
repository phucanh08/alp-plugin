# Phase 3 — `--mixed` (native + csd simultaneous) + coordination rules

**Status:** pending · **Effort:** L · **BlockedBy:** Phase 2 · **Blocks:** Phase 4

> ⚠️ Highest-complexity path. Advisor flagged not-recommended; user chose it explicitly for ensemble.
> Mitigations below are mandatory, not optional.

## Objective
Run native Agent Teams (claude) **and** csd (codex/pi) workers **concurrently in one run**, lead
cross-checks across models. Strongest bias-reduction, two monitoring loops at once.

## Files
- `skills/team/SKILL.md` (edit)
- `rules/team-coordination-rules.md` (edit — add csd-mode addendum)

## Steps

1. **`--mixed <list>` syntax (SKILL.md):** e.g. `--mixed claude,codex,codex` → 1 native + 2 csd workers.
   Parse into two pools: `native[]` (Agent Teams) and `csd[]` (per-harness).

2. **Gate scope (KISS):** `--mixed` allowed for **`research` and `review` only** at first
   (read-only fan-out + cross-check). **Reject** `--mixed` on `cook`/`debug` with a clear message
   (deferred — two isolation/cross-talk models too risky). Recorded in plan "Out of scope".

3. **Dual-loop orchestration protocol:**
   - **Native pool:** `TeamCreate` + `TaskCreate` + `Agent(run_in_background)`; monitor via
     `TaskCompleted` hook events (existing mechanism).
   - **csd pool:** `csd launch` per worker; monitor via `read-events --follow` / `status` polling.
   - **Separate namespaces in lead context:** native tracked by `TaskList`; csd tracked by a
     lead-maintained table (`name | harness | status | report-path`). Never conflate the two.
   - Lead waits on BOTH pools complete before synthesis.

4. **csd worker cap:** hard ceiling on csd workers in mixed mode (propose **max 3**) to bound lead
   polling/relay overhead. Document the cost trade-off (Opus lead keeps burning tokens while steering).

5. **Synthesis:** lead reads all reports on disk (native + csd) → single cross-model synthesis doc;
   explicitly note where models agreed/disagreed (the ensemble value).

6. **Teardown both pools:** native → `shutdown_request` + `TeamDelete`; csd → `csd stop` all + `csd prune`.
   Verify clean: `TaskList` cleared AND `csd list` empty.

7. **Coordination rules addendum (`rules/team-coordination-rules.md`):** add a clearly-scoped section
   "csd-Backend Workers (non-native)":
   - csd workers **cannot peer-message** — they share only disk + event streams with the lead;
     the existing "Communication Protocol" (SendMessage) applies to native teammates ONLY.
   - **Verify on disk, not prose** — csd workers may false-report success.
   - **No crash recovery** for codex/pi (no resume-by-id) — relaunch from zero.
   - **Codex not queryable until first `converse`** completes.
   - In `--mixed`: keep native + csd in separate tracking namespaces; lead mediates ALL cross-pool info.
   - Keep the rule header note (line 3) accurate: clarify it now covers native teammates AND
     lead-driven csd workers.

## Acceptance
- `--mixed claude,codex` on `research` spawns both pools, monitors both, synthesizes cross-model, tears
  down both cleanly.
- `--mixed` on `cook`/`debug` is rejected with explanation.
- csd worker count capped; cap message shown when exceeded.
- Coordination rules clearly separate native vs csd worker behavior (no ambiguity about peer messaging).

## Risks
- **Two monitoring models = highest failure surface.** Mitigate: strict namespace separation, cap,
  read-only-only gating, verify-on-disk.
- **Partial failure** (native ok, csd dead): lead must report partial synthesis honestly, not silently
  drop a pool. Add explicit "report partial + which pool failed" instruction.

## Unresolved
- Exact csd cap (propose 3) — confirm at execution.
- Whether `--mixed` should auto-fall-back to native-only if `csd-env-check` fails, or hard-stop
  (propose: warn + continue native-only for research/review).
