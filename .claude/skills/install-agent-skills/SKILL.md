# Install Agent Skills

Install generated skills to system locations by reading documentation for correct paths.

## Usage

Run `/install-agent-skills` after `/generate-agent-skills` to symlink skills to system.

## Instructions

When this skill is invoked:

### Step 1: Read docs for install paths

Read each agent's skill documentation to find the correct install locations:

**Claude Code** - Read `output/claude-code-docs/build-with-claude-code/agent-skills.md`:
- Look for "Where Skills live" section
- Find personal skills path (typically `~/.claude/skills/`)

**Codex** - Read `output/codex-docs/configuration/skills/overview.md`:
- Look for "Where to save skills" section
- Find USER scope path (typically `~/.codex/skills/`)

**OpenCode** - Read `output/opencode-docs/skills.mdx`:
- Look for "Place files" section
- Find global config path (typically `~/.config/opencode/skills/`)

### Step 2: Verify skills exist

Check that `dotfiles/` contains generated skills:
- `dotfiles/claude/skills/`
- `dotfiles/codex/skills/`
- `dotfiles/opencode/skills/`

If missing, tell user to run `/generate-agent-skills` first.

### Step 3: Install each skill

For each agent, install all skills from `dotfiles/<agent>/skills/` to the path found in Step 1.

Use the install.sh utility from this skill's scripts folder:
```bash
.claude/skills/install-agent-skills/scripts/install.sh <source_skill_dir> <target_skills_dir>
```

Example:
```bash
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/claude-code-docs ~/.claude/skills
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/opencode-docs ~/.claude/skills
```

### Step 4: Report results

Summarize:
- Install paths used (from docs)
- Skills installed per agent
- Any path changes detected vs previous runs

## Standalone Usage

For manual/CI use without Claude:
```bash
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills
```
