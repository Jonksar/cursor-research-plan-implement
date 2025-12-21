# c4_research_external

You are tasked with researching external solutions, libraries, and patterns to ensure robust, standard-compliant implementation.

## Initial response

When this command is invoked, respond with:

```
I'm ready to research external solutions. Please provide the problem, library, or pattern you want to investigate.
```

Then wait for the user’s query.

## After receiving the query

1. **Decompose the Request**
   - Identify the **Problem Domain**: (e.g., "Async file processing", "PDF parsing").
   - Identify the **Specific Target** (if known): (e.g., `pytesseract`, `boto3`).

2. **Phase 1: Broad Research (Perplexity)**
   - **Trigger**: If the task is novel, high-level, or lacks a specific library target.
   - **Action**: Use `mcp_perplexity_perplexity_research` to find a guide on "how to solve [problem type]".
   - **Goal**: Identify standard approaches, trade-offs, and candidate libraries.
   - **Criteria**: Prioritize libraries with high GitHub star counts, recent maintenance, and active community support.

3. **Phase 2: Deep Dive (Sub-Agents)**
   - **Trigger**: Once a specific library or pattern is identified (from Phase 1 or user input).
   - **Action**: Use the specialized sub-agents to find concrete implementation details.

   **A. Definition Scout**
   - **Goal**: Confirm definitions and available exceptions.
   - **Action**: `mcp_grep_searchGitHub` using definition strategies:
     - Exceptions: `raise .*Error` or `class .*Error`
     - Classes: `class <Name>:`
     - Functions: `def <name>\(`
     - Types: `type <Name> =`

   **B. Usage Miner**
   - **Goal**: See real-world usage.
   - **Action**: `mcp_grep_searchGitHub` for `(?s)try:.*?target.*?except`.
   - **Filter**: Focus on results from reputable repositories (high stars, known orgs).

   **C. Idiom Validator**
   - **Goal**: Verify best practices.
   - **Action**: Search for standard patterns (e.g., config, encoding).

4. **Phase 3: Synthesis & Recommendation**
   - Consolidate results from Perplexity (High-level guide) and GitHub (Low-level examples).
   - Compare multiple options if applicable.
   - Create a recommended approach with **example pseudocode** (or actual code).

5. **Write Research Artifact**

Use this structure:

```markdown
---
date: [Current Date]
researcher: Cursor Agent (External Researcher)
topic: "[Problem/Library Name]"
tags: [research, external, patterns]
status: complete
---

# External Research: [Topic]

## 1. High-Level Guide (Perplexity)
[Summary of the standard approach to this problem]

## 2. Technical Deep Dive (GitHub)
### Option A: [Library/Pattern 1]
- **Definition**: [Exceptions, Signature]
- **Usage**: [Common patterns found]
- **Pros/Cons**: [Based on findings]

### Option B: [Library/Pattern 2] (If applicable)
...

## 3. Recommended Approach
[Why we chose this path - citing maintenance, community adoption, and technical fit]

### Example Implementation
```python
# Concrete code example
```

## 4. Open Questions
[Ask the user if critical decisions remain]

## References
- [Link 1]
```

6. **Save and Present**
   - Save to `thoughts/shared/research/ext_NNN_topic.md`.
   - Present the summary and next steps to the user.

