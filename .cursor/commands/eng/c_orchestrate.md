# c_orchestrate

Orchestrates engineering workflow by delegating to sub-agents via `user-sub-agents` MCP. Always spawn subagents instead of doing the work in the orchestrator agent.

## Workflow Phases

| # | Phase | Agent | Output |
|---|-------|-------|--------|
| 1 | Research | `eng-researcher` | `code_research/CRNNN_*.md` |
| 1a* | External Research | `eng-external-researcher` | `research/ext_NNN_*.md` |
| 2 | Plan | `eng-planner` | `code_plans/CPNNN_*.md` |
| 3 | Test Planning | `eng-test-planner` | `test_plans/TPNNN_*.md` |
| 4 | Implementation | `eng-implementer` | Code changes |
| 5 | Validation | `eng-validator` | `code_validate/CVNNN_*.md` |
| 6 | Quality Review | `eng-quality-reviewer` | `code_review/QRNNN_*.md` |

*All artifacts in `thoughts/shared/`. Phase 1a can run parallel with Phase 1 or conditionally after.

## Initial Response

```
Ready to orchestrate workflow.

Provide: 1) Task description, 2) Context/constraints, 3) Scope
```

## Execution

### Step 0: Check MCP Availability
- Call `ListMcpResources` for `user-sub-agents`
- If unavailable: warn and stop

### Step 1: Invoke Agents
Use `CallMcpTool` with:
- `server`: "user-sub-agents"  
- `toolName`: "run_agent"
- `arguments`: `{"agent": "eng-researcher", "prompt": "...", "cwd": "/absolute/path"}`

**Never pass `session_id`** - agents read prior artifacts for context.

### Step 2: Adaptive Execution Flow

**Parallel Research (Phase 1 & 1a)**
- If task mentions external libraries/services (OAuth, Stripe, WebSockets) → invoke both agents in parallel
- Otherwise: run Phase 1, read artifact for "Recommended external research", conditionally run Phase 1a

**Validation Loop-Back (5 → 2 → 4 → 5)**
- Read Phase 5 artifact for ✗/⚠️ statuses or failed checks
- If incomplete: re-invoke planner → implementer → validator
- Repeat until complete

**Quality Review Loop (6 → 4 → 5 → 6)**
- If Phase 6 finds critical issues: offer fix → re-run implementation + validation + review

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

**Parallel Research:** Run Phase 1 & 1a together if external needs clear upfront (check for library/framework mentions)

**Phased Implementation:** Detect multiple phases in plan, spawn separate implementer per phase (Phase A → wait → Phase B → wait)

**Context:** Stateless agents read artifacts, pass explicit paths in prompts

**Error Recovery:** Validate before proceeding, offer retry/skip/abort, never silently continue

## Implementation Logic

**Parallel Research Detection:**
```
if task mentions libraries/frameworks/external services:
  invoke eng-researcher AND eng-external-researcher in parallel
else:
  invoke eng-researcher
  if artifact says "Recommended external research":
    invoke eng-external-researcher
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
- Phase 1 → 1a: Missing patterns (conditional mode)
- Phase 5 → 2,4,5: Incomplete/failed validation
- Phase 6 → 4,5,6: Critical quality issues

**Stop Conditions:** MCP unavailable, agent failure without retry, user abort, unresolved critical issues

## Examples

**Parallel Research:**
Task: "Add Stripe payment integration"
→ Mentions external service → run Phase 1 & 1a in parallel

**Phased Implementation:**
Plan has "## Phase 1: Database", "## Phase 2: API", "## Phase 3: Frontend"
→ Spawn 3 implementers sequentially, one per phase

**Validation Loop:**
Phase 5 shows Phase 2 incomplete, Phase 3 not implemented
→ Auto re-run: planner → implementer → validator

## Critical Rules
- Stop if MCP unavailable
- Never pass session_id
- Read artifacts before deciding next action
- Wait for completion (except parallel Phase 1 & 1a)
- Parallel research when possible
- Spawn separate implementers for multi-phase plans
- Loop until validation passes
- Quality gate can fail workflow

## Resuming
Check `thoughts/shared/` for completed artifacts, resume from first missing phase. Create `sessions/SS[NNN]_*.md` if interrupted.
