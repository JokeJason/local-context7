#!/bin/bash

# Download documentation from JSON manifests
# Orchestrates different handlers based on source type
#
# Outputs to: <repo-root>/output/<manifest-name>/

# Don't exit on error - continue processing other manifests
# set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HANDLERS_DIR="$SCRIPT_DIR/handlers"
MANIFESTS_DIR="$SCRIPT_DIR/manifests"
REPO_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"
OUTPUT_DIR="$REPO_ROOT/output"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Export colors for handlers
export RED GREEN YELLOW NC

# Source all handlers
for handler in "$HANDLERS_DIR"/*.sh; do
    [ -f "$handler" ] && source "$handler"
done

dispatch_handler() {
    local manifest_file="$1"

    # Determine source type (default to "url" if no _source specified)
    local source_type=$(jq -r '._source.type // "url"' "$manifest_file")

    case "$source_type" in
        github)
            download_from_github "$manifest_file" "$OUTPUT_DIR"
            ;;
        url|html)
            download_from_urls "$manifest_file" "$OUTPUT_DIR"
            ;;
        *)
            echo -e "${RED}Unknown source type: $source_type${NC}"
            echo "  Supported types: github, url"
            return 1
            ;;
    esac
}

main() {
    echo "========================================"
    echo "Download Docs - Documentation Downloader"
    echo "========================================"
    echo ""

    # Check for required tools
    if ! command -v jq &> /dev/null; then
        echo -e "${RED}Error: jq is required but not installed.${NC}"
        echo "Install with:"
        echo "  macOS:  brew install jq"
        echo "  Ubuntu: sudo apt install jq"
        echo "  Fedora: sudo dnf install jq"
        echo "  Windows: winget install jqlang.jq"
        exit 1
    fi

    if ! command -v git &> /dev/null; then
        echo -e "${RED}Error: git is required but not installed.${NC}"
        exit 1
    fi

    # Check that handlers exist
    if [ ! -d "$HANDLERS_DIR" ] || [ -z "$(ls -A "$HANDLERS_DIR"/*.sh 2>/dev/null)" ]; then
        echo -e "${RED}Error: No handlers found in $HANDLERS_DIR${NC}"
        exit 1
    fi

    # Check that manifests directory exists
    if [ ! -d "$MANIFESTS_DIR" ]; then
        echo -e "${RED}Error: Manifests directory not found: $MANIFESTS_DIR${NC}"
        exit 1
    fi

    # Create output directory
    mkdir -p "$OUTPUT_DIR"

    # Check for single manifest argument
    target="$1"

    if [ -n "$target" ]; then
        # Process single manifest
        manifest="$MANIFESTS_DIR/$target.json"
        if [ ! -f "$manifest" ]; then
            echo -e "${RED}Error: Manifest not found: $manifest${NC}"
            exit 1
        fi
        echo "Processing single manifest: $target"
        echo ""
        dispatch_handler "$manifest"
        manifest_count=1
    else
        # Process all manifests
        manifest_count=0
        for manifest in "$MANIFESTS_DIR"/*.json; do
            [ -f "$manifest" ] || continue
            dispatch_handler "$manifest"
            ((manifest_count++))
        done
    fi

    if [ $manifest_count -eq 0 ]; then
        echo -e "${YELLOW}No JSON manifests found in $MANIFESTS_DIR${NC}"
        exit 0
    fi

    echo "========================================"
    echo "Done! Downloaded to: $OUTPUT_DIR"
    echo ""
    echo "Next: Run /generate-agent-skills to build skills from these docs"
    echo "========================================"
}

main "$@"
