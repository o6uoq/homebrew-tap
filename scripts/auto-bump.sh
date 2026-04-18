#!/usr/bin/env bash
set -euo pipefail

MIN_RELEASE_AGE_DAYS=""
PR_BODY_PATH=""
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
  for cmd in curl jq perl npm shasum grep sed mktemp head git; do
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

  node_helper_source=$(curl -fsSL https://raw.githubusercontent.com/Homebrew/brew/HEAD/Library/Homebrew/language/node.rb)
  MIN_RELEASE_AGE_DAYS=$(sed -nE 's/.*--min-release-age=([0-9]+).*/\1/p' <<<"${node_helper_source}" | head -n 1)

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

bump_agent_scan() {
  local formula_path="Formula/agent-scan.rb"
  local release_json
  local latest
  local current
  local mac_sha
  local linux_sha
  local mac_url_expect
  local linux_url_expect
  local mac_url_count
  local linux_url_count
  local version_count
  local mac_sha_count
  local linux_sha_count

  release_json=$(curl -fsSL https://api.github.com/repos/snyk/agent-scan/releases/latest)
  latest=$(jq -r '.tag_name' <<<"${release_json}" | tr -d 'v')
  current=$(sed -nE 's#^  version "([0-9]+\.[0-9]+\.[0-9]+)"#\1#p' "${formula_path}")

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  mac_sha=$(jq -r --arg ver "${latest}" '.assets[] | select(.name == ("agent-scan-" + $ver + "-macos-arm64")) | .digest' <<<"${release_json}" | sed 's/^sha256://')
  linux_sha=$(jq -r --arg ver "${latest}" '.assets[] | select(.name == ("agent-scan-" + $ver + "-linux-x86_64")) | .digest' <<<"${release_json}" | sed 's/^sha256://')

  if [ -z "${mac_sha}" ] || [ -z "${linux_sha}" ] || [ "${mac_sha}" = "null" ] || [ "${linux_sha}" = "null" ]; then
    echo "Failed to resolve release checksums for agent-scan ${latest}" >&2
    exit 1
  fi

  perl -0i -pe '
    s#^  version "[0-9]+\.[0-9]+\.[0-9]+"#  version "'"${latest}"'"#m;
    s#/releases/download/v[0-9]+\.[0-9]+\.[0-9]+/#/releases/download/v'"${latest}"'/#g;
    s#agent-scan-[0-9]+\.[0-9]+\.[0-9]+-macos-arm64#agent-scan-'"${latest}"'-macos-arm64#g;
    s#agent-scan-[0-9]+\.[0-9]+\.[0-9]+-linux-x86_64#agent-scan-'"${latest}"'-linux-x86_64#g;
    s#(macos-arm64"\n      sha256 ")[a-f0-9]{64}"#${1}'"${mac_sha}"'"#m;
    s#(linux-x86_64"\n      sha256 ")[a-f0-9]{64}"#${1}'"${linux_sha}"'"#m;
  ' "${formula_path}"

  mac_url_expect="releases/download/v${latest}/agent-scan-${latest}-macos-arm64"
  linux_url_expect="releases/download/v${latest}/agent-scan-${latest}-linux-x86_64"
  mac_url_count=$(grep -F -c "${mac_url_expect}" "${formula_path}")
  linux_url_count=$(grep -F -c "${linux_url_expect}" "${formula_path}")
  version_count=$(grep -F -c "version \"${latest}\"" "${formula_path}")
  mac_sha_count=$(grep -F -c "sha256 \"${mac_sha}\"" "${formula_path}")
  linux_sha_count=$(grep -F -c "sha256 \"${linux_sha}\"" "${formula_path}")

  if [ "${mac_url_count}" -ne 1 ] || [ "${linux_url_count}" -ne 1 ] || [ "${version_count}" -ne 1 ] || [ "${mac_sha_count}" -ne 1 ] || [ "${linux_sha_count}" -ne 1 ]; then
    echo "agent-scan bump rewrite validation failed" >&2
    echo "MAC_URL_COUNT=${mac_url_count} LINUX_URL_COUNT=${linux_url_count} VERSION_COUNT=${version_count} MAC_SHA_COUNT=${mac_sha_count} LINUX_SHA_COUNT=${linux_sha_count}" >&2
    exit 1
  fi

  add_bump_line "agent-scan" "${current}" "${latest}"
}

bump_fuzmit() {
  local formula_path="Formula/fuzmit.rb"
  local latest
  local current
  local checksums
  local darwin_amd64_sha
  local darwin_arm64_sha
  local linux_amd64_sha
  local linux_arm64_sha
  local version_count
  local darwin_amd64_url_count
  local darwin_arm64_url_count
  local linux_amd64_url_count
  local linux_arm64_url_count
  local darwin_amd64_sha_count
  local darwin_arm64_sha_count
  local linux_amd64_sha_count
  local linux_arm64_sha_count

  latest=$(curl -fsSL https://api.github.com/repos/o6uoq/fuzmit/releases/latest | jq -r '.tag_name' | tr -d 'v')
  current=$(sed -nE 's#^  version "([0-9]+\.[0-9]+\.[0-9]+)"#\1#p' "${formula_path}")

  if [ "${latest}" = "${current}" ]; then
    return
  fi

  checksums=$(curl -fsSL "https://github.com/o6uoq/fuzmit/releases/download/v${latest}/checksums.txt")

  darwin_amd64_sha=$(echo "${checksums}" | grep "darwin_amd64" | cut -d' ' -f1)
  darwin_arm64_sha=$(echo "${checksums}" | grep "darwin_arm64" | cut -d' ' -f1)
  linux_amd64_sha=$(echo "${checksums}" | grep "linux_amd64" | cut -d' ' -f1)
  linux_arm64_sha=$(echo "${checksums}" | grep "linux_arm64" | cut -d' ' -f1)

  for value in "${darwin_amd64_sha}" "${darwin_arm64_sha}" "${linux_amd64_sha}" "${linux_arm64_sha}"; do
    if [ -z "${value}" ] || ! echo "${value}" | grep -qE '^[a-f0-9]{64}$'; then
      echo "Invalid checksum for fuzmit release ${latest}" >&2
      exit 1
    fi
  done

  perl -0i -pe '
    s#^  version "[0-9]+\.[0-9]+\.[0-9]+"#  version "'"${latest}"'"#m;
    s#fuzmit_[0-9]+\.[0-9]+\.[0-9]+_darwin_amd64#fuzmit_'"${latest}"'_darwin_amd64#g;
    s#fuzmit_[0-9]+\.[0-9]+\.[0-9]+_darwin_arm64#fuzmit_'"${latest}"'_darwin_arm64#g;
    s#fuzmit_[0-9]+\.[0-9]+\.[0-9]+_linux_amd64#fuzmit_'"${latest}"'_linux_amd64#g;
    s#fuzmit_[0-9]+\.[0-9]+\.[0-9]+_linux_arm64#fuzmit_'"${latest}"'_linux_arm64#g;
    s#/v[0-9]+\.[0-9]+\.[0-9]+/#/v'"${latest}"'/#g;
    s#(darwin_amd64\.tar\.gz"\n      sha256 ")[a-f0-9]{64}"#${1}'"${darwin_amd64_sha}"'"#m;
    s#(darwin_arm64\.tar\.gz"\n      sha256 ")[a-f0-9]{64}"#${1}'"${darwin_arm64_sha}"'"#m;
    s#(linux_amd64\.tar\.gz"\n      sha256 ")[a-f0-9]{64}"#${1}'"${linux_amd64_sha}"'"#m;
    s#(linux_arm64\.tar\.gz"\n      sha256 ")[a-f0-9]{64}"#${1}'"${linux_arm64_sha}"'"#m;
  ' "${formula_path}"

  version_count=$(grep -F -c "version \"${latest}\"" "${formula_path}")
  darwin_amd64_url_count=$(grep -F -c "releases/download/v${latest}/fuzmit_${latest}_darwin_amd64.tar.gz" "${formula_path}")
  darwin_arm64_url_count=$(grep -F -c "releases/download/v${latest}/fuzmit_${latest}_darwin_arm64.tar.gz" "${formula_path}")
  linux_amd64_url_count=$(grep -F -c "releases/download/v${latest}/fuzmit_${latest}_linux_amd64.tar.gz" "${formula_path}")
  linux_arm64_url_count=$(grep -F -c "releases/download/v${latest}/fuzmit_${latest}_linux_arm64.tar.gz" "${formula_path}")
  darwin_amd64_sha_count=$(grep -F -c "sha256 \"${darwin_amd64_sha}\"" "${formula_path}")
  darwin_arm64_sha_count=$(grep -F -c "sha256 \"${darwin_arm64_sha}\"" "${formula_path}")
  linux_amd64_sha_count=$(grep -F -c "sha256 \"${linux_amd64_sha}\"" "${formula_path}")
  linux_arm64_sha_count=$(grep -F -c "sha256 \"${linux_arm64_sha}\"" "${formula_path}")

  if [ "${version_count}" -ne 1 ] || [ "${darwin_amd64_url_count}" -ne 1 ] || [ "${darwin_arm64_url_count}" -ne 1 ] || [ "${linux_amd64_url_count}" -ne 1 ] || [ "${linux_arm64_url_count}" -ne 1 ] || [ "${darwin_amd64_sha_count}" -ne 1 ] || [ "${darwin_arm64_sha_count}" -ne 1 ] || [ "${linux_amd64_sha_count}" -ne 1 ] || [ "${linux_arm64_sha_count}" -ne 1 ]; then
    echo "fuzmit bump rewrite validation failed" >&2
    echo "VERSION_COUNT=${version_count} DARWIN_AMD64_URL_COUNT=${darwin_amd64_url_count} DARWIN_ARM64_URL_COUNT=${darwin_arm64_url_count} LINUX_AMD64_URL_COUNT=${linux_amd64_url_count} LINUX_ARM64_URL_COUNT=${linux_arm64_url_count} DARWIN_AMD64_SHA_COUNT=${darwin_amd64_sha_count} DARWIN_ARM64_SHA_COUNT=${darwin_arm64_sha_count} LINUX_AMD64_SHA_COUNT=${linux_amd64_sha_count} LINUX_ARM64_SHA_COUNT=${linux_arm64_sha_count}" >&2
    exit 1
  fi

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
  validate_npm_min_release_age_support

  bump_agent_scan
  bump_npm_formula "openspec" "Formula/openspec.rb" "@fission-ai/openspec"
  bump_npm_formula "paperclip" "Formula/paperclip.rb" "paperclipai"
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
