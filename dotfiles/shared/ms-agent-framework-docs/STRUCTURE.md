# Microsoft Agent Framework Documentation Structure

Total: 422 files (198 markdown, 224 C#)

## Root Files (5 files)

- `README.md` - Main project readme
- `COMMUNITY.md` - Community guidelines
- `SUPPORT.md` - Support information
- `TRANSPARENCY_FAQ.md` - Transparency FAQ

## agent-samples/ (1 file)

- `agent-samples/README.md`

## workflow-samples/ (1 file)

- `workflow-samples/README.md`

## docs/ (21 files)

Official documentation including ADRs, specs, and features.

### docs/decisions/ - Architecture Decision Records
- `docs/decisions/README.md`
- `docs/decisions/0001-agent-run-response.md`
- `docs/decisions/0002-agent-tools.md`
- `docs/decisions/0003-agent-opentelemetry-instrumentation.md`
- `docs/decisions/0004-foundry-sdk-extensions.md`
- `docs/decisions/0005-python-naming-conventions.md`
- `docs/decisions/0006-userapproval.md`
- `docs/decisions/0007-agent-filtering-middleware.md`
- `docs/decisions/0008-python-subpackages.md`
- `docs/decisions/0009-support-long-running-operations.md`
- `docs/decisions/0010-ag-ui-support.md`
- `docs/decisions/0011-create-get-agent-api.md`
- `docs/decisions/0011-python-typeddict-options.md`
- `docs/decisions/0012-python-get-response-simplification.md`
- `docs/decisions/adr-template.md`
- `docs/decisions/adr-short-template.md`

### docs/design/
- `docs/design/python-package-setup.md`

### docs/features/
- `docs/features/durable-agents/durable-agents-ttl.md`

### docs/specs/
- `docs/specs/001-foundry-sdk-alignment.md`
- `docs/specs/spec-template.md`

### docs/
- `docs/FAQS.md`

## dotnet/ (313 files)

.NET SDK samples and documentation.

### dotnet/samples/A2AClientServer/ - Agent-to-Agent Communication
- `dotnet/samples/A2AClientServer/README.md`
- `dotnet/samples/A2AClientServer/A2AClient/` (Program.cs, HostClientAgent.cs)
- `dotnet/samples/A2AClientServer/A2AServer/` (Program.cs, HostAgentFactory.cs, Models/)

### dotnet/samples/AgentWebChat/ - Web Chat Integration
- `dotnet/samples/AgentWebChat/AgentWebChat.AgentHost/` (Program.cs, Custom/, Utilities/)
- `dotnet/samples/AgentWebChat/AgentWebChat.AppHost/`
- `dotnet/samples/AgentWebChat/AgentWebChat.Web/`

### dotnet/samples/AGUIClientServer/ - Agent UI Protocol
- `dotnet/samples/AGUIClientServer/README.md`
- `dotnet/samples/AGUIClientServer/AGUIClient/`
- `dotnet/samples/AGUIClientServer/AGUIServer/`
- `dotnet/samples/AGUIClientServer/AGUIDojoServer/` (AgenticUI/, SharedState/, etc.)

### dotnet/samples/AGUIWebChat/
- `dotnet/samples/AGUIWebChat/README.md`
- `dotnet/samples/AGUIWebChat/Client/Program.cs`
- `dotnet/samples/AGUIWebChat/Server/Program.cs`

### dotnet/samples/AzureFunctions/ - Serverless Agent Hosting
- `dotnet/samples/AzureFunctions/README.md`
- `dotnet/samples/AzureFunctions/01_SingleAgent/`
- `dotnet/samples/AzureFunctions/02_AgentOrchestration_Chaining/`
- `dotnet/samples/AzureFunctions/03_AgentOrchestration_Concurrency/`
- `dotnet/samples/AzureFunctions/04_AgentOrchestration_Conditionals/`
- `dotnet/samples/AzureFunctions/05_AgentOrchestration_HITL/`
- `dotnet/samples/AzureFunctions/06_LongRunningTools/`
- `dotnet/samples/AzureFunctions/07_AgentAsMcpTool/`
- `dotnet/samples/AzureFunctions/08_ReliableStreaming/`

### dotnet/samples/GettingStarted/ - Step-by-Step Tutorials

#### GettingStarted/Agents/ - Core Agent Patterns
- `dotnet/samples/GettingStarted/Agents/README.md`
- `Agent_Step01_Running/` through `Agent_Step19_Declarative/`

#### GettingStarted/AgentProviders/ - LLM Provider Integration
- `dotnet/samples/GettingStarted/AgentProviders/README.md`
- `Agent_With_A2A/`, `Agent_With_Anthropic/`, `Agent_With_AzureAI*/`
- `Agent_With_GoogleGemini/`, `Agent_With_Ollama/`, `Agent_With_ONNX/`
- `Agent_With_OpenAI*/`, `Agent_With_CustomImplementation/`

#### GettingStarted/AgentWithAnthropic/
- Claude integration examples

#### GettingStarted/AgentWithOpenAI/
- OpenAI-specific examples

#### GettingStarted/AgentWithMemory/
- Memory patterns (ChatHistory, Mem0, Custom)

#### GettingStarted/AgentWithRAG/
- RAG integration (TextSearch, VectorStore, Custom, Foundry)

#### GettingStarted/AGUI/
- Agent UI protocol steps (GettingStarted, BackendTools, FrontendTools, HumanInLoop, StateManagement)

#### GettingStarted/FoundryAgents/
- Azure AI Foundry integration (15 steps)

#### GettingStarted/ModelContextProtocol/
- MCP server and client examples

#### GettingStarted/Workflows/
- Workflow patterns (Foundational, Agents, Checkpoint, Concurrent, ConditionalEdges, Declarative, HumanInTheLoop, Loop, Observability, SharedStates, Visualization)

#### GettingStarted/DeclarativeAgents/
- Declarative agent configuration

#### GettingStarted/DevUI/
- Developer UI integration

### dotnet/samples/HostedAgents/
- `AgentsInWorkflows/`, `AgentWithHostedMCP/`, `AgentWithTextSearchRag/`

### dotnet/samples/M365Agent/
- Microsoft 365 agent integration

### dotnet/samples/Purview/
- Purview compliance integration

## python/ (82 files)

Python SDK packages and samples.

### python/packages/ - SDK Packages
- `python/packages/core/` - Core agent framework
- `python/packages/a2a/` - Agent-to-Agent
- `python/packages/ag-ui/` - Agent UI
- `python/packages/anthropic/` - Anthropic integration
- `python/packages/azure-ai/` - Azure AI
- `python/packages/azure-ai-search/` - Azure AI Search
- `python/packages/azurefunctions/` - Azure Functions
- `python/packages/bedrock/` - AWS Bedrock
- `python/packages/chatkit/` - Chat UI
- `python/packages/copilotstudio/` - Copilot Studio
- `python/packages/declarative/` - Declarative agents
- `python/packages/devui/` - Developer UI
- `python/packages/foundry_local/` - Local Foundry
- `python/packages/mem0/` - Mem0 memory
- `python/packages/ollama/` - Ollama
- `python/packages/purview/` - Purview
- `python/packages/redis/` - Redis

### python/samples/getting_started/ - Tutorials
- `agents/` - Provider-specific agents (a2a, anthropic, azure_ai, openai, ollama, etc.)
- `azure_functions/` - Serverless hosting (8 examples)
- `context_providers/` - RAG and memory (azure_ai_search, mem0, redis)
- `mcp/` - MCP integration
- `middleware/` - Request/response middleware
- `multimodal_input/` - Image/audio handling
- `observability/` - Telemetry
- `threads/` - Conversation management
- `tools/` - Tool definitions
- `workflows/declarative/` - Declarative workflows
- `devui/` - Developer UI
- `evaluation/` - Red teaming, self-reflection
- `purview_agent/` - Compliance

### python/samples/demos/
- `chatkit-integration/`, `m365-agent/`, `workflow_evaluation/`

### python/samples/ - Migration Guides
- `autogen-migration/README.md`
- `semantic-kernel-migration/README.md`
