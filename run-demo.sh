#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]]; then
  echo "Usage: $0 <repo-url>" >&2
  echo "  e.g. $0 https://github.com/ironsh/actions-demo" >&2
  exit 1
fi

REPO_URL="$1"
OWNER_REPO="${REPO_URL#https://github.com/}"

echo "Fetching runner registration token..."
RUNNER_TOKEN=$(gh api "repos/${OWNER_REPO}/actions/runners/registration-token" --method POST --jq '.token')

echo "Generating CA (if needed)..."
./generate-ca.sh

echo "Starting docker compose..."
RUNNER_TOKEN="$RUNNER_TOKEN" RUNNER_REPO="$REPO_URL" docker compose up --build
