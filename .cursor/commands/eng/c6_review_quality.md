# c6_review_quality

You are tasked with reviewing recently implemented code for clean architecture compliance and code simplification opportunities.

## Initial Response

When this command is invoked, respond with:

```
I'm ready to review the code quality. Please provide:

1. **Implementation Scope**: What was recently implemented? (or point me to the plan artifact)
2. **Files to Review**: Specific files/directories to focus on (optional - I can detect from git status)
3. **Review Depth**: Full architectural review or just simplification?
```

Then wait for the user's input.

## After receiving user input

### Step 1: Identify Review Scope

**Automatic Detection** (if user doesn't specify files):
1. Check git status for modified/new files
2. Read the implementation plan artifact if provided
3. Focus on code files (exclude configs, migrations unless specifically requested)

**User-Specified Scope**:
- Use the files/directories the user mentions

### Step 2: Read Context

Before reviewing, gather context:
1. Read the implementation plan artifact (if available)
2. Read all files in scope
3. Check pre-commit status (if applicable)
4. Note any linter errors

### Step 3: Conduct Quality Review

Apply these review criteria:

#### A. Clean Architecture Assessment

**Layer Identification**:
- Identify which architectural layer each file belongs to
- Check if code is in the correct layer
- Verify dependency direction (inward toward domain)

**Key Violations to Check**:
- Business logic in controllers/routes
- Hard-coded database/external service calls (no interfaces)
- Framework dependencies in domain/use case layers
- Untestable code (no dependency injection)

#### B. Code Simplification Assessment

**Complexity Analysis**:
- Check cognitive complexity (use complexipy as reference)
- Identify nested ternaries
- Find overly clever one-liners
- Spot unnecessary nesting

**Clarity Assessment**:
- Variable/function naming clarity
- Logic flow readability
- Comment quality (remove obvious ones, keep helpful ones)

**Duplication Detection**:
- Repeated patterns across files
- Copy-pasted logic
- Opportunities for extraction

#### C. Project Standards Compliance

**Python Backend**:
- \`msgspec.Struct\` for models (not Pydantic)
- \`polars\` for dataframes (not pandas)
- Async/await patterns
- Type hints present
- Pre-commit checks passing

**TypeScript Frontend**:
- ES modules with correct imports
- \`function\` keyword over arrow functions
- Explicit return types
- React Props types explicit

### Step 4: Generate Review Report

Write a comprehensive review artifact:

**Structure**:
1. Executive Summary (Good/Needs Improvement/Requires Refactoring)
2. Clean Architecture Assessment (layer analysis, dependency violations)
3. Code Simplification Assessment (complexity, clarity, duplication)
4. Project Standards Compliance (specific violations)
5. Overall Assessment (strengths, improvements, critical issues)
6. Action Plan (immediate/short-term/long-term)
7. Testing Recommendations

**For Each Issue**:
- Location (file:lines)
- Severity (Critical/High/Medium/Low)
- Problem description
- Impact explanation
- Recommended fix with before/after code examples

### Step 5: Determine Review Outcome

**Fail Review (block merge)** if:
- Critical architectural violations
- Hard-coded external dependencies
- Untestable code
- Pre-commit checks failing
- Security concerns

**Pass with Recommendations** if:
- Only Medium/Low severity issues
- Style inconsistencies
- Opportunities for improvement
- Technical debt items

### Step 6: Save and Present

1. Determine next sequence number by checking \`thoughts/shared/code_review/\`
2. Save review to \`thoughts/shared/code_review/QR[NNN]_topic.md\`
3. Present to user:

**If Review Fails**:
```
❌ Code Review Failed - Blocking Issues Found

Critical Issues: [count]
- [Issue 1 title] (location)
- [Issue 2 title] (location)

These must be fixed before proceeding.

Review artifact: thoughts/shared/code_review/QR[NNN]_topic.md
```

**If Review Passes with Recommendations**:
```
✓ Code Review Passed - Recommendations Available

Strengths:
- [Strength 1]
- [Strength 2]

Recommended Improvements: [count]
- [Improvement 1]
- [Improvement 2]

Review artifact: thoughts/shared/code_review/QR[NNN]_topic.md
```

**If Review Passes Clean**:
```
✓ Code Review Passed - Excellent Quality

No critical or high-severity issues found.

Minor suggestions: [count]

Review artifact: thoughts/shared/code_review/QR[NNN]_topic.md
```

## Integration with Orchestrator

This command is designed to be called as **Phase 6** in the orchestration workflow:

- **Input**: Implementation plan artifact, list of changed files
- **Output**: Quality review artifact with pass/fail status
- **Blocking**: Should block PR/merge if critical issues found

## Best Practices

- **Focus on Recent Code**: Only review what was changed in this implementation
- **Be Constructive**: Provide solutions, not just criticism
- **Prioritize Issues**: Help developers know what to fix first
- **Show Examples**: Before/after code snippets make feedback actionable
- **Balance Pragmatism**: Don't demand perfection, focus on meaningful improvements

## Reference Materials

This review is based on:
- Clean Architecture by Robert C. Martin
- Code Simplifier patterns from Anthropic
- Project-specific standards in \`.cursor/rules/\`

## Example Invocation

```
/c6_review_quality

Implementation plan: thoughts/shared/code_plans/CP001_meal_planning.md
Focus areas: Clean architecture and complexity
```

## Notes

- This is a **read-only** phase - no code changes are made
- The review produces an artifact for developer action
- Can be run independently or as part of orchestrated workflow
- Integrates with pre-commit hooks (checks their status)
