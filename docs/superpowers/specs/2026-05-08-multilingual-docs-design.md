# Spec: Multilingual Docs & Guides for alp Plugin

## Metadata
- Date: 2026-05-08
- Scope: Documentation only (no behavior/code changes)
- Audience: Personal daily use + public-share ready
- Mode: Offline-first (inside repo)

## Goal
Add clear bilingual docs (English + Vietnamese) for basic plugin usage:
- Quick start
- Core workflow examples
- Easy extension to future languages

## Non-Goals
- No docs website setup (Mintlify/GitBook/VitePress)
- No full command/agent/skill encyclopedia in this phase
- No plugin runtime changes

## Source References Used
- `https://github.com/phucanh08/anhlpkit-engineer` docs/guide patterns
- Existing alp plugin structure and namespace (`/alp:*`)

## Final Structure

```text
docs/
├── docs-index.md
├── en/
│   ├── index.md
│   ├── quick-start.md
│   └── workflows/
│       ├── new-feature.md
│       ├── bug-fixing.md
│       ├── project-kickoff.md
│       ├── docs-update.md
│       └── code-review.md
└── vi/
    ├── index.md
    ├── quick-start.md
    └── workflows/
        ├── new-feature.md
        ├── bug-fixing.md
        ├── project-kickoff.md
        ├── docs-update.md
        └── code-review.md
```

## Navigation Model
- `docs/docs-index.md` is main entrypoint for bilingual navigation.
- Root `README.md` gets a short Documentation section linking to `docs/docs-index.md`.
- `docs/en/index.md` and `docs/vi/index.md` are language-specific landing pages.

## Content Model (per file)

Each guide uses this template:

```md
# Title

> One-line outcome

## When to use
## Prerequisites
## Step-by-step
## Command sequence
## Example prompt(s)
## Expected output
## Common mistakes
## Related docs
```

## File Coverage

### 1) `quick-start.md`
Covers:
1. Run Claude with plugin dir
2. Validate namespace and plugin loading (`/alp:watzup`)
3. First real run path (`/alp:plan "..."`)
4. What to do if command not found

### 2) `workflows/new-feature.md`
Flow:
- idea -> plan -> implement -> test -> review
- include fast path vs quality path

### 3) `workflows/bug-fixing.md`
Flow:
- reproduce -> debug -> fix -> test -> verify

### 4) `workflows/project-kickoff.md`
Flow:
- bootstrap scope -> setup baseline docs -> first implementation plan

### 5) `workflows/docs-update.md`
Flow:
- when to update docs -> sync checklist -> consistency checks

### 6) `workflows/code-review.md`
Flow:
- pre-review checks -> review loop -> merge/deploy readiness

## Multilingual Rules

### Source of truth
- `docs/en/*` is canonical source.
- `docs/vi/*` mirrors EN path + headings 1:1.

### Frontmatter
Each file includes:

```yaml
---
lang: en # or vi
version: 1
last_updated: 2026-05-08
source: docs/en/<same-file>.md # for non-EN files
---
```

### Sync tracking
`docs/docs-index.md` includes sync table:

| File | EN | VI | Sync |
|---|---|---|---|
| quick-start.md | ✅ | ✅ | synced |
| workflows/new-feature.md | ✅ | ⏳ | needs-update |

Rules:
- Any EN change marks corresponding VI as `needs-update`.
- Keep major section count identical between EN/VI.

## Writing Guidelines
- Keep each doc practical and short (target 80-180 lines).
- Use real plugin namespace only: `/alp:*`.
- Avoid legacy template internals unless directly needed for troubleshooting.
- Keep commands copy-paste ready.

## Future Language Expansion
To add a new language (ex: `fr`, `ja`):
1. Copy `docs/en/` structure into `docs/<lang>/`
2. Translate content while preserving filenames/headings
3. Add rows to `docs/docs-index.md` sync table
4. Do not change structure or link style

## Quality Gates Before Completion
- All internal links resolve
- Command samples are valid `/alp:*`
- EN/VI structure parity is preserved
- No placeholders (`TODO`, `TBD`, `...`)
- Quick-start can be followed end-to-end without external docs

## Deliverables
- 1 spec file (this file)
- Next implementation phase will create:
  - `docs/docs-index.md`
  - `docs/en/*`
  - `docs/vi/*`
  - root `README.md` docs section update

## Risks & Mitigations
- Risk: EN and VI drift over time
  - Mitigation: sync table + source-of-truth rule
- Risk: docs become too long
  - Mitigation: fixed template + 80-180 line target + split by workflow

## Acceptance Criteria
- Reader can start using plugin in <10 minutes via `quick-start`.
- Reader can execute 5 basic workflows from docs only.
- Adding third language requires no structural change.

## Unresolved Questions
- None
