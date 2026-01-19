# local-context7

Build local documentation reference material for AI coding agents.

> **This repo is designed to be used with Claude Code.** Open this repo in Claude Code and use slash commands (`/build-my-context7`, `/generate-agent-skills`, `/install-agent-skills`) to download docs, generate skills, and install them. The skills and scripts are meant to be invoked by Claude Code, not run manually.

## What It Does

local-context7 downloads official documentation from various sources, filters it with AI assistance to keep only developer-relevant content, and generates skills that make the docs available as context during development.

**Supported AI Agents:**
- Claude Code (`~/.claude/skills/`)
- OpenAI Codex CLI (`~/.codex/skills/`)
- OpenCode (`~/.config/opencode/skills/`)

**Included Documentation:**

| Skill | Source | Files | Description |
|-------|--------|-------|-------------|
| `claude-code-docs` | [Anthropic](https://docs.anthropic.com/en/docs/claude-code) | 30 | Claude Code CLI features, hooks, MCP, skills |
| `codex-docs` | [OpenAI](https://github.com/openai/codex) | 12 | Codex CLI configuration, skills, agents |
| `langchain-docs` | [LangChain](https://github.com/langchain-ai/docs) | 1688 | LangChain, LangGraph, agents, RAG, tools |
| `nextjs-canary-docs` | [Vercel](https://github.com/vercel/next.js) | 376 | Next.js App Router, Server Components, APIs |
| `opencode-docs` | [OpenCode](https://github.com/anomalyco/opencode) | 70 | OpenCode tools, agents, MCP, plugins |
| `prisma-docs` | [Prisma](https://github.com/prisma/docs) | 415 | Prisma ORM, Client, Schema, migrations |
| `tsf-docs` | [TanStack](https://github.com/TanStack/form) | 192 | TanStack Form validation, React/Vue/Solid/Angular |
| `zod-docs` | [Zod](https://github.com/colinhacks/zod) | 13 | Zod schema validation, TypeScript type inference |

## Quick Start

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) installed
- `jq`, `git`, `curl` available in your shell

### Usage

1. Open this repo in Claude Code
2. Run the slash commands:

```
/build-my-context7           # Download and filter all manifests
/generate-agent-skills       # Generate skills for all agents
/install-agent-skills        # Install skills to system locations
```

**To process a single library:**
```
/build-my-context7 zod-docs        # Download only zod-docs
/generate-agent-skills zod-docs    # Generate only zod-docs skill
/install-agent-skills zod-docs     # Install only zod-docs skill
```

After installation, the skills are available in your other projects. For example, when working on a Next.js app, Claude Code will automatically have access to `nextjs-canary-docs`.

## Adding New Documentation

Just give Claude Code the GitHub URL of the docs folder:

> "Add docs from https://github.com/prisma/docs/tree/main/content"

Claude Code will automatically create the manifest and run the build commands. This is the fastest way to add new documentation.

**Or create a manifest manually:**

1. Create a JSON file in `.claude/skills/download-docs/scripts/manifests/`
2. Run `/build-my-context7 <name>` → `/generate-agent-skills <name>` → `/install-agent-skills <name>`

### Manifest Formats

**GitHub Source** (for repos with docs):
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

**URL Source** (for individual files):
```json
{
  "getting-started": {
    "installation": "https://example.com/docs/install.md"
  }
}
```

**URL Source with HTML Conversion** (requires `pandoc`):
```json
{
  "_source": { "type": "url", "convert": "html" },
  "docs": { "overview": "https://example.com/docs/overview.html" }
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

This project is open source and available under the [MIT License](LICENSE).
