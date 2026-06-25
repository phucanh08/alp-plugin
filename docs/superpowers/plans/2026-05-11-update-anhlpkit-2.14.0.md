# Update alp-plugin to anhlpkit-engineer 2.14.0 — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Sync alp-plugin with anhlpkit-engineer-2.14.0 by adding 31 new skills, 5 new hooks, 3 new lib utilities, updated existing hooks/agents/rules, and new root-level files.

**Architecture:** File-copy sync from `D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0` (SRC) into `D:\Projects\alp-plugin` (DEST). Mapping: `SRC/.claude/skills/` → `DEST/skills/`, `SRC/.claude/hooks/` → `DEST/hooks/`, `SRC/.claude/agents/` → `DEST/agents/`, `SRC/.claude/rules/` → `DEST/rules/`. Existing hooks.json is updated to add new hook registrations while preserving the `${CLAUDE_PLUGIN_ROOT}` path prefix.

**Tech Stack:** PowerShell (Copy-Item), JSON editing for hooks.json, Markdown

---

## Variables (reuse across all tasks)

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
```

---

## Task 1: Create feature branch

**Files:**
- Git branch: `update/anhlpkit-engineer-2.14.0`

- [ ] **Step 1: Create and switch to feature branch**

```powershell
Set-Location "D:\Projects\alp-plugin"
git checkout -b update/anhlpkit-engineer-2.14.0
```

Expected: `Switched to a new branch 'update/anhlpkit-engineer-2.14.0'`

---

## Task 2: Add new skills — batch 1 (core infrastructure: _shared, ask, bootstrap, alp-*)

**Files:**
- Create: `skills\_shared\`
- Create: `skills\ask\`
- Create: `skills\bootstrap\`
- Create: `skills\alp-autoresearch\`
- Create: `skills\alp-debug\`
- Create: `skills\alp-help\`
- Create: `skills\alp-loop\`
- Create: `skills\alp-plan\`
- Create: `skills\alp-predict\`
- Create: `skills\alp-scenario\`
- Create: `skills\alp-security\`

- [ ] **Step 1: Copy alp-* and core new skills**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newSkills = @("_shared","ask","bootstrap","alp-autoresearch","alp-debug","alp-help","alp-loop","alp-plan","alp-predict","alp-scenario","alp-security")
foreach ($skill in $newSkills) {
    Copy-Item -Path "$SRC\.claude\skills\$skill" -Destination "$DEST\skills\$skill" -Recurse -Force
    Write-Host "Copied: $skill"
}
```

Expected: Each skill name printed with "Copied: " prefix, no errors.

- [ ] **Step 2: Verify batch 1**

```powershell
$skills = @("_shared","ask","bootstrap","alp-autoresearch","alp-debug","alp-help","alp-loop","alp-plan","alp-predict","alp-scenario","alp-security")
foreach ($s in $skills) {
    $exists = Test-Path "D:\Projects\alp-plugin\skills\$s"
    Write-Host "$s : $exists"
}
```

Expected: All show `True`.

- [ ] **Step 3: Commit batch 1**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add skills\_shared skills\ask skills\bootstrap skills\alp-autoresearch skills\alp-debug skills\alp-help skills\alp-loop skills\alp-plan skills\alp-predict skills\alp-scenario skills\alp-security
git commit -m "feat: add new skills batch 1 (_shared, ask, bootstrap, alp-*) from anhlpkit-engineer 2.14.0"
```

---

## Task 3: Add new skills — batch 2 (dev tools: coding-level, deploy, design, docs, journal, kanban)

**Files:**
- Create: `skills\coding-level\`
- Create: `skills\deploy\`
- Create: `skills\design\`
- Create: `skills\docs\`
- Create: `skills\journal\`
- Create: `skills\kanban\`

- [ ] **Step 1: Copy batch 2 skills**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newSkills = @("coding-level","deploy","design","docs","journal","kanban")
foreach ($skill in $newSkills) {
    Copy-Item -Path "$SRC\.claude\skills\$skill" -Destination "$DEST\skills\$skill" -Recurse -Force
    Write-Host "Copied: $skill"
}
```

Expected: Each skill printed, no errors.

- [ ] **Step 2: Verify batch 2**

```powershell
$skills = @("coding-level","deploy","design","docs","journal","kanban")
foreach ($s in $skills) { Write-Host "$s : $(Test-Path "D:\Projects\alp-plugin\skills\$s")" }
```

Expected: All `True`.

- [ ] **Step 3: Commit batch 2**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add skills\coding-level skills\deploy skills\design skills\docs skills\journal skills\kanban
git commit -m "feat: add new skills batch 2 (coding-level, deploy, design, docs, journal, kanban) from anhlpkit-engineer 2.14.0"
```

---

## Task 4: Add new skills — batch 3 (project & team: llms, preview, project-*, retro, security-scan, ship, stitch, tanstack, team, test, use-mcp, watzup, worktree)

**Files:**
- Create: `skills\llms\`
- Create: `skills\preview\`
- Create: `skills\project-management\`
- Create: `skills\project-organization\`
- Create: `skills\retro\`
- Create: `skills\security-scan\`
- Create: `skills\ship\`
- Create: `skills\stitch\`
- Create: `skills\tanstack\`
- Create: `skills\team\`
- Create: `skills\test\`
- Create: `skills\use-mcp\`
- Create: `skills\watzup\`
- Create: `skills\worktree\`

- [ ] **Step 1: Copy batch 3 skills**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newSkills = @("llms","preview","project-management","project-organization","retro","security-scan","ship","stitch","tanstack","team","test","use-mcp","watzup","worktree")
foreach ($skill in $newSkills) {
    Copy-Item -Path "$SRC\.claude\skills\$skill" -Destination "$DEST\skills\$skill" -Recurse -Force
    Write-Host "Copied: $skill"
}
```

Expected: Each skill printed, no errors.

- [ ] **Step 2: Verify batch 3**

```powershell
$skills = @("llms","preview","project-management","project-organization","retro","security-scan","ship","stitch","tanstack","team","test","use-mcp","watzup","worktree")
foreach ($s in $skills) { Write-Host "$s : $(Test-Path "D:\Projects\alp-plugin\skills\$s")" }
```

Expected: All `True`.

- [ ] **Step 3: Commit batch 3**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add skills\llms skills\preview skills\project-management skills\project-organization skills\retro skills\security-scan skills\ship skills\stitch skills\tanstack skills\team skills\test skills\use-mcp skills\watzup skills\worktree
git commit -m "feat: add new skills batch 3 (llms, preview, project-*, retro, security-scan, ship, stitch, tanstack, team, test, use-mcp, watzup, worktree) from anhlpkit-engineer 2.14.0"
```

---

## Task 5: Update shared skills (overwrite with anhlpkit 2.14.0 versions)

**Files:**
- Modify: `skills\agent-browser\`, `skills\ai-artist\`, `skills\ai-multimodal\`, `skills\backend-development\`, `skills\better-auth\`, `skills\brainstorm\`, `skills\chrome-devtools\`, `skills\code-review\`, `skills\common\`, `skills\context-engineering\`, `skills\cook\`, `skills\copywriting\`, `skills\databases\`, `skills\debug\`, `skills\devops\`, `skills\docs-seeker\`, `skills\document-skills\`, `skills\find-skills\`, `skills\fix\`, `skills\frontend-design\`, `skills\frontend-development\`, `skills\git\`, `skills\gkg\`, `skills\google-adk-python\`, `skills\mobile-development\`, `skills\payment-integration\`, `skills\plans-kanban\`, `skills\problem-solving\`, `skills\react-best-practices\`, `skills\remotion\`, `skills\scout\`, `skills\sequential-thinking\`, `skills\skill-creator\`, `skills\template-skill\`, `skills\ui-styling\`, `skills\ui-ux-pro-max\`, `skills\web-design-guidelines\`, `skills\web-testing\`
- Modify: `skills\agent_skills_spec.md`, `skills\install.ps1`, `skills\install.sh`, `skills\INSTALLATION.md`, `skills\README.md`, `skills\THIRD_PARTY_NOTICES.md`

- [ ] **Step 1: Overwrite shared skills with updated versions**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$sharedSkills = @(
    "agent-browser","ai-artist","ai-multimodal","backend-development","better-auth",
    "brainstorm","chrome-devtools","code-review","common","context-engineering","cook",
    "copywriting","databases","debug","devops","docs-seeker","document-skills",
    "find-skills","fix","frontend-design","frontend-development","git","gkg",
    "google-adk-python","mobile-development","payment-integration","plans-kanban",
    "problem-solving","react-best-practices","remotion","scout","sequential-thinking",
    "skill-creator","template-skill","ui-styling","ui-ux-pro-max","web-design-guidelines","web-testing"
)
foreach ($skill in $sharedSkills) {
    if (Test-Path "$SRC\.claude\skills\$skill") {
        Copy-Item -Path "$SRC\.claude\skills\$skill" -Destination "$DEST\skills\$skill" -Recurse -Force
        Write-Host "Updated: $skill"
    } else {
        Write-Host "SKIP (not in src): $skill"
    }
}
```

Expected: All skills print "Updated: " prefix.

- [ ] **Step 2: Update root skill files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$rootFiles = @("agent_skills_spec.md","install.ps1","install.sh","INSTALLATION.md","README.md","THIRD_PARTY_NOTICES.md",".env.example",".gitignore")
foreach ($file in $rootFiles) {
    if (Test-Path "$SRC\.claude\skills\$file") {
        Copy-Item -Path "$SRC\.claude\skills\$file" -Destination "$DEST\skills\$file" -Force
        Write-Host "Updated: $file"
    }
}
```

Expected: Each file printed, no errors.

- [ ] **Step 3: Commit shared skills update**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add skills\
git commit -m "feat: update shared skills to anhlpkit-engineer 2.14.0 versions"
```

---

## Task 6: Add new hook files (main hooks + lib utilities)

**Files:**
- Create: `hooks\plan-format-kanban.cjs`
- Create: `hooks\session-state.cjs`
- Create: `hooks\task-completed-handler.cjs`
- Create: `hooks\team-context-inject.cjs`
- Create: `hooks\teammate-idle-handler.cjs`
- Create: `hooks\lib\git-info-cache.cjs`
- Create: `hooks\lib\hook-logger.cjs`
- Create: `hooks\lib\session-state-manager.cjs`
- Create: `hooks\scout-block\vendor\ignore.cjs`

- [ ] **Step 1: Copy new main hook files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newHooks = @("plan-format-kanban.cjs","session-state.cjs","task-completed-handler.cjs","team-context-inject.cjs","teammate-idle-handler.cjs")
foreach ($hook in $newHooks) {
    Copy-Item -Path "$SRC\.claude\hooks\$hook" -Destination "$DEST\hooks\$hook" -Force
    Write-Host "Copied hook: $hook"
}
```

Expected: Each hook file copied, no errors.

- [ ] **Step 2: Copy new lib utility files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newLibFiles = @("git-info-cache.cjs","hook-logger.cjs","session-state-manager.cjs")
foreach ($lib in $newLibFiles) {
    Copy-Item -Path "$SRC\.claude\hooks\lib\$lib" -Destination "$DEST\hooks\lib\$lib" -Force
    Write-Host "Copied lib: $lib"
}
```

Expected: Each lib file copied, no errors.

- [ ] **Step 3: Copy scout-block vendor file**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
New-Item -Path "$DEST\hooks\scout-block\vendor" -ItemType Directory -Force | Out-Null
Copy-Item -Path "$SRC\.claude\hooks\scout-block\vendor\ignore.cjs" -Destination "$DEST\hooks\scout-block\vendor\ignore.cjs" -Force
Write-Host "Copied scout-block vendor"
```

Expected: No errors.

- [ ] **Step 4: Verify new hook files exist**

```powershell
$DEST = "D:\Projects\alp-plugin"
$files = @(
    "hooks\plan-format-kanban.cjs","hooks\session-state.cjs","hooks\task-completed-handler.cjs",
    "hooks\team-context-inject.cjs","hooks\teammate-idle-handler.cjs",
    "hooks\lib\git-info-cache.cjs","hooks\lib\hook-logger.cjs","hooks\lib\session-state-manager.cjs",
    "hooks\scout-block\vendor\ignore.cjs"
)
foreach ($f in $files) { Write-Host "$f : $(Test-Path "$DEST\$f")" }
```

Expected: All `True`.

- [ ] **Step 5: Commit new hook files**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add hooks\plan-format-kanban.cjs hooks\session-state.cjs hooks\task-completed-handler.cjs hooks\team-context-inject.cjs hooks\teammate-idle-handler.cjs hooks\lib\git-info-cache.cjs hooks\lib\hook-logger.cjs hooks\lib\session-state-manager.cjs hooks\scout-block\vendor\
git commit -m "feat: add new hook files from anhlpkit-engineer 2.14.0 (session-state, plan-format-kanban, team-context-inject, etc.)"
```

---

## Task 7: Add new hook tests

**Files:**
- Create: `hooks\__tests__\hook-logger.test.cjs`
- Create: `hooks\__tests__\plan-format-kanban.test.cjs`
- Create: `hooks\lib\__tests__\project-detector.test.cjs`
- Create: `hooks\lib\__tests__\statusline-scenarios.test.cjs`
- Create: `hooks\lib\__tests__\statusline-suite.cjs`
- Create: `hooks\tests\` (entire new test directory)

- [ ] **Step 1: Copy new __tests__ files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newTests = @("hook-logger.test.cjs","plan-format-kanban.test.cjs")
foreach ($t in $newTests) {
    Copy-Item -Path "$SRC\.claude\hooks\__tests__\$t" -Destination "$DEST\hooks\__tests__\$t" -Force
    Write-Host "Copied test: $t"
}
```

Expected: Both test files copied.

- [ ] **Step 2: Copy new lib/__tests__ files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$newLibTests = @("project-detector.test.cjs","statusline-scenarios.test.cjs","statusline-suite.cjs")
foreach ($t in $newLibTests) {
    Copy-Item -Path "$SRC\.claude\hooks\lib\__tests__\$t" -Destination "$DEST\hooks\lib\__tests__\$t" -Force
    Write-Host "Copied lib test: $t"
}
```

Expected: All 3 files copied.

- [ ] **Step 3: Copy new tests/ directory**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
Copy-Item -Path "$SRC\.claude\hooks\tests" -Destination "$DEST\hooks\tests" -Recurse -Force
Write-Host "Copied tests directory"
Get-ChildItem -Path "$DEST\hooks\tests" -Recurse -Name | Sort-Object
```

Expected: Directory created, test files listed.

- [ ] **Step 4: Commit new hook tests**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add hooks\__tests__\hook-logger.test.cjs hooks\__tests__\plan-format-kanban.test.cjs hooks\lib\__tests__\ hooks\tests\
git commit -m "feat: add new hook test files from anhlpkit-engineer 2.14.0"
```

---

## Task 8: Update existing hooks (overwrite with anhlpkit 2.14.0 versions)

**Files:**
- Modify: `hooks\cook-after-plan-reminder.cjs`
- Modify: `hooks\descriptive-name.cjs`
- Modify: `hooks\dev-rules-reminder.cjs`
- Modify: `hooks\post-edit-simplify-reminder.cjs`
- Modify: `hooks\privacy-block.cjs`
- Modify: `hooks\scout-block.cjs`
- Modify: `hooks\session-init.cjs`
- Modify: `hooks\skill-dedup.cjs`
- Modify: `hooks\subagent-init.cjs`
- Modify: `hooks\usage-context-awareness.cjs`
- Modify: `hooks\lib\alp-config-utils.cjs`
- Modify: `hooks\lib\colors.cjs`
- Modify: `hooks\lib\config-counter.cjs`
- Modify: `hooks\lib\context-builder.cjs`
- Modify: `hooks\lib\privacy-checker.cjs`
- Modify: `hooks\lib\project-detector.cjs`
- Modify: `hooks\lib\scout-checker.cjs`
- Modify: `hooks\lib\transcript-parser.cjs`
- Modify: `hooks\scout-block\broad-pattern-detector.cjs`
- Modify: `hooks\scout-block\error-formatter.cjs`
- Modify: `hooks\scout-block\path-extractor.cjs`
- Modify: `hooks\scout-block\pattern-matcher.cjs`

- [ ] **Step 1: Overwrite existing main hook files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$existingHooks = @(
    "cook-after-plan-reminder.cjs","descriptive-name.cjs","dev-rules-reminder.cjs",
    "post-edit-simplify-reminder.cjs","privacy-block.cjs","scout-block.cjs",
    "session-init.cjs","skill-dedup.cjs","subagent-init.cjs","usage-context-awareness.cjs"
)
foreach ($hook in $existingHooks) {
    Copy-Item -Path "$SRC\.claude\hooks\$hook" -Destination "$DEST\hooks\$hook" -Force
    Write-Host "Updated hook: $hook"
}
```

Expected: All 10 files updated.

- [ ] **Step 2: Overwrite existing lib files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$existingLibs = @(
    "alp-config-utils.cjs","colors.cjs","config-counter.cjs","context-builder.cjs",
    "privacy-checker.cjs","project-detector.cjs","scout-checker.cjs","transcript-parser.cjs"
)
foreach ($lib in $existingLibs) {
    if (Test-Path "$SRC\.claude\hooks\lib\$lib") {
        Copy-Item -Path "$SRC\.claude\hooks\lib\$lib" -Destination "$DEST\hooks\lib\$lib" -Force
        Write-Host "Updated lib: $lib"
    }
}
```

Expected: All existing lib files updated.

- [ ] **Step 3: Overwrite scout-block modules**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$scoutFiles = @("broad-pattern-detector.cjs","error-formatter.cjs","path-extractor.cjs","pattern-matcher.cjs")
foreach ($f in $scoutFiles) {
    Copy-Item -Path "$SRC\.claude\hooks\scout-block\$f" -Destination "$DEST\hooks\scout-block\$f" -Force
    Write-Host "Updated scout-block: $f"
}
```

Expected: All 4 files updated.

- [ ] **Step 4: Update existing hook tests**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$existingTests = @(
    "alp-config-utils.test.cjs","descriptive-name.test.cjs","dev-rules-reminder.test.cjs",
    "privacy-block.test.cjs","session-init.test.cjs","skill-dedup.test.cjs","subagent-init.test.cjs"
)
foreach ($t in $existingTests) {
    if (Test-Path "$SRC\.claude\hooks\__tests__\$t") {
        Copy-Item -Path "$SRC\.claude\hooks\__tests__\$t" -Destination "$DEST\hooks\__tests__\$t" -Force
        Write-Host "Updated test: $t"
    }
}
# Update lib tests
$libTests = @("alp-config-utils.test.cjs","context-builder.test.cjs","statusline-integration.test.cjs","statusline.test.cjs","README.md")
foreach ($t in $libTests) {
    if (Test-Path "$SRC\.claude\hooks\lib\__tests__\$t") {
        Copy-Item -Path "$SRC\.claude\hooks\lib\__tests__\$t" -Destination "$DEST\hooks\lib\__tests__\$t" -Force
        Write-Host "Updated lib test: $t"
    }
}
# Update scout-block tests
$sbTests = @("test-broad-pattern-detector.cjs","test-build-command-allowlist.cjs","test-error-formatter.cjs","test-full-flow-edge-cases.cjs","test-monorepo-scenarios.cjs","test-path-extractor.cjs","test-pattern-matcher.cjs")
foreach ($t in $sbTests) {
    if (Test-Path "$SRC\.claude\hooks\scout-block\tests\$t") {
        Copy-Item -Path "$SRC\.claude\hooks\scout-block\tests\$t" -Destination "$DEST\hooks\scout-block\tests\$t" -Force
        Write-Host "Updated sb test: $t"
    }
}
```

Expected: All files updated, no errors.

- [ ] **Step 5: Commit updated hooks**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add hooks\
git commit -m "feat: update existing hooks to anhlpkit-engineer 2.14.0 versions"
```

---

## Task 9: Update hooks.json — add new hook registrations

**Files:**
- Modify: `hooks\hooks.json`

The current `hooks.json` uses `${CLAUDE_PLUGIN_ROOT}/hooks/` prefix. New hooks need to be added:
- `session-state.cjs` → SessionStart (alongside session-init), SubagentStop (no matcher), Stop (new event)
- `team-context-inject.cjs` → SubagentStart (alongside subagent-init)
- `plan-format-kanban.cjs` → PostToolUse Edit|Write|MultiEdit (alongside post-edit-simplify-reminder)
- PostToolUse `*` matcher → change to `Bash|Edit|Write|MultiEdit|NotebookEdit` with timeout 10

- [ ] **Step 1: Read current hooks.json**

```powershell
Get-Content "D:\Projects\alp-plugin\hooks\hooks.json"
```

Expected: Current JSON printed.

- [ ] **Step 2: Write updated hooks.json**

Write the following content to `D:\Projects\alp-plugin\hooks\hooks.json`:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "matcher": "startup|resume|clear|compact",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/session-init.cjs\""
          },
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/session-state.cjs\""
          }
        ]
      }
    ],
    "SubagentStart": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/subagent-init.cjs\""
          },
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/team-context-inject.cjs\""
          }
        ]
      }
    ],
    "SubagentStop": [
      {
        "matcher": "Plan",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/cook-after-plan-reminder.cjs\""
          }
        ]
      },
      {
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/session-state.cjs\""
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/dev-rules-reminder.cjs\""
          },
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/usage-context-awareness.cjs\"",
            "timeout": 30
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "Write",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/descriptive-name.cjs\""
          }
        ]
      },
      {
        "matcher": "Bash|Glob|Grep|Read|Edit|Write",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/scout-block.cjs\""
          },
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/privacy-block.cjs\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/session-state.cjs\""
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Edit|Write|MultiEdit",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/post-edit-simplify-reminder.cjs\""
          },
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/plan-format-kanban.cjs\""
          }
        ]
      },
      {
        "matcher": "Bash|Edit|Write|MultiEdit|NotebookEdit",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/usage-context-awareness.cjs\"",
            "timeout": 10
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 3: Commit hooks.json update**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add hooks\hooks.json
git commit -m "feat: update hooks.json — add session-state, team-context-inject, plan-format-kanban, Stop event"
```

---

## Task 10: Add new rule and update existing rules

**Files:**
- Create: `rules\team-coordination-rules.md`
- Modify: `rules\development-rules.md`
- Modify: `rules\documentation-management.md`
- Modify: `rules\orchestration-protocol.md`
- Modify: `rules\primary-workflow.md`

- [ ] **Step 1: Copy new and updated rules**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$rules = @("development-rules.md","documentation-management.md","orchestration-protocol.md","primary-workflow.md","team-coordination-rules.md")
foreach ($r in $rules) {
    Copy-Item -Path "$SRC\.claude\rules\$r" -Destination "$DEST\rules\$r" -Force
    Write-Host "Updated rule: $r"
}
```

Expected: All 5 rules copied/updated.

- [ ] **Step 2: Verify new rule exists**

```powershell
Test-Path "D:\Projects\alp-plugin\rules\team-coordination-rules.md"
```

Expected: `True`.

- [ ] **Step 3: Commit rules update**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add rules\
git commit -m "feat: update rules and add team-coordination-rules.md from anhlpkit-engineer 2.14.0"
```

---

## Task 11: Update agents

**Files:**
- Modify: `agents\brainstormer.md`, `agents\code-reviewer.md`, `agents\code-simplifier.md`, `agents\debugger.md`, `agents\docs-manager.md`, `agents\fullstack-developer.md`, `agents\git-manager.md`, `agents\journal-writer.md`, `agents\mcp-manager.md`, `agents\planner.md`, `agents\project-manager.md`, `agents\researcher.md`, `agents\tester.md`, `agents\ui-ux-designer.md`

- [ ] **Step 1: Overwrite all agents with updated versions**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$agents = @(
    "brainstormer.md","code-reviewer.md","code-simplifier.md","debugger.md",
    "docs-manager.md","fullstack-developer.md","git-manager.md","journal-writer.md",
    "mcp-manager.md","planner.md","project-manager.md","researcher.md",
    "tester.md","ui-ux-designer.md"
)
foreach ($agent in $agents) {
    Copy-Item -Path "$SRC\.claude\agents\$agent" -Destination "$DEST\agents\$agent" -Force
    Write-Host "Updated agent: $agent"
}
```

Expected: All 14 agents updated.

- [ ] **Step 2: Commit agents update**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add agents\
git commit -m "feat: update all agents to anhlpkit-engineer 2.14.0 versions"
```

---

## Task 12: Add root-level new files (AGENTS.md, CHANGELOG.md, GEMINI.md, .repomixignore, guide/, plans/)

**Files:**
- Create: `AGENTS.md`
- Create: `CHANGELOG.md`
- Create: `GEMINI.md`
- Create: `.repomixignore`
- Create: `guide\` (entire directory)
- Create: `plans\` (entire directory)

- [ ] **Step 1: Copy new root markdown files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$rootFiles = @("AGENTS.md","CHANGELOG.md","GEMINI.md",".repomixignore")
foreach ($f in $rootFiles) {
    if (Test-Path "$SRC\$f") {
        Copy-Item -Path "$SRC\$f" -Destination "$DEST\$f" -Force
        Write-Host "Copied: $f"
    }
}
```

Expected: All 4 files copied.

- [ ] **Step 2: Copy guide/ directory**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
Copy-Item -Path "$SRC\guide" -Destination "$DEST\guide" -Recurse -Force
Write-Host "Copied guide/"
Get-ChildItem -Path "$DEST\guide" -Name | Sort-Object
```

Expected: Directory created with: COMMANDS.md, COMMANDS.yaml, ENVIRONMENT_RESOLVER.md, SKILLS.md, SKILLS.yaml

- [ ] **Step 3: Copy plans/ directory**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
Copy-Item -Path "$SRC\plans" -Destination "$DEST\plans" -Recurse -Force
Write-Host "Copied plans/"
Get-ChildItem -Path "$DEST\plans" -Name | Sort-Object
```

Expected: Directory created with plan templates and reports.

- [ ] **Step 4: Commit root files**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add AGENTS.md CHANGELOG.md GEMINI.md .repomixignore guide\ plans\
git commit -m "feat: add root-level files from anhlpkit-engineer 2.14.0 (AGENTS.md, CHANGELOG.md, GEMINI.md, guide/, plans/)"
```

---

## Task 13: Add .claude config files

**Files:**
- Create: `.claude\.alp.json`
- Create: `.claude\.alpignore`
- Create: `.claude\.env.example`
- Create: `.claude\.mcp.json.example`

- [ ] **Step 1: Copy .claude config files**

```powershell
$SRC = "D:\Projects\anhlpkit-engineer-2.14.0\anhlpkit-engineer-2.14.0"
$DEST = "D:\Projects\alp-plugin"
$claudeConfigs = @(".alp.json",".alpignore",".env.example",".mcp.json.example")
foreach ($cfg in $claudeConfigs) {
    if (Test-Path "$SRC\.claude\$cfg") {
        Copy-Item -Path "$SRC\.claude\$cfg" -Destination "$DEST\.claude\$cfg" -Force
        Write-Host "Copied .claude/$cfg"
    }
}
```

Expected: All config files copied.

- [ ] **Step 2: Verify**

```powershell
$DEST = "D:\Projects\alp-plugin"
$files = @(".claude\.alp.json",".claude\.alpignore",".claude\.env.example",".claude\.mcp.json.example")
foreach ($f in $files) { Write-Host "$f : $(Test-Path "$DEST\$f")" }
```

Expected: All `True`.

- [ ] **Step 3: Commit .claude config files**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add .claude\.alp.json .claude\.alpignore .claude\.env.example .claude\.mcp.json.example
git commit -m "feat: add .claude config files from anhlpkit-engineer 2.14.0 (.alp.json, .alpignore, .env.example, .mcp.json.example)"
```

---

## Task 14: Update CLAUDE.md — merge new instruction

**Files:**
- Modify: `CLAUDE.md`

Add the missing important note present in anhlpkit's CLAUDE.md (after the last `**IMPORTANT:**` in the Workflows section):
`**IMPORTANT:** DO NOT modify skills in \`~/.claude/skills\` directory directly. **MUST** modify skills in this current working directory. Unless you are asked to do so.`

- [ ] **Step 1: Read current CLAUDE.md Workflows section**

```powershell
Select-String -Path "D:\Projects\alp-plugin\CLAUDE.md" -Pattern "IMPORTANT" | Select-Object -First 10
```

Expected: Shows existing IMPORTANT lines.

- [ ] **Step 2: Edit CLAUDE.md — insert new IMPORTANT line**

In `D:\Projects\alp-plugin\CLAUDE.md`, locate the Workflows section and add after the existing IMPORTANT notes (before the `## Hook Response Protocol` section):

```markdown
**IMPORTANT:** DO NOT modify skills in `~/.claude/skills` directory directly. **MUST** modify skills in this current working directory. Unless you are asked to do so.
```

Use the Edit tool to make this precise change.

- [ ] **Step 3: Commit CLAUDE.md update**

```powershell
Set-Location "D:\Projects\alp-plugin"
git add CLAUDE.md
git commit -m "feat: add skills directory warning to CLAUDE.md from anhlpkit-engineer 2.14.0"
```

---

## Task 15: Final verification and merge

- [ ] **Step 1: Check git log**

```powershell
Set-Location "D:\Projects\alp-plugin"
git log --oneline -15
```

Expected: 12+ commits from this update branch.

- [ ] **Step 2: Verify key new files exist**

```powershell
$DEST = "D:\Projects\alp-plugin"
$checks = @(
    "skills\_shared","skills\ask","skills\alp-plan","skills\test","skills\worktree",
    "hooks\plan-format-kanban.cjs","hooks\session-state.cjs","hooks\team-context-inject.cjs",
    "rules\team-coordination-rules.md","AGENTS.md","CHANGELOG.md","GEMINI.md","guide","plans"
)
$passed = 0
foreach ($c in $checks) {
    $exists = Test-Path "$DEST\$c"
    Write-Host "$c : $exists"
    if ($exists) { $passed++ }
}
Write-Host "`n$passed / $($checks.Count) checks passed"
```

Expected: All `True`, `14 / 14 checks passed`.

- [ ] **Step 3: Check skill count**

```powershell
$skillDirs = Get-ChildItem -Path "D:\Projects\alp-plugin\skills" -Directory | Measure-Object
Write-Host "Total skill directories: $($skillDirs.Count)"
```

Expected: ≥79 (48 original + 31 new = 79, accounting for overlap with shared).

- [ ] **Step 4: Merge to master**

```powershell
Set-Location "D:\Projects\alp-plugin"
git checkout master
git merge update/anhlpkit-engineer-2.14.0 --no-ff -m "feat: update alp-plugin to anhlpkit-engineer 2.14.0"
```

Expected: Merge commit created.

- [ ] **Step 5: Delete feature branch**

```powershell
Set-Location "D:\Projects\alp-plugin"
git branch -d update/anhlpkit-engineer-2.14.0
```

---

## Self-Review

**Spec coverage:**
- ✅ 31 new skills added (3 batches)
- ✅ 38 shared skills updated
- ✅ 5 new hook main files
- ✅ 3 new hook lib utilities
- ✅ New hook tests added
- ✅ Existing hooks + libs updated
- ✅ hooks.json updated with new event registrations
- ✅ New rule (team-coordination-rules.md)
- ✅ All 14 agents updated
- ✅ Root files: AGENTS.md, CHANGELOG.md, GEMINI.md, .repomixignore, guide/, plans/
- ✅ .claude config: .alp.json, .alpignore, .env.example, .mcp.json.example
- ✅ CLAUDE.md updated

**Not included (intentional):**
- `commands/` — kept as-is; anhlpkit 2.14.0 archived these in a different format incompatible with alp-plugin's plugin format
- `.claude-archived/` — archived content, not meant for direct use
- `.husky/`, `.github/`, `.releaserc.*` — release automation not part of the plugin format
- `schemas/`, `output-styles/` — alp-plugin-specific, no equivalent in anhlpkit
- `worktrees/` inside `.claude/` — project-specific, kept as-is

**Unresolved questions:**
- Should `task-completed-handler.cjs` and `teammate-idle-handler.cjs` be registered in hooks.json? They're in anhlpkit's hooks folder but not in its settings.json — they may be used only internally or by team features. Review after executing.
