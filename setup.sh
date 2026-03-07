#!/bin/bash
set -e

echo "==================================="
echo "Jenkins CI/CD Test Environment Setup"
echo "==================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Clone repositories (skip if already present)
REPOS=(
    "git@github.com:gosuwachu/jenkinsfiles-test.git"
    "git@github.com:gosuwachu/jenkinsfiles-test-app.git"
    "git@github.com:gosuwachu/jenkinsfiles-test-app-ci.git"
)

echo ""
echo "Cloning repositories..."
for repo in "${REPOS[@]}"; do
    dir=$(basename "$repo" .git)
    if [ -d "$dir" ]; then
        echo "  $dir/ already exists — skipping"
    else
        echo "  Cloning $dir..."
        git clone "$repo"
    fi
done

# Start Jenkins
echo ""
echo "Starting Jenkins..."
./jenkinsfiles-test/scripts/start.sh

echo ""
echo "==================================="
echo "What to do next"
echo "==================================="
echo ""
echo "1. Open Jenkins in your browser:"
echo "   http://localhost:8080  (admin / admin)"
echo ""
echo "2. Open a PR against the app repo to trigger the pipeline:"
echo "   https://github.com/gosuwachu/jenkinsfiles-test-app/compare"
echo ""
