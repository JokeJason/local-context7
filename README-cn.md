# local-context7

[English](README.md) | [中文](README-cn.md)

为 AI 编程助手构建本地文档参考资料。

> **本仓库专为 Claude Code 设计。** 在 Claude Code 中打开本仓库，使用斜杠命令（`/build-my-context7`、`/generate-agent-skills`、`/install-agent-skills`）下载文档、生成技能并安装。这些技能和脚本需要通过 Claude Code 调用，不支持手动运行。

## 功能介绍

local-context7 从各种来源下载官方文档，通过 AI 辅助过滤仅保留开发者相关内容，并生成技能使这些文档在开发过程中可用作上下文参考。

**支持的 AI 助手：**
- Claude Code (`~/.claude/skills/`)
- OpenAI Codex CLI (`~/.codex/skills/`)
- OpenCode (`~/.config/opencode/skills/`)

**已包含的文档：**

| 技能名称 | 来源 | 文件数 | 描述 |
|---------|------|-------|------|
| `claude-code-docs` | [Anthropic](https://docs.anthropic.com/en/docs/claude-code) | 30 | Claude Code CLI 功能、钩子、MCP、技能 |
| `codex-docs` | [OpenAI](https://github.com/openai/codex) | 12 | Codex CLI 配置、技能、代理 |
| `langchain-docs` | [LangChain](https://github.com/langchain-ai/docs) | 1688 | LangChain、LangGraph、代理、RAG、工具 |
| `nextjs-canary-docs` | [Vercel](https://github.com/vercel/next.js) | 376 | Next.js App Router、Server Components、API |
| `opencode-docs` | [OpenCode](https://github.com/anomalyco/opencode) | 70 | OpenCode 工具、代理、MCP、插件 |
| `prisma-docs` | [Prisma](https://github.com/prisma/docs) | 415 | Prisma ORM、客户端、Schema、数据迁移 |
| `tsf-docs` | [TanStack](https://github.com/TanStack/form) | 192 | TanStack Form 表单验证、React/Vue/Solid/Angular |
| `zod-docs` | [Zod](https://github.com/colinhacks/zod) | 13 | Zod 模式验证、TypeScript 类型推断 |

## 快速开始

### 前置要求

- 已安装 [Claude Code](https://docs.anthropic.com/en/docs/claude-code)
- Shell 中可用 `jq`、`git`、`curl` 命令

### 使用方法

1. 在 Claude Code 中打开本仓库
2. 运行斜杠命令：

```
/build-my-context7           # 下载并过滤所有清单
/generate-agent-skills       # 为所有代理生成技能
/install-agent-skills        # 将技能安装到系统目录
```

**处理单个库：**
```
/build-my-context7 zod-docs        # 仅下载 zod-docs
/generate-agent-skills zod-docs    # 仅生成 zod-docs 技能
/install-agent-skills zod-docs     # 仅安装 zod-docs 技能
```

安装完成后，技能会在你的其他项目中自动可用。例如，在开发 Next.js 应用时，Claude Code 会自动获得 `nextjs-canary-docs` 的上下文支持。

## 添加新文档

只需给 Claude Code 提供文档文件夹的 GitHub URL：

> "添加文档：https://github.com/prisma/docs/tree/main/content"

Claude Code 会自动创建清单并运行构建命令。这是添加新文档最快的方式。

**或手动创建清单：**

1. 在 `.claude/skills/download-docs/scripts/manifests/` 目录下创建 JSON 文件
2. 依次运行 `/build-my-context7 <名称>` → `/generate-agent-skills <名称>` → `/install-agent-skills <名称>`

### 清单格式

**GitHub 来源**（适用于含文档的仓库）：
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

**URL 来源**（适用于单个文件）：
```json
{
  "getting-started": {
    "installation": "https://example.com/docs/install.md"
  }
}
```

**URL 来源 + HTML 转换**（需要安装 `pandoc`）：
```json
{
  "_source": { "type": "url", "convert": "html" },
  "docs": { "overview": "https://example.com/docs/overview.html" }
}
```

## 目录结构

```
.claude/                    # 本仓库的工作配置
├── skills/                 # 用于构建文档的技能
│   ├── build-my-context7/  # 主协调技能
│   ├── download-docs/      # 从清单下载文档
│   ├── filter-docs/        # AI 辅助过滤
│   ├── generate-agent-skills/
│   └── install-agent-skills/
└── agents/                 # 子代理

dotfiles/                   # 生成的技能（主数据源）
├── shared/                 # 文档统一存储
├── claude/skills/          # SKILL.md → ~/.claude/skills/
├── codex/skills/           # SKILL.md → ~/.codex/skills/
└── opencode/skills/        # SKILL.md → ~/.config/opencode/skills/

output/                     # 中间文件（已加入 gitignore）
```

## 工作原理

1. **下载** - 根据清单配置从 GitHub 仓库或 URL 获取文档
2. **过滤** - AI 审查每个文件，移除无用内容（变更日志、贡献指南、营销页面等）
3. **生成** - 按照各 AI 助手的特定格式要求创建技能
4. **安装** - 将生成的技能通过符号链接安装到系统目录，供各助手使用

## 为什么选择本地方案？

- **离线访问** - 无需联网即可使用文档
- **版本控制** - 可锁定特定版本的文档
- **自定义** - 可添加自己的文档来源
- **隐私保护** - 开发过程中不向外部服务发送数据
- **响应速度** - 即时加载上下文，无需 API 调用

## 许可证

本项目开源，采用 [MIT 许可证](LICENSE)。
