# 3_validate_plan

You are tasked with validating that an implementation plan was correctly executed: verify success criteria, identify deviations, and produce a clear validation report.

## Process

1. Locate and read the plan fully
   - If the user didn’t specify a plan path, find the most recent plan in `thoughts/shared/plans/` and ask the user to confirm.

2. Identify what should have changed
   - Files expected to be modified/added
   - Automated success criteria commands
   - Manual verification items

3. Gather evidence
   - Use `sub-agents-mcp` to speed up validation:
     - **codebase-locator**: enumerate the files/areas the plan touches and where the feature wires in.
     - **codebase-analyzer**: sanity-check that the implemented flow matches the plan’s intended behavior and contracts.
     - **codebase-pattern-finder**: check tests/implementation style against existing project patterns.
   - Review the actual code changes against the plan.
   - Run the automated verification commands listed in the plan (or report why they can’t be run).
   - If `thoughts/shared/guidelines/fix_patterns.yaml` exists:
     - Load the matchers and scan the repo (use `grep` scoped by the matcher globs).
     - Treat any remaining hits as potential deviations (or explicitly justify false positives).
   - If sub-agents fail due to auth, ask the user to run `cursor-agent login` once.

4. Validate phase by phase
   - Confirm each checked phase is truly complete.
   - For partial/incomplete work, point to the exact mismatch.

5. Produce a validation report

```markdown
## Validation Report: [Plan Name]

### Implementation Status
- ✓ Phase 1: [Name] - Implemented
- ⚠️ Phase 2: [Name] - Partially implemented (see deviations)
- ✗ Phase 3: [Name] - Not implemented

### Automated Verification Results
- ✓ Tests: [command] (pass)
- ✗ Lint: [command] (fail) — [summary]

### Pattern-based Guideline Checks (if present)
- ✓ `fix_patterns.yaml`: loaded (N matchers)
- ✗ Remaining matches: (K)
  - `rule_id` — `path:line` — [excerpt]

### Matches Plan
- [What was correctly implemented]

### Deviations from Plan
- [Deviation] — [why it matters] — [suggested fix]

### Potential Issues / Risks
- [Risk] — [impact]

### Manual Testing Required
1. [Step]
2. [Step]

### Recommendations
- [Action items before merge]
```

## Guidelines
- Be thorough but practical.
- Document both successes and issues with file/line references.
- If the plan needs updating due to reality, call it out explicitly.
