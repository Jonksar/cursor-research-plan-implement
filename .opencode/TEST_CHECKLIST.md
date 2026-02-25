# OpenCode Migration Test Checklist

This checklist helps you validate that the migration from Cursor to OpenCode was successful.

## Prerequisites

- [ ] OpenCode installed (`opencode --version`)
- [ ] Environment variable `PERPLEXITY_API_KEY` set
- [ ] `.opencode/opencode.json` exists and validates
- [ ] All 17 agents in `.opencode/agent/` directory
- [ ] All 17 commands in `.opencode/command/` directory

## Configuration Validation

### JSON Schema Validation

```bash
# Validate JSON syntax
jq . .opencode/opencode.json

# Check for required fields
jq '.mcp | keys' .opencode/opencode.json
# Expected: ["gh_grep", "perplexity_mcp", "subagents"]
```

- [ ] `opencode.json` is valid JSON
- [ ] All three MCP servers configured (subagents, perplexity_mcp, gh_grep)
- [ ] Environment variables properly referenced

### Agent File Validation

```bash
# Count agents
ls .opencode/agent/*.md | wc -l
# Expected: 17

# Check frontmatter in a sample agent
head -20 .opencode/agent/eng-planner.md
```

- [ ] All 17 agent files exist
- [ ] Sample agent has valid YAML frontmatter
- [ ] Frontmatter includes: model, mode, description, temperature, permission

### Command File Validation

```bash
# Count commands  
ls .opencode/command/*.md | wc -l
# Expected: 17

# Check frontmatter in a sample command
head -10 .opencode/command/eng-plan.md
```

- [ ] All 17 command files exist
- [ ] Sample command has valid YAML frontmatter
- [ ] Frontmatter includes: description, agent, model

## MCP Server Connectivity

### Test MCP Availability

Launch OpenCode and check MCP server status:

- [ ] subagents MCP server connects
- [ ] perplexity_mcp MCP server connects  
- [ ] gh_grep MCP server connects

### Test Sub-Agents MCP

Try spawning a simple agent:

```
# In OpenCode
Test spawning codebase-locator agent
```

- [ ] Agent spawns successfully
- [ ] Agent can read files
- [ ] Agent produces output

## Basic Command Tests

### Test Simple Commands

#### Test `/eng-plan`

```
/eng-plan
# Provide a simple task like "Add a new utility function"
```

**Expected**:
- Command prompts for input
- Creates todo list for planning
- Produces plan artifact in `thoughts/shared/code_plans/`

- [ ] Command invokes successfully
- [ ] Prompts for task description
- [ ] Generates plan artifact

#### Test `/eng-research`

```
/eng-research
# Ask about a specific feature in the codebase
```

**Expected**:
- Command prompts for research question
- Searches codebase
- Produces research artifact in `thoughts/shared/code_research/`

- [ ] Command invokes successfully
- [ ] Prompts for research question
- [ ] Generates research artifact

## Orchestrated Workflow Test

### Full Workflow Test

```
/eng-orchestrate
# Provide a small feature request
```

**Expected Flow**:
1. Prompts for task description
2. Spawns `eng-researcher` (scout phase)
3. Spawns `eng-researcher` (analyze phase)
4. Spawns `eng-planner`
5. Spawns `eng-implementer`
6. Spawns `eng-validator`
7. Optionally: Quality review phases

**Validation**:
- [ ] Orchestrator spawns subagents successfully
- [ ] Research artifact created (CR001...)
- [ ] Plan artifact created (CP001...)
- [ ] Implementation completes
- [ ] Validation artifact created (CV001...)

## Agent Mode Verification

### Primary Agents (Direct Invocation)

Test invoking primary agents directly:

- [ ] `codebase-analyzer` can be invoked directly
- [ ] `codebase-locator` can be invoked directly
- [ ] `codebase-pattern-finder` can be invoked directly
- [ ] `codebase-researcher` can be invoked directly
- [ ] `search-definition-scout` can be invoked directly

### Subagents (Spawned by Orchestrator)

Verify subagents are spawned correctly:

- [ ] `eng-planner` spawned by orchestrator
- [ ] `eng-implementer` spawned by orchestrator
- [ ] `eng-validator` spawned by orchestrator
- [ ] `eng-external-researcher` spawned when needed

## MCP Tool Tests

### Test Perplexity MCP

```
# In a command or agent that uses Perplexity
Test external research with Perplexity queries
```

- [ ] Perplexity search works
- [ ] Results are returned
- [ ] No authentication errors

### Test GitHub Search MCP

```
# In a command that uses GitHub search
Test GitHub code search for patterns
```

- [ ] GitHub search works
- [ ] Code examples returned
- [ ] No rate limiting errors

## Integration Tests

### Test Research → Plan → Implement Flow

1. Run codebase research
2. Create implementation plan
3. Implement the plan
4. Validate implementation

**Check**:
- [ ] Artifacts flow correctly between phases
- [ ] Agents can read prior artifacts
- [ ] No broken references

### Test Validation Loop

1. Create a plan with intentional gap
2. Implement partial solution
3. Run validation
4. Check if validator catches the gap

**Check**:
- [ ] Validator identifies missing implementation
- [ ] Validator produces detailed report
- [ ] Recommendations are actionable

## Quality Review Tests

### Architecture Review

```
/eng-architecture-review
# Point to recently implemented code
```

**Check**:
- [ ] Reviews code for clean architecture
- [ ] Identifies layer violations
- [ ] Produces detailed report with examples

### Simplification Review

```
/eng-simplification-review
# Point to recently implemented code
```

**Check**:
- [ ] Spawns external researcher
- [ ] Finds simpler patterns
- [ ] Produces recommendations with trade-offs

## Edge Cases & Error Handling

### MCP Unavailable

Test behavior when MCP server is down:

- [ ] Graceful fallback or error message
- [ ] No silent failures
- [ ] User is informed of issue

### Invalid Input

Test with invalid or missing inputs:

- [ ] Commands prompt for missing information
- [ ] Validation catches invalid paths
- [ ] Error messages are helpful

### Timeout Handling

Test with long-running operations:

- [ ] Research phases split correctly
- [ ] No 10-minute timeouts
- [ ] Progress is reported

## Artifact Generation

### Check Artifact Paths

Verify artifacts are created in correct locations:

- [ ] `thoughts/shared/code_research/CRNNN_*.md`
- [ ] `thoughts/shared/code_plans/CPNNN_*.md`
- [ ] `thoughts/shared/code_validate/CVNNN_*.md`
- [ ] `thoughts/shared/research/ext_NNN_*.md`
- [ ] `thoughts/shared/code_review/ARNNN_*.md`
- [ ] `thoughts/shared/code_review/SONNN_*.md`

### Check Artifact Format

- [ ] Artifacts have YAML frontmatter
- [ ] Frontmatter includes date, status, tags
- [ ] Content follows expected structure
- [ ] File names use proper sequence numbers

## Performance Tests

### Agent Spawn Time

- [ ] Agents spawn within reasonable time (<10s)
- [ ] No excessive delays
- [ ] Progress is visible

### Research Phase Performance

- [ ] Scout/Analyze split prevents timeouts
- [ ] Broad/Deep split for external research works
- [ ] Parallel research phases complete

## Comparison with Cursor

### Command Equivalence

For each migrated command, verify equivalent functionality:

- [ ] `/eng-plan` behaves like `/c1_plan`
- [ ] `/eng-implement` behaves like `/c2_code_implement`
- [ ] `/eng-orchestrate` behaves like `/c_orchestrate`
- [ ] All 17 commands have equivalent behavior

### Agent Equivalence

- [ ] Agent instructions are preserved
- [ ] Workflow logic unchanged
- [ ] Agent outputs are equivalent

## Documentation Review

- [ ] [MIGRATION.md](MIGRATION.md) is accurate
- [ ] Command mapping table is complete
- [ ] Environment setup instructions work
- [ ] Known issues are documented

## Final Validation

### Smoke Test

Run a complete workflow end-to-end:

1. **Research** existing feature
2. **Plan** small improvement
3. **Implement** the improvement
4. **Validate** implementation
5. **Review** for quality

**Success Criteria**:
- [ ] All phases complete successfully
- [ ] Artifacts generated correctly
- [ ] Code changes are applied
- [ ] Quality checks pass

### User Acceptance

- [ ] Commands are discoverable
- [ ] Command names are intuitive
- [ ] Agent behavior is predictable
- [ ] Error messages are helpful
- [ ] Documentation is sufficient

## Known Issues Encountered

Document any issues found during testing:

1. Issue: _______________
   - Severity: [Critical/High/Medium/Low]
   - Workaround: _______________

2. Issue: _______________
   - Severity: [Critical/High/Medium/Low]
   - Workaround: _______________

## Sign-off

- [ ] All critical tests pass
- [ ] All high-priority tests pass
- [ ] Known issues documented
- [ ] Migration is ready for use

**Tested by**: _______________
**Date**: _______________
**OpenCode Version**: _______________
**Status**: [PASS/FAIL/NEEDS WORK]
