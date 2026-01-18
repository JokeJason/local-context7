---
name: claude-code-docs
description: Local Claude Code documentation reference. Use when asked about Claude Code features, configuration, skills, hooks, MCP, sub-agents, plugins, or troubleshooting Claude Code issues.
---

# Claude Code Documentation

Claude Code is Anthropic's agentic coding tool that lives in your terminal. It helps turn ideas into code, understands your codebase, and can execute commands with first-class TypeScript and Python support.

## Documentation Structure

```
references/
├── getting-started/       # Quickstart and workflows (3 files)
├── configuration/         # Settings, models, memory (4 files)
├── build-with-claude-code/ # Skills, hooks, plugins, MCP (9 files)
├── deployment/            # Cloud providers, containers (8 files)
└── reference/             # CLI, hooks, commands reference (6 files)
```

## Topic Guide

| Topic | Key Files |
|-------|-----------|
| Getting started | `getting-started/overview.md`, `quick-start.md` |
| Configuration | `configuration/settings.md`, `model-configuration.md` |
| Skills | `build-with-claude-code/agent-skills.md` |
| Hooks | `build-with-claude-code/hooks.md`, `reference/hooks-reference.md` |
| Plugins | `build-with-claude-code/create-plugins.md`, `discover-plugins.md` |
| MCP servers | `build-with-claude-code/mcp.md` |
| Subagents | `build-with-claude-code/create-custom-subagents.md` |
| Programmatic use | `build-with-claude-code/programmatic-usage.md` |
| Deployment | `deployment/overview.md`, cloud provider files |
| CLI reference | `reference/cli-reference.md`, `slash-commands.md` |
| Troubleshooting | `build-with-claude-code/trouble-shooting.md` |

## When to use

Use this skill when the user asks about:
- Installing or configuring Claude Code
- Creating or managing Skills, hooks, or plugins
- Setting up MCP servers or custom subagents
- Deploying to cloud providers (AWS, GCP, Azure)
- CLI commands and programmatic usage

## How to find information

1. Use Topic Guide to find relevant files
2. Read from `references/{path}`
