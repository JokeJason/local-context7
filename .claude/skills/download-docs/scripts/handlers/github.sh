#!/bin/bash

# Handler for GitHub repository sources
# Uses sparse checkout to only download markdown files (fast for large repos)
#
# Manifest format:
# {
#     "_source": {
#         "type": "github",
#         "repo": "owner/repo-name",
#         "branch": "main",
#         "path": "docs",
#         "extensions": [".md", ".mdx"],
#         "exclude": ["CHANGELOG*", "CONTRIBUTING*", "**/test/**"]
#     }
# }

# Default exclude patterns for common non-documentation files
DEFAULT_EXCLUDES=(
    "CHANGELOG*"
    "CHANGE_LOG*"
    "CHANGES*"
    "CONTRIBUTING*"
    "LICENSE*"
    "SECURITY*"
    "CODE_OF_CONDUCT*"
    "CODEOWNERS*"
    ".github/**"
    "**/test/**"
    "**/tests/**"
    "**/__tests__/**"
    "**/spec/**"
    "**/fixtures/**"
    "**/node_modules/**"
)

should_exclude() {
    local file="$1"
    local rel_path="$2"
    shift 2
    local patterns=("$@")

    local filename=$(basename "$file")

    for pattern in "${patterns[@]}"; do
        # Check if pattern matches filename or relative path
        if [[ "$filename" == $pattern ]] || [[ "$rel_path" == $pattern ]]; then
            return 0  # Should exclude
        fi

        # Handle glob patterns with **
        if [[ "$pattern" == *"**"* ]]; then
            # Convert ** glob to regex-friendly pattern
            local regex_pattern=$(echo "$pattern" | sed 's/\*\*/.*/' | sed 's/\*/[^\/]*/')
            if [[ "$rel_path" =~ $regex_pattern ]]; then
                return 0
            fi
        fi
    done

    return 1  # Should not exclude
}

download_from_github() {
    local manifest_file="$1"
    local output_dir="$2"
    local manifest_name=$(basename "$manifest_file" .json)
    local manifest_output_dir="$output_dir/$manifest_name"

    # Check if manifest is disabled
    local disabled=$(jq -r '._source._disabled // false' "$manifest_file")
    if [ "$disabled" = "true" ]; then
        local reason=$(jq -r '._source._reason // "No reason provided"' "$manifest_file")
        echo -e "${YELLOW}Skipping: $manifest_name (disabled)${NC}"
        echo -e "  Reason: $reason"
        echo ""
        return 0
    fi

    # Extract GitHub source config
    local repo=$(jq -r '._source.repo' "$manifest_file")
    local branch=$(jq -r '._source.branch // "main"' "$manifest_file")
    local path=$(jq -r '._source.path // "."' "$manifest_file")

    # Get extensions array, default to .md and .mdx
    local extensions=$(jq -r '._source.extensions // [".md", ".mdx"] | .[]' "$manifest_file")

    # Get custom exclude patterns (if any)
    local custom_excludes=$(jq -r '._source.exclude // [] | .[]' "$manifest_file" 2>/dev/null)

    # Check if default excludes should be disabled
    local no_default_excludes=$(jq -r '._source.noDefaultExcludes // false' "$manifest_file")

    # Build exclude list
    local -a exclude_patterns
    if [ "$no_default_excludes" != "true" ]; then
        exclude_patterns=("${DEFAULT_EXCLUDES[@]}")
    fi
    while IFS= read -r pattern; do
        [ -n "$pattern" ] && exclude_patterns+=("$pattern")
    done <<< "$custom_excludes"

    echo -e "${YELLOW}Processing: $manifest_name (GitHub: $repo)${NC}"
    echo "  Branch: $branch"
    echo "  Path: $path"
    echo "  Extensions: $(echo $extensions | tr '\n' ' ')"
    if [ ${#exclude_patterns[@]} -gt 0 ]; then
        echo "  Excludes: ${#exclude_patterns[@]} patterns"
    fi

    # Create temp directory for sparse clone
    local temp_dir=$(mktemp -d)
    trap "rm -rf $temp_dir" RETURN

    # Initialize sparse checkout
    echo -n "  Initializing sparse checkout... "
    cd "$temp_dir"

    if ! git init -q 2>/dev/null; then
        echo -e "${RED}FAILED (git init)${NC}"
        return 1
    fi

    git remote add origin "https://github.com/$repo.git" 2>/dev/null
    git config core.sparseCheckout true 2>/dev/null

    # Build sparse-checkout patterns for extensions
    local sparse_file="$temp_dir/.git/info/sparse-checkout"
    for ext in $extensions; do
        if [ "$path" = "." ]; then
            echo "**/*$ext" >> "$sparse_file"
        else
            echo "$path/**/*$ext" >> "$sparse_file"
        fi
    done

    echo -e "${GREEN}OK${NC}"

    # Fetch only the branch we need with depth 1
    echo -n "  Fetching files... "
    if git fetch --depth 1 origin "$branch" -q 2>/dev/null && git checkout "$branch" -q 2>/dev/null; then
        echo -e "${GREEN}OK${NC}"
    else
        echo -e "${RED}FAILED${NC}"
        echo -e "  ${RED}Could not fetch from https://github.com/$repo.git${NC}"
        cd - > /dev/null
        return 1
    fi

    cd - > /dev/null

    # Determine source path
    local source_path="$temp_dir"
    if [ "$path" != "." ]; then
        source_path="$temp_dir/$path"
    fi

    # Build find command for extensions
    local find_args=()
    local first=true
    for ext in $extensions; do
        if [ "$first" = true ]; then
            find_args+=(-name "*$ext")
            first=false
        else
            find_args+=(-o -name "*$ext")
        fi
    done

    # Find all matching files
    local files=$(find "$source_path" -type f \( "${find_args[@]}" \) 2>/dev/null)
    local total_count=$(echo "$files" | grep -c . || echo 0)

    if [ -z "$files" ] || [ "$total_count" -eq 0 ]; then
        echo -e "  ${YELLOW}No matching files found${NC}"
        return 0
    fi

    echo "  Found $total_count files (before filtering)"

    # Create output directory
    mkdir -p "$manifest_output_dir"

    # Copy files preserving directory structure relative to source path
    local success_count=0
    local excluded_count=0
    local fail_count=0

    while IFS= read -r file; do
        [ -z "$file" ] && continue

        # Get relative path from source_path
        local rel_path="${file#$source_path/}"

        # Check if file should be excluded
        if should_exclude "$file" "$rel_path" "${exclude_patterns[@]}"; then
            ((excluded_count++))
            continue
        fi

        local dest_file="$manifest_output_dir/$rel_path"
        local dest_dir=$(dirname "$dest_file")

        mkdir -p "$dest_dir"

        if cp "$file" "$dest_file" 2>/dev/null; then
            ((success_count++))
        else
            echo -e "  ${RED}Failed to copy: $rel_path${NC}"
            ((fail_count++))
        fi
    done <<< "$files"

    echo -e "  ${GREEN}Copied: $success_count${NC}, Excluded: $excluded_count, ${RED}Failed: $fail_count${NC}"
    echo ""
}
