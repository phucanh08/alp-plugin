#!/usr/bin/env bash
# Pre-flight check for alp:team csd backend (--harness codex|pi, --mixed).
# Emits PASS/FAIL per prerequisite + a single overall verdict on the last line:
#   CSD_ENV: PASS   or   CSD_ENV: FAIL
# The skill MUST run this before entering csd mode and STOP on FAIL.
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CSD="$SCRIPT_DIR/../csd-runtime/csd"
fail=0

check() { # label, condition-result(0/1), detail
  if [ "$2" -eq 0 ]; then
    printf 'PASS  %-18s %s\n' "$1" "$3"
  else
    printf 'FAIL  %-18s %s\n' "$1" "$3"
    fail=1
  fi
}

# Node >= 22.12
if command -v node >/dev/null 2>&1; then
  ver="$(node -p 'process.versions.node')"
  major="${ver%%.*}"; rest="${ver#*.}"; minor="${rest%%.*}"
  if [ "$major" -gt 22 ] || { [ "$major" -eq 22 ] && [ "$minor" -ge 12 ]; }; then
    check "node>=22.12" 0 "v$ver"
  else
    check "node>=22.12" 1 "found v$ver (need >=22.12.0)"
  fi
else
  check "node>=22.12" 1 "node not on PATH"
fi

# tmux (csd hard requirement)
if command -v tmux >/dev/null 2>&1; then
  check "tmux" 0 "$(tmux -V 2>/dev/null)"
else
  check "tmux" 1 "missing — install (macOS: brew install tmux)"
fi

# Codex CLI + auth (only required when using --harness codex / --mixed with codex)
if command -v codex >/dev/null 2>&1; then
  check "codex-cli" 0 "$(codex --version 2>/dev/null | head -1)"
else
  check "codex-cli" 1 "missing (needed for --harness codex)"
fi
if [ -d "$HOME/.codex" ]; then
  check "codex-auth" 0 "~/.codex present"
else
  check "codex-auth" 1 "~/.codex absent — run codex login"
fi

# Vendored csd reachable + actually runnable ('list' exits 0 without tmux)
if [ -x "$CSD" ] && "$CSD" list >/dev/null 2>&1; then
  check "csd-runtime" 0 "$CSD (runnable)"
elif [ -f "$SCRIPT_DIR/../csd-runtime/lib/csd.cjs" ]; then
  check "csd-runtime" 1 "bundle present but '$CSD list' failed"
else
  check "csd-runtime" 1 "vendored bundle not found"
fi

if [ "$fail" -eq 0 ]; then
  echo "CSD_ENV: PASS"
  exit 0
else
  echo "CSD_ENV: FAIL"
  exit 1
fi
