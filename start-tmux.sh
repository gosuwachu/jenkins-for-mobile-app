#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "$0")" && pwd)"
SESSION="jenkins-mobile"

if ! tmux has-session -t "$SESSION" 2>/dev/null; then
    tmux new-session -d -s "$SESSION" -n claude-1 -c "$DIR"
    tmux send-keys -t "$SESSION:claude-1" "claude" Enter

    tmux new-window -t "$SESSION" -n claude-2 -c "$DIR"
    tmux send-keys -t "$SESSION:claude-2" "claude" Enter

    tmux new-window -t "$SESSION" -n root -c "$DIR"
    tmux new-window -t "$SESSION" -n ci-dashboard -c "$DIR/ci-dashboard"
    tmux new-window -t "$SESSION" -n jenkins-setup -c "$DIR/jenkins-setup"
    tmux new-window -t "$SESSION" -n mobile-app -c "$DIR/mobile-app"
    tmux new-window -t "$SESSION" -n mobile-app-ci -c "$DIR/mobile-app-ci"

    tmux select-window -t "$SESSION:claude-1"
fi

if [ -n "${TMUX:-}" ]; then
    tmux switch-client -t "$SESSION"
else
    tmux attach-session -t "$SESSION"
fi
