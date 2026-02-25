# OpenCode Subagent Limitations

## MCP Tool Inheritance Issue

### Problem
Subagents spawned via OpenCode's `task` tool run in **isolated contexts** and **do not inherit MCP tools** from the parent agent. This is an architectural limitation of how OpenCode implements subagent isolation.

### Affected Agents
- `eng-external-researcher` - Cannot access Perplexity MCP tools for AI-powered research
- Any other subagent expecting MCP tool access

### Root Cause
When OpenCode spawns a subagent using the `task` tool:
1. The subagent runs in a fresh, isolated context
2. Only OpenCode's built-in tools are available (bash, read, glob, grep, edit, write, webfetch, gh_grep, subagents_run_agent)
3. MCP servers configured at the parent level (like `perplexity_mcp`) are **not** passed through to the subagent
4. The `agent.tools` configuration in `opencode.json` only applies to primary agents, not subagents

### Verification
Smoke test confirmed:
- Parent agent: Has access to `perplexity_mcp_*` tools ✓
- Subagent (via `task` tool): No `perplexity_mcp_*` tools available ✗

### Current Workaround
The `eng-external-researcher` agent has been updated to:
1. Use `webfetch` to access documentation and web resources directly
2. Use `gh_grep_searchGitHub` for code examples (this works - remote MCP servers ARE accessible)
3. Recommend that parent agents call Perplexity directly when deep AI reasoning is needed

### Future Solutions

#### Option 1: Workflow Redesign (Recommended)
Restructure workflows so that:
- Parent orchestrator agents call Perplexity MCP directly
- Research results are passed to subagents as context
- Subagents focus on synthesis and implementation guidance

#### Option 2: Feature Request to OpenCode
Request that OpenCode support MCP tool inheritance for subagents, possibly via:
- A config option: `agent.inherit_mcp_tools: true`
- Subagent-specific MCP configuration
- Explicit tool passing in `task` tool invocations

#### Option 3: Use Alternative Subagent System
The `subagents` MCP server (sub-agents-mcp) spawns agents via CLI, which might support different tool configurations. However, this requires switching from OpenCode's built-in `task` tool to `subagents_run_agent` tool.

## Tools Available to Subagents

### ✅ Available (Built-in)
- `bash` - Shell commands
- `read` - Read files
- `glob` - File search by pattern
- `grep` - Content search
- `edit` - File editing
- `write` - File writing
- `webfetch` - HTTP requests
- `skill` - Load skills
- `gh_grep_searchGitHub` - GitHub code search (remote MCP)
- `subagents_run_agent` - Spawn sub-subagents

### ❌ Not Available (Local MCP)
- `perplexity_mcp_*` - Perplexity AI tools
- Any other local MCP servers configured in parent

### ⚠️ Remote MCP Status
- `gh_grep` (https://mcp.grep.app) - **WORKS** ✓
- Remote MCP servers appear to be accessible to subagents

## Recommendations for Agent Design

1. **Don't rely on local MCP tools in subagent definitions**
2. **Use remote MCP servers when possible** (they work in subagents)
3. **Design workflows where parent agents use local MCP tools** and pass results to subagents
4. **Use `webfetch` and `gh_grep_searchGitHub`** as reliable alternatives for external research
5. **Document tool dependencies** clearly in agent definitions

## Related Files
- `.opencode/opencode.json` - MCP and agent configuration
- `.opencode/agent/eng-external-researcher.md` - Updated to work without Perplexity MCP
- `.opencode/subagent-config/opencode.json` - Attempted fix (doesn't work with `task` tool)
