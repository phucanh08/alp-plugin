# Review toàn bộ skills trong alp-plugin

Ngày: 2026-06-25. Scope: `skills/**/SKILL.md`, manifests, script deps, installers. Không sửa code.

## Executive summary

- Có **80 primary operational skills**: 76 root-level skills + 4 document skills dưới `skills/document-skills/*`.
- Có **39 nested/alias skills** (`alp:*` wrappers hoặc duplicated vendored skill folders). Tổng `SKILL.md`: 119.
- Plugin manifest mỏng: `.claude-plugin/plugin.json` và `.codex-plugin/plugin.json` chỉ metadata; deps nằm trong từng skill + `skills/install.*`.
- Runtime nền: Node.js >=18 (root `package.json`), Python virtualenv trong skill installer, Git. Installer thêm optional tools: FFmpeg, ImageMagick, Docker, global npm CLIs `rmbg-cli`, `pnpm`, `wrangler`, `repomix`, optional Shopify CLI.
- Nhiều skill là pure-instruction/prompt. Script-heavy: `ai-multimodal`, `chrome-devtools`, `databases`, `devops`, `docs-seeker`, `document-skills`, `markdown-novel-viewer`, `mcp-management`, `media-processing`, `plans-kanban`, `sequential-thinking`, `stitch`, `ui-styling`, `web-frameworks`.
- Lưu ý repo: `CLAUDE.md` tham chiếu `.claude/rules/*.md` nhưng các file đó không tồn tại trong working tree hiện tại.

## Dependency map chung

- **Installers**: `skills/install.ps1`, `skills/install.sh`.
- **System tools**: FFmpeg, ImageMagick; Docker/PostgreSQL client detected optional.
- **Global npm tools**: `rmbg-cli`, `pnpm`, `wrangler`, `repomix`; optional `@shopify/cli`, `@shopify/theme`.
- **Python deps**: installed from each `scripts/requirements.txt` into `skills/.venv` by repo installer; packaged-install docs may use a different plugin cache path.
- **Node local deps**: per-skill `package.json`; notable packages below in each row.
- **Document deps**: Office/PDF skills carry Python scripts for OOXML/PDF operations; package deps are mostly implicit in scripts or handled by Claude environment/package snapshot.

## Workflow / command skills (28)

| Skill | Path | Đang làm gì | Phụ thuộc tương ứng |
|---|---|---|---|
| `alp:ask` | `skills/ask/SKILL.md` | Answer technical and architectural questions with expert consultation. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `alp:bootstrap` | `skills/bootstrap/SKILL.md` | Bootstrap new projects with research, tech stack, design, planning, and implementation. Modes: full (interactive), auto (default), fast (skip research), parallel (multi-agent). | 5 refs; External: Payments, Git/GitHub |
| `alp:autoresearch` | `skills/alp-autoresearch/SKILL.md` | Autonomous iterative optimization loop — run N iterations against a mechanical metric, learn from git history, auto-keep/discard changes. Use for improving measurable metrics (cov… | 5 refs; External: Git/GitHub |
| `alp:debug` | `skills/alp-debug/SKILL.md` | Debug systematically with root cause analysis before fixes. Use for bugs, test failures, unexpected behavior, performance issues, call stack tracing, multi-layer validation, log a… | 10 refs; 2 scripts; External: Browser/Puppeteer, Databases, Git/GitHub, Repomix |
| `alp:loop` | `skills/alp-loop/SKILL.md` | Autonomous iterative optimization loop — run N iterations against a mechanical metric, learn from git history, auto-keep/discard changes. Use for improving measurable metrics (cov… | 5 refs; External: Git/GitHub |
| `alp:plan` | `skills/alp-plan/SKILL.md` | Plan implementations, design architectures, create technical roadmaps with detailed phases. Use for feature planning, system design, solution architecture, implementation strategy… | 13 refs; External: Git/GitHub |
| `alp:predict` | `skills/alp-predict/SKILL.md` | 5 expert personas debate proposed changes before implementation. Catches architectural, security, performance, and UX issues early. Use before major features or risky changes. | External: Git/GitHub |
| `alp:scenario` | `skills/alp-scenario/SKILL.md` | Generate comprehensive edge cases and test scenarios by decomposing features across 12 dimensions. Use before implementation or testing to catch issues early. | External: Git/GitHub |
| `alp:security` | `skills/alp-security/SKILL.md` | STRIDE + OWASP-based security audit with optional auto-fix. Scans code for vulnerabilities, categorizes by severity, and can iteratively fix findings using alp:autoresearch pattern. | 1 refs; External: Git/GitHub |
| `alp:coding-level` | `skills/coding-level/SKILL.md` | Set coding experience level for tailored explanations and output format. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `cook` | `skills/cook/SKILL.md` | ALWAYS activate this skill before implementing EVERY feature, plan, or fix. | 4 refs |
| `alp:deploy` | `skills/deploy/SKILL.md` | Deploy projects to any platform with auto-detection. Use when user says "deploy", "publish", "ship", "go live", "push to production", "host this app", or mentions any hosting plat… | 16 refs; External: Cloud/Docker, Git/GitHub |
| `ckm:design` | `skills/design/SKILL.md` | Comprehensive design skill: brand identity, design tokens, UI styling, logo generation (55 styles, Gemini AI), corporate identity program (50 deliverables, CIP mockups), HTML pres… | 18 refs; 8 scripts; External: Gemini/Google AI, Browser/Puppeteer |
| `alp:docs` | `skills/docs/SKILL.md` | Analyze codebase and manage project documentation — init, update, summarize. | 3 refs; External: Git/GitHub |
| `alp:journal` | `skills/journal/SKILL.md` | Write journal entries analyzing recent changes and session reflections. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `alp:kanban` | `skills/kanban/SKILL.md` | AI agent orchestration board for task visualization and team coordination. | External: Git/GitHub |
| `alp:llms` | `skills/llms/SKILL.md` | Generate llms.txt files from docs or codebase scanning. Follows llmstxt.org spec. Use for LLM-friendly site indexes, documentation summaries, AI context optimization. | 1 refs; 1 scripts |
| `alp:preview` | `skills/preview/SKILL.md` | View files/directories OR generate visual explanations, slides, diagrams (Markdown or self-contained HTML). | 7 refs; 4 templates; External: Git/GitHub |
| `alp:project-management` | `skills/project-management/SKILL.md` | Track progress, update plan statuses, manage Claude Tasks, generate reports, coordinate docs updates. Use for project oversight, status checks, plan completion, task hydration, cr… | 5 refs |
| `alp:project-organization` | `skills/project-organization/SKILL.md` | Organize files, directories, and content structure in any project. Use when creating files, determining output paths, organizing existing assets, or standardizing project layout. | 3 refs; External: Git/GitHub |
| `alp:retro` | `skills/retro/SKILL.md` | Data-driven sprint retrospective. Gathers git metrics (commits, LOC, hotspots, churn), computes derived health indicators, and generates a structured markdown or HTML report. Use … | 2 refs; External: Git/GitHub |
| `alp:security-scan` | `skills/security-scan/SKILL.md` | Scan codebase for security vulnerabilities, hardcoded secrets, dependency issues, and OWASP patterns. Use when asked to 'security scan', 'check for secrets', 'audit security', or … | 2 refs; External: Payments, Git/GitHub |
| `alp:ship` | `skills/ship/SKILL.md` | Ship pipeline: merge main, test, review, commit, push, PR. Single command from feature branch to PR URL. Use for shipping official releases to main/master or beta releases to dev/… | 3 refs; External: Git/GitHub |
| `alp:team` | `skills/team/SKILL.md` | Orchestrate Agent Teams for parallel multi-session collaboration. Use for research, implementation, review, and debug workflows requiring independent teammates. | 3 refs; External: Git/GitHub |
| `alp:test` | `skills/test/SKILL.md` | Run unit, integration, e2e, and UI tests. Use for test execution, coverage analysis, build verification, visual regression, and QA reports. | 3 refs; External: Browser/Puppeteer |
| `alp:use-mcp` | `skills/use-mcp/SKILL.md` | Utilize MCP server tools with intelligent discovery and execution. | External: Gemini/Google AI, MCP |
| `alp:watzup` | `skills/watzup/SKILL.md` | Review recent changes and wrap up the current work session. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `alp:worktree` | `skills/worktree/SKILL.md` | Create isolated git worktree for parallel development in monorepos. | 2 scripts; External: Git/GitHub |

## Domain / engineering skills (39)

| Skill | Path | Đang làm gì | Phụ thuộc tương ứng |
|---|---|---|---|
| `agent-browser` | `skills/agent-browser/SKILL.md` | AI-optimized browser automation CLI with context-efficient snapshots. Use for long autonomous sessions, self-verifying workflows, video recording, and cloud browser testing (Brows… | 2 refs; External: Browser/Puppeteer, Cloud/Docker, Git/GitHub, OOXML/PDF Office |
| `backend-development` | `skills/backend-development/SKILL.md` | Build backends with Node.js, Python, Go (NestJS, FastAPI, Django). Use for REST/GraphQL/gRPC APIs, auth (OAuth, JWT), databases, microservices, security (OWASP), Docker/K8s. | 11 refs; External: Cloud/Docker, Databases, Git/GitHub |
| `better-auth` | `skills/better-auth/SKILL.md` | Add authentication with Better Auth (TypeScript). Use for email/password, OAuth providers (Google, GitHub), 2FA/MFA, passkeys/WebAuthn, sessions, RBAC, rate limiting. | 4 refs; 3 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0; External: Git/GitHub |
| `brainstorm` | `skills/brainstorm/SKILL.md` | Brainstorm solutions with trade-off analysis and brutal honesty. Use for ideation, architecture decisions, technical debates, feature exploration, feasibility assessment, design d… | Pure instructions/prompt; không có script/ref trực tiếp. |
| `chrome-devtools` | `skills/chrome-devtools/SKILL.md` | Automate browsers with Puppeteer CLI scripts and persistent sessions. Use for screenshots, performance analysis, network monitoring, web scraping, form automation, JavaScript debu… | 3 refs; 25 scripts; Node: debug@^4.4.0, puppeteer@^24.15.0, sharp@^0.33.5, yargs@^17.7.2; External: FFmpeg/ImageMagick, Browser/Puppeteer, Git/GitHub |
| `code-review` | `skills/code-review/SKILL.md` | Review code quality, receive feedback with technical rigor, verify completion claims. Use before PRs, after implementing features, when claiming task completion. Includes scout-ba… | 4 refs; External: Git/GitHub |
| `context-engineering` | `skills/context-engineering/SKILL.md` | Check context usage limits, monitor time remaining, optimize token consumption, debug context failures. Use when asking about context percentage, rate limits, usage warnings, cont… | 10 refs; 3 scripts; External: Git/GitHub |
| `databases` | `skills/databases/SKILL.md` | Design schemas, write queries for MongoDB and PostgreSQL. Use for database design, SQL/NoSQL queries, aggregation pipelines, indexes, migrations, replication, performance optimiza… | 8 refs; 9 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0, pytest>=7.0.0, pytest-cov>=4.0.0, pytest-mock>=3.10.0, mongomock>=4.1.0; External: Databases |
| `devops` | `skills/devops/SKILL.md` | Deploy to Cloudflare (Workers, R2, D1), Docker, GCP (Cloud Run, GKE), Kubernetes (kubectl, Helm). Use for serverless, containers, CI/CD, GitOps, security audit. | 21 refs; 6 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0, pytest>=7.0.0, pytest-cov>=4.0.0, pytest-mock>=3.10.0; External: Browser/Puppeteer, Cloud/Docker, Databases |
| `docs-seeker` | `skills/docs-seeker/SKILL.md` | Search library/framework documentation via llms.txt (context7.com). Use for API docs, GitHub repository analysis, technical documentation lookup, latest library features. | 3 refs; 8 scripts; Node: package.json/no deps |
| `find-skills` | `skills/find-skills/SKILL.md` | Helps users discover and install agent skills when they ask questions like "how do I do X", "find a skill for X", "is there a skill that can...", or express interest in extending … | External: Browser/Puppeteer, Cloud/Docker, Git/GitHub |
| `fix` | `skills/fix/SKILL.md` | ALWAYS activate this skill before fixing ANY bug, error, test failure, CI/CD issue, type error, lint, log error, UI issue, code problem. | 13 refs; External: Git/GitHub |
| `frontend-design` | `skills/frontend-design/SKILL.md` | Create polished frontend interfaces from designs/screenshots/videos. Use for web components, 3D experiences, replicating UI designs, quick prototypes, immersive interfaces, avoidi… | 22 refs |
| `frontend-dev-guidelines` | `skills/frontend-development/SKILL.md` | Build React/TypeScript frontends with modern patterns. Use for components, Suspense, lazy loading, useSuspenseQuery, MUI v7 styling, TanStack Router, performance optimization. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `git` | `skills/git/SKILL.md` | Git operations with conventional commits. Use for staging, committing, pushing, PRs, merges. Auto-splits commits by type/scope. Security scans for secrets. | 8 refs; External: Git/GitHub |
| `gkg` | `skills/gkg/SKILL.md` | Semantic code analysis with GitLab Knowledge Graph. Use for go-to-definition, find-usages, impact analysis, architecture visualization. Supports Ruby, Java, Kotlin, Python, TypeSc… | 4 refs; External: Git/GitHub, Repomix |
| `google-adk-python` | `skills/google-adk-python/SKILL.md` | Build AI agents with Google ADK Python. Multi-agent systems, A2A protocol, MCP tools, workflow agents, state/memory, callbacks/plugins, Vertex AI deployment, evaluation. | 7 refs; External: Gemini/Google AI, MCP, Git/GitHub |
| `mcp-builder` | `skills/mcp-builder/SKILL.md` | Build MCP servers for LLM-external service integration. Use for FastMCP (Python), MCP SDK (Node/TypeScript), tool design, API integration, resource providers. | 4 scripts; Python: anthropic>=0.39.0, mcp>=1.1.0; External: MCP, Git/GitHub |
| `mcp-management` | `skills/mcp-management/SKILL.md` | Manage MCP servers - discover, analyze, execute tools/prompts/resources. Use for MCP integrations, intelligent tool selection, multi-server management, context-efficient capabilit… | 3 refs; 6 scripts; Node: @modelcontextprotocol/sdk@^1.25.1, @types/node@^20.0.0, nodemon@^3.1.11, ts-node@^10.9.2, tsx@^4.20.6, typescript@^5.9.3; External: Gemini/Google AI, Browser/Puppeteer, MCP |
| `mintlify` | `skills/mintlify/SKILL.md` | Build and deploy documentation sites with Mintlify. Use when creating API docs, developer portals, or knowledge bases. Covers docs.json configuration, MDX components (Cards, Steps… | 6 refs; External: Cloud/Docker, Git/GitHub |
| `mobile-development` | `skills/mobile-development/SKILL.md` | Build mobile apps with React Native, Flutter, Swift/SwiftUI, Kotlin/Jetpack Compose. Use for iOS/Android, mobile UX, performance optimization, offline-first, app store deployment. | 6 refs; External: Git/GitHub |
| `payment-integration` | `skills/payment-integration/SKILL.md` | Integrate payments with SePay (VietQR), Polar, Stripe, Paddle (MoR subscriptions), Creem.io (licensing). Checkout, webhooks, subscriptions, QR codes, multi-provider orders. | 35 refs; 6 scripts; Node: package.json/no deps; External: Payments, Git/GitHub |
| `plans-kanban` | `skills/plans-kanban/SKILL.md` | View plans dashboard with progress tracking and timeline visualization. Use for kanban boards, plan status overview, phase progress, milestone tracking, project visibility. | 8 scripts; Node: gray-matter@^4.0.3 |
| `Problem-Solving Techniques` | `skills/problem-solving/SKILL.md` | Apply systematic problem-solving techniques when stuck. Use for complexity spirals, innovation blocks, recurring patterns, assumption constraints, simplification cascades, scale u… | 7 refs; External: Git/GitHub |
| `vercel-react-best-practices` | `skills/react-best-practices/SKILL.md` | React and Next.js performance optimization guidelines from Vercel Engineering. This skill should be used when writing, reviewing, or refactoring React/Next.js code to ensure optim… | External: Cloud/Docker, Git/GitHub |
| `repomix` | `skills/repomix/SKILL.md` | Pack repositories into AI-friendly files with Repomix (XML, Markdown, plain text). Use for codebase snapshots, LLM context preparation, security audits, third-party library analys… | 2 refs; 5 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0; External: Gemini/Google AI, MCP, Git/GitHub, Repomix |
| `research` | `skills/research/SKILL.md` | Research technical solutions, analyze architectures, gather requirements thoroughly. Use for technology evaluation, best practices research, solution design, scalability/security/… | External: Gemini/Google AI, Git/GitHub |
| `scout` | `skills/scout/SKILL.md` | Fast codebase scouting using parallel agents. Use for file discovery, task context gathering, quick searches across directories. Supports internal (Explore) and external (Gemini/O… | 2 refs; External: Gemini/Google AI |
| `sequential-thinking` | `skills/sequential-thinking/SKILL.md` | Apply step-by-step analysis for complex problems with revision capability. Use for multi-step reasoning, hypothesis verification, adaptive planning, problem decomposition, course … | 6 refs; 2 scripts; Node: jest@^29.7.0 |
| `shopify` | `skills/shopify/SKILL.md` | Build Shopify apps, extensions, themes with Shopify CLI. Use for GraphQL/REST APIs, Polaris UI, Liquid templates, checkout customization, webhooks, billing integration. | 3 refs; 3 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0; External: Payments, Shopify |
| `skill-creator` | `skills/skill-creator/SKILL.md` | Create or update Claude skills. Use for new skills, skill references, skill scripts, optimizing existing skills, extending Claude's capabilities. | 10 refs; 4 scripts; External: Cloud/Docker, Git/GitHub, OOXML/PDF Office |
| `alp:stitch` | `skills/stitch/SKILL.md` | AI design generation with Google Stitch. Generate UI designs from text prompts, export Tailwind/HTML/DESIGN.md, orchestrate design-to-code pipeline. Use for rapid prototyping, UI … | 4 refs; 4 scripts; Node: @google/stitch-sdk@>=0.0.3 <1.0.0, tsx@^4.0.0; External: MCP |
| `alp:tanstack` | `skills/tanstack/SKILL.md` | Build with TanStack Start (full-stack React framework), TanStack Form (headless form management), and TanStack AI (AI streaming/chat). Use when creating TanStack projects, routes,… | 3 refs; External: Gemini/Google AI, Cloud/Docker |
| `template-skill` | `skills/template-skill/SKILL.md` | Replace with description of the skill and when Claude should use it. | Pure instructions/prompt; không có script/ref trực tiếp. |
| `ui-styling` | `skills/ui-styling/SKILL.md` | Style UIs with shadcn/ui components (Radix UI + Tailwind CSS). Use for accessible components, themes, dark mode, responsive layouts, design systems, color customization. | 7 refs; 7 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0, pytest>=7.4.0, pytest-mock>=3.11.1 |
| `ui-ux-pro-max` | `skills/ui-ux-pro-max/SKILL.md` | UI/UX design intelligence. 50 styles, 21 palettes, 50 font pairings, 20 charts, 9 stacks (React, Next.js, Vue, Svelte, SwiftUI, React Native, Flutter, Tailwind, shadcn/ui). Action… | 3 scripts; External: Git/GitHub |
| `web-design-guidelines` | `skills/web-design-guidelines/SKILL.md` | Review UI code for Web Interface Guidelines compliance. Use when asked to "review my UI", "check accessibility", "audit design", "review UX", or "check my site against best practi… | External: Cloud/Docker, Git/GitHub |
| `web-frameworks` | `skills/web-frameworks/SKILL.md` | Build with Next.js (App Router, RSC, SSR, ISR), Turborepo monorepos. Use for React apps, server rendering, build optimization, caching strategies, shared dependencies. | 8 refs; 8 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0, pytest>=7.0.0, pytest-cov>=4.0.0, pytest-mock>=3.10.0; External: Git/GitHub |
| `web-testing` | `skills/web-testing/SKILL.md` | Web testing with Playwright, Vitest, k6. E2E/unit/integration/load/security/visual/a11y testing. Use for test automation, flakiness, Core Web Vitals, mobile gestures, cross-browse… | 24 refs; 2 scripts; External: Browser/Puppeteer, Git/GitHub |

## Creative / media / visual skills (9)

| Skill | Path | Đang làm gì | Phụ thuộc tương ứng |
|---|---|---|---|
| `ai-artist` | `skills/ai-artist/SKILL.md` | Generate images via Nano Banana with 129 curated prompts. Mandatory validation interview refines style/mood/colors (use --skip to bypass). 3 modes: search, creative, wild. Styles:… | 12 refs; 4 scripts |
| `ai-multimodal` | `skills/ai-multimodal/SKILL.md` | Analyze images/audio/video with Gemini API (better vision than Claude). Generate images (Imagen 4), videos (Veo 3). Use for vision analysis, transcription, OCR, design extraction,… | 6 refs; 9 scripts; Python: google-genai>=0.1.0, pypdf>=4.0.0, python-docx>=1.0.0, docx2pdf>=0.1.8, markdown>=3.5.0, Pillow>=10.0.0, python-dotenv>=1.0.0, pytest>=8.0.0; External: FFmpeg/ImageMagick, Gemini/Google AI, OO… |
| `copywriting` | `skills/copywriting/SKILL.md` | Conversion copywriting formulas, headline templates, email copy patterns, landing page structures, CTA optimization, and writing style extraction. Activate for writing high-conver… | 12 refs; 1 templates; 1 scripts; External: Gemini/Google AI, OOXML/PDF Office |
| `markdown-novel-viewer` | `skills/markdown-novel-viewer/SKILL.md` | View markdown files with calm, book-like reading experience via HTTP server. Use for long-form content, documentation preview, novel reading, report viewing, distraction-free read… | 7 scripts; Node: gray-matter@^4.0.3, highlight.js@^11.11.1, marked@^17.0.0 |
| `media-processing` | `skills/media-processing/SKILL.md` | Process media with FFmpeg (video/audio), ImageMagick (images), RMBG (AI background removal). Use for encoding, format conversion, filters, thumbnails, batch processing, HLS/DASH s… | 9 refs; 12 scripts; Python: pytest>=8.0.0, pytest-cov>=4.1.0, pytest-mock>=3.12.0, pytest>=7.4.0; External: FFmpeg/ImageMagick, Git/GitHub |
| `mermaidjs-v11` | `skills/mermaidjs-v11/SKILL.md` | Create diagrams with Mermaid.js v11 syntax. Use for flowcharts, sequence diagrams, class diagrams, ER diagrams, Gantt charts, state diagrams, architecture diagrams, timelines, use… | 5 refs; External: Cloud/Docker, OOXML/PDF Office |
| `remotion-best-practices` | `skills/remotion/SKILL.md` | Best practices for Remotion - Video creation in React | Pure instructions/prompt; không có script/ref trực tiếp. |
| `shader` | `skills/shader/SKILL.md` | Write GLSL fragment shaders for procedural graphics. Topics: shapes (SDF), patterns, noise (Perlin/simplex/cellular), fBm, colors (HSB/RGB), matrices, gradients, animations. Use f… | 12 refs; External: Payments |
| `threejs` | `skills/threejs/SKILL.md` | Build 3D web apps with Three.js (WebGL/WebGPU). 556 searchable examples, 60 API classes, 20 use cases. Actions: create 3D scene, load model, add animation, implement physics, buil… | 20 refs; 4 scripts; External: Git/GitHub |

## Document skills (4)

| Skill | Path | Đang làm gì | Phụ thuộc tương ứng |
|---|---|---|---|
| `docx` | `skills/document-skills/docx/SKILL.md` | Create, edit, analyze .docx Word documents. Use for document creation, tracked changes, comments, formatting preservation, text extraction, template modification. | 16 scripts; External: Git/GitHub, OOXML/PDF Office |
| `pdf` | `skills/document-skills/pdf/SKILL.md` | Extract text/tables, create, merge, split PDFs. Fill PDF forms programmatically. Use for PDF processing, generation, form filling, document analysis, batch operations. | 8 scripts; External: OOXML/PDF Office |
| `pptx` | `skills/document-skills/pptx/SKILL.md` | Create, edit, analyze .pptx PowerPoint files. Use for presentations, slides, layouts, speaker notes, template modification, content extraction, slide generation. | 13 scripts; External: Browser/Puppeteer, Git/GitHub, OOXML/PDF Office |
| `xlsx` | `skills/document-skills/xlsx/SKILL.md` | Create, edit, analyze spreadsheets (.xlsx, .csv, .tsv). Use for Excel formulas, data analysis, visualization, formatting, pivot tables, charts, formula recalculation. | External: OOXML/PDF Office |

## Nested / alias skills

- Có 39 nested `SKILL.md`, đa phần cùng nội dung với primary nhưng đổi `name:` thành `alp:*` để tương thích AnhlpKit/command namespace.
- Khi review functional behavior, ưu tiên primary skill; khi review packaging/activation, cần kiểm tra cả alias để tránh drift.

<details>
<summary>Danh sách nested aliases</summary>

- `alp:agent-browser` — `skills/agent-browser/agent-browser/SKILL.md`
- `alp:ai-artist` — `skills/ai-artist/ai-artist/SKILL.md`
- `alp:ai-multimodal` — `skills/ai-multimodal/ai-multimodal/SKILL.md`
- `alp:backend-development` — `skills/backend-development/backend-development/SKILL.md`
- `alp:better-auth` — `skills/better-auth/better-auth/SKILL.md`
- `alp:brainstorm` — `skills/brainstorm/brainstorm/SKILL.md`
- `alp:chrome-devtools` — `skills/chrome-devtools/chrome-devtools/SKILL.md`
- `alp:code-review` — `skills/code-review/code-review/SKILL.md`
- `alp:context-engineering` — `skills/context-engineering/context-engineering/SKILL.md`
- `alp:cook` — `skills/cook/cook/SKILL.md`
- `alp:copywriting` — `skills/copywriting/copywriting/SKILL.md`
- `alp:databases` — `skills/databases/databases/SKILL.md`
- `alp:devops` — `skills/devops/devops/SKILL.md`
- `alp:docs-seeker` — `skills/docs-seeker/docs-seeker/SKILL.md`
- `alp:docx` — `skills/document-skills/document-skills/docx/SKILL.md`
- `alp:pdf` — `skills/document-skills/document-skills/pdf/SKILL.md`
- `alp:pptx` — `skills/document-skills/document-skills/pptx/SKILL.md`
- `alp:xlsx` — `skills/document-skills/document-skills/xlsx/SKILL.md`
- `alp:find-skills` — `skills/find-skills/find-skills/SKILL.md`
- `alp:fix` — `skills/fix/fix/SKILL.md`
- `alp:frontend-design` — `skills/frontend-design/frontend-design/SKILL.md`
- `alp:frontend-development` — `skills/frontend-development/frontend-development/SKILL.md`
- `alp:git` — `skills/git/git/SKILL.md`
- `alp:gkg` — `skills/gkg/gkg/SKILL.md`
- `alp:google-adk-python` — `skills/google-adk-python/google-adk-python/SKILL.md`
- `alp:mobile-development` — `skills/mobile-development/mobile-development/SKILL.md`
- `alp:payment-integration` — `skills/payment-integration/payment-integration/SKILL.md`
- `alp:plans-kanban` — `skills/plans-kanban/plans-kanban/SKILL.md`
- `alp:problem-solving` — `skills/problem-solving/problem-solving/SKILL.md`
- `alp:react-best-practices` — `skills/react-best-practices/react-best-practices/SKILL.md`
- `alp:remotion` — `skills/remotion/remotion/SKILL.md`
- `alp:scout` — `skills/scout/scout/SKILL.md`
- `alp:sequential-thinking` — `skills/sequential-thinking/sequential-thinking/SKILL.md`
- `alp:skill-creator` — `skills/skill-creator/skill-creator/SKILL.md`
- `alp:template-skill` — `skills/template-skill/template-skill/SKILL.md`
- `alp:ui-styling` — `skills/ui-styling/ui-styling/SKILL.md`
- `alp:ui-ux-pro-max` — `skills/ui-ux-pro-max/ui-ux-pro-max/SKILL.md`
- `alp:web-design-guidelines` — `skills/web-design-guidelines/web-design-guidelines/SKILL.md`
- `alp:web-testing` — `skills/web-testing/web-testing/SKILL.md`

</details>

## Gaps / rủi ro cần chú ý

- **Duplicate drift risk**: primary và nested aliases có thể lệch nội dung nếu update một bên. Nên có script kiểm tra hash/semantic diff.
- **README mismatch**: `skills/README.md` vẫn mô tả example skills từ Anthropic (`algorithmic-art`, `canvas-design`, ...) không khớp inventory hiện tại của `alp-plugin`.
- **Dependency doc split**: deps nằm rải rác trong install scripts, `requirements.txt`, `package.json`, và body skill. Nên sinh tự động `docs/skill-catalog.md` từ source.
- **Venv path mismatch**: repo instruction và installer/dev path có thể khác nhau tùy packaged install vs local repo; cần chuẩn hóa docs.
- **Workflow overlap**: `alp:autoresearch` và `alp:loop` gần giống nhau; cần clarify alias vs separate behavior.
- **External services**: Gemini/Google AI, Browserbase, MCP servers, Cloudflare, Shopify, Stripe/Paddle/Polar/SePay/Creem phụ thuộc credentials/env thực tế; report này chỉ map static dependency.

## Next steps đề xuất

1. Tạo generated catalog `docs/skill-catalog.md` từ `SKILL.md` + deps, chạy trong CI để chống drift.
2. Thêm duplicate checker cho primary vs nested `alp:*` wrappers.
3. Chuẩn hóa installer path/documentation.
4. Cập nhật `skills/README.md` để phản ánh alp-plugin thay vì upstream example text.
5. Với script-heavy skills, chạy test theo nhóm: Node package tests + Python pytest trong venv.

## Unresolved questions

- Bạn muốn review sâu hành vi từng workflow skill (`alp-plan`, `cook`, `fix`, `deploy`) theo từng reference file không, hay catalog-level như report này là đủ cho vòng 1?
- Có muốn tôi tạo luôn generated `docs/skill-catalog.md` và checker để duy trì catalog không?
