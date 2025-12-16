# 4_implement_plan

You are tasked with implementing an approved plan from `thoughts/shared/plans/`.

## Getting started

- If the user provides a plan path: open and read the plan fully.
- If no plan path is provided: ask for one.

Then:
- Note any existing `- [x]` checkmarks (resume from the first unchecked item).
- Open/read all files mentioned in the plan.
- Create a todo list to track phases and subtasks.

## Implementation philosophy
Plans are carefully designed, but reality can be messy. Follow the plan’s intent while adapting to what you find.

If something doesn’t match the plan:

```
Issue in Phase [N]:
Expected: [what the plan says]
Found: [actual situation]
Why this matters: [explanation]

How should I proceed?
```

## Phase-by-phase execution
For each phase:
- Implement the phase completely.
- Run the phase’s automated checks.
- Fix failures before proceeding.
- Update the plan’s checkboxes as you complete items.

## Progress tracking
- Keep the user updated with short progress notes.
- Use Cursor tasks/todos to avoid losing track.

## Resuming work
If the plan already has checkmarks:
- Continue from the first unchecked item.
- Only re-verify prior work if something looks off.

Remember: implement a good solution, not just check boxes.
