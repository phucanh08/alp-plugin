# Multilingual Docs (EN/VI) Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add offline-first bilingual documentation (English + Vietnamese) for quick start and five core workflows, with a structure that supports adding more languages later.

**Architecture:** Build a mirrored docs tree under `docs/en/` and `docs/vi/`, with `docs/en/*` as source-of-truth and `docs/docs-index.md` as bilingual entrypoint. Keep each guide focused and operational, using real `/alp:*` command examples and identical section structure across languages for syncability.

**Tech Stack:** Markdown docs, repo file structure, Claude Code command examples (`/alp:*`), git.

---

## File Structure Map

### Create
- `docs/docs-index.md` — bilingual entrypoint + translation sync table
- `docs/en/index.md` — English docs landing page
- `docs/en/quick-start.md` — English quick start
- `docs/en/workflows/new-feature.md` — English feature workflow
- `docs/en/workflows/bug-fixing.md` — English bug workflow
- `docs/en/workflows/project-kickoff.md` — English kickoff workflow
- `docs/en/workflows/docs-update.md` — English docs update workflow
- `docs/en/workflows/code-review.md` — English review workflow
- `docs/vi/index.md` — Vietnamese docs landing page
- `docs/vi/quick-start.md` — Vietnamese quick start
- `docs/vi/workflows/new-feature.md` — Vietnamese feature workflow
- `docs/vi/workflows/bug-fixing.md` — Vietnamese bug workflow
- `docs/vi/workflows/project-kickoff.md` — Vietnamese kickoff workflow
- `docs/vi/workflows/docs-update.md` — Vietnamese docs update workflow
- `docs/vi/workflows/code-review.md` — Vietnamese review workflow

### Modify
- `README.md` — add short Documentation section linking to `docs/docs-index.md`

### Verify
- Structure parity between `docs/en/` and `docs/vi/`
- Internal link integrity (local markdown links)
- Command namespace correctness (`/alp:*` only)

---

### Task 1: Create docs skeleton and bilingual navigation

**Files:**
- Create: `docs/docs-index.md`
- Create: `docs/en/index.md`
- Create: `docs/vi/index.md`

- [ ] **Step 1: Create `docs/docs-index.md` with language navigation and sync table**

```md
# alp Documentation

Choose language:
- [English](./en/index.md)
- [Tiếng Việt](./vi/index.md)

## Translation Sync Status

| File | EN | VI | Sync |
|---|---|---|---|
| index.md | ✅ | ✅ | synced |
| quick-start.md | ✅ | ✅ | synced |
| workflows/new-feature.md | ✅ | ✅ | synced |
| workflows/bug-fixing.md | ✅ | ✅ | synced |
| workflows/project-kickoff.md | ✅ | ✅ | synced |
| workflows/docs-update.md | ✅ | ✅ | synced |
| workflows/code-review.md | ✅ | ✅ | synced |

## Notes
- `docs/en/*` is source-of-truth.
- Any EN content change must mark VI file as `needs-update` until translated.
```

- [ ] **Step 2: Create `docs/en/index.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# alp Docs (English)

> Practical guides for daily usage of the alp plugin.

## Start Here
- [Quick Start](./quick-start.md)

## Workflows
- [New Feature](./workflows/new-feature.md)
- [Bug Fixing](./workflows/bug-fixing.md)
- [Project Kickoff](./workflows/project-kickoff.md)
- [Docs Update](./workflows/docs-update.md)
- [Code Review](./workflows/code-review.md)

## Language
- [Tiếng Việt](../vi/index.md)
```

- [ ] **Step 3: Create `docs/vi/index.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/index.md
---

# Tài liệu alp (Tiếng Việt)

> Hướng dẫn thực dụng để dùng plugin alp hằng ngày.

## Bắt đầu
- [Quick Start](./quick-start.md)

## Workflow
- [Phát triển tính năng mới](./workflows/new-feature.md)
- [Sửa lỗi](./workflows/bug-fixing.md)
- [Khởi tạo dự án](./workflows/project-kickoff.md)
- [Cập nhật tài liệu](./workflows/docs-update.md)
- [Code review](./workflows/code-review.md)

## Ngôn ngữ
- [English](../en/index.md)
```

- [ ] **Step 4: Verify files exist and language links are present**

Run:
```bash
ls "docs" "docs/en" "docs/vi"
```

Expected:
- `docs-index.md` exists
- `index.md` exists in both `en` and `vi`

- [ ] **Step 5: Commit Task 1**

```bash
git add docs/docs-index.md docs/en/index.md docs/vi/index.md
git commit -m "docs: add bilingual docs entrypoints and sync index"
```

---

### Task 2: Write English quick start guide

**Files:**
- Create: `docs/en/quick-start.md`

- [ ] **Step 1: Create `docs/en/quick-start.md` with runnable first-use flow**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# Quick Start

> Get alp running and execute your first workflow in under 10 minutes.

## When to use
Use this when setting up alp for the first time on a machine.

## Prerequisites
- Claude Code installed
- Local plugin path available: `D:\Projects\alp-plugin`

## Step-by-step
1. Start Claude with the plugin directory:
   ```bash
   claude --plugin-dir D:\Projects\alp-plugin
   ```
2. Verify plugin command namespace:
   ```text
   /alp:watzup
   ```
3. Run your first planning command:
   ```text
   /alp:plan "implement feature X"
   ```

## Command sequence
1. `claude --plugin-dir D:\Projects\alp-plugin`
2. `/alp:watzup`
3. `/alp:plan "..."`

## Example prompt(s)
- `/alp:plan "build user profile settings page"`

## Expected output
- `/alp:watzup` returns project status summary.
- `/alp:plan` starts plan generation flow.

## Common mistakes
- Using `/watzup` instead of `/alp:watzup`
- Running Claude without `--plugin-dir` for local testing

## Related docs
- [New Feature Workflow](./workflows/new-feature.md)
- [alp Docs Index](./index.md)
```

- [ ] **Step 2: Verify namespace correctness in file**

Run:
```bash
grep -n "/alp:" docs/en/quick-start.md
```

Expected:
- All command examples use `/alp:*`

- [ ] **Step 3: Commit Task 2**

```bash
git add docs/en/quick-start.md
git commit -m "docs: add English quick start for alp plugin"
```

---

### Task 3: Write five English workflow guides

**Files:**
- Create: `docs/en/workflows/new-feature.md`
- Create: `docs/en/workflows/bug-fixing.md`
- Create: `docs/en/workflows/project-kickoff.md`
- Create: `docs/en/workflows/docs-update.md`
- Create: `docs/en/workflows/code-review.md`

- [ ] **Step 1: Create `docs/en/workflows/new-feature.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# New Feature Workflow

> Build a feature from idea to validated implementation.

## When to use
Use when adding a new feature with planning and verification.

## Prerequisites
- Plugin is loaded (`/alp:watzup` works)
- Feature scope is clear

## Step-by-step
1. Create a plan: `/alp:plan "implement <feature>"`
2. Execute implementation using the approved plan
3. Run tests: `/alp:test`
4. Run review: `/alp:review:codebase "review this feature"`

## Command sequence
- `/alp:plan "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:plan "add audit logging to payment flow"`

## Expected output
- Plan artifacts created
- Tests executed with pass/fail report
- Review summary with issues and recommendations

## Common mistakes
- Skipping plan review before implementation
- Claiming done before test/review results

## Related docs
- [Quick Start](../quick-start.md)
- [Code Review Workflow](./code-review.md)
```

- [ ] **Step 2: Create `docs/en/workflows/bug-fixing.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# Bug Fixing Workflow

> Reproduce, debug, fix, and verify with evidence.

## When to use
Use for runtime bugs, regressions, and failing tests.

## Prerequisites
- Reproduction details (error message/log or failing case)

## Step-by-step
1. Reproduce and summarize issue context
2. Run debug flow: `/alp:debug "<issue>"` or `/alp:plan "fix <issue>"`
3. Implement minimal fix
4. Run validation tests: `/alp:test`
5. Confirm no regressions via review: `/alp:review:codebase "check bug fix impact"`

## Command sequence
- `/alp:debug "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:debug "login API returns 500 when token is expired"`

## Expected output
- Root-cause hypothesis
- Verified fix with passing tests

## Common mistakes
- Fixing without reproduction
- Not testing adjacent paths

## Related docs
- [Code Review Workflow](./code-review.md)
- [Docs Update Workflow](./docs-update.md)
```

- [ ] **Step 3: Create `docs/en/workflows/project-kickoff.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# Project Kickoff Workflow

> Bootstrap a new project with structure, docs, and first plan.

## When to use
Use at the start of a new repo or major module.

## Prerequisites
- Repo initialized
- Basic goals defined

## Step-by-step
1. Capture high-level scope and constraints
2. Start kickoff guidance: `/alp:bootstrap "<project description>"`
3. Review generated planning artifacts
4. Approve implementation sequence before coding

## Command sequence
- `/alp:bootstrap "..."`
- `/alp:plan "..."` (if needed for focused phase)

## Example prompt(s)
- `/alp:bootstrap "SaaS admin panel with auth, billing, and audit logs"`

## Expected output
- Structured project setup guidance
- Phased plan ready for execution

## Common mistakes
- Starting coding before plan approval
- Mixing unrelated scopes into first phase

## Related docs
- [New Feature Workflow](./new-feature.md)
- [Quick Start](../quick-start.md)
```

- [ ] **Step 4: Create `docs/en/workflows/docs-update.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# Docs Update Workflow

> Keep documentation synchronized with code changes.

## When to use
Use after implementing features, fixes, or architectural changes.

## Prerequisites
- Code changes complete enough to document

## Step-by-step
1. Identify changed behavior and affected files
2. Update relevant docs files
3. Run docs summary/update helper if needed: `/alp:docs:update`
4. Verify links and command examples

## Command sequence
- `/alp:docs:update`

## Example prompt(s)
- `/alp:docs:update`

## Expected output
- Updated docs aligned with current code behavior

## Common mistakes
- Updating README only, ignoring workflow docs
- Leaving stale command examples

## Related docs
- [Code Review Workflow](./code-review.md)
- [New Feature Workflow](./new-feature.md)
```

- [ ] **Step 5: Create `docs/en/workflows/code-review.md`**

```md
---
lang: en
version: 1
last_updated: 2026-05-08
---

# Code Review Workflow

> Validate quality and readiness before merge or deploy.

## When to use
Use before finalizing any meaningful change set.

## Prerequisites
- Changes implemented
- Tests executed at least once

## Step-by-step
1. Run test pass: `/alp:test`
2. Run review pass: `/alp:review:codebase "review pending changes"`
3. Address findings and re-run tests
4. Re-run review for clean result

## Command sequence
- `/alp:test`
- `/alp:review:codebase "..."`

## Example prompt(s)
- `/alp:review:codebase "security + maintainability pass"`

## Expected output
- Actionable review notes
- Merge-ready state after fixes and re-check

## Common mistakes
- Treating first review pass as final
- Merging without re-running tests after fixes

## Related docs
- [Bug Fixing Workflow](./bug-fixing.md)
- [Docs Update Workflow](./docs-update.md)
```

- [ ] **Step 6: Verify all five workflow files are present**

Run:
```bash
ls "docs/en/workflows"
```

Expected:
- Exactly 5 files: `new-feature.md`, `bug-fixing.md`, `project-kickoff.md`, `docs-update.md`, `code-review.md`

- [ ] **Step 7: Commit Task 3**

```bash
git add docs/en/workflows/new-feature.md docs/en/workflows/bug-fixing.md docs/en/workflows/project-kickoff.md docs/en/workflows/docs-update.md docs/en/workflows/code-review.md
git commit -m "docs: add English workflow guides for core alp use cases"
```

---

### Task 4: Translate quick start and workflows to Vietnamese

**Files:**
- Create: `docs/vi/quick-start.md`
- Create: `docs/vi/workflows/new-feature.md`
- Create: `docs/vi/workflows/bug-fixing.md`
- Create: `docs/vi/workflows/project-kickoff.md`
- Create: `docs/vi/workflows/docs-update.md`
- Create: `docs/vi/workflows/code-review.md`

- [ ] **Step 1: Create `docs/vi/quick-start.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/quick-start.md
---

# Quick Start

> Chạy alp và thực hiện workflow đầu tiên trong dưới 10 phút.

## Khi nào dùng
Dùng khi thiết lập alp lần đầu trên máy.

## Điều kiện trước
- Đã cài Claude Code
- Có local plugin path: `D:\Projects\alp-plugin`

## Các bước
1. Mở Claude với plugin dir:
   ```bash
   claude --plugin-dir D:\Projects\alp-plugin
   ```
2. Kiểm tra namespace command:
   ```text
   /alp:watzup
   ```
3. Chạy command plan đầu tiên:
   ```text
   /alp:plan "implement feature X"
   ```

## Chuỗi lệnh
1. `claude --plugin-dir D:\Projects\alp-plugin`
2. `/alp:watzup`
3. `/alp:plan "..."`

## Ví dụ prompt
- `/alp:plan "build user profile settings page"`

## Kết quả mong đợi
- `/alp:watzup` trả trạng thái project.
- `/alp:plan` bắt đầu flow tạo plan.

## Lỗi thường gặp
- Dùng `/watzup` thay vì `/alp:watzup`
- Chạy Claude mà không thêm `--plugin-dir`

## Tài liệu liên quan
- [Workflow phát triển tính năng](./workflows/new-feature.md)
- [Mục lục docs alp](./index.md)
```

- [ ] **Step 2: Create `docs/vi/workflows/new-feature.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/new-feature.md
---

# Workflow phát triển tính năng mới

> Xây tính năng từ ý tưởng đến triển khai đã kiểm chứng.

## Khi nào dùng
Dùng khi thêm tính năng mới cần plan và verify.

## Điều kiện trước
- Plugin đã load (`/alp:watzup` chạy được)
- Scope tính năng rõ ràng

## Các bước
1. Tạo plan: `/alp:plan "implement <feature>"`
2. Triển khai theo plan đã duyệt
3. Chạy test: `/alp:test`
4. Review: `/alp:review:codebase "review this feature"`

## Chuỗi lệnh
- `/alp:plan "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:plan "add audit logging to payment flow"`

## Kết quả mong đợi
- Có artifacts plan
- Có báo cáo test pass/fail
- Có review summary và khuyến nghị

## Lỗi thường gặp
- Bỏ qua bước duyệt plan trước khi code
- Báo done trước khi có kết quả test/review

## Tài liệu liên quan
- [Quick Start](../quick-start.md)
- [Workflow code review](./code-review.md)
```

- [ ] **Step 3: Create `docs/vi/workflows/bug-fixing.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/bug-fixing.md
---

# Workflow sửa lỗi

> Tái hiện lỗi, debug, sửa tối thiểu và verify bằng bằng chứng.

## Khi nào dùng
Dùng cho bug runtime, regression, hoặc test fail.

## Điều kiện trước
- Có mô tả tái hiện lỗi (log/error/failing case)

## Các bước
1. Tái hiện lỗi và tóm tắt context
2. Chạy debug: `/alp:debug "<issue>"` hoặc `/alp:plan "fix <issue>"`
3. Sửa tối thiểu
4. Chạy test xác nhận: `/alp:test`
5. Review ảnh hưởng: `/alp:review:codebase "check bug fix impact"`

## Chuỗi lệnh
- `/alp:debug "..."`
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:debug "login API returns 500 when token is expired"`

## Kết quả mong đợi
- Có giả thuyết root cause
- Có fix đã verify bằng test

## Lỗi thường gặp
- Sửa khi chưa tái hiện được lỗi
- Không test đường đi liên quan

## Tài liệu liên quan
- [Workflow code review](./code-review.md)
- [Workflow cập nhật docs](./docs-update.md)
```

- [ ] **Step 4: Create `docs/vi/workflows/project-kickoff.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/project-kickoff.md
---

# Workflow khởi tạo dự án

> Bootstrap dự án mới với cấu trúc, docs và kế hoạch đầu tiên.

## Khi nào dùng
Dùng khi bắt đầu repo/module lớn mới.

## Điều kiện trước
- Repo đã khởi tạo
- Có mục tiêu cấp cao

## Các bước
1. Ghi rõ scope và constraints
2. Chạy kickoff: `/alp:bootstrap "<project description>"`
3. Duyệt artifacts plan sinh ra
4. Chốt sequence triển khai trước khi code

## Chuỗi lệnh
- `/alp:bootstrap "..."`
- `/alp:plan "..."` (nếu cần plan chi tiết từng phase)

## Ví dụ prompt
- `/alp:bootstrap "SaaS admin panel with auth, billing, and audit logs"`

## Kết quả mong đợi
- Có hướng dẫn setup có cấu trúc
- Có phased plan sẵn sàng triển khai

## Lỗi thường gặp
- Code ngay khi chưa duyệt plan
- Gom quá nhiều scope vào phase đầu

## Tài liệu liên quan
- [Workflow tính năng mới](./new-feature.md)
- [Quick Start](../quick-start.md)
```

- [ ] **Step 5: Create `docs/vi/workflows/docs-update.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/docs-update.md
---

# Workflow cập nhật tài liệu

> Đồng bộ tài liệu theo thay đổi code.

## Khi nào dùng
Dùng sau khi triển khai feature/fix/thay đổi kiến trúc.

## Điều kiện trước
- Code change đủ rõ để mô tả

## Các bước
1. Xác định behavior và file thay đổi
2. Cập nhật file docs liên quan
3. Dùng trợ giúp nếu cần: `/alp:docs:update`
4. Verify links và command examples

## Chuỗi lệnh
- `/alp:docs:update`

## Ví dụ prompt
- `/alp:docs:update`

## Kết quả mong đợi
- Docs phản ánh đúng behavior hiện tại

## Lỗi thường gặp
- Chỉ sửa README, bỏ qua workflow docs
- Để command examples bị cũ

## Tài liệu liên quan
- [Workflow code review](./code-review.md)
- [Workflow tính năng mới](./new-feature.md)
```

- [ ] **Step 6: Create `docs/vi/workflows/code-review.md`**

```md
---
lang: vi
version: 1
last_updated: 2026-05-08
source: docs/en/workflows/code-review.md
---

# Workflow code review

> Xác nhận chất lượng và độ sẵn sàng trước merge/deploy.

## Khi nào dùng
Dùng trước khi chốt bất kỳ thay đổi đáng kể nào.

## Điều kiện trước
- Đã triển khai xong thay đổi
- Đã chạy test ít nhất một lần

## Các bước
1. Chạy test: `/alp:test`
2. Chạy review: `/alp:review:codebase "review pending changes"`
3. Sửa theo findings và chạy lại test
4. Chạy lại review đến khi sạch

## Chuỗi lệnh
- `/alp:test`
- `/alp:review:codebase "..."`

## Ví dụ prompt
- `/alp:review:codebase "security + maintainability pass"`

## Kết quả mong đợi
- Có review notes hành động được
- Sẵn sàng merge sau fix và re-check

## Lỗi thường gặp
- Xem pass review đầu tiên là cuối cùng
- Merge mà không re-run test sau khi sửa

## Tài liệu liên quan
- [Workflow sửa lỗi](./bug-fixing.md)
- [Workflow cập nhật docs](./docs-update.md)
```

- [ ] **Step 7: Verify EN/VI parity for workflow filenames**

Run:
```bash
ls "docs/en/workflows" && ls "docs/vi/workflows"
```

Expected:
- Two lists have identical filenames

- [ ] **Step 8: Commit Task 4**

```bash
git add docs/vi/quick-start.md docs/vi/workflows/new-feature.md docs/vi/workflows/bug-fixing.md docs/vi/workflows/project-kickoff.md docs/vi/workflows/docs-update.md docs/vi/workflows/code-review.md
git commit -m "docs: add Vietnamese quick start and workflow guides"
```

---

### Task 5: Update root README and run final docs verification

**Files:**
- Modify: `README.md`
- Modify: `docs/docs-index.md` (sync table status confirmation)

- [ ] **Step 1: Add concise Documentation section to `README.md` near top-level docs area**

```md
## Documentation

- [Docs Index (EN/VI)](./docs/docs-index.md)
- [English Docs](./docs/en/index.md)
- [Tài liệu Tiếng Việt](./docs/vi/index.md)
```

- [ ] **Step 2: Confirm sync table reflects initial fully-synced state**

`docs/docs-index.md` must show:
- all listed files as `EN ✅`, `VI ✅`, `Sync = synced`

- [ ] **Step 3: Verify `/alp:*` namespace usage in all new docs**

Run:
```bash
grep -R -n "/alp:" docs/en docs/vi
```

Expected:
- Command samples found across quick-start/workflows
- No un-namespaced `/watzup`, `/plan`, `/test` examples in new docs

- [ ] **Step 4: Verify no placeholders**

Run:
```bash
grep -R -n "TODO\|TBD\|\.\.\." docs/docs-index.md docs/en docs/vi
```

Expected:
- No placeholder content in the newly created docs set

- [ ] **Step 5: Commit Task 5**

```bash
git add README.md docs/docs-index.md
git commit -m "docs: link bilingual docs in README and finalize verification"
```

---

## Final Verification Checklist

- [ ] `docs/docs-index.md` exists and links to EN/VI indexes
- [ ] EN and VI trees are mirrored for quick-start + 5 workflows
- [ ] All examples use `/alp:*` namespace
- [ ] README links to bilingual docs entrypoint
- [ ] No placeholders in created docs

---

## Self-Review

### 1) Spec coverage
- Quick start: covered in Task 2 + Task 4 (EN/VI)
- Five workflow examples: covered in Task 3 + Task 4
- Multilingual structure and future extensibility: covered in Task 1 + File Structure Map + sync rules
- Offline-first repo docs + README linkage: covered in Task 5
- EN source-of-truth and VI sync control: covered in Task 1 (`docs/docs-index.md`) and rules

No coverage gaps found.

### 2) Placeholder scan
- Plan contains no `TODO`, `TBD`, or “implement later” placeholders.
- Every file operation has exact path and concrete markdown content.

### 3) Type/signature consistency
- Not applicable to code APIs; naming consistency validated for doc file paths and command namespace (`/alp:*`).

No consistency issues found.
