# c7_quality_checks

You are tasked with ensuring the codebase passes all static quality checks (pre-commit, linters, type checkers) and fixing any issues that arise.

## Initial Response

When this command is invoked, respond with:

```
I'm ready to run static quality checks. Please provide:
1. **Scope**: Should I check the whole repo or specific files? (Default: changed files)
2. **Auto-fix**: Should I automatically fix issues where possible? (Default: yes)
```

## After receiving user input

### Step 1: Run Checks
Run the project's static analysis tools.
- `pre-commit run --all-files` (or scoped to changes)
- **Python**:
  - `pyright` (type checking)
  - `pylint` (linting)
  - `complexipy` (cognitive complexity)
- **Frontend**:
  - `eslint`, `prettier`

### Step 2: Analyze & Fix
If checks fail:
1. Analyze the error output.
2. Attempt to fix the underlying issue (don't just suppress warnings unless necessary).
   - Fix formatting (black/isort/prettier)
   - Fix type errors (adjust types, generic constraints)
   - Fix linter warnings (unused imports, variables, complexity)
3. Re-run checks to verify fixes.

### Step 3: Report
Produce a summary of checks run and fixes applied.
