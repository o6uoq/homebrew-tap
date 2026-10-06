#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/auto-bump.sh

test_dir=$(mktemp -d)
trap 'rm -rf "${test_dir}"' EXIT

# Unchanged metadata exercises every GitHub lookup without rewriting formulas.
gh() {
  test "$1" = api
  printf '%s\n' "$2" >> "${test_dir}/requests"
  case "$2" in
    repos/snyk/agent-scan/releases/latest)
      sed -nE 's/^  version "([^"]+)"/\1/p' Formula/agent-scan.rb | jq -R '{tag_name: ("v" + .)}' ;;
    repos/o6uoq/fuzmit/releases/latest)
      sed -nE 's/^  version "([^"]+)"/\1/p' Formula/fuzmit.rb | jq -R '{tag_name: ("v" + .)}' ;;
    repos/tobi/try/tags)
      sed -nE 's#.*tags/(v[^/]+)\.tar\.gz.*#\1#p' Formula/try.rb | jq -R '[{name: .}]' ;;
    *) return 1 ;;
  esac
}

bump_agent_scan
bump_fuzmit
bump_try
cat > "${test_dir}/expected" <<'REQUESTS'
repos/snyk/agent-scan/releases/latest
repos/o6uoq/fuzmit/releases/latest
repos/tobi/try/tags
REQUESTS
diff -u "${test_dir}/expected" "${test_dir}/requests"

# An API error must stop each bump, not become a skipped or successful check.
gh() { return 22; }
for bump in bump_agent_scan bump_fuzmit bump_try; do
  set +e
  (set -e; "$bump")
  status=$?
  set -e
  test "$status" -eq 22
done

echo 'Auto-bump API regression tests passed.'
