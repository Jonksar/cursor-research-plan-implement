# c6b_simplification_opportunities

You are tasked with reviewing recently implemented code to find simplification opportunities by researching how other codebases implement similar functionality.

## Initial Response

When this command is invoked, respond with:

```
I'm ready to review for simplification opportunities. Please provide:

1. **Implementation Scope**: What was recently implemented? (or point me to the plan artifact)
2. **Files to Review**: Specific files/directories to focus on (optional - I can detect from git status)
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

### Step 2: Read and Decompose Implementation

Before researching, understand what was built:
1. Read the implementation plan artifact (if available)
2. Read all files in scope
3. Break down the implementation into logical components/features
4. Identify the core patterns and approaches used

**Output**: Create a decomposition summary covering:
- **Components identified**: List of logical pieces (e.g., "Authentication flow", "Data validation", "Cache layer")
- **Current approaches**: How each component is implemented
- **Patterns used**: Design patterns, algorithms, data structures
- **Complexity indicators**: Areas that feel complex or unclear

### Step 3: Parallel External Research

For each identified component, research better implementations in parallel:

**Use eng-external-researcher agent** for each component:

```
CallMcpTool:
  server: "user-sub-agents"
  toolName: "run_agent"
  arguments:
    agent: "eng-external-researcher"
    prompt: |
      Research better implementations for: [component name]
      
      Current implementation approach: [summary]
      Technology stack: [language/framework]
      
      Look for:
      - Simpler patterns from high-quality codebases (>1000 stars)
      - More maintainable approaches
      - Better error handling patterns
      - Industry best practices
      - Modern idioms that reduce complexity
      
      Focus on finding the SIMPLEST and CLEANEST way to implement this.
    cwd: "/absolute/workspace/path"
```

**Key**: Spawn multiple eng-external-researcher agents in parallel (one per component) to speed up research.

### Step 4: Synthesize Research Findings

After all research completes:
1. Consolidate findings from all research artifacts
2. Compare our implementation vs. industry patterns
3. Identify concrete simplification opportunities
4. Assess complexity reduction potential

**Criteria for Simplification**:
- **Reduced cognitive complexity**: Fewer branches, less nesting
- **Clearer intent**: More readable, self-documenting code
- **Better separation**: Simpler boundaries between components
- **Less code**: Fewer lines without sacrificing clarity
- **Standard patterns**: Using well-known idioms instead of custom solutions

### Step 5: Generate Simplification Report

Write a comprehensive simplification artifact:

**Structure**:
1. Executive Summary (simplification opportunities found)
2. Component Breakdown (what was implemented, how it could be simpler)
3. External Research Summary (key findings from other codebases)
4. Simplification Opportunities (ranked by impact)
5. Trade-off Analysis (simplicity vs. other concerns)
6. Action Plan (immediate/short-term/long-term)

**For Each Opportunity**:
- Location (file:lines)
- Priority (High/Medium/Low)
- Current complexity (description + metrics if available)
- Simpler approach (with examples from research)
- Benefits (reduced complexity, better maintainability)
- Recommended changes with before/after code examples
- Research references (which external codebases showed this pattern)

### Step 6: Determine Review Outcome

**High-Impact Simplifications** if:
- Significant complexity reduction possible (>30%)
- Industry-standard patterns available that we're not using
- Clear path to simpler implementation
- Multiple components can be simplified

**Moderate Simplifications** if:
- Some complexity reduction possible
- Minor improvements to clarity and maintainability
- Incremental adoption of better patterns

**Already Optimal** if:
- Implementation matches industry best practices
- Complexity is inherent to the problem domain
- No simpler patterns found in research

### Step 7: Save and Present

1. Determine next sequence number by checking `thoughts/shared/code_review/`
2. Save review to `thoughts/shared/code_review/SO[NNN]_topic.md`
3. Present to user:

**If High-Impact Simplifications Found**:
```
🎯 High-Impact Simplification Opportunities Found

Components analyzed: [count]
Research artifacts: [count]

Top Opportunities:
- [Opportunity 1]: [current complexity → simpler approach] (Priority: High)
- [Opportunity 2]: [current complexity → simpler approach] (Priority: High)
- [Opportunity 3]: [current complexity → simpler approach] (Priority: Medium)

Potential complexity reduction: [estimate]%

Review artifact: thoughts/shared/code_review/SO[NNN]_topic.md
Research references: [list of ext_NNN artifacts]
```

**If Moderate Simplifications Found**:
```
✓ Simplification Opportunities Available

Components analyzed: [count]
Research artifacts: [count]

Opportunities:
- [Opportunity 1] (Priority: Medium)
- [Opportunity 2] (Priority: Low)

Review artifact: thoughts/shared/code_review/SO[NNN]_topic.md
Research references: [list of ext_NNN artifacts]
```

**If Already Optimal**:
```
✓ Implementation is Already Simple and Clean

Components analyzed: [count]
Research artifacts: [count]

Your implementation matches or exceeds industry best practices.
No significant simplification opportunities found.

Review artifact: thoughts/shared/code_review/SO[NNN]_topic.md
Research references: [list of ext_NNN artifacts]
```

## Integration with Orchestrator

This command is designed to be called as **Phase 6b** in the orchestration workflow (runs in parallel with Phase 6a):

- **Input**: Implementation plan artifact, list of changed files
- **Output**: Simplification review artifact + external research artifacts
- **Blocking**: Non-blocking, but high-impact findings should trigger re-planning
- **Loop-back**: If high-impact simplifications found → consider going back to plan (Phase 2) → implement (Phase 4)

## Parallel Research Strategy

**Critical**: This command spawns multiple external research agents in parallel for efficiency:

1. Decompose implementation into N components
2. Spawn N `eng-external-researcher` agents simultaneously
3. Wait for all research to complete
4. Synthesize findings into one simplification report

**Example**:
- Component 1: "File upload handling" → Research agent 1
- Component 2: "Data validation" → Research agent 2  
- Component 3: "Error handling" → Research agent 3
All three agents run in parallel, saving time.

## Best Practices

- **Break Down First**: Decompose before researching to target research effectively
- **Research Widely**: Look at high-quality repos (>1000 stars) for patterns
- **Be Pragmatic**: Simplicity is good, but don't sacrifice necessary complexity
- **Show Evidence**: Every recommendation should cite external examples
- **Balance Trade-offs**: Simpler isn't always better - consider maintainability, performance
- **Prioritize Impact**: Focus on high-impact simplifications first

## Example Invocation

```
/c6b_simplification_opportunities

Implementation plan: thoughts/shared/code_plans/CP001_meal_planning.md
Focus: Find simpler patterns from other codebases
```

## Notes

- This is a **read-only research phase** - no code changes are made
- Spawns multiple eng-external-researcher agents in parallel for speed
- The review produces artifacts for developer decision-making
- Can be run independently or as part of orchestrated workflow
- Runs in parallel with c6a_architecture_review
- May trigger loop-back to planning if high-impact simplifications found
