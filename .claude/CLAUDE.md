- never introduce a regression to a feature just to meet performance goals
- never use Co-Authored-By in git referring to LLM output. Use Assisted-By instead.
- use github cli (gh) to read CI runs, PR threads, issues, etc

## CodeRabbit CLI

Use `coderabbit review --plain` for local AI code reviews before pushing.

**Rate limits**: CodeRabbit has usage limits. To avoid hitting them:
- Run reviews only once per significant change, not repeatedly
- Use `--base-commit <sha>` to review specific commit ranges instead of full diffs
- If rate limited, wait the indicated time (typically ~25 min) before retrying
- Consider batching changes into fewer, larger reviews rather than many small ones

**Common commands**:
```bash
coderabbit review --plain                    # Review all changes (non-interactive)
coderabbit review --plain --type committed   # Review only committed changes
coderabbit review --plain --base main        # Compare against main branch
coderabbit review --prompt-only              # Get AI prompts without full review
```
