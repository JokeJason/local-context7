# Install Agent Skills

Symlink generated skills from `dotfiles/` to system locations.

## Usage

Run `/install-agent-skills` after `/generate-agent-skills`.

## Instructions

### Step 1: Verify skills exist

Check that `dotfiles/` contains generated skills:
- `dotfiles/claude/skills/`
- `dotfiles/codex/skills/`
- `dotfiles/opencode/skills/`

If missing, tell user to run `/generate-agent-skills` first.

### Step 2: Install skills

Use the install.sh script to symlink each skill:

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
.claude/skills/install-agent-skills/scripts/install.sh dotfiles/claude/skills/codex-docs ~/.claude/skills
```
