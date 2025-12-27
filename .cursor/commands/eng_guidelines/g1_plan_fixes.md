# g1_plan_fixes

You are tasked with generating a **/c1_code_plan-style implementation plan** to fix violations against the guideline files in `thoughts/shared/guidelines/`.

This command produces a **plan file** in: `thoughts/shared/guideline_plans/GPNNN_guideline_fixes.md`

## Process

1. Load guidelines
   - If `thoughts/shared/guidelines/` is empty, ask the user to run `/g0_research_guidelines` first.
   - Read all `*.md` guideline files (generic guidance).
   - Process guidelines **one file at a time** for sub-agent calls to keep context tight and outputs attributable.

2. Audit the codebase for violations
   - Use `sub-agents-mcp` to speed up and reduce noise:
     - Run these agents **per guideline file** (single guideline at a time), then merge results:
       - **guideline-violation-auditor**: primary pass to translate that guideline’s sections into concrete searches and produce a structured violations list.
       - **codebase-locator**: find the relevant directories/files for that guideline’s domain (tightens search scope and globs).
       - **codebase-pattern-finder**: locate in-repo “good examples” related to that guideline to contrast against violations.
       - **codebase-analyzer**: for ambiguous findings from that guideline, confirm whether a match is truly a violation in context.
     - If `sub-agents-mcp` is not available in this environment:
       - STOP and ask for confirmation to proceed without it.
       - Prompt: `sub-agents-mcp is unavailable. Reply CONTINUE to proceed without it (using only codebase_search/grep/file reads), or anything else to abort.`
   - Derive candidate violation queries from the guideline text:
     - Use `codebase_search` to locate likely hotspots by meaning.
     - Use `grep` for concrete anti-patterns when the guideline implies a textual signature.
   - Record each hit with: `guideline_domain`, `guideline_section`, `file`, `line`, and a short excerpt.
   - Prefer high-confidence, low-noise findings; explicitly label uncertain findings.

3. Convert violations into a plan (match `/c1_code_plan` structure)
   - Group violations into 2–6 phases by domain or by “mechanical vs refactor”.
   - For each phase, list:
     - Files to change
     - The rule(s) being addressed
     - The intended fix approach
   - Define clear success criteria:
     - Automated: tests/lint/typecheck/build commands (discover from repo; if unknown, propose likely ones and flag assumptions)
     - Manual: spot-check steps

4. Write the plan file
   - Determine next `GPNNN_` by inspecting `thoughts/shared/guideline_plans/`.
   - Save as `thoughts/shared/guideline_plans/GPNNN_guideline_fixes.md`.
   - Print a short summary plus the plan path.

5. Include a structured appendix for `/g2`
   - Append an `## Appendix: Violations (structured)` section containing a fenced YAML block:
     - `violations[]` entries with domain/section/file/line/excerpt/confidence/suggested_fix_notes
   - `/g2_generate_patterns` will use this appendix to derive automatic matchers.

## Output format (plan file)

The plan MUST use the same structure as `.cursor/commands/c1_code_plan.md`, including:
- Overview
- Current State Analysis
- Desired End State
- What We’re NOT Doing
- Implementation Approach
- Phase 1..N with Changes Required (file paths) and Success Criteria
- Testing Strategy

## Notes
- Prefer high-confidence, low-risk changes first.
- If guideline rules conflict with existing repo conventions, call it out explicitly and propose the smallest adjustment.

