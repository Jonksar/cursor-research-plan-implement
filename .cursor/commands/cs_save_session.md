# cs_save_session

You are tasked with saving a durable progress checkpoint when the user needs to pause work.

## When to use
- Stopping mid-implementation
- Switching tasks
- End of session

## Process

1. Assess current state
- Summarize what was being worked on.
- Note the active plan path (if any).
- Capture current git status/diff summary (if available).

2. Update the plan (if applicable)
Add a progress checkpoint section near the top of the plan (or in a dedicated section):

```markdown
## Progress Checkpoint - [Date Time]

### Work Completed This Session
- [x] ...
- [ ] ... (partial)

### Current State
- **Active File**: `path/to/file.ext:line`
- **Current Task**: ...
- **Blockers**: ...

### Local Changes
- Modified: `...`
- Added: `...`

### Next Steps
1. ...
2. ...

### Context Notes
- ...

### Commands to Resume
- `/cr_resume_session thoughts/shared/code_sessions/CSNNN_feature.md`
```

3. Create a session summary document
- Determine next sequence number (CS001, CS002...) by checking `thoughts/shared/code_sessions/`.
- Save to `thoughts/shared/code_sessions/CSNNN_feature.md`.

Use this structure:

```markdown
---
date: [ISO timestamp]
feature: [Feature name]
plan: thoughts/shared/code_plans/[plan].md
research: thoughts/shared/code_research/[research].md
status: in_progress
last_commit: [git hash or "unknown"]
---

# Session Summary: [Feature Name]

## Objectives
- ...

## Accomplishments
- ...

## Discoveries
- ...

## Decisions Made
- ...

## Open Questions
- ...

## File Changes
[List key files + what changed]

## Test Status
- [ ] Unit tests passing
- [ ] Integration tests passing
- [ ] Manual testing completed

## Ready to Resume
1. Read this session summary
2. Check plan: [plan path]
3. Continue with: [next concrete action]
```

4. Present a concise resume instruction

```
✅ Progress saved!

📁 Session: thoughts/shared/code_sessions/CSNNN_...
📋 Plan: thoughts/shared/code_plans/...

To resume: /cr_resume_session thoughts/shared/code_sessions/CSNNN_...
```

## Guidelines
- Be specific: future-you needs exact context.
- Include the next concrete action and where to resume.

