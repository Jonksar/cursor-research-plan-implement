# Commit

1. **Review Context**:
   - Run `git diff` and `git status` to understand all pending changes in detail.
   - Run `git log -n 5` to review recent commit messages; ensure your new message matches their style/convention (e.g., Conventional Commits).
2. **Compose Message**: Draft a clear, concise commit message summarizing the changes.
3. **Commit**:
   - Execute the commit.
   - **CRITICAL**: NEVER override pre-commit hooks (e.g., never use `--no-verify`).
   - If pre-commit checks fail, try to fix simple lint errors and retry.
   - If failures persist, **STOP** and return to the user.
4. **Completion**: Return control to the user immediately after the commit.
