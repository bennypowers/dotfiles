- never introduce a regression to a feature just to meet performance goals
- never use Co-Authored-By in git referring to LLM output. Use Assisted-By instead.
- use github cli (gh) to read CI runs, PR threads, issues, etc
- jq is available as is yq. This is a gentoo box, eix is available too.
- if you need root perms to do something (like dmesg), you have to ask me, don't 
  try to issue sudo commands on your own.
- prefer to work on features or fixes in new git worktrees, from main

## GitHub
- NEVER post a comment using gh api without my explicit permission
- When drafting or editing issues, PR descriptions, comments, etc on GitHub,
  avoid the use of "em dashes" and other obvious tells of AI use, since some maintainers are bothered by this.
- place worktrees in ~/Developer/worktrees/{project}-{branch}/ by default, 
unless the project already has a location set up for that
- never force push to published branches.
   - In most of my repos, I squash PRs to maintain a nice history on main, so force pushing is unnecessary;
   - and in others' repos, it's rude to force push unless explicitly asked to by maintainers.
- commit messages containing syntax like `@slot` or `@summary` (beginning with an @) must wrap those jsdoc-like tags in backticks, to avoid tagging github users inadvertently.

## Go
- **Before every push**: run `golangci-lint run ./...` (full project, not just changed packages) and `go test ./... -count=1`. Fix all issues before pushing. Every push to a PR triggers CI and CodeRabbit; failed lint wastes a rate-limited review cycle.
- Use `go vet`, `golangci-lint`, and `staticcheck` to improve all code prior to review and before pushing.
  Common examples:
  - replace `interface{}` with `any`
  - replace `if/else` with `min`
  - replace `m[k]=v` loop with `maps.Copy` [mapsloop]
  - Loop can be simplified using slices.Contains [slicescontains]
- Getter methods should be named `Foo()`, not `GetFoo()`.

## Testing
- Practice TDD. Red tests first.
- Obsessively test. Validate results.

## CodeRabbit Reviews

For git repos under `bennypowers` github org, use `coderabbit:code-review` plugin skill
for local AI code reviews before pushing. Iteratively fix comments and re-request
reviews until all comments are addressed (or dismissed as irrelevant or mistaken, with proof).

**Rate limits**: CodeRabbit has usage limits. To avoid hitting them:
- Run reviews only once per significant change, not repeatedly
- Use `--base-commit <sha>` to review specific commit ranges instead of full diffs
- If rate limited, wait the indicated time (typically ~25 min) before retrying
- Consider batching changes into fewer, larger reviews rather than many small ones

**Post-push review loop**: Every push to a PR triggers a CodeRabbit review on GitHub (or edits its sticky comment with an error/rate limit). After pushing:
1. Set a 10-minute timer, then check the PR thread (`gh api repos/OWNER/REPO/pulls/N/comments`) if there's no comment, then coderabbit isn't enabled for this repo, so review locally instead.
2. If rate limited: set a timer for the indicated wait, then post `@coderabbitai review` as a PR comment to re-request
3. If review is pending/in-progress: wait another 5 minutes before checking again
4. If new comments: address them, commit, push, and restart the loop
5. If a finding is dismissed as WONTFIX: reply to that specific CodeRabbit comment in the PR thread with reasoning, don't just ignore it

As you review, or as user pastes in review comments from coderabbit's github PR thread comments, update this file with any advice that's generically applicable.
