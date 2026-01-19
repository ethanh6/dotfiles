---
name: commit
description: Create a well-formatted git commit with conventional commit style. Analyzes staged changes and generates an appropriate commit message.
---

# Git Commit Skill

Create a git commit following conventional commit format.

## Instructions

1. First, check the current git status and staged changes:
   - Run `git status` to see what's staged
   - Run `git diff --cached` to see the actual changes

2. Analyze the changes and determine:
   - The type of change (feat, fix, docs, style, refactor, test, chore)
   - The scope (optional, e.g., component or file affected)
   - A concise description of what changed

3. Generate a commit message following this format:
   ```
   <type>(<scope>): <description>

   [optional body with more details]
   ```

4. Present the proposed commit message to the user for approval

5. If approved, execute the commit

## Commit Types

- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that don't affect code meaning (whitespace, formatting)
- **refactor**: Code change that neither fixes a bug nor adds a feature
- **test**: Adding or correcting tests
- **chore**: Changes to build process or auxiliary tools

## Examples

```
feat(auth): add OAuth2 login support

fix(api): handle null response from user endpoint

docs: update README with installation instructions

refactor(utils): extract date formatting into separate module
```

## Guidelines

- Keep the first line under 72 characters
- Use imperative mood ("add" not "added" or "adds")
- Don't end the subject line with a period
- Separate subject from body with a blank line
- Use the body to explain what and why, not how
