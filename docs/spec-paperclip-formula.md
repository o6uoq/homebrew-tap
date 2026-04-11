## Acceptance Criteria
- `Formula/paperclip.rb` exists and installs the `paperclipai` CLI from npm.
- Formula test is deterministic and validates executable behavior.
- `.github/workflows/formula-smoke-tests.yaml` runs a smoke command when `Formula/paperclip.rb` changes.
- `.github/workflows/auto-bump.yaml` includes an automated bump check for `paperclip`.
- `README.md` includes `paperclip` in formula and install example lists.

## Constraints
- Follow existing tap conventions for npm formulas.
- Keep edits scoped to paperclip packaging and related CI wiring only.
- Preserve current workflow structure and secret/token handling.

## Approach
- Add a tap-only Node formula named `paperclip` using npm package `paperclipai`.
- Use `paperclipai --version` in formula test and CI smoke command.
- Add an autobump step that reads latest `paperclipai` npm version and rewrites URL + sha256 in `Formula/paperclip.rb`.
