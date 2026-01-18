#!/bin/bash

# Utility to install a skill to a target directory
# Creates symlinks to shared docs at install time
#
# Usage: ./install.sh <source_skill_dir> <target_skills_dir> [--copy]
#
# Examples:
#   ./install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills
#   ./install.sh dotfiles/codex/skills/codex-docs ~/.codex/skills --copy
#
# The script expects this structure:
#   dotfiles/
#   ├── shared/<skill-name>/     # Shared docs
#   └── <agent>/skills/<skill-name>/SKILL.md

set -e

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

show_help() {
    echo "Usage: install.sh <source_skill_dir> <target_skills_dir> [--copy]"
    echo ""
    echo "Arguments:"
    echo "  source_skill_dir   Path to skill directory (e.g., dotfiles/claude/skills/codex-docs)"
    echo "  target_skills_dir  Target skills directory (e.g., ~/.claude/skills)"
    echo ""
    echo "Options:"
    echo "  --copy    Copy docs instead of symlink (creates standalone copy)"
    echo ""
    echo "Notes:"
    echo "  - Default mode creates symlinks to shared docs"
    echo "  - Shared docs are expected at dotfiles/shared/<skill-name>/"
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
    echo -e "${RED}Error:${NC} Source skill directory not found: $SOURCE_SKILL"
    exit 1
fi

# Get skill name from source path
SKILL_NAME=$(basename "$SOURCE_SKILL")
TARGET_SKILL="$TARGET_DIR/$SKILL_NAME"

# Resolve source to absolute path
SOURCE_ABSOLUTE=$(cd "$SOURCE_SKILL" && pwd)

# Find shared docs: go up to dotfiles/ and look in shared/
# Path: dotfiles/<agent>/skills/<skill-name> -> dotfiles/shared/<skill-name>
DOTFILES_DIR=$(cd "$SOURCE_ABSOLUTE/../../.." && pwd)
SHARED_DOCS="$DOTFILES_DIR/shared/$SKILL_NAME"

# Validate shared docs exist
if [ ! -d "$SHARED_DOCS" ]; then
    echo -e "${RED}Error:${NC} Shared docs not found: $SHARED_DOCS"
    exit 1
fi

# Create target directory if needed
mkdir -p "$TARGET_DIR"

# Remove existing target
if [ -e "$TARGET_SKILL" ] || [ -L "$TARGET_SKILL" ]; then
    rm -rf "$TARGET_SKILL"
fi

# Install
mkdir -p "$TARGET_SKILL"

# Copy SKILL.md and any other files (except references/)
for item in "$SOURCE_ABSOLUTE"/*; do
    [ -e "$item" ] || continue
    item_name=$(basename "$item")
    if [ "$item_name" != "references" ]; then
        cp -r "$item" "$TARGET_SKILL/"
    fi
done

if [ "$USE_COPY" = true ]; then
    # Copy mode: copy actual docs
    cp -r "$SHARED_DOCS" "$TARGET_SKILL/references"
    echo -e "${GREEN}✓${NC} Installed $SKILL_NAME -> $TARGET_SKILL (copied docs)"
else
    # Symlink mode: create symlink to shared docs
    ln -s "$SHARED_DOCS" "$TARGET_SKILL/references"
    echo -e "${GREEN}✓${NC} Installed $SKILL_NAME -> $TARGET_SKILL (references -> $SHARED_DOCS)"
fi
