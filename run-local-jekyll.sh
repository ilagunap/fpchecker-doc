#!/usr/bin/env bash
set -euo pipefail

ENV_NAME="tutorial_env"
CONDA_ROOT="/opt/anaconda3"
JEKYLL_DIR="/Users/lagunaperalt1/projects/jekyll_projects/fpchecker/documentation-theme-jekyll"
BUNDLER_VERSION="2.2.25"
JEKYLL_HOST="${JEKYLL_HOST:-127.0.0.1}"
JEKYLL_PORT="${JEKYLL_PORT:-4000}"
ENABLE_LIVERELOAD="${ENABLE_LIVERELOAD:-0}"
LIVERELOAD_PORT="${LIVERELOAD_PORT:-35730}"

# Conda hook scripts can reference optional shell vars; keep nounset off briefly.
set +u
if [[ -f "${CONDA_ROOT}/etc/profile.d/conda.sh" ]]; then
  # Needed so "conda activate" works in non-interactive shells.
  source "${CONDA_ROOT}/etc/profile.d/conda.sh"
else
  echo "Could not find conda.sh at ${CONDA_ROOT}/etc/profile.d/conda.sh" >&2
  exit 1
fi

conda activate "${ENV_NAME}"
set -u
export PATH="${CONDA_ROOT}/envs/${ENV_NAME}/bin:${PATH}"

# Force absolute compiler paths so native gems can build reliably in Conda.
export CC="${CONDA_ROOT}/envs/${ENV_NAME}/bin/arm64-apple-darwin20.0.0-clang"
export CXX="${CONDA_ROOT}/envs/${ENV_NAME}/bin/arm64-apple-darwin20.0.0-clang++"
export CPP="${CC} -E"

cd "${JEKYLL_DIR}"

mkdir -p .bundle-home .bundle-cache .bundle vendor/bundle
export BUNDLE_USER_HOME="${PWD}/.bundle-home"
export BUNDLE_USER_CACHE="${PWD}/.bundle-cache"
export BUNDLE_APP_CONFIG="${PWD}/.bundle"
export BUNDLE_PATH="${PWD}/vendor/bundle"

if ! bundle "_${BUNDLER_VERSION}_" -v >/dev/null 2>&1; then
  echo "Installing bundler ${BUNDLER_VERSION} in ${ENV_NAME}..."
  gem install bundler -v "${BUNDLER_VERSION}"
fi

echo "Installing Jekyll gems (if needed)..."
bundle "_${BUNDLER_VERSION}_" install

if [[ "${ENABLE_LIVERELOAD}" == "1" ]]; then
  echo "Starting Jekyll at http://${JEKYLL_HOST}:${JEKYLL_PORT} (livereload on :${LIVERELOAD_PORT})"
  exec bundle "_${BUNDLER_VERSION}_" exec jekyll serve --livereload --livereload_port "${LIVERELOAD_PORT}" --host "${JEKYLL_HOST}" --port "${JEKYLL_PORT}"
fi

echo "Starting Jekyll at http://${JEKYLL_HOST}:${JEKYLL_PORT}"
exec bundle "_${BUNDLER_VERSION}_" exec jekyll serve --host "${JEKYLL_HOST}" --port "${JEKYLL_PORT}"
