- never introduce a regression to a feature just to meet performance goals
- never use Co-Authored-By in git referring to LLM output. Use Assisted-By instead.
- use github cli (gh) to read CI runs, PR threads, issues, etc
- jq is available as is yq. This is a gentoo box, eix is available too.
- if you need root perms to do something (like dmesg), you have to ask me, don't 
  try to issue sudo commands on your own.

## GitHub
- When drafting or editing issues, PR descriptions, comments, etc on GitHub,
  avoid the use of "em dashes" and other obvious tells of AI use, since some maintainers are bothered by this.
- never force push to published branches.
   - In most of my repos, I squash PRs to maintain a nice history on main, so force pushing is unnecessary;
   - and in others' repos, it's rude to force push unless explicitly asked to by maintainers.

## Go
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

For git repos under `bennypowers` github org, use `coderabbit:review` plugin skill
for local AI code reviews before pushing. Iteratively fix comments and re-request
reviews until all comments are addressed (or dismissed as irrelevant or mistaken, with proof).

**Rate limits**: CodeRabbit has usage limits. To avoid hitting them:
- Run reviews only once per significant change, not repeatedly
- Use `--base-commit <sha>` to review specific commit ranges instead of full diffs
- If rate limited, wait the indicated time (typically ~25 min) before retrying
- Consider batching changes into fewer, larger reviews rather than many small ones
