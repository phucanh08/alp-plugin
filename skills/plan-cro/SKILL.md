---
name: alp:plan:cro
description: "Create a Conversion Rate Optimization (CRO) plan for the given content or issues."
argument-hint: "[issues]"
metadata:
  author: anhlpkit
  version: "1.0.0"
---

# CRO Plan

You are an expert in conversion optimization. Analyze the content based on the given issues:
<issues>$ARGUMENTS</issues>

Activate `alp:plan` skill.

**IMPORTANT:** Analyze the skills catalog and activate the skills that are needed for the task during the process.
**IMPORTANT:** Sacrifice grammar for the sake of concision when writing outputs.

## Conversion Optimization Framework

1. Headline 4-U Formula: **Useful, Unique, Urgent, Ultra-specific** (80% won't read past this)
2. Above-Fold Value Proposition: Customer problem focus, no company story, zero scroll required
3. CTA First-Person Psychology: "Get MY Guide" vs "Get YOUR Guide" (90% more clicks)
4. 5-Field Form Maximum: Every field kills conversions, progressive profiling for the rest
5. Message Match Precision: Ad copy, landing page headline, broken promises = bounce
6. Social Proof Near CTAs: Testimonials with faces/names, results, placed at decision points
7. Cognitive Bias Stack: Loss aversion (fear), social proof (FOMO), anchoring (pricing)
8. PAS Copy Framework: Problem > Agitate > Solve, emotion before logic
9. Genuine Urgency Only: Real deadlines, actual limits, fake timers destroy trust forever
10. Price Anchoring Display: Show expensive option first, make real price feel like relief
11. Trust Signal Clustering: Security badges, guarantees, policies all visible together
12. Visual Hierarchy F-Pattern: Eyes scan F-shape, put conversions in the path
13. Lead Magnet Hierarchy: Templates > Checklists > Guides (instant > delayed gratification)
14. Objection Preemption: Address top 3 concerns before they think them, FAQ near CTA
15. Mobile Thumb Zone: CTAs where thumbs naturally rest, not stretching required
16. One-Variable Testing: Change one thing, measure impact, compound wins over time
17. Post-Conversion Momentum: Thank you page sells next step while excitement peaks
18. Cart Recovery Sequence: Email in 1 hour, retarget in 4 hours, incentive at 24 hours
19. Reading Level Grade 6: Smart people prefer simple, 11-word sentences, short paragraphs
20. TOFU/MOFU/BOFU Logic: Awareness content ≠ decision content, match intent precisely
21. White Space = Focus: Empty space makes CTAs impossible to miss, crowded = confused
22. Benefit-First Language: Features tell, benefits sell, transformations compel
23. Micro-Commitment Ladder: Small yes leads to big yes, start with email only
24. Performance Tracking Stack: Heatmaps show problems, recordings show why, events show what
25. Weekly Optimization Ritual: Review metrics Monday, test Tuesday, iterate or scale

## Workflow

- If the user provides screenshots or videos, use `ai-multimodal` skill to describe the issue in detail so fullstack-developer can fully understand it.
- If the user provides a URL, use `web_fetch` tool to fetch the content and analyze current issues.
- Use `/alp:scout` skill to search the codebase for files needed to complete the task.
- Use `planner` agent to create a comprehensive CRO plan following the progressive disclosure structure:
  - Create a directory using naming pattern from `## Naming` section.
  - Every `plan.md` MUST start with YAML frontmatter:
    ```yaml
    ---
    title: "{Brief title}"
    description: "{One sentence for card preview}"
    status: pending
    priority: P2
    effort: {sum of phases, e.g., 4h}
    branch: {current git branch}
    tags: [cro, conversion]
    created: {YYYY-MM-DD}
    ---
    ```
  - Save the overview access point at `plan.md`, keep it generic, under 80 lines, list each phase with status/progress and links.
  - For each phase, add `phase-XX-phase-name.md` files with sections: Context links, Overview, Key Insights, Requirements, Architecture, Related code files, Implementation Steps, Todo list, Success Criteria, Risk Assessment, Security Considerations, Next steps.
  - Keep every research markdown report concise (≤150 lines).
- Do not start implementing the CRO plan — wait for user approval first.

**IMPORTANT:** Sacrifice grammar for the sake of concision when writing reports.
**IMPORTANT:** In reports, list any unresolved questions at the end, if any.
