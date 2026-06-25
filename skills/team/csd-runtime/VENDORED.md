# Vendored: claude-session-driver (csd)

Prebuilt runtime of [obra/claude-session-driver](https://github.com/obra/claude-session-driver),
vendored to give `alp:team` a harness-agnostic backend (Codex / Pi / Claude workers) for
`--harness codex|pi` and `--mixed`.

## Provenance

| Field | Value |
|-------|-------|
| Upstream | https://github.com/obra/claude-session-driver |
| Pinned commit | `d97d1eb0a904546ed059b0a33dd5d4aa3e199c9a` |
| Upstream version | `4.0.0` |
| Vendored date | 2026-06-25 |
| License | MIT © 2025 Jesse Vincent (see `LICENSE`) |

## What is vendored (prebuilt only — no build toolchain)

`dist/` is committed upstream and CI-verified (`dist:check = pnpm build && git diff --exit-code dist/`),
so we vendor the prebuilt bundle directly. The bundle is fully self-contained (tsup, no external
runtime `node_modules`).

```
csd-runtime/
├── csd                 # alp wrapper entry (NOT upstream's scripts/csd — see note below)
├── lib/                # prebuilt bundle (renamed from upstream dist/)
│   ├── csd.cjs
│   ├── emit-event.cjs  # hook program workers run to emit JSONL lifecycle events
│   └── pi-extension.mjs
├── .claude-plugin/plugin.json   # needed when csd launches a claude worker (--plugin-dir)
├── hooks/hooks.json    # paths rewritten dist/ -> lib/
├── LICENSE             # MIT attribution (MANDATORY)
└── VENDORED.md         # this file
```

Not vendored: `src/`, `tests/`, configs, lockfiles, `node_modules/`.

## Two deliberate deviations from upstream

1. **Bundle dir `dist/` -> `lib/`.** alp's scout-block `.alpignore` blocks the literal `dist` and
   `vendor` path tokens from context tooling. Naming the dir `lib/` (and the parent `csd-runtime/`,
   not `vendor/`) keeps the tree readable to Grep/Glob/Bash. `hooks/hooks.json` paths rewritten to match.

2. **Custom `csd` wrapper.** Upstream `scripts/csd` honors inherited `$CLAUDE_PLUGIN_ROOT`, which inside
   the alp plugin points at alp — wrong for csd. Our wrapper forces `CLAUDE_PLUGIN_ROOT` + the
   `CSD_*_PATH` overrides to this vendored tree. In alp:team's design csd is only invoked for
   codex/pi (claude workers use native Agent Teams), and codex/pi resolve `emit-event.cjs` via
   `__dirname`/`CSD_EMIT_EVENT_PATH` independent of `CLAUDE_PLUGIN_ROOT` — so this is robust.

## Runtime prerequisites

- Node `>=22.12.0`
- `tmux` (hard requirement — csd manages workers as tmux sessions)
- Codex CLI authenticated (`~/.codex`) for `--harness codex`; optional `CSD_CODEX_MODEL` override
- Pi: `~/.pi/agent` for `--harness pi`

Run `skills/team/scripts/csd-env-check.sh` to verify.

## ⚠️ Upgrade fragility

csd worker shim paths (`/tmp/csd-workers/bin/<name>`) embed the absolute path to this vendored tree.
The plugin installs at a **versioned** cache path (`.../alp/<version>/...`); upgrading the plugin
changes that path and **invalidates any running csd workers** → finish/teardown running teams
(`csd stop` + `csd prune`) BEFORE upgrading, then relaunch.

## Re-vendoring (when bumping the pin)

```
git clone --depth 1 https://github.com/obra/claude-session-driver <tmp>
# copy <tmp>/dist/{csd.cjs,emit-event.cjs,pi-extension.mjs} -> lib/
# copy <tmp>/.claude-plugin/plugin.json, <tmp>/LICENSE
# re-apply hooks/hooks.json with dist/ -> lib/
# update the Pinned commit + version + date table above
```
