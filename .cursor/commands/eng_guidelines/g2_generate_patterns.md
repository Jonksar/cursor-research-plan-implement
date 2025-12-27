# g2_generate_patterns

You are tasked with generating a **reusable matcher library** for validating guideline fixes. The matchers are derived from:
- Generic guideline text in `thoughts/shared/guidelines/*.md`
- The most recent guideline-fix plan in `thoughts/shared/guideline_plans/` (if present), especially its violations appendix
- The current codebase state (optional hit counts)

This command writes/overwrites: `thoughts/shared/guideline_patterns/GPATNNN_fix_patterns.yaml`

## Process

1. Identify inputs
   - Read guideline files (generic guidance).
   - Find the most recent `thoughts/shared/guideline_plans/*guideline_fixes*.md` (or ask user for the plan path).
   - Extract the plan’s `## Appendix: Violations (structured)` YAML block (if present).
     - If missing, ask the user to re-run `/g1_plan_fixes` with the appendix enabled.

2. Generate matchers
   - For each violation cluster (same domain/section/pattern), create a matcher entry with:
     - `id` (stable slug, derived from domain+pattern)
     - `domain`
     - `file_globs` (inferred from affected files)
     - `rg` (ripgrep regex pattern)
     - `confidence` (high/medium/low)
     - `notes` (how to interpret hits; common false positives)
   - If there is a safe mechanical fix, include it as `suggested_fix` metadata (do not apply fixes in this command).

3. (Optional) Compute current hit counts
   - Run `grep` searches per matcher and record `hit_count` and a few example locations.

4. Write `fix_patterns.yaml`
   - Determine next sequence number (GPAT001...).
   - Save to `thoughts/shared/guideline_patterns/GPATNNN_fix_patterns.yaml`.

## Output format (fix_patterns.yaml)

```yaml
version: 1
generated_at: "<ISO-8601>"
inputs:
  guidelines_dir: "thoughts/shared/guidelines"
  plan_path: "<path or null>"
matchers:
  - id: "python_http_requests_missing_timeout"
    domain: "api-client"
    file_globs: ["**/*.py"]
    rg: "requests\\.(get|post)\\("
    confidence: "high"
    notes: "Hits indicate missing timeout=... on requests calls."
    suggested_fix:
      kind: "none"
    observed:
      hit_count: 0
      examples: []
```

## Notes
- Keep matchers stable: avoid embedding repo-specific absolute paths.
- Prefer fewer, higher-quality matchers over broad ones that create noise.

