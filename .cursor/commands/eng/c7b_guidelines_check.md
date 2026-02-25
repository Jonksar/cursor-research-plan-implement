# c7b_guidelines_check

You are tasked with verifying that the code changes comply with the project guidelines.

## Initial Response

When this command is invoked, respond with:

```
Ready to check guidelines compliance.
Guidelines Path: [User provided path or default]
Scope: [Changes/Codebase]
```

## Execution

1. **Read Guidelines**:
   - Read the guidelines file at the specified path (default: `thoughts/shared/guidelines.md`).
   - If the file doesn't exist, check `~/reiterate/fire/thoughts/shared/guidelines` (if accessible) or ask the user for the correct path.

2. **Check Compliance**:
   - If checking **changes**, run `git diff` to see what changed.
   - Read the changed files.
   - Verify compliance with the rules in the guidelines.

3. **Report**:
   - Output a list of violations and suggestions.
   - If serious violations are found, mark the check as FAILED.

## Output Artifact
- Write the report to `thoughts/shared/quality/guidelines_check_result.md`.
