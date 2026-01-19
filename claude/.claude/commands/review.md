---
name: review
description: Review code changes for bugs, style issues, and improvements
---

Review the current staged changes or specified file for:

1. **Bugs & Logic Errors**: Race conditions, null references, off-by-one errors, edge cases
2. **Security Issues**: Injection vulnerabilities, exposed secrets, insecure patterns
3. **Performance**: Unnecessary loops, missing indexes, memory leaks
4. **Code Style**: Naming conventions, consistency with codebase patterns
5. **Best Practices**: Error handling, logging, testability

Format your review as:

```
## Summary
[One sentence overview]

## Issues Found
### 🔴 Critical
- [issue]: [file:line] - [explanation]

### 🟡 Suggestions
- [suggestion]: [file:line] - [explanation]

## Verdict
[APPROVE / REQUEST_CHANGES / NEEDS_DISCUSSION]
```

If no file is specified, review `git diff --cached`. If nothing is staged, review `git diff`.
