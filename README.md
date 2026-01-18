# local-context7

Build local documentation reference material for AI coding agents.

## What It Does

local-context7 downloads official documentation from various sources, filters it with AI assistance to keep only developer-relevant content, and generates skills that make the docs available as context during development.

**Supported AI Agents:**
- Claude Code
- OpenAI Codex CLI
- OpenCode

**Included Documentation:**
- Claude Code official docs
- Codex CLI docs
- OpenCode docs

## Quick Start

### Prerequisites

- `jq` - JSON parsing
- `git` - GitHub cloning
- `curl` - URL downloads

### Using with Claude Code

```bash
# 1. Download and filter documentation
/build-my-context7

# 2. Generate skills from filtered docs
/generate-agent-skills

# 3. Install skills to system locations
/install-agent-skills
```

### Manual/Standalone Usage

```bash
# Download docs from a specific manifest
.claude/skills/download-docs/scripts/download.sh claude-code-docs

# Download from all manifests
.claude/skills/download-docs/scripts/download.sh

# Install a specific skill
.claude/skills/install-agent-skills/scripts/install.sh \
  dotfiles/claude/skills/claude-code-docs \
  ~/.claude/skills
```

## Adding New Documentation

Create a manifest JSON file in `.claude/skills/download-docs/scripts/manifests/`.

### GitHub Source

For repositories containing documentation:

```json
{
  "_source": {
    "type": "github",
    "repo": "owner/repo-name",
    "branch": "main",
    "path": "docs",
    "extensions": [".md", ".mdx"],
    "exclude": ["**/internal/**"]
  }
}
```

### URL Source

For individual files:

```json
{
  "getting-started": {
    "installation": "https://example.com/docs/install.md",
    "quickstart": "https://example.com/docs/quickstart.md"
  },
  "api": {
    "reference": "https://example.com/docs/api.md"
  }
}
```

### URL Source with HTML Conversion

For HTML documentation (requires `pandoc`):

```json
{
  "_source": {
    "type": "url",
    "convert": "html"
  },
  "docs": {
    "overview": "https://example.com/docs/overview.html"
  }
}
```

## Directory Structure

```
.claude/                    # Working config for this repo
├── skills/                 # Skills for building docs
│   ├── build-my-context7/  # Main orchestration skill
│   ├── download-docs/      # Downloads from manifests
│   ├── filter-docs/        # AI-assisted filtering
│   ├── generate-agent-skills/
│   └── install-agent-skills/
└── agents/                 # Sub-agents

dotfiles/                   # Generated skills (source of truth)
├── claude/skills/          # → ~/.claude/skills/
├── codex/skills/           # → ~/.codex/skills/
└── opencode/skills/        # → ~/.config/opencode/skills/

output/                     # Intermediate files (gitignored)
├── claude-code-docs/
├── codex-docs/
└── opencode-docs/
```

## How It Works

1. **Download** - Fetches documentation from GitHub repos or URLs based on manifest configurations
2. **Filter** - AI reviews each file and removes non-useful content (changelogs, contribution guides, marketing pages, etc.)
3. **Generate** - Creates skills for each AI agent following their specific format requirements
4. **Install** - Symlinks generated skills to system locations where agents can find them

## Why Local?

- **Offline access** - Documentation available without internet
- **Version control** - Pin to specific documentation versions
- **Customization** - Add your own documentation sources
- **Privacy** - No data sent to external services during development
- **Speed** - Instant context loading without API calls

## License

MIT
