# Generate Agent Skills

Generate documentation skills for each AI agent using the latest skill specifications from downloaded docs.

## Usage

Run `/generate-agent-skills` after `/build-my-context7` to generate skills based on the latest documentation.

## How It Works

This skill reads the downloaded documentation to understand each agent's current skill format, then generates appropriate skills. Documentation files are stored once in a shared location, with each agent's skill containing only its SKILL.md and a symlink to the shared references.

## Instructions

When this skill is invoked:

### Step 1: Verify docs exist

Check that `output/` contains downloaded documentation:
- `output/claude-code-docs/`
- `output/codex-docs/`
- `output/opencode-docs/`

If missing, tell user to run `/build-my-context7` first.

### Step 2: Read skill specifications

For each agent, read its skill documentation to understand the current format:

**Claude Code:**
- Read `output/claude-code-docs/build-with-claude-code/agent-skills.md`
- Note: YAML frontmatter with `name`, `description`, optional `allowed-tools`
- Note: `references/` folder for documentation files

**Codex CLI:**
- Read `output/codex-docs/configuration/skills/overview.md`
- Read `output/codex-docs/configuration/skills/create-skill.md`
- Note: YAML frontmatter with `name`, `description`
- Note: `references/` folder for documentation

**OpenCode:**
- Read `output/opencode-docs/skills.mdx`
- Note: YAML frontmatter with `name` (lowercase, hyphens), `description`
- Note: skill locations and format requirements

### Step 3: Create shared documentation

Create shared documentation directory and copy docs once:

```bash
# Create shared directory
mkdir -p dotfiles/shared

# For each documentation set, copy to shared location
cp -r output/claude-code-docs dotfiles/shared/
cp -r output/codex-docs dotfiles/shared/
cp -r output/opencode-docs dotfiles/shared/
```

### Step 4: Generate skills for each agent

For each agent (Claude, Codex, OpenCode), create skills in `dotfiles/<agent>/skills/`:

1. **claude-code-docs** - Claude Code reference documentation
2. **codex-docs** - Codex CLI reference documentation
3. **opencode-docs** - OpenCode reference documentation

For each skill:
1. Create directory: `dotfiles/<agent>/skills/<skill-name>/`
2. Create `SKILL.md` following the agent's format from Step 2
3. Do NOT create `references/` - the install script handles this

**Example commands:**
```bash
# Create skill directory
mkdir -p dotfiles/claude/skills/opencode-docs

# Create SKILL.md (with appropriate content)
# ... write SKILL.md file ...

# No symlinks needed - install.sh creates them at install time
```

### Step 5: Adapt to spec changes

If the skill documentation shows different requirements than current implementation:
- Update SKILL.md format accordingly
- Adjust directory structure if needed
- Report what changes were made

### Step 6: Report results

Summarize:
- Which agents were processed
- Which skills were generated/updated
- Any format changes detected
- Disk space saved by using shared docs

**Recommend next step**: Tell the user to run `/install-agent-skills` to deploy the generated skills to system locations.

## Target Structure

```
dotfiles/
├── shared/                      # Single copy of all documentation
│   ├── claude-code-docs/
│   ├── codex-docs/
│   └── opencode-docs/
├── claude/skills/
│   ├── claude-code-docs/
│   │   └── SKILL.md             # Only SKILL.md, no references/
│   ├── codex-docs/
│   │   └── SKILL.md
│   └── opencode-docs/
│       └── SKILL.md
├── codex/skills/
│   └── (same structure)
└── opencode/skills/
    └── (same structure)
```

## Important

- Always read the latest skill documentation before generating. Do not assume formats are static.
- Do NOT create `references/` folders - the install script creates symlinks at install time.
- The shared docs are stored once, reducing repo size significantly.
