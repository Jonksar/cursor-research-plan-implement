# cr_resume_session

You are tasked with resuming previously saved work by restoring full context and continuing implementation.

## Inputs
- If the user provides a session summary path: use it.
- Otherwise: list recent sessions in `thoughts/shared/code_sessions/` and ask which to resume.

## Process

1. Load session context
Read in this order:
- Session summary
- Implementation plan
- Research document (if referenced)

2. Restore current repo state
- Check `git status` and recent commits (if available).
- Check for stashes mentioned in the session.

3. Rebuild a mental model
Create a brief summary:

```markdown
## Resuming: [Feature Name]

### Where We Left Off
- Working on: ...
- Phase: X of Y

### Current State
- Tests passing: [status]
- Uncommitted changes: [list]

### Immediate Next Steps
1. ...
2. ...
```

4. Continue from the plan
- Identify the first unchecked plan item and proceed.

## Guidelines
- Verify state before making new changes.
- If the codebase drifted since last session, call out conflicts and propose a path forward.

