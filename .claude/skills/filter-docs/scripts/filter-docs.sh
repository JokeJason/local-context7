#!/bin/bash

# AI-assisted documentation filter
# Generates a review manifest for Claude to evaluate which docs to keep
#
# Usage:
#   ./filter-docs.sh [manifest-name]   # Filter specific manifest output
#   ./filter-docs.sh                   # Filter all manifest outputs
#
# Outputs: output/<manifest>/._review.json
# Claude reviews this and creates: output/<manifest>/._delete.txt

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/output"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Number of lines to preview from each file
PREVIEW_LINES=10

generate_review() {
    local manifest_dir="$1"
    local manifest_name=$(basename "$manifest_dir")
    local review_file="$manifest_dir/._review.json"

    echo -e "${YELLOW}Generating review for: $manifest_name${NC}"

    # Find all markdown files
    local files=$(find "$manifest_dir" -type f \( -name "*.md" -o -name "*.mdx" \) ! -name "._*")
    local file_count=$(echo "$files" | grep -c . || echo 0)

    if [ "$file_count" -eq 0 ]; then
        echo -e "  ${YELLOW}No files to review${NC}"
        return 0
    fi

    echo "  Found $file_count files to review"

    # Start JSON array
    echo "[" > "$review_file"

    local first=true
    while IFS= read -r file; do
        [ -z "$file" ] && continue

        local rel_path="${file#$manifest_dir/}"
        local filename=$(basename "$file")
        local file_size=$(wc -c < "$file" | tr -d ' ')
        local line_count=$(wc -l < "$file" | tr -d ' ')

        # Get first N lines as preview
        local preview=$(head -n $PREVIEW_LINES "$file" | jq -Rs '.')

        # Add comma separator
        if [ "$first" = true ]; then
            first=false
        else
            echo "," >> "$review_file"
        fi

        # Write file entry
        cat >> "$review_file" << EOF
  {
    "path": "$rel_path",
    "filename": "$filename",
    "size_bytes": $file_size,
    "line_count": $line_count,
    "preview": $preview
  }
EOF
    done <<< "$files"

    echo "" >> "$review_file"
    echo "]" >> "$review_file"

    echo -e "  ${GREEN}Review file created: $review_file${NC}"
    echo ""
}

apply_deletions() {
    local manifest_dir="$1"
    local manifest_name=$(basename "$manifest_dir")
    local delete_file="$manifest_dir/._delete.txt"

    if [ ! -f "$delete_file" ]; then
        return 0
    fi

    echo -e "${YELLOW}Applying deletions for: $manifest_name${NC}"

    local deleted=0
    while IFS= read -r rel_path; do
        [ -z "$rel_path" ] && continue
        [[ "$rel_path" == \#* ]] && continue  # Skip comments

        local file="$manifest_dir/$rel_path"
        if [ -f "$file" ]; then
            rm "$file"
            ((deleted++))
        fi
    done < "$delete_file"

    echo -e "  ${GREEN}Deleted $deleted files${NC}"

    # Clean up empty directories
    find "$manifest_dir" -type d -empty -delete 2>/dev/null || true

    # Remove the delete file
    rm "$delete_file"

    echo ""
}

main() {
    local target="$1"

    echo "========================================"
    echo "AI Documentation Filter"
    echo "========================================"
    echo ""

    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required${NC}"
        exit 1
    fi

    # Determine which directories to process
    local dirs=()
    if [ -n "$target" ]; then
        if [ -d "$OUTPUT_DIR/$target" ]; then
            dirs+=("$OUTPUT_DIR/$target")
        else
            echo -e "${RED}Error: $OUTPUT_DIR/$target not found${NC}"
            exit 1
        fi
    else
        for dir in "$OUTPUT_DIR"/*/; do
            [ -d "$dir" ] && dirs+=("${dir%/}")
        done
    fi

    if [ ${#dirs[@]} -eq 0 ]; then
        echo -e "${YELLOW}No output directories found. Run download-docs first.${NC}"
        exit 0
    fi

    # First apply any pending deletions
    for dir in "${dirs[@]}"; do
        apply_deletions "$dir"
    done

    # Then generate new review files
    for dir in "${dirs[@]}"; do
        generate_review "$dir"
    done

    echo "========================================"
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. Review the ._review.json files in each output directory"
    echo "2. Create ._delete.txt with paths of files to remove (one per line)"
    echo "3. Run this script again to apply deletions"
    echo ""
    echo "Or ask Claude to review and filter the files for you!"
    echo "========================================"
}

main "$@"
