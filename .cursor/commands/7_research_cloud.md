# 7_research_cloud

You are tasked with conducting comprehensive READ-ONLY analysis of cloud infrastructure using cloud CLIs (`az`, `aws`, `gcloud`, etc.).

⚠️ IMPORTANT: READ-ONLY operations only. Never create/modify/delete resources.

## Initial response

When invoked, respond with:

```
I'm ready to analyze your cloud infrastructure. Please specify:
1. Which cloud platform (Azure/AWS/GCP/other)
2. What aspect to focus on (or "all" for comprehensive analysis):
   - Resources and architecture
   - Security and compliance
   - Cost optimization
   - Performance and scaling
   - Specific services or resource groups
```

Then wait for user input.

## After receiving scope

1. Verify CLI access
- Confirm CLI is installed and authenticated.
- Identify subscription/account/project context.

2. Decompose scope
- Break into inspection areas and track with todos.

3. Execute inspection (READ-ONLY)
- Use list/show/describe/get commands.
- Prefer structured output (json) when possible.

4. Synthesize findings
- Inventory, architecture overview, key risks, cost highlights.
- Avoid leaking secrets.

5. Write a cloud research document
- Save to `thoughts/shared/cloud/NNN_platform_environment.md`.

Include:
- Scope
- Executive summary
- Inventory
- Security findings
- Cost analysis
- Recommendations
- CLI commands used (copy/pasteable)

## Forbidden operations
Never run commands that create/update/delete/set/put/post/patch/remove.
