#!/bin/sh
# Link the skill into Claude Code. `git pull` then keeps it current.
set -eu
src="$(cd "$(dirname "$0")" && pwd)/skill/ads-taste"
mkdir -p "$HOME/.claude/skills"
ln -sfn "$src" "$HOME/.claude/skills/ads-taste"
echo "linked $HOME/.claude/skills/ads-taste -> $src"
