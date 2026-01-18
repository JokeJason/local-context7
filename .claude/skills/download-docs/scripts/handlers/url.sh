#!/bin/bash

# Handler for URL-based sources
# Downloads files from specified URLs, with optional HTML conversion
#
# Manifest formats:
#
# Simple URL manifest (markdown files):
# {
#     "category-name": {
#         "doc-name": "https://example.com/path/to/doc.md"
#     }
# }
#
# With explicit source config:
# {
#     "_source": {
#         "type": "url",
#         "convert": "html"  // optional: convert HTML to markdown
#     },
#     "category-name": {
#         "doc-name": "https://example.com/docs/page.html"
#     }
# }

download_from_urls() {
    local manifest_file="$1"
    local output_dir="$2"
    local manifest_name=$(basename "$manifest_file" .json)
    local manifest_output_dir="$output_dir/$manifest_name"
    local success_count=0
    local fail_count=0
    local failed_urls=""

    # Check if HTML conversion is requested
    local convert=$(jq -r '._source.convert // empty' "$manifest_file")

    if [ "$convert" = "html" ]; then
        echo -e "${YELLOW}Processing: $manifest_name (URLs with HTML conversion)${NC}"

        # Check for pandoc
        if ! command -v pandoc &> /dev/null; then
            echo -e "  ${RED}Error: pandoc is required for HTML conversion${NC}"
            echo "  Install with:"
            echo "    macOS:  brew install pandoc"
            echo "    Ubuntu: sudo apt install pandoc"
            return 1
        fi
    else
        echo -e "${YELLOW}Processing: $manifest_name (URLs)${NC}"
    fi

    # Use jq to recursively find all string values (URLs) with their paths
    # Exclude _source key used for source config
    local entries=$(jq -r '
        del(._source) |
        paths(type == "string") as $p |
        "\($p | join("/"))|\(getpath($p))"
    ' "$manifest_file")

    # Check if there are any entries
    if [ -z "$entries" ]; then
        echo -e "  ${YELLOW}No URLs found in manifest${NC}"
        echo ""
        return 0
    fi

    while IFS='|' read -r doc_path url; do
        [ -z "$doc_path" ] && continue

        # Extract directory path and filename
        local dir_path=$(dirname "$doc_path")
        local doc_name=$(basename "$doc_path")
        local full_dir="$manifest_output_dir/$dir_path"
        local output_file="$full_dir/${doc_name}.md"

        mkdir -p "$full_dir"

        echo -n "  Downloading $doc_path... "

        if [ "$convert" = "html" ]; then
            # Download and convert HTML to markdown
            local temp_html=$(mktemp)

            if curl -sSfL "$url" -o "$temp_html" 2>/dev/null; then
                if pandoc -f html -t markdown -o "$output_file" "$temp_html" 2>/dev/null; then
                    echo -e "${GREEN}OK${NC}"
                    ((success_count++))
                else
                    echo -e "${RED}CONVERSION FAILED${NC}"
                    ((fail_count++))
                    failed_urls="$failed_urls\n  - $url (conversion failed)"
                    rm -f "$output_file"
                fi
            else
                echo -e "${RED}DOWNLOAD FAILED${NC}"
                ((fail_count++))
                failed_urls="$failed_urls\n  - $url"
            fi

            rm -f "$temp_html"
        else
            # Direct download (markdown)
            if curl -sSfL "$url" -o "$output_file" 2>/dev/null; then
                echo -e "${GREEN}OK${NC}"
                ((success_count++))
            else
                echo -e "${RED}FAILED${NC}"
                ((fail_count++))
                failed_urls="$failed_urls\n  - $url"
                rm -f "$output_file"
            fi
        fi
    done <<< "$entries"

    echo -e "  ${GREEN}Downloaded: $success_count${NC}, ${RED}Failed: $fail_count${NC}"

    if [ $fail_count -gt 0 ]; then
        echo -e "  Failed URLs:$failed_urls"
    fi
    echo ""
}

# Alias for backwards compatibility
download_from_html() {
    download_from_urls "$@"
}
