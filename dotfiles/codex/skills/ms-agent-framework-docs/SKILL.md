---
name: ms-agent-framework-docs
description: Local Microsoft Agent Framework documentation reference. Use when asked about Microsoft Agent Framework, building AI agents in .NET or Python, MCP servers/clients, durable agents, agent tools, Teams/WebChat adapters, or agent-to-agent communication.
---

# Microsoft Agent Framework Documentation

Microsoft Agent Framework is a comprehensive SDK for building AI agents in .NET and Python. It provides abstractions for AI integration (Azure AI, OpenAI, Anthropic, Ollama), tool execution, Model Context Protocol (MCP), durable agents with state persistence, workflows, and multi-channel adapters (Teams, WebChat, DirectLine).

## Quick Reference

| Topic | Entry Point |
|-------|-------------|
| Project overview | `references/README.md` |
| FAQ & nightly builds | `references/docs/FAQS.md` |
| .NET samples | `references/dotnet/samples/README.md` |
| .NET getting started | `references/dotnet/samples/GettingStarted/README.md` |
| Python samples | `references/python/samples/README.md` |
| Architecture decisions | `references/docs/decisions/README.md` |
| Durable agents TTL | `references/docs/features/durable-agents/durable-agents-ttl.md` |
| Azure Functions hosting | `references/dotnet/samples/AzureFunctions/README.md` |
| Workflows | `references/dotnet/samples/GettingStarted/Workflows/README.md` |

## When to use

Use this skill when the user asks about:
- Building AI agents with Microsoft Agent Framework
- .NET or Python agent development
- MCP (Model Context Protocol) servers and clients
- Durable agents and session state management
- Agent tools and tool execution
- Teams, WebChat, or DirectLine adapters
- Agent-to-agent (A2A) communication
- Azure AI, OpenAI, Anthropic, or Ollama integration
- AG-UI (Agent UI) protocol implementation
- Workflows and orchestration patterns
- Azure Functions agent hosting

## How to find information

1. **First**, read `references/STRUCTURE.md` to see all available documentation files
2. Identify the relevant section/files based on the user's question
3. Read specific files for detailed information

**STRUCTURE.md contains a complete file listing organized by directory - always check it first before searching.**

## Key Directories

- `dotnet/samples/GettingStarted/` - Step-by-step .NET tutorials
- `dotnet/samples/AzureFunctions/` - Serverless hosting examples
- `dotnet/samples/GettingStarted/AgentProviders/` - LLM provider integration
- `dotnet/samples/GettingStarted/Workflows/` - Workflow patterns
- `python/samples/getting_started/` - Python tutorials
- `docs/decisions/` - Architecture Decision Records (ADRs)
