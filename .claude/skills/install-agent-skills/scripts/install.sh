#!/bin/bash

# Simple utility to symlink or copy a skill to a target directory
# Usage: ./install.sh <source_skill_dir> <target_skills_dir> [--copy]
#
# Examples:
#   ./install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills
#   ./install.sh dotfiles/codex/skills/codex-docs ~/.codex/skills --copy

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

show_help() {
    echo "Usage: install.sh <source_skill_dir> <target_skills_dir> [--copy]"
    echo ""
    echo "Arguments:"
    echo "  source_skill_dir   Path to skill directory (e.g., dotfiles/claude/skills/codex-docs)"
    echo "  target_skills_dir  Target skills directory (e.g., ~/.claude/skills)"
    echo ""
    echo "Options:"
    echo "  --copy    Copy instead of symlink (default: symlink)"
}

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ -z "$1" ] || [ -z "$2" ]; then
    show_help
    exit 0
fi

SOURCE_SKILL="$1"
TARGET_DIR="$2"
USE_COPY=false

if [ "$3" = "--copy" ]; then
    USE_COPY=true
fi

# Validate source exists
if [ ! -d "$SOURCE_SKILL" ]; then
    echo "Error: Source skill directory not found: $SOURCE_SKILL"
    exit 1
fi

# Get skill name from source path
SKILL_NAME=$(basename "$SOURCE_SKILL")
TARGET_SKILL="$TARGET_DIR/$SKILL_NAME"

# Resolve source to absolute path for symlink
SOURCE_ABSOLUTE=$(cd "$SOURCE_SKILL" && pwd)

# Create target directory if needed
mkdir -p "$TARGET_DIR"

# Remove existing target
if [ -e "$TARGET_SKILL" ] || [ -L "$TARGET_SKILL" ]; then
    rm -rf "$TARGET_SKILL"
fi

# Install
if [ "$USE_COPY" = true ]; then
    cp -r "$SOURCE_ABSOLUTE" "$TARGET_SKILL"
    echo -e "${GREEN}✓${NC} Copied $SKILL_NAME -> $TARGET_SKILL"
else
    ln -s "$SOURCE_ABSOLUTE" "$TARGET_SKILL"
    echo -e "${GREEN}✓${NC} Symlinked $SKILL_NAME -> $TARGET_SKILL"
fi
