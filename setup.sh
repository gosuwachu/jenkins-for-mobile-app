#!/bin/bash
set -e

echo "==================================="
echo "Jenkins CI/CD Test Environment Setup"
echo "==================================="

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Clone repositories (skip if already present)
REPOS=(
    "git@github.com:gosuwachu/jenkins-setup.git"
    "git@github.com:gosuwachu/mobile-app.git"
    "git@github.com:gosuwachu/mobile-app-ci.git"
    "git@github.com:gosuwachu/ci-dashboard.git"
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
./jenkins-setup/scripts/start.sh

echo ""
echo "==================================="
echo "What to do next"
echo "==================================="
echo ""
echo "1. Open Jenkins in your browser:"
echo "   http://localhost:8080  (admin / admin)"
echo ""
echo "2. Open a PR against the app repo to trigger the pipeline:"
echo "   https://github.com/gosuwachu/mobile-app/compare"
echo ""
