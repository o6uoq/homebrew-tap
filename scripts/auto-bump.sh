#!/usr/bin/env bash
set -euo pipefail

MIN_RELEASE_AGE_DAYS=""
PR_BODY_PATH=""
HOMEBREW_BREW_RAW_BASE="${HOMEBREW_BREW_RAW_BASE:-https://raw.githubusercontent.com/Homebrew/brew/HEAD/Library/Homebrew}"
declare -a BUMP_LINES=()
declare -a TMP_DIRS=()

cleanup() {
  if [ "${#TMP_DIRS[@]}" -gt 0 ]; then
    rm -rf "${TMP_DIRS[@]}"
  fi
}
trap cleanup EXIT

require_commands() {
  local cmd
  local missing=()
  for cmd in curl jq perl npm shasum grep sed mktemp head paste git; do
    if ! command -v "${cmd}" >/dev/null 2>&1; then
      missing+=("${cmd}")
    fi
  done

  if [ "${#missing[@]}" -gt 0 ]; then
    echo "Missing required command(s): ${missing[*]}" >&2
    exit 1
  fi
}

make_tmp_dir() {
  local tmp_dir
  tmp_dir=$(mktemp -d)
  TMP_DIRS+=("${tmp_dir}")
  printf '%s\n' "${tmp_dir}"
}

add_bump_line() {
  local id="$1"
  local current="$2"
  local latest="$3"
  local line="- ${id}: ${current} → ${latest}"
  BUMP_LINES+=("${line}")
  echo "Bumped ${id}: ${current} -> ${latest}"
}

resolve_npm_policy() {
  local node_helper_source
  local release_cooldown_source
  local release_cooldown_constant

  node_helper_source=$(curl -fsSL "${HOMEBREW_BREW_RAW_BASE}/language/node.rb")
  MIN_RELEASE_AGE_DAYS=$(sed -nE 's/.*--min-release-age=([0-9]+).*/\1/p' <<<"${node_helper_source}" | head -n 1)

  if [ -z "${MIN_RELEASE_AGE_DAYS}" ]; then
    release_cooldown_constant=$(sed -nE 's/.*--min-release-age=#\{Homebrew::([A-Z0-9_]+)\}.*/\1/p' <<<"${node_helper_source}" | head -n 1)

    if [ -n "${release_cooldown_constant}" ]; then
      release_cooldown_source=$(curl -fsSL "${HOMEBREW_BREW_RAW_BASE}/release_cooldown.rb")
      MIN_RELEASE_AGE_DAYS=$(sed -nE 's/.*'"${release_cooldown_constant}"'[[:space:]]*=[[:space:]]*(T\.let\()?([0-9]+).*/\2/p' <<<"${release_cooldown_source}" | head -n 1)
    fi
  fi

  if [ -z "${MIN_RELEASE_AGE_DAYS}" ] || ! [[ "${MIN_RELEASE_AGE_DAYS}" =~ ^[0-9]+$ ]]; then
    echo "Failed to resolve Homebrew npm --min-release-age policy." >&2
    exit 1
  fi

  echo "Resolved Homebrew npm min-release-age=${MIN_RELEASE_AGE_DAYS} day(s)."
}

validate_npm_min_release_age_support() {
  if ! npm config ls -l | grep -q '^min-release-age = '; then
    echo "Runner npm does not expose min-release-age; cannot enforce Homebrew policy." >&2
    npm --version >&2
    exit 1
  fi
}

bump_npm_formula() {
  local id="$1"
  local formula_path="$2"
  local package_name="$3"
  local current_url
  local current_version
  local latest_version
  local suffix
  local candidate_url
  local tmp_dir
  local npm_log
  local npm_status
  local sha
  local url_count
  local sha_count

  current_url=$(sed -nE 's#^  url "([^"]+)"#\1#p' "${formula_path}")
  if [ -z "${current_url}" ]; then
    echo "failed to parse url from ${formula_path}" >&2
    exit 1
  fi

  current_version=$(sed -nE 's#^  url ".*-([0-9A-Za-z][0-9A-Za-z.+-]*)\.tgz"#\1#p' "${formula_path}")
  if [ -z "${current_version}" ]; then
    echo "failed to parse current npm version from ${formula_path}" >&2
    exit 1
  fi

  latest_version=$(curl -fsSL "https://registry.npmjs.org/${package_name}/latest" | jq -r '.version')
  if [ -z "${latest_version}" ] || [ "${latest_version}" = "null" ]; then
    echo "failed to resolve latest version for ${package_name}" >&2
    exit 1
  fi

  if [ "${latest_version}" = "${current_version}" ]; then
    return
  fi

  suffix="-${current_version}.tgz"
  if [[ "${current_url}" != *"${suffix}" ]]; then
    echo "formula url '${current_url}' does not end with expected suffix '${suffix}'" >&2
    exit 1
  fi
  candidate_url="${current_url%${suffix}}-${latest_version}.tgz"

  tmp_dir=$(make_tmp_dir)
  npm_log="${tmp_dir}/npm-install.log"

  set +e
  npm install \
    --loglevel=silly \
    --global \
    --build-from-source \
    "--min-release-age=${MIN_RELEASE_AGE_DAYS}" \
    "--cache=${tmp_dir}/npm_cache" \
    "--prefix=${tmp_dir}/prefix" \
    "${candidate_url}" \
    --ignore-scripts \
    > "${npm_log}" 2>&1
  npm_status=$?
  set -e

  if [ "${npm_status}" -ne 0 ]; then
    if grep -Eq 'with a date before' "${npm_log}"; then
      echo "Skipping ${package_name}@${latest_version}: npm min-release-age=${MIN_RELEASE_AGE_DAYS} not satisfied yet."
      return
    fi

    echo "npm preflight failed for ${package_name}@${latest_version}" >&2
    tail -n 80 "${npm_log}" >&2
    exit "${npm_status}"
  fi

  sha=$(curl -fsSL "${candidate_url}" | shasum -a 256 | cut -d' ' -f1)
  if [ -z "${sha}" ] || ! [[ "${sha}" =~ ^[a-f0-9]{64}$ ]]; then
    echo "failed to compute sha256 for ${candidate_url}" >&2
    exit 1
  fi

  CURRENT_URL="${current_url}" CANDIDATE_URL="${candidate_url}" \
    perl -0i -pe 's/\Q$ENV{CURRENT_URL}\E/$ENV{CANDIDATE_URL}/g' "${formula_path}"
  perl -0i -pe 's#^  sha256 "[a-f0-9]{64}"#  sha256 "'"${sha}"'"#m' "${formula_path}"

  url_count=$(grep -F -c "${candidate_url}" "${formula_path}")
  sha_count=$(grep -F -c "sha256 \"${sha}\"" "${formula_path}")
  if [ "${url_count}" -ne 1 ] || [ "${sha_count}" -ne 1 ]; then
    echo "${id} bump rewrite validation failed" >&2
    echo "URL_COUNT=${url_count} SHA_COUNT=${sha_count}" >&2
    exit 1
  fi

  add_bump_line "${id}" "${current_version}" "${latest_version}"
}

release_asset_sha() {
  local release_json="$1"
  local asset_name="$2"
  local sha

  sha=$(jq -r --arg name "${asset_name}" '.assets[] | select(.name == $name) | .digest' <<<"${release_json}" | sed 's/^sha256://' | head -n 1)
  if [ -n "${sha}" ] && [ "${sha}" != "null" ] && [[ "${sha}" =~ ^[a-f0-9]{64}$ ]]; then
    printf '%s\n' "${sha}"
  fi
}

release_asset_candidates() {
  local release_json="$1"
  local asset_prefix="$2"
  local asset_suffix="$3"

  jq -r --arg prefix "${asset_prefix}" --arg suffix "${asset_suffix}" '
    .assets[].name
    | select(startswith($prefix) and endswith($suffix))
  ' <<<"${release_json}" | paste -sd ',' -
}

write_multi_asset_digests() {
  local id="$1"
  local latest="$2"
  local release_json="$3"
  local asset_spec_path="$4"
  local digest_path="$5"
  local missing=()
  local platform
  local asset_name
  local url_fragment
  local asset_prefix
  local asset_suffix
  local sha
  local candidates

  : > "${digest_path}"

  while IFS='|' read -r platform asset_name url_fragment asset_prefix asset_suffix; do
    [ -n "${platform}" ] || continue

    sha=$(release_asset_sha "${release_json}" "${asset_name}")
    if [ -z "${sha}" ]; then
      candidates=$(release_asset_candidates "${release_json}" "${asset_prefix}" "${asset_suffix}")
      if [ -n "${candidates}" ]; then
        missing+=("${asset_name} (found: ${candidates})")
      else
        missing+=("${asset_name}")
      fi
      continue
    fi

    printf '%s|%s|%s|%s\n' "${platform}" "${asset_name}" "${url_fragment}" "${sha}" >> "${digest_path}"
  done < "${asset_spec_path}"

  if [ "${#missing[@]}" -gt 0 ]; then
    echo "Skipping ${id} ${latest}: missing required release asset(s): ${missing[*]}."
    return 1
  fi
}

rewrite_multi_asset_formula() {
  local id="$1"
  local formula_path="$2"
  local current="$3"
  local latest="$4"
  local digest_path="$5"
  local version_count
  local platform
  local asset_name
  local url_fragment
  local sha
  local url_count
  local sha_count

  CURRENT_VERSION="${current}" LATEST_VERSION="${latest}" \
    perl -0i -pe '
      s#^  version "\Q$ENV{CURRENT_VERSION}\E"#  version "$ENV{LATEST_VERSION}"#m;
      s#\Q$ENV{CURRENT_VERSION}\E#$ENV{LATEST_VERSION}#g;
    ' "${formula_path}"

  while IFS='|' read -r platform asset_name url_fragment sha; do
    ASSET_NAME="${asset_name}" ASSET_SHA="${sha}" \
      perl -0i -pe '
        $asset = quotemeta($ENV{ASSET_NAME});
        $sha = $ENV{ASSET_SHA};
        s#($asset"\n      sha256 ")[a-f0-9]{64}"#${1}$sha"#m;
      ' "${formula_path}"
  done < "${digest_path}"

  version_count=$(grep -F -c "version \"${latest}\"" "${formula_path}")
  if [ "${version_count}" -ne 1 ]; then
    echo "${id} bump rewrite validation failed" >&2
    echo "VERSION_COUNT=${version_count}" >&2
    exit 1
  fi

  while IFS='|' read -r platform asset_name url_fragment sha; do
    url_count=$(grep -F -c "${url_fragment}" "${formula_path}")
    sha_count=$(grep -F -c "sha256 \"${sha}\"" "${formula_path}")
    if [ "${url_count}" -ne 1 ] || [ "${sha_count}" -ne 1 ]; then
      echo "${id} ${platform} bump rewrite validation failed" >&2
      echo "URL_COUNT=${url_count} SHA_COUNT=${sha_count} ASSET=${asset_name}" >&2
      exit 1
    fi
  done < "${digest_path}"
}

write_agent_scan_asset_spec() {
  local latest="$1"
  local asset_spec_path="$2"

  {
    printf 'macos-x86_64|agent-scan-%s-macos-x86_64|releases/download/v%s/agent-scan-%s-macos-x86_64|agent-scan-|-macos-x86_64\n' "${latest}" "${latest}" "${latest}"
    printf 'macos-arm64|agent-scan-%s-macos-arm64|releases/download/v%s/agent-scan-%s-macos-arm64|agent-scan-|-macos-arm64\n' "${latest}" "${latest}" "${latest}"
    printf 'linux-x86_64|agent-scan-%s-linux-x86_64|releases/download/v%s/agent-scan-%s-linux-x86_64|agent-scan-|-linux-x86_64\n' "${latest}" "${latest}" "${latest}"
  } > "${asset_spec_path}"
}

write_fuzmit_asset_spec() {
  local latest="$1"
  local asset_spec_path="$2"

  {
    printf 'darwin-amd64|fuzmit_%s_darwin_amd64.tar.gz|releases/download/v%s/fuzmit_%s_darwin_amd64.tar.gz|fuzmit_|_darwin_amd64.tar.gz\n' "${latest}" "${latest}" "${latest}"
    printf 'darwin-arm64|fuzmit_%s_darwin_arm64.tar.gz|releases/download/v%s/fuzmit_%s_darwin_arm64.tar.gz|fuzmit_|_darwin_arm64.tar.gz\n' "${latest}" "${latest}" "${latest}"
    printf 'linux-amd64|fuzmit_%s_linux_amd64.tar.gz|releases/download/v%s/fuzmit_%s_linux_amd64.tar.gz|fuzmit_|_linux_amd64.tar.gz\n' "${latest}" "${latest}" "${latest}"
    printf 'linux-arm64|fuzmit_%s_linux_arm64.tar.gz|releases/download/v%s/fuzmit_%s_linux_arm64.tar.gz|fuzmit_|_linux_arm64.tar.gz\n' "${latest}" "${latest}" "${latest}"
  } > "${asset_spec_path}"
}

bump_agent_scan() {
  local formula_path="Formula/agent-scan.rb"
  local release_json
  local latest
  local current
  local tmp_dir
  local asset_spec_path
  local digest_path

  release_json=$(curl -fsSL https://api.github.com/repos/snyk/agent-scan/releases/latest)
  latest=$(jq -r '.tag_name' <<<"${release_json}" | tr -d 'v')
  current=$(sed -nE 's#^  version "([0-9]+\.[0-9]+\.[0-9]+)"#\1#p' "${formula_path}")

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  tmp_dir=$(make_tmp_dir)
  asset_spec_path="${tmp_dir}/agent-scan-assets.txt"
  digest_path="${tmp_dir}/agent-scan-digests.txt"

  write_agent_scan_asset_spec "${latest}" "${asset_spec_path}"
  if ! write_multi_asset_digests "agent-scan" "${latest}" "${release_json}" "${asset_spec_path}" "${digest_path}"; then
    return
  fi

  rewrite_multi_asset_formula "agent-scan" "${formula_path}" "${current}" "${latest}" "${digest_path}"

  add_bump_line "agent-scan" "${current}" "${latest}"
}

bump_fuzmit() {
  local formula_path="Formula/fuzmit.rb"
  local release_json
  local latest
  local current
  local tmp_dir
  local asset_spec_path
  local digest_path

  release_json=$(curl -fsSL https://api.github.com/repos/o6uoq/fuzmit/releases/latest)
  latest=$(jq -r '.tag_name' <<<"${release_json}" | tr -d 'v')
  current=$(sed -nE 's#^  version "([0-9]+\.[0-9]+\.[0-9]+)"#\1#p' "${formula_path}")

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  tmp_dir=$(make_tmp_dir)
  asset_spec_path="${tmp_dir}/fuzmit-assets.txt"
  digest_path="${tmp_dir}/fuzmit-digests.txt"

  write_fuzmit_asset_spec "${latest}" "${asset_spec_path}"
  if ! write_multi_asset_digests "fuzmit" "${latest}" "${release_json}" "${asset_spec_path}" "${digest_path}"; then
    return
  fi

  rewrite_multi_asset_formula "fuzmit" "${formula_path}" "${current}" "${latest}" "${digest_path}"

  add_bump_line "fuzmit" "${current}" "${latest}"
}

bump_toad() {
  local formula_path="Formula/toad.rb"
  local pypi_json
  local latest
  local current
  local url
  local sha
  local url_count
  local sha_count

  pypi_json=$(curl -fsSL https://pypi.org/pypi/batrachian-toad/json)
  latest=$(jq -r '.info.version' <<<"${pypi_json}")
  current=$(sed -nE 's#^  url ".*batrachian_toad-([0-9]+\.[0-9]+\.[0-9]+)\.tar\.gz"#\1#p' "${formula_path}")

  if [ -z "${current}" ]; then
    echo "Failed to parse current toad version from ${formula_path}" >&2
    exit 1
  fi

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  url=$(jq -r '[.urls[] | select(.packagetype == "sdist")][0].url' <<<"${pypi_json}")
  sha=$(jq -r '[.urls[] | select(.packagetype == "sdist")][0].digests.sha256' <<<"${pypi_json}")

  if [ -z "${url}" ] || [ "${url}" = "null" ] || [ -z "${sha}" ] || [ "${sha}" = "null" ]; then
    echo "Failed to resolve sdist URL or sha256 for batrachian-toad ${latest}" >&2
    exit 1
  fi

  perl -0i -pe 's#^  url ".*batrachian_toad-[^"]+\.tar\.gz"#  url "'"${url}"'"#m; s#^  sha256 "[a-f0-9]{64}"#  sha256 "'"${sha}"'"#m' "${formula_path}"

  url_count=$(grep -F -c "${url}" "${formula_path}")
  sha_count=$(grep -F -c "sha256 \"${sha}\"" "${formula_path}")
  if [ "${url_count}" -ne 1 ] || [ "${sha_count}" -ne 1 ]; then
    echo "toad bump rewrite validation failed" >&2
    echo "URL_COUNT=${url_count} SHA_COUNT=${sha_count}" >&2
    exit 1
  fi

  add_bump_line "toad" "${current}" "${latest}"
}

bump_try() {
  local formula_path="Formula/try.rb"
  local latest
  local current
  local archive_url
  local sha
  local url_count
  local sha_count

  latest=$(curl -fsSL https://api.github.com/repos/tobi/try/tags | jq -r '.[0].name' | tr -d 'v')
  current=$(sed -nE 's#.*tags/v([0-9]+\.[0-9]+\.[0-9]+)\.tar\.gz.*#\1#p' "${formula_path}")

  if [ -z "${current}" ]; then
    echo "Failed to parse current try version from ${formula_path}" >&2
    exit 1
  fi

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  archive_url="https://github.com/tobi/try/archive/refs/tags/v${latest}.tar.gz"
  sha=$(curl -fsSL "${archive_url}" | shasum -a 256 | cut -d' ' -f1)
  if [ -z "${sha}" ] || ! [[ "${sha}" =~ ^[a-f0-9]{64}$ ]]; then
    echo "Failed to compute sha256 for ${archive_url}" >&2
    exit 1
  fi

  CURRENT_TRY_VERSION="${current}" LATEST_TRY_VERSION="${latest}" NEW_SHA="${sha}" \
    perl -0i -pe 's#tags/v\Q$ENV{CURRENT_TRY_VERSION}\E#tags/v$ENV{LATEST_TRY_VERSION}#g; s#^  sha256 "[a-f0-9]{64}"#  sha256 "$ENV{NEW_SHA}"#m' "${formula_path}"

  url_count=$(grep -F -c "tags/v${latest}.tar.gz" "${formula_path}")
  sha_count=$(grep -F -c "sha256 \"${sha}\"" "${formula_path}")
  if [ "${url_count}" -ne 1 ] || [ "${sha_count}" -ne 1 ]; then
    echo "try bump rewrite validation failed" >&2
    echo "URL_COUNT=${url_count} SHA_COUNT=${sha_count}" >&2
    exit 1
  fi

  add_bump_line "try" "${current}" "${latest}"
}

write_pr_body() {
  PR_BODY_PATH="${RUNNER_TEMP:-/tmp}/autobump-pr-body.md"

  {
    echo "**Version bumps:**"
    if [ "${#BUMP_LINES[@]}" -eq 0 ]; then
      echo "- none"
    else
      printf '%s\n' "${BUMP_LINES[@]}"
    fi
    echo
    echo "@o6uoq"
  } > "${PR_BODY_PATH}"
}

emit_outputs() {
  local changed="false"

  if ! git diff --quiet; then
    changed="true"
  fi

  if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "changed=${changed}" >> "${GITHUB_OUTPUT}"
    echo "pr_body_path=${PR_BODY_PATH}" >> "${GITHUB_OUTPUT}"
  fi

  echo "Autobump changed=${changed}"
}

main() {
  require_commands

  resolve_npm_policy

  if [ "${AUTOBUMP_RESOLVE_POLICY_ONLY:-}" = "1" ]; then
    return
  fi

  validate_npm_min_release_age_support

  bump_agent_scan
  bump_npm_formula "context-mode" "Formula/context-mode.rb" "context-mode"
  bump_npm_formula "openspec" "Formula/openspec.rb" "@fission-ai/openspec"
  bump_npm_formula "skills" "Formula/skills.rb" "skills"
  bump_npm_formula "slidev" "Formula/slidev.rb" "@slidev/cli"
  bump_fuzmit
  bump_npm_formula "jira-cli" "Formula/jira-cli.rb" "jira-cl"
  bump_toad
  bump_try
  bump_npm_formula "tmux-ide" "Formula/tmux-ide.rb" "tmux-ide"

  write_pr_body
  emit_outputs
}

main "$@"
