# c_orchestrate

Orchestrates engineering workflow by delegating to sub-agents via `user-sub-agents` MCP. Always spawn subagents instead of doing the work in the orchestrator agent.

## Workflow Phases

| # | Phase | Agent | Output |
|---|-------|-------|--------|
| 1 | Research | `eng-researcher` | `code_research/CRNNN_*.md` |
| 1a* | External Research | `eng-external-researcher` | `research/ext_NNN_*.md` |
| 2 | Plan | `eng-planner` | `code_plans/CPNNN_*.md` |
| 4 | Implementation | `eng-implementer` | Code changes |
| 5 | Validation | `eng-validator` | `code_validate/CVNNN_*.md` |
| 6a | Architecture Review | `c6a_architecture_review` | `code_review/ARNNN_*.md` |
| 6b | Simplification Review | `c6b_simplification_opportunities` | `code_review/SONNN_*.md` |
| 7 | Quality Checks | `c7_quality_checks` & `eng-guidelines-checker` | Report artifacts |

*All artifacts in `thoughts/shared/`. Phase 1a can run parallel with Phase 1. Phase 7 runs parallel checks.

## Initial Response

```
Ready to orchestrate workflow.

Provide: 1) Task description, 2) Context/constraints, 3) Scope
```

## Execution

### Step 0: Check MCP Availability
- Call `ListMcpResources` for `user-sub-agents`
- If unavailable: warn user and stop immediately

### Step 1: Invoke Agents
Use `CallMcpTool` with:
- `server`: "user-sub-agents"  
- `toolName`: "run_agent"
- `arguments`: `{"agent": "eng-researcher", "prompt": "...", "cwd": "/absolute/path"}`

**Never pass `session_id`** - agents read prior artifacts for context.

### Step 2: Adaptive Execution Flow

**Split Research Execution (Avoid Timeouts)**
To prevent 10-minute timeouts, break research into chunks:

**Phase 1: Codebase Research (Split)**
1. **Scout**: Invoke `eng-researcher` to "Identify relevant files and high-level architecture only. Do not perform deep analysis yet. Output to `thoughts/shared/code_research/scratch_CRNNN_scout.md`."
2. **Analyze**: Invoke `eng-researcher` to "Read `thoughts/shared/code_research/scratch_CRNNN_scout.md`. Perform deep analysis and write final report to `thoughts/shared/code_research/CRNNN_topic.md`."

**Phase 1a: External Research (Split)**
If task mentions external libraries/services, run in parallel with Phase 1.
1. **Broad Scan**: Invoke `eng-external-researcher` to "Phase 1: Broad Research only. Use Perplexity to identify approaches. Output to `thoughts/shared/research/scratch_ext_NNN_broad.md`."
2. **Deep Dive**: Invoke `eng-external-researcher` to "Phase 2 & 3: Deep Dive & Synthesis. Read `thoughts/shared/research/scratch_ext_NNN_broad.md`. Use GitHub Search. Create final artifact `thoughts/shared/research/ext_NNN_topic.md`."

**Parallel Quality Review (Phase 6a & 6b)**
- After validation passes (Phase 5), invoke both c6a_architecture_review and c6b_simplification_opportunities in parallel
- Phase 6a: Clean architecture compliance (blocking if critical violations)
- Phase 6b: Simplification research via external examples (may suggest re-planning)

**Final Quality Checks (Phase 7)**
- Run in parallel after Phase 6a/6b pass:
  1. **Static Analysis**: Invoke `c7_quality_checks` (runs pre-commit, linters).
  2. **Guidelines Check**: Invoke `c7b_guidelines_check` (checks against project guidelines).
- Blocking: If either fails, issues must be resolved before completion.

**Validation Loop-Back (5 → 2 → 4 → 5)**
- Read Phase 5 artifact for ✗/⚠️ statuses or failed checks
- If incomplete: re-invoke planner → implementer → validator
- Repeat until complete

**Quality Review Loop (6a/6b → 2 → 4 → 5 → 6a/6b)**
- If Phase 6a finds critical architectural issues: must fix → re-run implementation + validation + review
- If Phase 6b finds high-impact simplifications: consider re-plan → implement → validate → review

**Phased Implementation (Phase 4)**
- Read plan artifact after Phase 2
- Detect phase markers: "## Phase 1:", "## Phase A:", etc.
- If multiple phases: spawn separate `eng-implementer` per phase sequentially
- Pass: "Implement Phase X: [description]. Plan: [path]"

### Step 3: Error Handling
**Failure:** Present options (Retry/Skip/Abort), wait for user
**Incomplete validation:** Auto loop-back to Phase 2,4,5
**Quality gate fail:** Stop, require user decision

### Step 4: Progress Tracking
```
✓ Phase [N]: [Agent] - Completed
  → Output: [path]
  → Next: [action]
```

### Step 5: Final Summary
```
🎉 Complete!
Artifacts: [paths]
Files: [count], Tests: [status], Quality: [result]
Next: [user action]
```

## Key Patterns

**Adaptive Flow:** Loop-backs for incomplete work, conditional branches, parallel when possible

**Chunked Execution:** Research phases are split (Scout → Analyze, Broad → Deep) to avoid timeouts.

**Phased Implementation:** Detect multiple phases in plan, spawn separate implementer per phase (Phase A → wait → Phase B → wait)

**Context:** Stateless agents read artifacts, pass explicit paths in prompts

**Error Recovery:** Validate before proceeding, offer retry/skip/abort, never silently continue

## Implementation Logic

**Research Execution Logic:**
```
invoke eng-researcher (Scout) -> scratch_scout.md
invoke eng-researcher (Analyze) -> CRNNN_topic.md

if external needed:
  invoke eng-external-researcher (Broad) -> scratch_broad.md
  invoke eng-external-researcher (Deep) -> ext_NNN_topic.md
```

**Phased Implementation Detection:**
```
after Phase 2:
  read plan artifact
  if contains "## Phase 1:", "## Phase A:", etc.:
    for each phase:
      invoke eng-implementer with "Implement Phase X: [desc]"
      wait for completion
  else:
    invoke eng-implementer once
```

**Loop-Back Triggers:**
- Phase 5 → 2,4,5: Incomplete/failed validation
- Phase 6a → 4,5,6a,6b: Critical architectural issues (required)
- Phase 6b → 2,4,5,6a,6b: High-impact simplifications (optional, user decides)
- Phase 7 → 4,5,6,7: Failed static checks or guideline violations

**Stop Conditions:** MCP unavailable, agent failure without retry, user abort, unresolved critical issues

## Examples

**Chunked Research:**
Task: "Add Stripe payment integration"
1. `eng-researcher` (Scout): Finds payment controllers.
2. `eng-researcher` (Analyze): Details data flow.
3. `eng-external-researcher` (Broad): Perplexity finds Stripe Python patterns.
4. `eng-external-researcher` (Deep): GitHub Search finds `stripe-python` usage examples.

**Phased Implementation:**
Plan has "## Phase 1: Database", "## Phase 2: API", "## Phase 3: Frontend"
→ Spawn 3 implementers sequentially, one per phase

**Validation Loop:**
Phase 5 shows Phase 2 incomplete, Phase 3 not implemented
→ Auto re-run: planner → implementer → validator

## Critical Rules
- Stop immediately if MCP unavailable or any issue arises with the agents
- Never pass session_id between agents, all agents should have clean scope
- Read artifacts before deciding next action
- Wait for completion (except parallel Phase 1 & 1a)
- ALWAYS split research into Scout/Analyze and Broad/Deep steps
- Spawn separate implementers for multi-phase plans
- Loop until validation passes
- Quality gate can fail workflow

## Resuming
Check `thoughts/shared/` for completed artifacts, resume from first missing phase. Create `sessions/SS[NNN]_*.md` if interrupted.
