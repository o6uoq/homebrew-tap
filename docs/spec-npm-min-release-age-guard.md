## Acceptance Criteria
- `Formula/*` npm package bumps are gated by Homebrew's current npm `--min-release-age` value before formula files are rewritten.
- Npm-backed formulas in `.github/workflows/auto-bump.yaml` use one shared mechanism instead of formula-specific ad hoc logic.
- Formula install behavior remains policy-compliant (`std_npm_args` only; no per-formula age-gate bypass).
- Auto-bump job fails fast if runner npm cannot enforce `min-release-age`.

## Constraints
- Respect Homebrew policy exactly as implemented upstream; no custom override windows.
- Keep scope to autobump + packaging policy; no unrelated formula refactors.
- Preserve existing PR creation flow and output wiring (`steps.<id>.outputs.bumped`).

## Approach
- Resolve `min-release-age` dynamically from Homebrew `language/node.rb` at workflow runtime.
- Replace repeated npm bump snippets with a shared helper script (`scripts/bump-npm-formula.sh`) that:
  - resolves latest npm version,
  - runs an npm preflight install with the resolved `min-release-age`,
  - skips bumps that fail only due age gating,
  - rewrites formula URL + sha256 when compliant.
- Revert formula-level `--min-release-age=0` override so enforcement remains centralized.
