# Smoke Test Results - Subagent Tool Access

**Date**: January 22, 2026  
**Test Goal**: Verify all subagents can access their required tools

## Test Summary

| Agent | Required Tools | Result | Notes |
|-------|---------------|--------|-------|
| `eng-researcher` | glob, grep, read | ✅ PASSED | All file tools accessible |
| `eng-external-researcher` | gh_grep, webfetch | ✅ PASSED | Works with available tools |
| `eng-external-researcher` | perplexity_mcp_* | ❌ FAILED | MCP tools not inherited by subagents |
| `eng-planner` | glob, read, write | ✅ PASSED | All tools accessible |
| `eng-implementer` | glob, read, edit, write | ✅ PASSED | All tools accessible |
| `eng-validator` | glob, bash, read | ✅ PASSED | All tools accessible |
| `eng-quality-reviewer` | glob, read | ✅ PASSED | All tools accessible |
| `eng-quality-checker` | glob, bash, edit | ✅ PASSED | All tools accessible |
| `eng-guidelines-checker` | glob, read | ✅ PASSED | All tools accessible |
| `eng-test-planner` | glob, read, write | ✅ PASSED | All tools accessible |
| `meta-researcher` | glob, read | ✅ PASSED | All tools accessible |

## Key Finding: MCP Tool Inheritance Issue

### Problem Discovered
**OpenCode subagents spawned via the `task` tool do not inherit local MCP tools from the parent agent.**

### Root Cause
- Subagents run in isolated contexts with only built-in OpenCode tools
- Local MCP servers (like `perplexity_mcp`) are not passed through
- Remote MCP servers (like `gh_grep`) ARE accessible ✓

### Impact
The `eng-external-researcher` agent was designed to use Perplexity for AI-powered research, but these tools are unavailable in subagent context.

## Resolution

### Changes Made

#### 1. Updated `eng-external-researcher` agent definition
**File**: `.opencode/agent/eng-external-researcher.md`

- Removed references to unavailable `perplexity_mcp_*` tools
- Updated to use `webfetch` for documentation research
- Continues using `gh_grep_searchGitHub` (which works ✓)
- Added note about Perplexity limitation

#### 2. Configuration attempts (unsuccessful)
- Added `agent.eng-external-researcher.tools` config in `opencode.json` - **No effect**
- Created `.opencode/subagent-config/opencode.json` with Perplexity MCP - **Not used by `task` tool**
- Added `AGENTS_SETTINGS_PATH` to subagents MCP environment - **Not applicable to `task` tool**

#### 3. Documentation created
- `.opencode/SUBAGENT_LIMITATIONS.md` - Comprehensive documentation of the issue
- This file - Test results and resolution

### Verification Test

**Final Test**: Asked `eng-external-researcher` to research TypeScript async error handling

**Result**: ✅ **PASSED**
- Successfully used `webfetch` to access TypeScript docs
- Successfully used `gh_grep_searchGitHub` to find real-world examples
- Provided accurate, useful research summary

## Available Tools by Context

### Parent Agent (Primary/Build Mode)
✅ All built-in tools  
✅ Local MCP tools (`perplexity_mcp_*`)  
✅ Remote MCP tools (`gh_grep`)  

### Subagent (via `task` tool)
✅ All built-in tools  
❌ Local MCP tools (`perplexity_mcp_*`)  
✅ Remote MCP tools (`gh_grep`)  

## Recommendations

### For Agent Design
1. **Don't rely on local MCP tools in subagent definitions**
2. **Use remote MCP servers** (like gh_grep) - they work in subagents
3. **Use `webfetch`** for accessing web resources
4. **Design workflows** where parent agents call local MCP tools and pass results to subagents

### For Workflow Design
If Perplexity-powered research is critical:
1. Have the orchestrator agent call Perplexity directly (it has MCP access)
2. Pass Perplexity research results to `eng-external-researcher` as context
3. Let `eng-external-researcher` focus on synthesis and code examples via GitHub search

### For Future Enhancement
Consider filing a feature request with OpenCode for:
- MCP tool inheritance option for subagents
- Explicit tool passing in `task` tool parameters
- Subagent-specific MCP configuration support

## Conclusion

✅ **All subagents can now successfully perform their intended functions**
- Core built-in tools (read, write, edit, bash, glob, grep) work universally
- Remote MCP tools (gh_grep) work in subagents
- Local MCP limitation documented and worked around
- `eng-external-researcher` updated and verified working

❌ **Known Limitation**: Local MCP tools not available to subagents
- This is an OpenCode architectural constraint
- Workarounds implemented and tested
- Agents remain functional with available tools

---

**Test completed by**: OpenCode AI Agent  
**Test session**: Multiple smoke tests over 30+ invocations  
**Final status**: All agents operational ✅
