- never introduce a regression to a feature just to meet performance goals
- never use Co-Authored-By in git referring to LLM output. Use Assisted-By instead.
- use github cli (gh) to read CI runs, PR threads, issues, etc
- jq is available as is yq. This is a gentoo box, eix is available too.
- if you need root perms to do something (like dmesg), you have to ask me, don't 
  try to issue sudo commands on your own.

## NVM and Fish Shell
- i use fish shell. nvm is available as fish function. need nvm? use fish shell.
IMPORTANT: when you print commands for me to run in terminal, print them using fish syntax. Use bash when you run your own commands

## JSON

`jq` and `yq` are available. ALWAYS use `jq` or `yq` for JSON/YAML processing — never `python -m json.tool` or inline `python -c` with json/yaml modules.

## GitHub
- NEVER post a comment using gh api without my explicit permission
- When drafting or editing issues, PR descriptions, comments, etc on GitHub,
  avoid the use of "em dashes" and other obvious tells of AI use, since some maintainers are bothered by this.
- If instructed to use worktrees, place them in ~/Developer/worktrees/{project}-{branch}/ by default, 
unless the project already has a location set up for that
- never force push to published branches.
   - In most of my repos, I squash PRs to maintain a nice history on main, so force pushing is unnecessary;
   - and in others' repos, it's rude to force push unless explicitly asked to by maintainers.
- commit messages containing syntax like `@slot` or `@summary` (beginning with an @) must wrap those jsdoc-like tags in backticks, to avoid tagging github users inadvertently.

### Action workflows
When adding or updating github actions workflows, always check them with actionlint
Verify URLs for embedded shared actions

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
- Practice TDD.
- When fixing a bug or writing a new feature ALWAYS validate with red tests, 
  first, before implementing the fix/feat.
- Obsessively test. Validate results.

## Blocked Fetches
If you get blocked from fetching a web page, use chrome or firefox mcp to fetch the page

## Hallucinations
- IMPORTANT: I am not nicolo-ribaudo. 99.99999% of the time that you think you need to generate the text `nicolo-ribaudo`, you are actually hallucinating.. If you ever get a 200 response to a github repo under `nicolo-ribaudo`'s namespace, you *MUST* verify that the repo is a source and not a fork. If it is a fork, you MUST NOT continue to query that repo, only the source.
- Always verify the current date when writing copyright headers
- _never_ use regexp to manipulate HTML. Instead, ALWAYS use a parser like parse5, 
  tree-sitter, go's html parser, etc.
