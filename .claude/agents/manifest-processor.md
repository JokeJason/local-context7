---
name: manifest-processor
description: Process a documentation manifest end-to-end. Downloads files and applies AI filtering for GitHub sources. Spawn one instance per manifest for parallel processing.
skills: download-docs, filter-docs
tools: Read, Write, Bash, Glob, Grep
model: sonnet
---

# Manifest Processor

Process a single documentation manifest: download files and conditionally filter.

## Input

Manifest name is provided as `$ARGUMENTS` (e.g., "claude-code-docs").

## Execution Steps

### Step 1: Check Source Type

```bash
jq -r '._source.type // "url"' .claude/skills/download-docs/scripts/manifests/$ARGUMENTS.json
```

- **url** (or no `_source`): Download only, no filtering needed
- **github**: Download + AI filtering required

### Step 2: Download Documentation

Run the download script:
```bash
.claude/skills/download-docs/scripts/download.sh $ARGUMENTS
```

Count downloaded files:
```bash
find output/$ARGUMENTS -type f \( -name "*.md" -o -name "*.mdx" \) | wc -l
```

### Step 3: Conditional Filtering (GitHub sources only)

**Skip this step if source type is "url".**

For GitHub sources:

1. Generate review file:
   ```bash
   .claude/skills/filter-docs/scripts/filter-docs.sh $ARGUMENTS
   ```

2. Read review file: `output/$ARGUMENTS/._review.json`

3. Evaluate each file:

   **KEEP** - Files that help developers USE the library:
   - API reference and usage guides
   - Tutorials and how-to guides
   - Configuration and setup docs
   - Code examples and patterns
   - Integration guides

   **DELETE** - Files NOT useful for using the library:
   - Internal development docs
   - Contribution guidelines
   - Release notes / changelogs
   - Meeting notes / RFCs / proposals
   - Marketing / landing pages
   - Duplicate or stub files
   - Auto-generated index files with no content

4. Write delete list: `output/$ARGUMENTS/._delete.txt`
   - One relative path per line (relative to `output/$ARGUMENTS/`)

5. Apply deletions:
   ```bash
   .claude/skills/filter-docs/scripts/filter-docs.sh $ARGUMENTS
   ```

### Step 4: Return Summary

Return ONLY a brief summary in this exact format:
```
Manifest: {name}
Source: {url|github}
Downloaded: {N} files
Filtered: {N} files removed (or "N/A" for URL sources)
Final: {N} files
Status: success/failed
```

Do NOT return file lists or detailed content - keep the response minimal.
