# Phase 4 — Prerequisites, safeguards, docs, teardown

**Status:** pending · **Effort:** S · **BlockedBy:** Phase 3

## Objective
Cross-cutting hardening + discoverability: document prereqs/auth, codify safeguards, update user-facing
docs so the new harness support is findable and the failure modes are known.

## Files
- `skills/team/SKILL.md` (edit — Requirements + safeguards)
- `README.md` (edit — note multi-harness support)
- `docs/codebase-summary.md` (edit — record vendored csd + backend architecture)

## Steps

1. **Requirements block (SKILL.md):** add csd-mode prerequisites alongside existing Agent Teams reqs:
   - Node ≥22.12, `tmux`, Codex CLI authed (`~/.codex`), `CSD_CODEX_MODEL` optional.
   - csd-mode runs in environments where native Agent Teams cannot (incl. VSCode), since it's
     external processes — note this as the one place csd beats native.

2. **Safeguards (SKILL.md), consolidated checklist for csd/mixed modes:**
   - Verify artifacts on disk before declaring success.
   - Always `csd prune` + verify `csd list` empty on exit (no orphan tmux / `/tmp/csd-workers`).
   - **Shim path fragility:** shim embeds absolute (versioned) plugin path → **finish running teams
     before upgrading the plugin**; upgrade invalidates live workers → relaunch.
   - csd worker cap honored in `--mixed`.
   - Codex: relaunch on death (no recovery); `converse` before any monitoring.

3. **README:** one line under the team/orchestration section — "`alp:team` supports `--harness
   claude|codex|pi` and `--mixed` (multi-model ensemble) via vendored csd (MIT)."

4. **docs/codebase-summary.md:** record the dual-backend architecture (native Agent Teams vs vendored
   csd), where csd lives (`skills/team/vendor/csd/`), pinned version pointer to `VENDORED.md`, and the
   "one run = one backend except --mixed" rule.

5. **Attribution check:** confirm MIT LICENSE present in vendor dir and credited (README or VENDORED.md).

6. **Version bump:** bump `alp:team` SKILL.md `metadata.version` (3.0.0 → 3.1.0) + changelog note;
   consider plugin manifest `2.14.0` → `2.15.0` per repo convention.

## Acceptance
- Prereqs + safeguards documented in SKILL.md; a new user can self-diagnose missing deps.
- README + codebase-summary reflect multi-harness support.
- MIT attribution present.
- Version bumped + changelog noted.

## Risks
- **Docs drift** if SKILL.md/README diverge — single source of truth = SKILL.md Requirements; others link.

## Unresolved
- Plugin manifest version bump magnitude (minor 2.15.0 proposed).
