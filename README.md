# local-context7

Build local documentation reference material for AI coding agents.

## What It Does

local-context7 downloads official documentation from various sources, filters it with AI assistance to keep only developer-relevant content, and generates skills that make the docs available as context during development.

**Supported AI Agents:**
- Claude Code (`~/.claude/skills/`)
- OpenAI Codex CLI (`~/.codex/skills/`)
- OpenCode (`~/.config/opencode/skills/`)

**Included Documentation:**

| Skill | Source | Files | Description |
|-------|--------|-------|-------------|
| `claude-code-docs` | [Anthropic](https://docs.anthropic.com/en/docs/claude-code) | 13 | Claude Code CLI features, hooks, MCP, skills |
| `codex-docs` | [OpenAI](https://github.com/openai/codex) | 12 | Codex CLI configuration, skills, agents |
| `opencode-docs` | [OpenCode](https://github.com/anomalyco/opencode) | 70 | OpenCode tools, agents, MCP, plugins |
| `nextjs-canary-docs` | [Vercel](https://github.com/vercel/next.js) | 376 | Next.js App Router, Server Components, APIs |
| `tsf-docs` | [TanStack](https://github.com/TanStack/form) | 192 | TanStack Form validation, React/Vue/Solid/Angular |
| `zod-docs` | [Zod](https://github.com/colinhacks/zod) | 13 | Zod schema validation, TypeScript type inference |

## Quick Start

### Prerequisites

- `jq` - JSON parsing
- `git` - GitHub cloning
- `curl` - URL downloads

### Using with Claude Code

**Process all documentation:**
```bash
/build-my-context7           # Download and filter all manifests
/generate-agent-skills       # Generate all skills
/install-agent-skills        # Install all skills
```

**Process a single library (more efficient for adding new docs):**
```bash
/build-my-context7 zod-docs        # Download only zod-docs
/generate-agent-skills zod-docs    # Generate only zod-docs skill
/install-agent-skills zod-docs     # Install only zod-docs skill
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
├── shared/                 # Documentation stored once
├── claude/skills/          # SKILL.md → ~/.claude/skills/
├── codex/skills/           # SKILL.md → ~/.codex/skills/
└── opencode/skills/        # SKILL.md → ~/.config/opencode/skills/

output/                     # Intermediate files (gitignored)
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
