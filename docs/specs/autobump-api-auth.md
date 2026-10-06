# Authenticated auto-bump metadata

## Acceptance criteria

- GitHub release and tag metadata uses authenticated `gh api` requests.
- The workflow supplies its read-only GitHub token through `GH_TOKEN`.
- API failures remain fatal and identify the failing endpoint.
- Regression tests cover all three GitHub metadata lookups and failure propagation.

## Constraints

Preserve every formula, bump eligibility rule, release cooldown, and PR token permission.
Do not send the GitHub token to npm, PyPI, raw content, or release downloads.
Do not log credentials or pass them through command arguments.

## Approach

Replace the three unauthenticated GitHub API curl requests with `gh api`.
Require `gh`, inject the workflow token, and run isolated shell regression tests in CI.
Validate with pre-commit and a live auto-bump run in a disposable checkout.
