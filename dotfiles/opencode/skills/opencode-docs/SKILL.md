---
name: opencode-docs
description: Local OpenCode documentation reference. Use when asked about OpenCode features, tools, agents, MCP servers, plugins, CLI, TUI, or IDE integration.
---

# OpenCode Documentation

OpenCode is an open source AI coding agent available as a terminal-based interface (TUI), desktop app, or IDE extension. It provides an interactive interface for working on projects with LLMs.

## Documentation Structure

```
references/
├── index.mdx              # Introduction and installation (1 file)
├── cli.mdx                # CLI options and commands
├── tui.mdx                # Terminal user interface guide
├── config.mdx             # JSON configuration options
├── agents.mdx             # Specialized AI assistants configuration
├── tools.mdx              # Built-in tool management
├── custom-tools.mdx       # Creating custom tools
├── mcp-servers.mdx        # Model Context Protocol servers
├── plugins.mdx            # Plugin development and usage
├── skills.mdx             # Skills system
├── providers.mdx          # LLM provider configuration
├── models.mdx             # Model selection and settings
├── permissions.mdx        # Tool permission controls
├── keybinds.mdx           # Keyboard shortcuts
├── themes.mdx             # Theme customization
├── github.mdx             # GitHub integration
├── gitlab.mdx             # GitLab integration
├── ide.mdx                # IDE extension setup
├── troubleshooting.mdx    # Common issues and solutions
└── (more...)              # Additional docs (70 total files)
```

## Topic Guide

| Topic | Key Files |
|-------|-----------|
| Getting Started | `index.mdx`, `cli.mdx`, `tui.mdx` |
| Configuration | `config.mdx`, `permissions.mdx`, `keybinds.mdx` |
| Agents | `agents.mdx`, `modes.mdx` |
| Tools & Extensions | `tools.mdx`, `custom-tools.mdx`, `mcp-servers.mdx` |
| Plugins & Skills | `plugins.mdx`, `skills.mdx` |
| LLM Setup | `providers.mdx`, `models.mdx` |
| Git Integration | `github.mdx`, `gitlab.mdx` |
| IDE Integration | `ide.mdx`, `sdks/vscode/README.md` |
| Customization | `themes.mdx`, `formatters.mdx` |
| Troubleshooting | `troubleshooting.mdx`, `network.mdx` |
| Web Interface | `web.mdx`, `server.mdx` |

## When to use

Use this skill when the user asks about:
- OpenCode installation and setup
- CLI commands and TUI navigation
- Configuration options (opencode.json)
- Agents and modes
- Tools, custom tools, and MCP servers
- Plugins and skills
- LLM providers and models
- GitHub/GitLab integration
- IDE extensions (VS Code, etc.)
- Keyboard shortcuts and themes

## How to find information

1. Use the Topic Guide table to identify the relevant file(s)
2. Read the file from `references/{filename}`
3. For related topics, explore other files in the same category
