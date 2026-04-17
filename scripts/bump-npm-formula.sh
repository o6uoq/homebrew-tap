#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <formula-path> <npm-package-name>" >&2
  exit 1
fi

FORMULA_PATH="$1"
PACKAGE_NAME="$2"
MIN_RELEASE_AGE_DAYS="${MIN_RELEASE_AGE_DAYS:-}"

if [ -z "${MIN_RELEASE_AGE_DAYS}" ] || ! [[ "${MIN_RELEASE_AGE_DAYS}" =~ ^[0-9]+$ ]]; then
  echo "MIN_RELEASE_AGE_DAYS must be a non-negative integer; got '${MIN_RELEASE_AGE_DAYS}'" >&2
  exit 1
fi

CURRENT_URL=$(sed -nE 's#^  url "([^"]+)"#\1#p' "${FORMULA_PATH}")
if [ -z "${CURRENT_URL}" ]; then
  echo "failed to parse url from ${FORMULA_PATH}" >&2
  exit 1
fi

CURRENT_VERSION=$(sed -nE 's#^  url ".*-([0-9A-Za-z][0-9A-Za-z.+-]*)\.tgz"#\1#p' "${FORMULA_PATH}")
if [ -z "${CURRENT_VERSION}" ]; then
  echo "failed to parse current npm version from ${FORMULA_PATH}" >&2
  exit 1
fi

LATEST_VERSION=$(curl -fsSL "https://registry.npmjs.org/${PACKAGE_NAME}/latest" | jq -r '.version')
if [ -z "${LATEST_VERSION}" ] || [ "${LATEST_VERSION}" = "null" ]; then
  echo "failed to resolve latest version for ${PACKAGE_NAME}" >&2
  exit 1
fi

if [ "${LATEST_VERSION}" = "${CURRENT_VERSION}" ]; then
  exit 0
fi

SUFFIX="-${CURRENT_VERSION}.tgz"
if [[ "${CURRENT_URL}" != *"${SUFFIX}" ]]; then
  echo "formula url '${CURRENT_URL}' does not end with expected suffix '${SUFFIX}'" >&2
  exit 1
fi
CANDIDATE_URL="${CURRENT_URL%${SUFFIX}}-${LATEST_VERSION}.tgz"

TMP_DIR=$(mktemp -d)
trap 'rm -rf "${TMP_DIR}"' EXIT
NPM_LOG="${TMP_DIR}/npm-install.log"

set +e
npm install \
  --loglevel=silly \
  --global \
  --build-from-source \
  "--min-release-age=${MIN_RELEASE_AGE_DAYS}" \
  "--cache=${TMP_DIR}/npm_cache" \
  "--prefix=${TMP_DIR}/prefix" \
  "${CANDIDATE_URL}" \
  --ignore-scripts \
  > "${NPM_LOG}" 2>&1
NPM_STATUS=$?
set -e

if [ "${NPM_STATUS}" -ne 0 ]; then
  if grep -Eq 'with a date before' "${NPM_LOG}"; then
    echo "Skipping ${PACKAGE_NAME}@${LATEST_VERSION}: npm min-release-age=${MIN_RELEASE_AGE_DAYS} not satisfied yet."
    exit 0
  fi

  echo "npm preflight failed for ${PACKAGE_NAME}@${LATEST_VERSION}" >&2
  tail -n 80 "${NPM_LOG}" >&2
  exit "${NPM_STATUS}"
fi

SHA=$(curl -fsSL "${CANDIDATE_URL}" | shasum -a 256 | cut -d' ' -f1)
if [ -z "${SHA}" ] || ! [[ "${SHA}" =~ ^[a-f0-9]{64}$ ]]; then
  echo "failed to compute sha256 for ${CANDIDATE_URL}" >&2
  exit 1
fi

CURRENT_URL="${CURRENT_URL}" CANDIDATE_URL="${CANDIDATE_URL}" \
  perl -0i -pe 's/\Q$ENV{CURRENT_URL}\E/$ENV{CANDIDATE_URL}/g' "${FORMULA_PATH}"
perl -0i -pe 's#^  sha256 "[a-f0-9]{64}"#  sha256 "'"${SHA}"'"#m' "${FORMULA_PATH}"

echo "bumped=${CURRENT_VERSION} → ${LATEST_VERSION}" >> "${GITHUB_OUTPUT}"
