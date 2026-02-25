# c4_research_external

You are tasked with researching external solutions, libraries, and patterns to ensure robust, standard-compliant implementation. 

## Initial response

When this command is invoked, respond with:

```
I'm ready to research external solutions. Please provide:

1. **Problem/Gap**: What are you trying to solve that the codebase doesn't have examples for?
2. **Context**: What has been researched in the codebase already?
3. **Constraints**: Any requirements (license, performance, tech stack compatibility)?
```

Then wait for the user's query.

## After receiving the query

### Step 1: Decompose the Request

- Identify the **Problem Domain** (e.g., "Async file processing", "PDF parsing")
- Identify the **Specific Target** if known (e.g., `pytesseract`, `boto3`)
- Understand what the codebase already has vs. what's missing

### Step 2: Phase 1 - Broad Research (Perplexity)

**Trigger**: If the task is novel, high-level, or lacks a specific library target.

**Use Perplexity MCP**:
- `user-perplexity-perplexity_search` for faster, straightforward questions

**Query Format**: "How to solve [problem type]? What are specific approaches and library recommendations? What to focus on?"

**Goal**: Identify standard approaches, trade-offs, and candidate libraries.

**Criteria**: Prioritize libraries with:
- High GitHub star counts
- Recent maintenance activity
- Active community support
- Good documentation
- License compatibility with project

### Step 3: Phase 2 - Deep Dive (GitHub Search)

**Trigger**: Once a specific library or pattern is identified (from Phase 1 or user input).

**Use GitHub Search MCP** (`user-grep-searchGitHub`):

**A. Definition Scout**
- **Goal**: Confirm definitions and available exceptions
- **Strategies**:
  - Exceptions: `raise .*Error` or `class .*Error`
  - Classes: `class <Name>:`
  - Functions: `def <name>\(`
  - Types: `type <Name> =`
- **Target**: The library's repository and high-quality projects using it

**B. Usage Miner**
- **Goal**: See real-world usage patterns
- **Pattern**: `(?s)try:.*?target.*?except` and common usage idioms
- **Filter**: Reputable repositories only:
  - High star counts (>1000)
  - Known organizations
  - Active maintenance
  - Good test coverage

**C. Idiom Validator**
- **Goal**: Verify best practices
- **Search for**:
  - Configuration patterns
  - Error handling approaches
  - Resource management (context managers)
  - Testing patterns

### Step 4: Phase 3 - Synthesis & Recommendation

- Consolidate results from Perplexity (High-level guide) and GitHub (Low-level examples)
- Compare multiple options if applicable
- Create trade-off matrix (performance, complexity, maintainability, community)
- Provide recommended approach with **concrete code examples**
- Note any caveats or gotchas discovered

### Step 5: Write Research Artifact

Use this structure:

```markdown
---
date: [Current Date in ISO format]
researcher: Cursor Agent (External Researcher)
topic: "[Problem/Library Name]"
tags: [research, external, patterns]
status: complete
---

# External Research: [Topic]

## Research Context

**Problem Statement**: [What we're trying to solve]
**Codebase Gap**: [Why existing code doesn't provide examples]
**Research Scope**: [What we researched]

## 1. High-Level Guide (Perplexity)

[Summary of the standard approach to this problem]

### Industry Standards
- [Standard practice 1]
- [Standard practice 2]

### Common Approaches
- **Approach A**: [Description, pros/cons]
- **Approach B**: [Description, pros/cons]

## 2. Technical Deep Dive (GitHub)

### Option A: [Library/Pattern 1]

**Repository**: [GitHub URL]
**Stars**: [Count] | **Last Updated**: [Date] | **License**: [Type]

**Definition & API**:
\`\`\`python
# Key classes/functions found
\`\`\`

**Real-World Usage**:
\`\`\`python
# Common patterns from popular repos
\`\`\`

**Pros**:
- [Benefit 1]
- [Benefit 2]

**Cons**:
- [Limitation 1]
- [Limitation 2]

### Option B: [Library/Pattern 2] (If applicable)

[Same structure as Option A]

## 3. Trade-Off Analysis

| Criterion | Option A | Option B |
|-----------|----------|----------|
| Performance | [Rating] | [Rating] |
| Learning Curve | [Rating] | [Rating] |
| Community | [Rating] | [Rating] |
| Maintenance | [Rating] | [Rating] |

## 4. Recommended Approach

**Selected**: [Option X]

**Rationale**: [Why we chose this - citing maintenance, community adoption, technical fit]

### Implementation Guide

**Step 1**: [Setup/Installation]
\`\`\`bash
# Commands
\`\`\`

**Step 2**: [Core Implementation]
\`\`\`python
# Concrete code example showing the pattern
\`\`\`

**Step 3**: [Error Handling]
\`\`\`python
# How to handle exceptions and edge cases
\`\`\`

**Step 4**: [Testing]
\`\`\`python
# How to test this implementation
\`\`\`

## 5. Integration Considerations

- **Dependencies**: [What needs to be added to requirements/package.json]
- **Configuration**: [Any config files or environment variables]
- **Migration**: [If replacing existing code, how to migrate]
- **Testing**: [Testing strategy for this integration]

## 6. Open Questions

[Ask the user if critical decisions remain]

- [ ] Question 1?
- [ ] Question 2?

## References

- [Perplexity search/research URLs]
- [GitHub repository URLs]
- [Documentation links]
```

### Step 6: Save and Present

- Determine next sequence number by checking `thoughts/shared/research/`
- Save to `thoughts/shared/research/ext_NNN_topic.md`
- Present the summary highlighting:
  - Recommended solution
  - Key implementation steps
  - Any open questions requiring user input

## Best Practices

- **Be Specific**: Don't just say "use library X" - show concrete examples
- **Verify Currency**: Check that libraries are actively maintained (2026 or recent updates)
- **Consider Context**: Match recommendations to project tech stack and constraints
- **Show Trade-offs**: Help users make informed decisions
- **Cite Sources**: Always link to GitHub repos and documentation
- **Test Patterns**: If possible, verify patterns work in the target environment

## Integration with Orchestrator

This command can be:
- Run standalone when you need external research
- Invoked as Phase 1a in the orchestration workflow (conditionally)

When used in orchestration, the eng-researcher agent will indicate if external research is needed.

## Example Usage

### Standalone
```
/c4_research_external

Problem: Need to implement async file upload with progress tracking
Context: Codebase has no examples of this pattern
Constraints: Must work with Litestar framework, Python 3.12+
```

### In Orchestration
The orchestrator will automatically invoke this after Phase 1 if the codebase research indicates a gap.
