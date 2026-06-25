# Phase 1 — Vendor csd (prebuilt) + smoke test

**Status:** pending · **Effort:** M · **Blocks:** Phase 2

## Objective
Get a working, version-pinned `csd` CLI inside the plugin, invokable from the skill path, verified
end-to-end against a real Codex worker. No TS build toolchain added.

## Why prebuilt is safe
`package.json` ships `dist:check = pnpm build && git diff --exit-code dist/` → **`dist/` is committed**
and CI-verified to match source. Vendor the committed `dist/` directly. Runtime needs only Node ≥22.12.

## Steps

1. **Pin upstream version.** Choose a release tag or commit SHA of `obra/claude-session-driver`.
   Record it in `skills/team/vendor/csd/VENDORED.md` (URL, SHA, date, license=MIT © Jesse Vincent).

2. **Vendor files** into `skills/team/vendor/csd/`:
   - `dist/**` (compiled output)
   - `skills/driving-claude-code-sessions/scripts/csd` (entry script/shim)
   - `hooks/**` (node hook programs that emit JSONL events)
   - `package.json` (for `bin`/module resolution + runtime metadata)
   - `LICENSE` (MANDATORY — MIT attribution)
   - Do NOT vendor: `src/`, `tests/`, `node_modules/`, lockfiles, configs.

3. **Resolve runtime module deps.** Confirm whether `dist/` is fully bundled (tsup, `type: module`).
   - If bundled (no external runtime deps): nothing else needed.
   - If it requires prod `dependencies`: vendor a pruned `node_modules` for prod-only, OR document a
     one-time `pnpm install --prod` in vendor dir. Prefer bundled — verify by running csd with an empty
     `node_modules`.

4. **Path resolution check (CRITICAL RISK).** csd shim embeds the **absolute skill path**.
   Plugin installs at versioned cache path (`.../alp/<version>/skills/team/vendor/csd/...`).
   - Verify how the vendored `csd` resolves its own dir (relative `__dirname` vs hardcoded).
   - Confirm a fresh `csd launch` after copy produces a usable `/tmp/csd-workers/bin/<name>` shim.
   - Document: **plugin upgrade changes the path → relaunch any running workers.**

5. **Env-check helper** `skills/team/scripts/csd-env-check.sh`:
   - Checks: `node --version` ≥22.12, `tmux` present, `codex` on PATH + `~/.codex` exists, csd runnable.
   - Emits a clear PASS/FAIL report; skill calls this before entering csd mode.

6. **Smoke test (manual, documented in VENDORED.md):**
   ```bash
   CSD=skills/team/vendor/csd/.../csd
   $CSD launch --harness codex smoke /tmp/csd-smoke
   /tmp/csd-workers/bin/smoke converse "Print hello and exit" 120
   /tmp/csd-workers/bin/smoke read-events --last 5
   /tmp/csd-workers/bin/smoke status
   /tmp/csd-workers/bin/smoke stop
   $CSD prune
   ```
   Confirm: events captured, status transitions idle→working→idle/terminated, no orphan tmux.

## Acceptance
- `csd-env-check.sh` PASS on dev machine.
- Smoke test launches + converses + collects events + tears down cleanly (`csd list` empty after prune).
- `VENDORED.md` records pinned SHA + license + path-fragility note.

## Risks
- **dist not bundled** → unexpected runtime deps. Mitigate: test with empty node_modules in step 3.
- **Node <22.12 on user machine** → csd fails. Mitigate: env-check gates with clear message.
- **Absolute-path shim** → handled in step 4 + documented.

## Unresolved
- Exact pinned SHA/tag (decide at execution).
- Whether to commit vendored `node_modules` (only if dist not fully bundled).
