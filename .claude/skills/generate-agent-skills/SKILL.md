---
name: generate-agent-skills
description: Generate documentation skills for AI agents from downloaded docs. Use after /build-my-context7 to create skills.
---

# Generate Agent Skills

Generate documentation skills for each AI agent using the latest skill specifications from downloaded docs.

## Usage

```
/generate-agent-skills              # Generate ALL skills
/generate-agent-skills zod-docs     # Generate only zod-docs skill
```

Run after `/build-my-context7` to generate skills based on the latest documentation.

## Instructions

### Step 1: Check Arguments

Check if `$ARGUMENTS` is provided:
- If **argument provided**: Generate only that specific skill
- If **no argument**: Generate all skills from `output/*-docs/`

### Step 2: Verify docs exist

**If processing a specific skill:**
- Verify `output/{argument}/` exists
- If not found, tell user to run `/build-my-context7 {argument}` first

**If processing all skills:**
- Check that `output/` contains downloaded documentation directories
- If empty, tell user to run `/build-my-context7` first

### Step 3: Read skill specifications (only needed once per session)

For each agent, read its skill documentation to understand the current format:

**Claude Code:**
- Read `output/claude-code-docs/build-with-claude-code/agent-skills.md`
- Note: YAML frontmatter with `name`, `description`, optional `allowed-tools`

**Codex CLI:**
- Read `output/codex-docs/configuration/skills/overview.md`
- Note: YAML frontmatter with `name`, `description`

**OpenCode:**
- Read `output/opencode-docs/skills.mdx`
- Note: YAML frontmatter with `name` (lowercase, hyphens), `description`

### Step 4: Create/update shared documentation

```bash
mkdir -p dotfiles/shared

# For specific skill:
rm -rf dotfiles/shared/{skill-name}
cp -r output/{skill-name} dotfiles/shared/

# For all skills:
for dir in output/*-docs; do
  name=$(basename "$dir")
  rm -rf "dotfiles/shared/$name"
  cp -r "$dir" "dotfiles/shared/$name"
done
```

### Step 5: Generate skills for each agent

For each agent (Claude, Codex, OpenCode), create/update skills in `dotfiles/<agent>/skills/`:

1. Create directory: `dotfiles/<agent>/skills/<skill-name>/`
2. Create `SKILL.md` following the agent's format
3. Do NOT create `references/` - the install script handles this

**SKILL.md template:**
```yaml
---
name: {skill-name}
description: Local {Library} documentation reference. Use when asked about {topics}.
---

# {Library} Documentation

This skill provides local reference documentation for {Library}.

## When to use

Use this skill when the user asks about:
- {topic 1}
- {topic 2}
- ...

## Available documentation

See the `references/` folder for the full documentation.
```

### Step 6: Report results

Summarize:
- Which skills were generated/updated
- Which agents were updated
- Disk space used by shared docs

**Recommend next step**: Tell the user to run `/install-agent-skills` (or `/install-agent-skills {skill-name}`) to deploy.

## Important

- Do NOT create `references/` folders - the install script creates symlinks at install time.
- The shared docs are stored once, reducing repo size significantly.
