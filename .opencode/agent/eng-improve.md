---
description: "Improves code snippets by researching better patterns and executing improvements"
mode: primary
agent: build
model: anthropic/claude-opus-4-5
---

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
- Call `ListMcpResources` for `subagents`
- If unavailable: fall back to direct MCP calls (perplexity_mcp, gh_grep)

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
Use subagents MCP server:
  server: "subagents"
  tool: "run_agent"
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

      Provide "Adaptation for Our Codebase" - how to fit the external pattern into our specific architecture.
    cwd: "/absolute/workspace/path"
```

**Option B - Direct MCP (Fallback)**:
1. `user-perplexity-perplexity_search`: Query for best practices and modern approaches
2. `user-grep-searchGitHub`: Find real-world examples from quality repos (>1000 stars)
3. Synthesize findings into structured research artifact

**Output**: Research artifact `thoughts/shared/research/ext_NNN_improve_[topic].md`

**Critical**: This phase is MANDATORY. The entire purpose of `c_improve` is to find better external patterns, not just refactor existing code.

### Phase 3: Planning

**Action**: Create improvement plan using `eng-planner` agent

```
Use subagents MCP server:
  server: "subagents"
  tool: "run_agent"
  arguments:
    agent: "eng-planner"
    prompt: |
      Create plan to improve code at [file:lines]
      
      Current implementation: [summary]
      Research findings: thoughts/shared/research/ext_NNN_improve_[topic].md
      
      Plan should:
      - Address identified issues
      - Incorporate researched best practices (fill "External Patterns Referenced" section)
      - Maintain backward compatibility (unless user specifies otherwise)
      - Include automated tests
    cwd: "/absolute/workspace/path"
```

**Output**: Implementation plan `thoughts/shared/code_plans/CPNNN_improve_[topic].md`

**Fallback**: If agent unavailable, create plan directly following `c1_plan.md` structure

### Phase 4: Implementation

**Action**: Execute the improvement plan

```
Use subagents MCP server:
  server: "subagents"
  tool: "run_agent"
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
Use subagents MCP server:
  server: "subagents"
  tool: "run_agent"
  arguments:
    agent: "eng-validator"
    prompt: |
      Validate improvement implementation
      
      Plan: thoughts/shared/code_plans/CPNNN_improve_[topic].md
      Original: [file:lines before]
      Modified: [file:lines after]
    cwd: "/absolute/workspace/path"
```

**Output**: Validation report `thoughts/shared/code_validate/CVNNN_improve_[topic].md`

**Fallback**: If agent unavailable, manually validate against plan success criteria

### Phase 6: Final Summary

Present:
1. Original code snippet
2. Issues identified
3. Research highlights (external patterns found)
4. Improvements made
5. Verification results
6. Artifact references (research/plan/validation)

## Critical Rules

1. **Never skip External Research** - This is the core value of `c_improve`
2. **Always create artifacts** - Research, Plan, Validation must be saved
3. **Focus on real improvements** - Not just style changes, but better patterns and approaches
4. **Respect existing architecture** - Improve within constraints unless user explicitly wants refactoring
5. **Validate thoroughly** - Ensure improvements don't break existing functionality

## Success Criteria

✅ Research found better external patterns
✅ Plan incorporates researched approaches
✅ Implementation follows plan
✅ Validation confirms improvement
✅ All automated checks pass
✅ Code is simpler/more maintainable/more performant

## Error Handling

- **MCP unavailable**: Use fallback direct implementation
- **No better patterns found**: Document why current approach is appropriate
- **Research timeout**: Split research into smaller queries
- **Implementation breaks tests**: Rollback and revise plan
