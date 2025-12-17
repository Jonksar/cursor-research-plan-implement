# g0_research_guidelines

You are tasked with generating **domain-specific engineering guidelines** for the current repository, using **Perplexity search** and **GitHub code search** for evidence-based best practices.

Guidelines MUST be written (overwritten) to: `thoughts/shared/guidelines/GRNNN_<domain_slug>.md`

## Process

1. Discover domains (confirm-first)
   - Inspect the repo to infer likely domains (languages, frameworks, notable libs, architectural patterns).
   - Use fast signals first (file tree, config files, import usage, directory clusters).
   - Present the proposed domain list to the user for confirmation/editing **before writing any files**.

2. For each confirmed domain, gather evidence
   - Use Perplexity search for current best practices and pitfalls.
   - Use GitHub code search to find real-world idioms and patterns (prefer mature repos; capture a handful of canonical snippets/approaches).
   - Cross-check against this repo’s existing conventions (use `codebase_search` / `grep`).

3. Write guideline files
   - Ensure `thoughts/shared/guidelines/` exists.
   - Determine sequence number (GR001...) for tracking, but use slug in filename for readability if preferred, or keep structure `GRNNN_slug.md`.
   - Write/overwrite one file per domain: `thoughts/shared/guidelines/GRNNN_<domain_slug>.md`.

## Output requirements

### Domain confirmation prompt (before writing)

Provide a proposed list like:

```
Proposed domains (edit/confirm):
1) <domain_slug> — <display name> — <why this domain applies>
2) ...
Reply with: keep all / remove X / add Y / rename slug A->B
```

### Guideline file structure

Each guideline file MUST follow:

```markdown
---
date: <ISO-8601>
domain: <domain_slug>
title: <human title>
status: draft
sources:
  - type: perplexity
    query: "<query>"
    notes: "<1–2 lines>"
  - type: github
    query: "<literal code query>"
    notes: "<1–2 lines>"
---

## Scope
<what code/files this guideline applies to>

## Principles
- ...

## Do / Don’t
### Do
- ...
### Don’t
- ...

## Notes
- Avoid repo-specific descriptions.
- Keep guidelines **generic** and broadly applicable; don’t tailor rules to this repo.
- If you mention checks, keep them illustrative (examples), not required for automation.
- `/g2_generate_patterns` is responsible for deriving automatic matchers.
```

