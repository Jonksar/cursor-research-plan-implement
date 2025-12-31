# p1_user_problem_research

You are tasked with conducting user problem research using the Jobs-to-be-Done (JTBD) framework to identify user needs, pain points, and gaps in the current product.

## Initial response

When this command is invoked, respond with:

```
I'm ready to research user problems using the JTBD framework. Please provide:

1. **Problem Area/Feature**: What part of the product are we analyzing?
2. **User Context**: Who is experiencing this problem? (role, scenario)
3. **Additional Context**: Any specific pain points, user feedback, or areas of concern?
4. **Supporting Materials**: Any user quotes, metrics, or feedback?

Once you provide this information, I'll:
- Apply the JTBD framework to identify the core job
- Break down functional, emotional, and social dimensions
- Identify pain points and desired outcomes
- Document the job statement and ideal solution
```

Then wait for the user's input.

## After receiving the user input

### Phase 1: Information Gathering (Request All Upfront)

Confirm the following before proceeding:
- Problem area/feature name
- User persona/role experiencing the problem
- Any supporting materials (user quotes, metrics, feedback)

### Phase 2: Research Execution

1. **JTBD Analysis**
   - Identify the user's core "job to be done"
   - Break down functional, emotional, and social dimensions
   - Articulate the job statement: "When [situation], I want to [job], so I can [outcome] without [pain point]"
   - Identify the current "hired solution" vs. desired solution
   - Ask "why" repeatedly to get to the core job

2. **Pain Point Identification**
   - List specific pain points with evidence
   - For each pain point, identify:
     - Description of the problem
     - Evidence (user quotes, feedback, observations)
     - Impact on user's job
     - Gap between current and desired state

3. **Desired Outcomes**
   - What would perfectly satisfy this job?
   - What are the success criteria?
   - What would eliminate the pain points?

4. **Critical Thinking Analysis**
   - **What's Missing**: Identify gaps in functionality or experience
   - **What's Broken**: Identify what exists but doesn't work well
   - **What's Confusing**: Identify unclear or complex areas
   - Apply critical thinking framework:
     - Challenge assumptions about the user's job
     - Question why current solutions exist
     - Compare with alternatives or competitors
     - Identify constraints preventing ideal solutions

### Phase 3: Document Structure

Create a research artifact with the following structure:

```markdown
---
date: [Current date and time in ISO format]
researcher: Product Research Agent
topic: "[Problem Area]: User Problem Analysis"
tags: [product-research, jtbd, user-problem, relevant-feature-names]
status: complete
---

# User Problem Research: [Problem Area]

## Problem Definition

### User Context
- **Persona/Role**: [Who is experiencing this problem]
- **Scenario**: [When/where does this problem occur]
- **Frequency**: [How often does this problem occur]

### Jobs-to-be-Done (JTBD) Analysis

**Main Job Statement:**
"When [situation], I want to [job], so I can [outcome] without [pain point]"

**Job Dimensions:**
- **Functional**: What the user is trying to accomplish (objective task)
- **Emotional**: How the user wants to feel during/after the job
- **Social**: How the user wants to be perceived by others

**Current "Hired Solution":**
[What workaround or solution users currently use]

**Desired "Ideal Solution":**
[What would perfectly satisfy this job]

### Problem Evidence

List of specific pain points with evidence:
- **[Pain Point 1]**: [Description]
  - *Evidence*: [User quote, feedback, or observation]
  - *Impact*: [Why this matters to the user]
  - *Gap*: [Difference between current and desired]

- **[Pain Point 2]**: [Description]
  - *Evidence*: [User quote, feedback, or observation]
  - *Impact*: [Why this matters to the user]
  - *Gap*: [Difference between current and desired]

[Continue for all identified pain points]

## Critical Analysis

### What's Missing
- [Gap 1]: [What's absent that should be present]
  - *Impact on Job*: [How this gap affects the user's job]
- [Gap 2]: [Another missing element]
  - *Impact on Job*: [How this gap affects the user's job]

### What's Broken
- [Issue 1]: [What exists but doesn't work well]
  - *Impact on Job*: [How this issue affects the user's job]
- [Issue 2]: [Another broken aspect]
  - *Impact on Job*: [How this issue affects the user's job]

### What's Confusing
- [Confusion 1]: [What's unclear to users]
  - *Impact on Job*: [How this confusion affects the user's job]
- [Confusion 2]: [Another confusion point]
  - *Impact on Job*: [How this confusion affects the user's job]

## Desired Solution Vision

### Ideal Experience
[Describe the ideal experience that would satisfy the job perfectly]

### Success Criteria
- [Criterion 1]: [How to measure if the job is done well]
- [Criterion 2]: [Another success measure]
- [Criterion 3]: [Another success measure]

### Expected Outcomes
- [Outcome 1]: [What would improve]
- [Outcome 2]: [Another expected improvement]

## Recommendations

### Priority 1: Critical Jobs Unmet
[List the most critical gaps in meeting user jobs]
- **Recommendation**: [What should be done]
- **Rationale**: [Why this is priority 1]
- **Impact**: [Expected improvement to user's job]

### Priority 2: High-Friction Areas
[List areas with significant user friction]
- **Recommendation**: [What should be done]
- **Rationale**: [Why this is priority 2]
- **Impact**: [Expected improvement to user's job]

### Priority 3: Quick Wins
[List improvements that would have high impact with lower effort]
- **Recommendation**: [What should be done]
- **Rationale**: [Why this is a quick win]
- **Impact**: [Expected improvement to user's job]

## Next Steps

### Suggested Follow-up
- [ ] Run `/p2_status_quo_analysis` to document how the current product handles (or fails to handle) this job
- [ ] Validate findings with user research/interviews
- [ ] Use JTBD + Status Quo to create implementation plan

## Open Questions
[Any areas needing further investigation or user validation]
```

### Phase 4: Save and Present

1. **Determine sequence number**
   - Check `thoughts/shared/user_problem/` for existing files
   - Use next available number (P001, P002, P003, etc.)

2. **Create user_problem folder if needed**
   - Create `thoughts/shared/user_problem/` if it doesn't exist

3. **Save artifact**
   - Save to `thoughts/shared/user_problem/PNNN_topic.md`
   - Use kebab-case for topic (e.g., `P001_xero-integration.md`)

4. **Present summary**
   - Show the JTBD statement
   - Highlight top 3 pain points
   - Show prioritized recommendations
   - Provide path to full artifact
   - Suggest running `/p2_status_quo_analysis` for detailed current state documentation

## Research Guidelines

### JTBD Best Practices
- Focus on the underlying job, not the solution
- Job statements should be solution-agnostic
- Look for functional, emotional, and social dimensions
- Ask "why" repeatedly to get to the core job
- Distinguish between the job and the solution

### Evidence Collection Best Practices
- Collect user quotes, feedback, and observations
- Focus on understanding the job, not jumping to solutions
- Look for patterns in user behavior and workarounds
- Distinguish between stated needs and actual jobs

### Critical Thinking Framework
- **Challenge assumptions**: Is this really the user's job, or our assumption?
- **Question status quo**: Why does it work this way? Is it necessary?
- **Compare alternatives**: How do competitors solve this job?
- **Identify constraints**: What prevents the ideal solution?
- **Think holistically**: How does this job relate to other user jobs?

## Notes

- **Pure JTBD focus**: This command focuses solely on understanding the user's job - no codebase or browser research
- **Evidence-based**: Every claim should reference specific evidence (user quote, feedback, observation)
- **Solution-agnostic**: Focus on the job, not how to solve it
- **Outcome-focused**: Always tie problems back to the user's job and desired outcomes
- **Complement with p2**: Use `/p2_status_quo_analysis` to see how the current product handles (or fails to handle) this job
