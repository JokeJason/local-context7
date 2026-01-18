---
name: build-my-context7
description: Build local Context7 documentation by downloading and filtering docs from manifests. Use when setting up or updating local documentation reference.
---

# Build My Context7

Download and filter documentation from manifests for Context7 integration.

## Quick Start

Invoke this skill to process all documentation manifests. Output goes to `output/`.

## Workflow

### Phase 1: Discovery

List all manifests:
```bash
ls .claude/skills/download-docs/scripts/manifests/*.json
```

Extract manifest names (without .json extension) for spawning sub-agents.

### Phase 2: Parallel Processing

**CRITICAL**: Spawn ALL sub-agents in a SINGLE message for maximum parallelism.

For EACH manifest, spawn a `manifest-processor` sub-agent:

```
Task tool call:
- subagent_type: manifest-processor
- prompt: "{manifest-name}"
```

The sub-agent handles everything:
- Downloads files from the manifest source
- Detects source type (URL vs GitHub)
- Applies AI filtering for GitHub sources (skips for URL sources)
- Returns a summary

**Example** - if there are 4 manifests, spawn 4 sub-agents in ONE message:
```
Task(manifest-processor): "claude-code-docs"
Task(manifest-processor): "codex-docs"
Task(manifest-processor): "langchain-docs"
Task(manifest-processor): "opencode-docs"
```

### Phase 3: Summary

After all sub-agents complete, compile results into a summary table:

| Manifest | Source | Downloaded | Filtered | Final | Status |
|----------|--------|------------|----------|-------|--------|
| name     | url/github | N | N/N/A | N | ✅/❌ |

Remind user to run `/generate-agent-skills` if needed.

## Requirements

- `jq` - JSON parsing
- `git` - GitHub cloning
- `curl` - URL downloads
