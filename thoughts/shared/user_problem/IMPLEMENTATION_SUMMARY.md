# Product Command: p1_user_problem_research

## Implementation Summary

Successfully implemented the `p1_user_problem_research` command for conducting systematic user problem research using the Jobs-to-be-Done (JTBD) framework.

## What Was Created

### 1. Command Definition
**File**: `.cursor/commands/product/p1_user_problem_research.md`

**Key Features**:
- Structured JTBD framework application
- Browser-based product research
- Codebase analysis via sub-agents
- Mermaid flowchart generation for status quo
- Evidence-based problem identification
- Current vs. desired state comparison

**Workflow**:
1. Request all information upfront (problem area, user context, URLs)
2. Use browser tools to explore product
3. Delegate codebase research to `c0_research_codebase` sub-agent
4. Apply JTBD framework
5. Create mermaid flowcharts
6. Document gaps and recommendations
7. Save to `thoughts/shared/user_problem/PNNN_topic.md`

### 2. Documentation Updates

**PLAYBOOK.md**:
- Added Product Domain section to Command Reference
- Added Product Research workflow phase description
- Updated framework architecture to include user_problem folder

**README.md**:
- Added Product Flow to process map diagram
- Updated Phase Descriptions
- Added Product Research Workflow example

### 3. Directory Structure
**Created**: `thoughts/shared/user_problem/`
- For storing JTBD user problem research artifacts
- Naming convention: `PNNN_topic.md` (e.g., `P001_xero-integration.md`)

### 4. Example Artifact
**File**: `thoughts/shared/user_problem/P000_example_file_upload.md`

**Demonstrates**:
- Complete JTBD analysis structure
- Mermaid flowcharts for current and desired states
- Evidence-based problem identification
- Code references and screenshots
- Critical thinking framework
- Prioritized recommendations

## JTBD Framework Integration

The command implements core JTBD principles:

### Job Statement Format
"When [situation], I want to [job], so I can [outcome] without [pain point]"

### Job Dimensions
- **Functional**: Objective tasks the user needs to accomplish
- **Emotional**: How the user wants to feel during/after
- **Social**: How the user wants to be perceived

### Research Approach
- Focus on the underlying job, not the solution
- Solution-agnostic job statements
- Functional, emotional, and social dimensions
- Repeated "why" questioning to find core job

## Integration Points

### Sub-Agent Usage
- Uses `c0_research_codebase` as sub-agent for codebase analysis
- Keeps main context clean by delegating technical research
- Links to generated code research artifacts

### Browser Tools
- `browser_navigate` - Navigate to product pages
- `browser_snapshot` - Capture page state
- `browser_take_screenshot` - Visual evidence collection
- Documents user flows and interaction patterns

### Visual Documentation
- Mermaid flowcharts for process visualization
- Color coding for problem areas (red) and improvements (green)
- Current state vs. desired state comparison

## Usage Example

```bash
/p1_user_problem_research

# Agent prompts for:
# 1. Problem Area/Feature: File upload for Xero integration
# 2. User Context: Accountant uploading bank statements
# 3. Product URL(s): https://app.example.com/xero/upload
# 4. Additional Context: Users confused about file formats and entities

# Agent then:
# - Navigates to URLs and explores product
# - Takes screenshots
# - Researches codebase implementation
# - Applies JTBD framework
# - Creates flowcharts
# - Generates comprehensive research document
```

## Output Structure

Each research artifact includes:

1. **Problem Definition**
   - User context (persona, scenario, frequency)
   - JTBD analysis with main job statement
   - Job dimensions (functional, emotional, social)
   - Current vs. desired solutions
   - Evidence-based pain points

2. **Status Quo Document**
   - Current state mermaid flowchart
   - Detailed implementation analysis
   - Problem highlights from JTBD perspective
   - Specific product pages/features with issues
   - Critical thinking: what's missing/broken/confusing
   - Desired state mermaid flowchart
   - Expected outcomes and metrics

3. **Supporting Evidence**
   - Screenshots with descriptions
   - Code references with line ranges
   - Links to codebase research artifacts

4. **Recommendations**
   - Priority 1: Critical jobs unmet
   - Priority 2: High-friction areas
   - Priority 3: Quick wins
   - Open questions for further investigation

## Benefits

1. **Systematic Problem Analysis**: Structured JTBD framework ensures comprehensive research
2. **Evidence-Based**: All claims backed by screenshots, code, or user quotes
3. **Visual Clarity**: Mermaid flowcharts make problems immediately visible
4. **Actionable Insights**: Prioritized recommendations guide implementation
5. **Context Preservation**: Artifacts persist for future reference
6. **Integration**: Links product problems to code implementation
7. **Clean Context**: Sub-agent delegation keeps analysis focused

## Next Steps for Users

After generating a user problem research artifact:

1. Review the JTBD statement and validate with stakeholders
2. Prioritize recommendations based on impact and effort
3. Use insights to inform implementation planning with `/c1_code_plan`
4. Reference the artifact when making UX/product decisions
5. Share with product team for alignment

## File Locations

- Command: `.cursor/commands/product/p1_user_problem_research.md`
- Example: `thoughts/shared/user_problem/P000_example_file_upload.md`
- Output directory: `thoughts/shared/user_problem/`
- Documentation: `PLAYBOOK.md` (sections 268-297, 306-311)
- README: Updated with Product Flow

