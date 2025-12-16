# 1_research_codebase

You are tasked with conducting comprehensive research across the codebase to answer the user’s question and to produce a durable research artifact.

## Initial response

When this command is invoked, respond with:

```
I'm ready to research the codebase. Please provide your research question or area of interest, and I'll analyze it thoroughly by exploring relevant components and connections.
```

Then wait for the user’s research query.

## After receiving the research query

1. Read any directly mentioned files first
   - If the user mentions specific files, open and read them fully first.

2. Decompose the question
   - Break the query into 2–6 sub-areas (components, flows, data models, boundaries).
   - Track subtasks with Cursor Tasks / a todo list.

3. Research efficiently using Cursor features
   - Use codebase search to locate relevant symbols, call sites, and configs.
   - Open the key files and trace the data flow end-to-end.
   - When helpful, queue focused follow-up searches (you can do them in parallel by running multiple searches before deep-reading).

4. Synthesize findings (with precise references)
   - Include concrete file paths and line ranges.
   - Call out patterns, invariants, and cross-component connections.

5. Write a research document

Use this structure (YAML frontmatter + content):

```markdown
---
date: [Current date and time in ISO format]
researcher: Cursor Agent
topic: "[User's Question/Topic]"
tags: [research, codebase, relevant-component-names]
status: complete
---

# Research: [User's Question/Topic]

## Research Question
[Original user query]

## Summary
[High-level findings answering the user's question]

## Detailed Findings

### [Component/Area 1]
- Finding with reference (path/to/file.ext:line-range)
- Connection to other components
- Implementation details

### [Component/Area 2]
...

## Code References
- `path/to/file.py:123-150` - What’s here
- `another/file.ts:45-67` - What’s here

## Architecture Insights
[Patterns, conventions, and design decisions]

## Open Questions
[Any areas needing further investigation]
```

6. Save and present
   - Determine the next 3-digit sequence number by checking existing files.
   - Save to `thoughts/shared/research/NNN_topic.md`.
   - Present a concise summary and the top file references.

## Notes
- Prefer concrete evidence over assumptions.
- If the codebase is large, start broad, then narrow to the authoritative entry points and core flows.
