# c_improve

Improves user-provided code snippets by researching better patterns and implementations, then planning and executing the improvement.

## Purpose

Takes a code snippet reference (e.g., `@file.ext:10-25`) and:
1. Decomposes what the code is doing
2. **Always** researches better approaches using external examples
3. Plans the improvement
4. Implements the changes
5. Verifies quality

## Initial Response

```
Ready to improve your code snippet.

Provide: Code snippet reference (e.g., @file.ext:10-25)

I'll analyze it, research better approaches, and implement improvements.
```

## Execution Flow

### Phase 0: Check MCP Availability
- Call `ListMcpResources` for `user-sub-agents`
- If unavailable: fall back to direct MCP calls (perplexity, GitHub search)

### Phase 1: Decomposition & Analysis

**Action**: Read and understand the provided code snippet

**Output**: Written summary covering:
- **What it does**: Functional description
- **Current approach**: Implementation details
- **Patterns used**: Control flow, data structures, algorithms
- **Potential issues**: Code smells, complexity, maintainability concerns
- **Improvement opportunities**: What could be better

**Tools**:
- Read the referenced file/lines
- Use codebase search to understand context and dependencies
- Analyze surrounding code for full picture

### Phase 2: External Research (ALWAYS REQUIRED)

**Action**: Research better implementations and patterns - **NEVER SKIP THIS PHASE**

**Option A - Use Agent (Preferred if MCP available)**:
```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-external-researcher"
    prompt: |
      Research better approaches for: [decomposed functionality]
      
      Current implementation: [summary from Phase 1]
      
      Look for:
      - More maintainable patterns
      - Better error handling
      - Performance improvements
      - Industry best practices
      - Modern idioms and approaches
      
      Focus on: [specific technology/framework]
    cwd: "/absolute/workspace/path"
```

**Option B - Direct MCP (Fallback)**:
1. `mcp_perplexity_perplexity_search`: Query for best practices and modern approaches
2. `mcp_grep_searchGitHub`: Find real-world examples from quality repos (>1000 stars)
3. Synthesize findings into structured research artifact

**Output**: Research artifact `thoughts/shared/research/ext_NNN_improve_[topic].md`

**Critical**: This phase is MANDATORY. The entire purpose of `c_improve` is to find better external patterns, not just refactor existing code.

### Phase 3: Planning

**Action**: Create improvement plan using `eng-planner` agent

```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-planner"
    prompt: |
      Create plan to improve code at [file:lines]
      
      Current implementation: [summary]
      Research findings: thoughts/shared/research/ext_NNN_improve_[topic].md
      
      Plan should:
      - Address identified issues
      - Incorporate researched best practices
      - Maintain backward compatibility (unless user specifies otherwise)
      - Include automated tests
    cwd: "/absolute/workspace/path"
```

**Output**: Implementation plan `thoughts/shared/code_plans/CPNNN_improve_[topic].md`

**Fallback**: If agent unavailable, create plan directly following `c1_plan.md` structure

### Phase 4: Implementation

**Action**: Execute the improvement plan

```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-implementer"
    prompt: |
      Implement improvement plan: thoughts/shared/code_plans/CPNNN_improve_[topic].md
      
      Original code: [file:lines]
      Research reference: thoughts/shared/research/ext_NNN_improve_[topic].md
      
      Apply patterns and approaches from research.
    cwd: "/absolute/workspace/path"
```

**Fallback**: If agent unavailable, implement directly following the plan

### Phase 5: Validation

**Action**: Verify the improvement

```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-validator"
    prompt: |
      Validate improvement implementation
      
      Plan: thoughts/shared/code_plans/CPNNN_improve_[topic].md
      Original: [file:lines before]
      Modified: [file:lines after]
    cwd: "/absolute/workspace/path"
```

**Checks**:
- All tests pass
- No new linter warnings
- Original functionality preserved
- New patterns correctly applied
- Research recommendations implemented

**Output**: Validation artifact `thoughts/shared/code_validate/CVNNN_improve_[topic].md`

### Phase 6: Quality Review

**Action**: Final quality check

```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-quality-reviewer"
    prompt: |
      Review code improvement quality
      
      Original: [file:lines before]
      Improved: [file:lines after]
      Plan: thoughts/shared/code_plans/CPNNN_improve_[topic].md
      Research: thoughts/shared/research/ext_NNN_improve_[topic].md
    cwd: "/absolute/workspace/path"
```

**Output**: Quality review `thoughts/shared/code_review/QRNNN_improve_[topic].md`

## Progress Tracking

Update user after each phase:

```
✓ Phase 1: Decomposition - [file:lines]
  → Identified: [key issues]
  → Next: External research
  
✓ Phase 2: External Research (REQUIRED) - ext_NNN_improve_[topic].md
  → Found: [better approach]
  → Next: Create improvement plan
  
✓ Phase 3: Planning - CPNNN_improve_[topic].md
  → Strategy: [approach]
  → Next: Implementation
  
✓ Phase 4: Implementation
  → Changed: [files]
  → Next: Validation
  
✓ Phase 5: Validation - CVNNN_improve_[topic].md
  → Status: [pass/fail]
  → Next: Quality review
  
✓ Phase 6: Quality Review - QRNNN_improve_[topic].md
  → Result: [summary]
```

## Loop-Back Triggers

**Validation Failures (Phase 5 → 3 → 4 → 5)**:
- If tests fail or functionality broken
- Re-plan → re-implement → re-validate

**Quality Issues (Phase 6 → 4 → 5 → 6)**:
- If critical quality issues found
- Re-implement → re-validate → re-review

## Error Handling

**MCP Unavailable**: Fall back to direct tool usage (perplexity + GitHub search)
**Agent Failure**: Present options (Retry/Manual/Abort), wait for user
**Test Failures**: Loop back to planning with failure context
**Quality Gate Fail**: Stop, present findings, require user decision

## Final Summary

```
🎉 Improvement Complete!

Original: [file:lines] - [brief description]
Improved: [file:lines] - [brief description]

Key Changes:
- [Change 1]
- [Change 2]
- [Change 3]

Research Findings Applied:
- [Pattern/approach 1]
- [Pattern/approach 2]

Artifacts:
- Research: thoughts/shared/research/ext_NNN_improve_[topic].md
- Plan: thoughts/shared/code_plans/CPNNN_improve_[topic].md
- Validation: thoughts/shared/code_validate/CVNNN_improve_[topic].md
- Review: thoughts/shared/code_review/QRNNN_improve_[topic].md

Tests: ✓ | Quality: [score/result]
```

## Example Usage

**User Input**:
```
@auth.py:45-67
```

**Execution**:
1. **Decompose**: Read auth.py lines 45-67 → "Manual password hashing with sha256, no salt, vulnerable"
2. **Research** (REQUIRED): Find bcrypt/argon2 best practices via perplexity + GitHub examples from top security repos
3. **Plan**: Replace with bcrypt, add salt, update tests, migration strategy
4. **Implement**: New hash_password/verify_password functions using researched patterns
5. **Validate**: All auth tests pass + new security tests + no regressions
6. **Review**: Security improved, best practices applied, backwards compatibility addressed

## Critical Rules

- **Always decompose first**: Understand before researching
- **External research MANDATORY**: Phase 2 is never skipped - it's the core purpose of this command
- **Evidence-based**: Cite research findings in plan
- **Preserve functionality**: Unless user explicitly requests breaking changes
- **Test everything**: Original behavior + new improvements
- **Loop until complete**: Don't stop at first validation failure
- **Quality gate**: Phase 6 can block completion

## Difference from c_orchestrate

| Aspect | c_orchestrate | c_improve |
|--------|--------------|-----------|
| Input | Task description | Code snippet reference |
| Phase 1 | Codebase research | Decomposition |
| Phase 2 | External research (conditional) | **External research (ALWAYS)** |
| Focus | Building new features | Improving existing code |
| Scope | Full feature implementation | Targeted code improvement |
| Research Trigger | Only if codebase lacks patterns | Every single time |
