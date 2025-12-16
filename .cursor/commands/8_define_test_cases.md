# 8_define_test_cases

You are helping define automated acceptance test cases using a Domain Specific Language (DSL) approach.

## Core principles
1. Comment-first: write test cases as structured comments before implementation.
2. DSL at every layer: setup/actions/assertions are readable DSL functions.
3. Implicit structure: blank lines separate setup/action/assertion. Never write “Given/When/Then”.
4. Follow existing patterns: study current tests and DSL naming conventions first.

## Test case structure

```javascript
// 1. Test Case Name

// setupFunction
// anotherSetupFunction
//
// actionThatTriggersLogic
//
// expectOutcome
// expectAnotherOutcome
```

## Workflow

1. Understand the feature
Ask minimal clarifying questions (systems involved, outcomes, failure modes).

2. Research existing patterns
Use codebase search to find:
- Acceptance/integration test files
- Existing DSL helpers and naming conventions
- How tests are organized (describe blocks, fixtures, helpers)

3. Define test cases in comments
Cover:
- Happy paths
- Edge cases
- Error scenarios
- Boundary conditions
- Authorization/permissions

4. List required DSL functions
Group by:
- Setup (arrange)
- Action (act)
- Assertion (assert)

Note which functions likely already exist vs need creation.

## Deliverables
Provide:
1) Comment-first test case definitions
2) Required DSL function list (organized)
3) Notes on alignment with existing patterns
