# Team Coordination Rules

> These rules apply to (a) **native** teammates within an Agent Team and (b) **csd-backend** workers
> (`--harness codex|pi`, `--mixed`) driven by a lead. Sections below tagged for native teammates use
> tools (`SendMessage`, `TaskUpdate`) that csd workers do NOT have — see "csd-Backend Workers".
> They have no effect on standard sessions or subagent workflows.

Rules for agents operating as teammates within an Agent Team.

## File Ownership (CRITICAL)

- Each teammate MUST own distinct files — no overlapping edits
- Define ownership via glob patterns in task descriptions: `File ownership: src/api/*, src/models/*`
- Lead resolves ownership conflicts by restructuring tasks or handling shared files directly
- Tester owns test files only; reads implementation files but never edits them
- If ownership violation detected: STOP and report to lead immediately

## Git Safety

- Prefer git worktrees for implementation teams — each dev in own worktree eliminates conflicts
- Never force-push from a teammate session
- Commit frequently with descriptive messages
- Pull before push to catch merge conflicts early
- If working in a git worktree, commit/push to the worktree branch — not main or dev

## Communication Protocol

- Use `SendMessage(type: "message")` for peer DMs — always specify recipient by name
- Use `SendMessage(type: "broadcast")` ONLY for critical blocking issues affecting entire team
- Mark tasks completed via `TaskUpdate` BEFORE sending completion message to lead
- Include actionable findings in messages, not just "I'm done"
- Never send structured JSON status messages — use plain text

## CK Stack Conventions

### Report Output
- Save reports to `{ALP_REPORTS_PATH}` (injected via hook, fallback: `plans/reports/`)
- Naming: `{type}-{date}-{slug}.md` where type = your role (researcher, reviewer, debugger)
- Sacrifice grammar for concision. List unresolved questions at end.

### Commit Messages
- Use conventional commits: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`
- No AI references in commit messages
- Keep commits focused on actual code changes

### Docs Sync (Implementation Teams Only)
- After completing implementation tasks, lead MUST evaluate docs impact
- State explicitly: `Docs impact: [none|minor|major]`
- If impact: update `docs/` directory or note in completion message

## Task Claiming

- Claim lowest-ID unblocked task first (earlier tasks set up context for later ones)
- Check `TaskList` after completing each task for newly unblocked work
- Set task to `in_progress` before starting work
- If all tasks blocked, notify lead and offer to help unblock

## Plan Approval Flow

When `plan_mode_required` is set:
1. Research and plan your approach (read-only — no file edits)
2. Send plan via `ExitPlanMode` — this triggers approval request to lead
3. Wait for lead's `plan_approval_response`
4. If rejected: revise based on feedback, resubmit
5. If approved: proceed with implementation

## Conflict Resolution

- If two teammates need the same file: escalate to lead immediately
- If a teammate's plan is rejected twice: lead takes over that task
- If findings conflict between reviewers: lead synthesizes and documents disagreement
- If blocked by another teammate's incomplete work: message them directly first, escalate to lead if unresponsive

## Shutdown Protocol

- Approve shutdown requests unless mid-critical-operation
- Always mark current task as completed before approving shutdown
- If rejecting shutdown, explain why concisely
- Extract `requestId` from shutdown request JSON and pass to `shutdown_response`

## Idle State (Normal Behavior)

- Going idle after sending a message is NORMAL — not an error
- Idle means waiting for input, not disconnected
- Sending a message to an idle teammate wakes them up
- Do not treat idle notifications as completion signals — check task status instead

## Discovery

- Read team config at `~/.claude/teams/{team-name}/config.json` to discover teammates
- Always refer to teammates by NAME (not agent ID)
- Names are used for: `recipient` in SendMessage, task `owner` in TaskUpdate

## csd-Backend Workers (non-native: `--harness codex|pi`, `--mixed`)

These override the native assumptions above when the worker runs via csd (see
`skills/team/references/csd-backend-driving.md` for mechanics):

- **No peer messaging.** csd workers share ONLY disk files + JSONL event streams with the lead. The
  "Communication Protocol" (SendMessage) section applies to **native teammates only**. The lead
  relays ALL cross-worker information (e.g. debug adversarial challenges go lead → worker, not peer→peer).
- **No shared task list.** `TaskUpdate`/`TaskList`/"Task Claiming" do not apply to csd workers. The lead
  holds task state in its own context (`name|harness|cwd|status|report` table).
- **Verify on disk, not prose.** csd workers may falsely report success. The lead confirms the actual
  produced artifacts before accepting completion.
- **No crash recovery** for codex/pi (no resume-by-id). A dead worker is relaunched from zero; the lead
  reports lost work honestly rather than masking it.
- **Codex not queryable until first `converse`** completes (launch ≠ ready).
- **`--mixed`:** keep native pool (Agent Teams, this file's main rules) and csd pool (these rules) in
  SEPARATE tracking namespaces. Never conflate. Lead mediates all cross-pool information.
- **Teardown:** lead `stop`s every csd worker + runs `csd prune`; verifies `csd list` is empty.
