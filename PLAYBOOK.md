# Cursor Research-Plan-Implement Framework Playbook

## Table of Contents
1. [Overview](#overview)
2. [Quick Start](#quick-start)
3. [Framework Architecture](#framework-architecture)
4. [Workflow Phases](#workflow-phases)
5. [Command Reference](#command-reference)
6. [Session Management](#session-management)
7. [Agent Reference](#agent-reference)
8. [Best Practices](#best-practices)
9. [Customization Guide](#customization-guide)
10. [Troubleshooting](#troubleshooting)

## Overview

The Research-Plan-Implement Framework is a structured approach to AI-assisted software development that emphasizes:
- **Thorough research** before coding
- **Detailed planning** with clear phases
- **Systematic implementation** with verification
- **Persistent context** through markdown documentation

### Core Benefits
- 🔍 **Deep Understanding**: Research phase ensures complete context
- 📋 **Clear Planning**: Detailed plans prevent scope creep
- ✅ **Quality Assurance**: Built-in validation at each step
- 📚 **Knowledge Building**: Documentation accumulates over time
- ⚡ **Parallel Processing**: Multiple AI agents work simultaneously
- 🧪 **Test-Driven Development**: Design test cases following existing patterns before implementation

## Quick Start

### Installation

**Recommended: Use the setup script**

```bash
./setup.sh /path/to/your/repo
```

This script offers two modes:
*   **Copy (Standard)**: Copies files to your repo. You can modify them freely.
*   **Symlink (Dev)**: Links files to the framework repo. Useful if you want to keep up-to-date with framework changes automatically.

It also configures the required **MCP servers**.

**Manual Installation**

1. **Copy framework files to your repository:**
```bash
# From the framework directory
cp -r .cursor your-repo/
cp -r thoughts your-repo/
cp PLAYBOOK.md your-repo/
```

2. **Configure MCP Servers:**
```bash
python3 mcp_setup.py --repo-root your-repo/
```

3. **Customize for your project:**
- Edit `.cursor/commands/*.md` to match your tooling
- Update `.cursor/rules/*.mdc` to encode project conventions
- (Optional) Add project-specific guidance used by your team/tooling

3. **Test the workflow:**

**Standard Approach:**
```
/c0_research_codebase
> How does user authentication work in this codebase?

/c1_code_plan
> I need to add two-factor authentication

/c2_code_implement
> thoughts/shared/code_plans/CP001_two_factor_auth.md
```

**Test-Driven Approach:**
```
/t1_plan_tests
> Two-factor authentication for user login

# Design tests, then implement feature
/c2_code_implement
> Implement 2FA to make tests pass
```

## Framework Architecture

```
your-repo/
├── .cursor/                      # Cursor Configuration
│   ├── commands/                 # Workflow slash commands
│   │   ├── c0_research_codebase.md
│   │   ├── c1_code_plan.md
│   │   ├── c2_code_implement.md
│   │   ├── c3_code_validate.md
│   │   └── ... (see Command Reference)
│   └── rules/                    # Cursor Rules
│       └── research-plan-implement.mdc
├── thoughts/                     # Persistent Context Storage
│   └── shared/
│       ├── code_research/       # Research findings
│       ├── code_plans/          # Implementation plans
│       ├── code_sessions/       # Work session summaries
│       ├── ux_research/         # UX studies
│       └── ... (see Command Reference)
```

## Workflow Phases

### Phase 1: Research (`/c0_research_codebase`)

**Purpose**: Comprehensive exploration and understanding

**Process**:
1. Invoke command with research question
2. Cursor Agent uses codebase search + targeted file reads to investigate
3. Findings compiled into structured document
4. Saved to `thoughts/shared/code_research/`

**Example**:
```
/c0_research_codebase
> How does the payment processing system work?
```

**Output**: Detailed research document with:
- Code references (file:line)
- Architecture insights
- Patterns and conventions
- Related components

### Phase 2: Planning (`/c1_code_plan`)

**Purpose**: Create detailed, phased implementation plan

**Process**:
1. Read requirements and research
2. Interactive planning with user
3. Generate phased approach
4. Save to `thoughts/shared/code_plans/`

**Example**:
```
/c1_code_plan
> Add Stripe payment integration based on the research
```

**Plan Structure**:
```markdown
# Feature Implementation Plan

## Phase 1: Database Setup
### Changes Required:
- Add payment tables
- Migration scripts

### Success Criteria:
#### Automated:
- [ ] Migration runs successfully
- [ ] Tests pass

#### Manual:
- [ ] Data integrity verified

## Phase 2: API Integration
[...]
```

### Phase 3: Implementation (`/c2_code_implement`)

**Purpose**: Execute plan systematically

**Process**:
1. Read plan and track with todos
2. Implement phase by phase
3. Run verification after each phase
4. Update plan checkboxes

**Example**:
```
/c2_code_implement
> thoughts/shared/code_plans/CP001_stripe_integration.md
```

**Progress Tracking**:
- Uses checkboxes in plan
- TodoWrite for task management
- Communicates blockers clearly

### Phase 4: Validation (`/c3_code_validate`)

**Purpose**: Verify implementation matches plan

**Process**:
1. Review git changes
2. Run all automated checks
3. Generate validation report
4. Identify deviations
5. Prepare for manual commit process

**Example**:
```
/c3_code_validate
> Validate the Stripe integration implementation
```

**Report Includes**:
- Implementation status
- Test results
- Code review findings
- Manual testing requirements

### Test-Driven Development (`/t1_plan_tests`)

**Purpose**: Design acceptance test cases before implementation

**Process**:
1. Invoke command with feature description
2. AI researches existing test patterns in codebase
3. Defines test cases in structured comment format
4. Identifies required DSL functions
5. Notes which DSL functions exist vs. need creation

**Example**:
```
/t1_plan_tests
> Partner enrollment workflow when ordering kit products
```

**Output**:
1. **Test Case Definitions**: All scenarios in comment format:
```javascript
// 1. New Customer Orders Partner Kit

// newCustomer
// partnerKitInCart
//
// customerPlacesOrder
//
// expectOrderCreated
// expectPartnerCreatedInExigo
```

2. **DSL Function List**: Organized by type (setup/action/assertion)
3. **Pattern Notes**: How tests align with existing patterns

**Test Structure**:
- Setup phase (arrange state)
- Blank line
- Action phase (trigger behavior)
- Blank line
- Assertion phase (verify outcomes)
- No "Given/When/Then" labels - implicit structure

**Coverage Areas**:
- Happy paths
- Edge cases
- Error scenarios
- Boundary conditions
- Authorization/permission checks

**Key Principle**: Comment-first approach - design tests as specifications before any implementation.

## Command Reference

### Code Domain (`c`)
*Focus: Implementation, Architecture, Logic*

| Command | File | Output | Purpose |
| :--- | :--- | :--- | :--- |
| `/c0_research_codebase` | `c0_research_codebase.md` | `thoughts/shared/code_research/CRNNN_*.md` | Deep dive into existing code |
| `/c1_code_plan` | `c1_code_plan.md` | `thoughts/shared/code_plans/CPNNN_*.md` | Implementation planning |
| `/c1a_plan_incremental` | `c1a_plan_incremental.md` | `thoughts/shared/code_plans/CPINNN_*.md` | Phasing large plans |
| `/c2_code_implement` | `c2_code_implement.md` | - | Execution of plans |
| `/c3_code_validate` | `c3_code_validate.md` | `thoughts/shared/code_validate/CVNNN_*.md` | Verification reports |

### Session Management (`cs`/`cr`)
*Focus: Context, State, Resume*

| Command | File | Output | Purpose |
| :--- | :--- | :--- | :--- |
| `/cs_save_session` | `cs_save_session.md` | `thoughts/shared/code_sessions/CSNNN_*.md` | Checkpoints and summaries |
| `/cr_resume_session` | `cr_resume_session.md` | - | Restore context |

### UX & Design Domain (`u`)
*Focus: User Experience, Interface, Visuals*

| Command | File | Output | Purpose |
| :--- | :--- | :--- | :--- |
| `/u0_research_ux` | `u0_research_ux.md` | `thoughts/shared/ux_research/URNNN_*.md` | Competitor/User/Heuristic research |
| `/u1_plan_ux` | `u1_plan_ux.md` | `thoughts/shared/ux_plans/UPNNN_*.md` | Flows, Information Architecture |
| `/u2_design_ui` | `u2_design_ui.md` | `thoughts/shared/ui_designs/UDNNN_*.md` | UI Specs, Component states |
| `/u3_validate_ux` | `u3_validate_ux.md` | `thoughts/shared/ux_validate/UVNNN_*.md` | Design reviews, Visual QA |

### Testing Domain (`t`)
*Focus: QA, Test Cases*

| Command | File | Output | Purpose |
| :--- | :--- | :--- | :--- |
| `/t1_plan_tests` | `t1_plan_tests.md` | `thoughts/shared/test_plans/TPNNN_*.md` | Defining test cases (DSL/Comment-first) |

### Guidelines Domain (`g`)
*Focus: Standards, Best Practices*

| Command | File | Output | Purpose |
| :--- | :--- | :--- | :--- |
| `/g0_research_guidelines` | `g0_research_guidelines.md` | `thoughts/shared/guidelines/GRNNN_*.md` | Auditing/Discovering patterns |
| `/g1_plan_fixes` | `g1_plan_fixes.md` | `thoughts/shared/guideline_plans/GPNNN_*.md` | Planning systemic fixes |
| `/g2_generate_patterns` | `g2_generate_patterns.md` | `thoughts/shared/guideline_patterns/GPATNNN_*.yaml` | Creating fix patterns |

## Cursor Rules & Commands

Cursor uses:
- `.cursor/commands/` for repo-defined slash commands
- `.cursor/rules/` for always-on and contextual guidance

## Best Practices

### 1. Research First
- Always start with research for complex features
- Don't skip research even if you think you know the codebase
- Research documents become valuable references

### 2. Plan Thoroughly
- Break work into testable phases
- Include specific success criteria
- Document what's NOT in scope
- Resolve all questions before finalizing
- Consider how work will be committed

### 3. Implement Systematically
- Complete one phase before starting next
- Run tests after each phase
- Update plan checkboxes as you go
- Communicate blockers immediately

### 4. Document Everything
- Research findings persist in `thoughts/`
- Plans serve as technical specs
- Session summaries maintain continuity

### 5. Use Parallel Agents
- In Cursor, keep exploration fast by:
  - using codebase search to fan out across call sites
  - opening the authoritative entry points first
  - queueing structured commands when helpful (e.g. `/c0_research_codebase` → `/c1_code_plan` → `/c2_code_implement`)

### 6. Design Tests Early
- Define test cases before implementing features
- Follow existing test patterns and DSL conventions
- Use comment-first approach for test specifications
- Ensure tests cover happy paths, edge cases, and errors
- Let tests guide implementation

## Customization Guide

### Adapting Commands

1. **Remove framework-specific references:**
```markdown
# Before (cli project specific)
Run `cli thoughts sync`

# After (Generic)
Save to thoughts/shared/research/
```

2. **Adjust tool commands:**
```markdown
# Match your project's tooling
- Tests: `npm test` → `yarn test`
- Lint: `npm run lint` → `make lint`
- Build: `npm run build` → `cargo build`
```

3. **Customize success criteria:**
```markdown
# Add project-specific checks
- [ ] Security scan passes: `npm audit`
- [ ] Performance benchmarks met
- [ ] Documentation generated
```

### Adding Custom Agents

Create new agents for specific needs:

```markdown
---
name: security-analyzer
description: Analyzes security implications
tools: Read, Grep
---

You are a security specialist...
```

### Project-Specific Guidance

If your team uses additional guidance files, add instructions for your project (or extend `.cursor/rules/*.mdc`):

```markdown
# Project Conventions

## Testing
- Always write tests first (TDD)
- Minimum 80% coverage required
- Use Jest for unit tests

## Code Style
- Use Prettier formatting
- Follow ESLint rules
- Prefer functional programming

## Git Workflow
- Feature branches from develop
- Squash commits on merge
- Conventional commit messages
```

## Troubleshooting

### Common Issues

**Q: Research phase taking too long?**
- A: Limit scope of research question
- Focus on specific component/feature
- Use more targeted queries

**Q: Plan too vague?**
- A: Request more specific details
- Ask for code examples
- Ensure success criteria are measurable

**Q: Implementation doesn't match plan?**
- A: Stop and communicate mismatch
- Update plan if needed
- Validate assumptions with research

**Q: How to commit changes?**
- A: Use git commands directly after validation
- Group related changes logically
- Write clear commit messages following project conventions

### Tips for Success

1. **Start Small**: Test with simple feature first
2. **Iterate**: Customize based on what works
3. **Build Library**: Accumulate research/plans over time
4. **Team Alignment**: Share framework with team
5. **Regular Reviews**: Update commands based on learnings

## Advanced Usage

### Chaining Commands

For complex features, chain commands:

```
/c0_research_codebase
> Research current auth system

/c1_code_plan
> Based on research, plan OAuth integration

/c2_code_implement
> thoughts/shared/code_plans/CP001_oauth_integration.md

/c3_code_validate
> Verify OAuth implementation

# Then manually commit using git
```

### Parallel Research

Research multiple aspects simultaneously:

```
/c0_research_codebase
> How do authentication, authorization, and user management work together?
```

This spawns agents to research each aspect in parallel.

### Test-Driven Development Workflow

Design tests before implementation:

```
# Step 1: Define test cases
/t1_plan_tests
> Partner enrollment when customer orders a kit product

# Output includes:
# - Test cases in comment format (happy path, edge cases, errors)
# - List of DSL functions needed (setup/action/assertion)
# - Existing functions that can be reused

# Step 2: Implement missing DSL functions
# (Follow patterns discovered by the agent)

# Step 3: Write tests using the defined test cases
# (Copy comment structure to test files, add function calls)

# Step 4: Create plan for feature implementation
/c1_code_plan
> Implement partner enrollment logic to make tests pass

# Step 5: Implement the feature
/c2_code_implement
> thoughts/shared/code_plans/CP001_partner_enrollment.md

# Step 6: Validate tests pass
/c3_code_validate
```

**Key Benefit**: Tests are designed with existing patterns in mind, ensuring consistency across the test suite.

## Conclusion

This framework provides structure without rigidity. It scales from simple features to complex architectural changes. The key is consistent use - the more you use it, the more valuable your `thoughts/` directory becomes as organizational knowledge.

Remember: The framework is a tool to enhance development, not replace thinking. Use it to augment your capabilities, not as a rigid process.
