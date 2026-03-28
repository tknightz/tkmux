#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

tmux set -g status-left "#(lua ${CURRENT_DIR}/scripts/run.lua status-left)"
tmux set -g status-right "#(lua ${CURRENT_DIR}/scripts/run.lua status-right)"

# Optional window formats
tmux set -g window-status-current-format "#(lua ${CURRENT_DIR}/scripts/run.lua window-active)"
tmux set -g window-status-format "#(lua ${CURRENT_DIR}/scripts/run.lua window-common)"
