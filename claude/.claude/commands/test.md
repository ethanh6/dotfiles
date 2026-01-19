---
name: test
description: Generate unit tests for specified code
---

Generate comprehensive unit tests for the specified function, class, or file.

## Guidelines

1. **Detect the test framework** used in the project (jest, pytest, go test, etc.)
2. **Follow existing patterns** - match the style of existing tests in the codebase
3. **Cover these cases**:
   - Happy path (normal inputs)
   - Edge cases (empty, null, boundary values)
   - Error conditions (invalid inputs, exceptions)
   - If applicable: async behavior, mocking external dependencies

## Output Format

1. Show the test file path where tests should be added
2. Provide the complete test code
3. List any mocks or fixtures needed
4. Explain what each test verifies

## Do NOT

- Over-mock (test real behavior when possible)
- Test implementation details (test behavior, not internals)
- Create flaky tests (no timing-dependent assertions)
