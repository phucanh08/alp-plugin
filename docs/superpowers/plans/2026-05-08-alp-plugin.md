# alp-plugin Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert `anhlpkit-engineer` project template thành Claude Code / Codex plugin cá nhân, cài một lần dùng cho tất cả projects.

**Architecture:** Clone repo nguồn, di chuyển nội dung từ `.claude/` ra root level theo plugin convention, thêm plugin manifests (`.claude-plugin/`, `.codex-plugin/`), tạo `hooks/hooks.json` với `${CLAUDE_PLUGIN_ROOT}`, rồi đăng ký plugin local vào `~/.claude/settings.json` và `installed_plugins.json`.

**Tech Stack:** Node.js (hook scripts), JSON (manifests), Markdown (skills/agents/commands), PowerShell / Bash (platform hooks)

---

## File Structure

| File | Trạng thái | Trách nhiệm |
|------|------------|-------------|
| `D:\Projects\alp-plugin\.claude-plugin\plugin.json` | CREATE | Claude Code plugin manifest |
| `D:\Projects\alp-plugin\.codex-plugin\plugin.json` | CREATE | Codex plugin manifest |
| `D:\Projects\alp-plugin\hooks\hooks.json` | CREATE | Hook config với `${CLAUDE_PLUGIN_ROOT}` |
| `D:\Projects\alp-plugin\skills\**\SKILL.md` | COPY | 40+ skills từ `.claude/skills/` |
| `D:\Projects\alp-plugin\agents\*.md` | COPY | 16 agents từ `.claude/agents/` |
| `D:\Projects\alp-plugin\commands\*.md` | COPY | 13 commands từ `.claude/commands/` |
| `D:\Projects\alp-plugin\hooks\*.js` / `*.sh` / `*.ps1` | COPY | Hook scripts từ `.claude/hooks/` |
| `D:\Projects\alp-plugin\workflows\*.md` | COPY | Workflows từ `.claude/workflows/` |
| `D:\Projects\alp-plugin\CLAUDE.md` | CREATE | Plugin contributor guide |
| `D:\Projects\alp-plugin\package.json` | CREATE | npm metadata với name `alp-plugin` |
| `C:\Users\anhlp\.claude\settings.json` | MODIFY | Thêm `alp-plugin@local` vào enabledPlugins |
| `C:\Users\anhlp\.claude\plugins\installed_plugins.json` | MODIFY | Đăng ký plugin path |

---

## Task 1: Clone repo nguồn

**Files:**
- Tạo: `D:\Projects\alp-plugin\.tmp-source\` (temporary, sẽ xóa)

> **Prerequisite:** Đảm bảo https://github.com/phucanh08/anhlpkit-engineer tồn tại.  
> Nếu chưa có, fork từ https://github.com/gnoah1379/anhlpkit-engineer trước.

- [ ] **Step 1: Clone repo vào thư mục tạm**

```powershell
cd D:\Projects\alp-plugin
git clone https://github.com/phucanh08/anhlpkit-engineer.git .tmp-source
```

Expected output: `Cloning into '.tmp-source'...` + thông báo hoàn tất.  
Nếu 404, thay bằng: `https://github.com/gnoah1379/anhlpkit-engineer.git`

- [ ] **Step 2: Xác nhận clone thành công**

```powershell
ls D:\Projects\alp-plugin\.tmp-source\.claude
```

Expected: Thấy `agents/`, `commands/`, `skills/`, `hooks/`, `workflows/`

---

## Task 2: Copy nội dung ra root level

**Files:**
- COPY: `.tmp-source\.claude\skills\` → `skills\`
- COPY: `.tmp-source\.claude\agents\` → `agents\`
- COPY: `.tmp-source\.claude\commands\` → `commands\`
- COPY: `.tmp-source\.claude\hooks\` → `hooks\`
- COPY: `.tmp-source\.claude\workflows\` → `workflows\`

- [ ] **Step 1: Copy từng thư mục**

```powershell
Copy-Item -Recurse D:\Projects\alp-plugin\.tmp-source\.claude\skills D:\Projects\alp-plugin\skills
Copy-Item -Recurse D:\Projects\alp-plugin\.tmp-source\.claude\agents D:\Projects\alp-plugin\agents
Copy-Item -Recurse D:\Projects\alp-plugin\.tmp-source\.claude\commands D:\Projects\alp-plugin\commands
Copy-Item -Recurse D:\Projects\alp-plugin\.tmp-source\.claude\hooks D:\Projects\alp-plugin\hooks
Copy-Item -Recurse D:\Projects\alp-plugin\.tmp-source\.claude\workflows D:\Projects\alp-plugin\workflows
```

- [ ] **Step 2: Xác nhận các thư mục đã được copy**

```powershell
ls D:\Projects\alp-plugin
```

Expected: Thấy `skills/`, `agents/`, `commands/`, `hooks/`, `workflows/`

- [ ] **Step 3: Kiểm tra số lượng skills**

```powershell
(ls D:\Projects\alp-plugin\skills -Directory).Count
```

Expected: Khoảng 40+ thư mục

- [ ] **Step 4: Xóa thư mục tạm**

```powershell
Remove-Item -Recurse -Force D:\Projects\alp-plugin\.tmp-source
```

---

## Task 3: Tạo Plugin Manifests

**Files:**
- Create: `D:\Projects\alp-plugin\.claude-plugin\plugin.json`
- Create: `D:\Projects\alp-plugin\.codex-plugin\plugin.json`

- [ ] **Step 1: Tạo `.claude-plugin\plugin.json`**

Tạo file `D:\Projects\alp-plugin\.claude-plugin\plugin.json` với nội dung:

```json
{
  "name": "alp-plugin",
  "description": "Personal engineering plugin — skills, agents, workflows for daily development",
  "version": "1.0.0",
  "author": {
    "name": "phucanh08",
    "email": "phucanhdn01@gmail.com"
  },
  "license": "MIT"
}
```

- [ ] **Step 2: Tạo `.codex-plugin\plugin.json`**

Tạo file `D:\Projects\alp-plugin\.codex-plugin\plugin.json` với nội dung:

```json
{
  "name": "alp-plugin",
  "description": "Personal engineering plugin for Codex",
  "version": "1.0.0",
  "author": {
    "name": "phucanh08",
    "email": "phucanhdn01@gmail.com"
  }
}
```

- [ ] **Step 3: Validate JSON**

```powershell
node -e "JSON.parse(require('fs').readFileSync('D:\\Projects\\alp-plugin\\.claude-plugin\\plugin.json', 'utf8')); console.log('OK')"
node -e "JSON.parse(require('fs').readFileSync('D:\\Projects\\alp-plugin\\.codex-plugin\\plugin.json', 'utf8')); console.log('OK')"
```

Expected: `OK` cho cả hai

---

## Task 4: Tạo `hooks\hooks.json`

**Files:**
- Create: `D:\Projects\alp-plugin\hooks\hooks.json`

Hook scripts (`scout-block.js`, `modularization-hook.js`) dùng `__dirname` để resolve sibling files — không cần thay đổi code của chúng. Chỉ cần tạo `hooks.json` với đúng path format cho plugin system.

- [ ] **Step 1: Tạo `hooks\hooks.json`**

Tạo file `D:\Projects\alp-plugin\hooks\hooks.json` với nội dung:

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "Bash",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/scout-block.js\"",
            "async": false
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "Write|Edit",
        "hooks": [
          {
            "type": "command",
            "command": "node \"${CLAUDE_PLUGIN_ROOT}/hooks/modularization-hook.js\"",
            "async": true
          }
        ]
      }
    ]
  }
}
```

- [ ] **Step 2: Validate JSON**

```powershell
node -e "JSON.parse(require('fs').readFileSync('D:\\Projects\\alp-plugin\\hooks\\hooks.json', 'utf8')); console.log('OK')"
```

Expected: `OK`

- [ ] **Step 3: Xác nhận hook scripts tồn tại**

```powershell
ls D:\Projects\alp-plugin\hooks\scout-block.js
ls D:\Projects\alp-plugin\hooks\modularization-hook.js
ls D:\Projects\alp-plugin\hooks\scout-block.ps1
ls D:\Projects\alp-plugin\hooks\scout-block.sh
```

Expected: Tất cả 4 files đều tồn tại

---

## Task 5: Tạo CLAUDE.md và package.json

**Files:**
- Create: `D:\Projects\alp-plugin\CLAUDE.md`
- Create: `D:\Projects\alp-plugin\package.json`

- [ ] **Step 1: Tạo `README.md`**

Tạo file `D:\Projects\alp-plugin\README.md` với nội dung:

```markdown
# alp-plugin

Personal Claude Code / Codex plugin for daily engineering workflows.

## What's included

- **40+ skills** — debugging, backend, frontend, mobile, AI, MCP, planning, and more
- **16 agents** — brainstormer, code-reviewer, debugger, planner, researcher, tester, etc.
- **13 commands** — /plan, /code, /debug, /fix, /test, /brainstorm, /scout, etc.
- **Automation hooks** — scout-block (prevent heavy dir access), modularization (200-line guard)

## Installation

Local-only plugin. Already registered in `~/.claude/settings.json`.

## Source

Based on [anhlpkit-engineer](https://github.com/gnoah1379/anhlpkit-engineer)
```

- [ ] **Step 3: Tạo `CLAUDE.md`**

Tạo file `D:\Projects\alp-plugin\CLAUDE.md` với nội dung:

```markdown
# alp-plugin

Personal Claude Code / Codex plugin, chuyển đổi từ anhlpkit-engineer.

## Structure

- `skills/` — 40+ skill modules (SKILL.md format với YAML frontmatter)
- `agents/` — 16 specialized agents
- `commands/` — 13 slash commands
- `hooks/` — automation hooks (scout-block, modularization)
- `workflows/` — workflow definitions

## Adding new skills

Tạo thư mục `skills/<name>/` chứa `SKILL.md`:

```yaml
---
name: <name>
description: <khi nào Claude nên dùng skill này — trigger conditions>
---

# Nội dung skill...
```

## Conventions

- Kebab-case cho tên files và thư mục
- Mỗi skill file < 200 lines
- Skill `description` phải mô tả rõ trigger conditions để Claude biết khi nào load

## Source

Dựa trên https://github.com/gnoah1379/anhlpkit-engineer
```

- [ ] **Step 4: Tạo `package.json`**

Tạo file `D:\Projects\alp-plugin\package.json` với nội dung:

```json
{
  "name": "alp-plugin",
  "version": "1.0.0",
  "description": "Personal engineering plugin for Claude Code and Codex",
  "type": "module",
  "author": "phucanh08 <phucanhdn01@gmail.com>",
  "license": "MIT",
  "engines": {
    "node": ">=18.0.0"
  }
}
```

---

## Task 6: Khởi tạo git và commit

**Files:** `D:\Projects\alp-plugin\.git\` (tạo mới)

- [ ] **Step 1: Git init**

```powershell
cd D:\Projects\alp-plugin
git init
```

Expected: `Initialized empty Git repository in D:/Projects/alp-plugin/.git/`

- [ ] **Step 2: Tạo .gitignore**

Tạo file `D:\Projects\alp-plugin\.gitignore`:

```
node_modules/
.env
.env.local
*.log
```

- [ ] **Step 3: Commit ban đầu**

```powershell
git add .
git commit -m "feat: initial alp-plugin from anhlpkit-engineer"
```

Expected: Commit thành công với số files

---

## Task 7: Đăng ký plugin local

**Files:**
- Modify: `C:\Users\anhlp\.claude\settings.json`
- Modify: `C:\Users\anhlp\.claude\plugins\installed_plugins.json`

### `settings.json` hiện tại:
```json
{
  "env": {},
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true
  },
  "skipDangerousModePermissionPrompt": true
}
```

- [ ] **Step 1: Thêm `alp-plugin@local` vào `settings.json`**

Sửa `C:\Users\anhlp\.claude\settings.json` thành:

```json
{
  "env": {},
  "enabledPlugins": {
    "superpowers@claude-plugins-official": true,
    "alp-plugin@local": true
  },
  "skipDangerousModePermissionPrompt": true
}
```

### `installed_plugins.json` hiện tại:
```json
{
  "version": 2,
  "plugins": {
    "superpowers@claude-plugins-official": [
      {
        "scope": "user",
        "installPath": "C:\\Users\\anhlp\\.claude\\plugins\\cache\\claude-plugins-official\\superpowers\\5.1.0",
        "version": "5.1.0",
        "installedAt": "2026-02-25T01:35:02.085Z",
        "lastUpdated": "2026-05-05T02:00:03.809Z",
        "gitCommitSha": "e4a2375cb705ca5800f0833528ce36a3faf9017a"
      }
    ]
  }
}
```

- [ ] **Step 2: Thêm `alp-plugin@local` vào `installed_plugins.json`**

Sửa `C:\Users\anhlp\.claude\plugins\installed_plugins.json` thành:

```json
{
  "version": 2,
  "plugins": {
    "superpowers@claude-plugins-official": [
      {
        "scope": "user",
        "installPath": "C:\\Users\\anhlp\\.claude\\plugins\\cache\\claude-plugins-official\\superpowers\\5.1.0",
        "version": "5.1.0",
        "installedAt": "2026-02-25T01:35:02.085Z",
        "lastUpdated": "2026-05-05T02:00:03.809Z",
        "gitCommitSha": "e4a2375cb705ca5800f0833528ce36a3faf9017a"
      }
    ],
    "alp-plugin@local": [
      {
        "scope": "user",
        "installPath": "D:\\Projects\\alp-plugin",
        "version": "1.0.0",
        "installedAt": "2026-05-08T00:00:00.000Z",
        "lastUpdated": "2026-05-08T00:00:00.000Z"
      }
    ]
  }
}
```

- [ ] **Step 3: Validate cả hai files JSON**

```powershell
node -e "JSON.parse(require('fs').readFileSync('C:\\Users\\anhlp\\.claude\\settings.json', 'utf8')); console.log('settings.json OK')"
node -e "JSON.parse(require('fs').readFileSync('C:\\Users\\anhlp\\.claude\\plugins\\installed_plugins.json', 'utf8')); console.log('installed_plugins.json OK')"
```

Expected: `settings.json OK` và `installed_plugins.json OK`

---

## Task 8: Verification

- [ ] **Step 1: Kiểm tra cấu trúc plugin hoàn chỉnh**

```powershell
ls D:\Projects\alp-plugin
```

Expected: Thấy `.claude-plugin/`, `.codex-plugin/`, `skills/`, `agents/`, `commands/`, `hooks/`, `workflows/`, `CLAUDE.md`, `package.json`

- [ ] **Step 2: Kiểm tra một skill có đúng format không**

```powershell
Get-Content "D:\Projects\alp-plugin\skills\problem-solving\SKILL.md" | Select-Object -First 10
```

Expected: Thấy YAML frontmatter với `name:` và `description:`

- [ ] **Step 3: Restart Claude Code**

Đóng và mở lại Claude Code (hoặc dùng `/clear`).

- [ ] **Step 4: Verify commands xuất hiện**

Gõ `/` trong Claude Code.  
Expected: Thấy commands từ alp-plugin (plan, code, debug, v.v.)

- [ ] **Step 5: Verify skills được load**

Hỏi Claude: "I need help debugging a JavaScript error"  
Expected: Claude reference skills từ `skills/debugging/`

- [ ] **Step 6: Test scout-block hook**

Yêu cầu Claude: "Run `ls node_modules` in bash"  
Expected: Hook chặn lại với thông báo block

- [ ] **Step 7: Test modularization hook**

Dùng Write tool để tạo một file > 200 dòng.  
Expected: Thấy gợi ý modularization trong response

---

## Troubleshooting

**Plugin không load:** Kiểm tra `settings.json` và `installed_plugins.json` đúng format JSON. Restart Claude Code.

**Skills không được nhận:** Kiểm tra `skills/<name>/SKILL.md` có đúng YAML frontmatter với `name:` và `description:`.

**Hook không chạy:** Kiểm tra `hooks/hooks.json` tồn tại và `scout-block.js` có thể chạy với `node D:\Projects\alp-plugin\hooks\scout-block.js`.

**Repo không clone được:** Fork từ https://github.com/gnoah1379/anhlpkit-engineer rồi clone từ fork của bạn.
