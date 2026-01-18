# Install Agent Skills

Deploy generated skills from `dotfiles/` to system locations.

## Usage

Run `/install-agent-skills` after `/generate-agent-skills`.

## How It Works

The install script:
1. Copies `SKILL.md` from `dotfiles/<agent>/skills/<skill>/`
2. Creates a symlink `references/` pointing to `dotfiles/shared/<skill>/`

This keeps the repo clean (no symlinks) while installed skills link to shared docs.

## Instructions

### Step 1: Verify skills exist

Check that `dotfiles/` contains generated skills:
- `dotfiles/shared/` (shared documentation)
- `dotfiles/claude/skills/`
- `dotfiles/codex/skills/`
- `dotfiles/opencode/skills/`

If missing, tell user to run `/generate-agent-skills` first.

### Step 2: Install skills

Use the install.sh script to install each skill:

```bash
# Claude Code skills -> ~/.claude/skills/
for skill in dotfiles/claude/skills/*/; do
  .claude/skills/install-agent-skills/scripts/install.sh "$skill" ~/.claude/skills
done

# Codex skills -> ~/.codex/skills/
for skill in dotfiles/codex/skills/*/; do
  .claude/skills/install-agent-skills/scripts/install.sh "$skill" ~/.codex/skills
done

# OpenCode skills -> ~/.config/opencode/skills/
for skill in dotfiles/opencode/skills/*/; do
  .claude/skills/install-agent-skills/scripts/install.sh "$skill" ~/.config/opencode/skills
done
```

### Step 3: Report results

Summarize skills installed per agent.

## Standalone Usage

```bash
# Default: symlink mode (references/ links to shared docs)
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills

# Copy mode: copies docs, creates standalone skill
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills --copy
```

## Installed Structure

After installation, each skill in `~/.claude/skills/` (or equivalent) contains:
- `SKILL.md` - Agent-specific skill definition
- `references/` - Symlink to `<repo>/dotfiles/shared/<docs>/`

Updates to `dotfiles/shared/` are immediately reflected in all installed skills.
