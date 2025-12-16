# 10_plan_guideline_fixes

You are tasked with generating a **/2_create_plan-style implementation plan** to fix violations against the guideline files in `thoughts/shared/guidelines/`.

This command produces a **plan file** in: `thoughts/shared/plans/NNN_guideline_fixes.md`

## Process

1. Load guidelines
   - If `thoughts/shared/guidelines/` is empty, ask the user to run `/9_generate_guidelines` first.
   - Read all `*.md` guideline files (generic guidance).

2. Audit the codebase for violations
   - Derive candidate violation queries from the guideline text:
     - Use `codebase_search` to locate likely hotspots by meaning.
     - Use `grep` for concrete anti-patterns when the guideline implies a textual signature.
   - Record each hit with: `guideline_domain`, `guideline_section`, `file`, `line`, and a short excerpt.
   - Prefer high-confidence, low-noise findings; explicitly label uncertain findings.

3. Convert violations into a plan (match `/2_create_plan` structure)
   - Group violations into 2–6 phases by domain or by “mechanical vs refactor”.
   - For each phase, list:
     - Files to change
     - The rule(s) being addressed
     - The intended fix approach
   - Define clear success criteria:
     - Automated: tests/lint/typecheck/build commands (discover from repo; if unknown, propose likely ones and flag assumptions)
     - Manual: spot-check steps

4. Write the plan file
   - Determine next `NNN_` by inspecting `thoughts/shared/plans/`.
   - Save as `thoughts/shared/plans/NNN_guideline_fixes.md`.
   - Print a short summary plus the plan path.

5. Include a structured appendix for `/11`
   - Append an `## Appendix: Violations (structured)` section containing a fenced YAML block:
     - `violations[]` entries with domain/section/file/line/excerpt/confidence/suggested_fix_notes
   - `/11_generate_fix_patterns` will use this appendix to derive automatic matchers.

## Output format (plan file)

The plan MUST use the same structure as `.cursor/commands/2_create_plan.md`, including:
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


