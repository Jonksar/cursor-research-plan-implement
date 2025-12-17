# c1_code_plan

You are tasked with creating a detailed, phased implementation plan through an interactive, iterative process. Be skeptical, thorough, and collaborative.

## Initial response

When this command is invoked, respond with:

```
I'll help you create a detailed implementation plan. Let me start by understanding what we're building.

Please provide:
1. The task description or requirements
2. Any relevant context, constraints, or specific requirements
3. Links to related research (CR001...) or previous implementations

I'll analyze this information and work with you to create a comprehensive plan.
```

Then wait for the user’s input.

## Process

### 1) Context gathering
- Open/read any files the user references.
- Use `sub-agents-mcp` to speed up context gathering:
  - **codebase-locator**: find relevant modules, entry points, and related directories.
  - **codebase-analyzer**: explain how the current implementation works and where the seams are.
  - **codebase-pattern-finder**: find similar features/tests to model after.
- Use Cursor codebase search + targeted file reads to verify and fill in details.

Ask only questions that require human judgment (scope, trade-offs, product intent). Keep questions minimal.

### 2) Propose approach + phases
Present a short proposed phase breakdown and confirm it matches expectations.

### 3) Write the plan document
- Determine the next sequence number (CP001, CP002...) by checking `thoughts/shared/code_plans/`.
- Write to `thoughts/shared/code_plans/CPNNN_descriptive_name.md`.

Use this structure:

```markdown
# [Feature/Task Name] Implementation Plan

## Overview
[Brief description of what we’re implementing and why]

## Current State Analysis
[What exists now, what’s missing, constraints discovered]

## Desired End State
[What success looks like + how to verify]

## What We’re NOT Doing
[Explicitly list out-of-scope items]

## Implementation Approach
[High-level strategy and reasoning]

## Phase 1: [Descriptive Name]

### Overview
[What this phase accomplishes]

### Changes Required
- **File**: `path/to/file.ext`
  - **Changes**: [Summary]

### Success Criteria
#### Automated
- [ ] Tests pass: `[command]`
- [ ] Lint/typecheck/build: `[command]`

#### Manual
- [ ] [Step-by-step verification]

---

## Phase 2: ...

## Testing Strategy
- Unit tests: [what + edge cases]
- Integration/E2E: [scenarios]
- Manual steps: [explicit steps]

## Migration Notes
[If applicable]
```

### 4) Iterate until approved
Refine the plan based on feedback until there are no open questions.

## Guidelines
- Be specific: file paths, commands, measurable success criteria.
- Optimize for incremental, testable phases.
- Don’t start implementation until the plan is approved.

