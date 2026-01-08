# Frequently Asked Questions (FAQ)

Common questions and answers about the Claude Code Agents Toolkit.

## Table of Contents

- [General Questions](#general-questions)
- [Installation](#installation)
- [Maestro vs Coordinator](#maestro-vs-coordinator)
- [RULEBOOK](#rulebook)
- [Agents](#agents)
- [Scripts](#scripts)
- [Troubleshooting](#troubleshooting)
- [Advanced Usage](#advanced-usage)

---

## General Questions

### What is the Claude Code Agents Toolkit?

A global installation system that provides AI-powered development assistance through specialized agents and workflow modes. It works with Claude Code (the CLI tool) to enhance your development experience with project-aware AI assistance.

### Do I need Claude Code to use this?

**Yes.** This toolkit is designed to work with Claude Code. The agents and workflow modes are invoked through Claude Code's slash commands (`/maestro`, `/coordinator`).

### Is this official from Anthropic?

**No.** This is a community-created toolkit that extends Claude Code with specialized agents and workflows. It is not officially affiliated with or endorsed by Anthropic.

### What's the difference between this and Claude Code?

- **Claude Code**: The official CLI tool from Anthropic for AI-assisted development
- **This Toolkit**: An enhancement that adds:
  - 72 specialized agents
  - Workflow modes (Maestro, Coordinator)
  - RULEBOOK system for project patterns
  - Agent routing and selection intelligence

### Is it free?

**Yes**, the toolkit is free and open source. However, you still need a Claude subscription to use Claude Code.

---

## Installation

### How do I install it?

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)
```

See [Installation Guide](../README.md#installation) for details.

### Where does it install?

**Global installation:**
- `~/.claude-global/` - All shared resources

**Per-project:**
- `.claude/` - Symlinks + project-specific config

### Can I install it in a specific directory?

Currently, the global installation must be at `~/.claude-global/`. Project installations use `.claude/` in each project root.

### How do I update it?

```bash
~/.claude-global/scripts/update.sh
```

The update script:
1. Checks for new version
2. Backs up current installation
3. Downloads and installs latest version
4. All projects auto-update (thanks to symlinks)

### How do I uninstall it?

```bash
~/.claude-global/scripts/uninstall.sh
```

This removes:
- Global installation (`~/.claude-global/`)
- Bash aliases (if added)
- Does NOT remove project `.claude/` directories (manual cleanup)

### Can I use it on Windows?

**Yes**, but only through WSL (Windows Subsystem for Linux). Native Windows support is not available due to bash script dependencies.

---

## Maestro vs Coordinator

### Which mode should I use?

**Use Maestro if:**
- ✅ Production application
- ✅ Team project with coding standards
- ✅ Want project-specific pattern enforcement
- ✅ Need 4-mode workflow (Planning → Dev → Review → Commit)

**Use Coordinator if:**
- ✅ Prototype or experiment
- ✅ Learning a new stack
- ✅ Prefer generic best practices
- ✅ Want lightweight, fast workflow

### Can I switch between modes?

**Yes!** Just run `scripts/init-project.sh` again and select a different mode. The script will ask if you want to reinitialize.

### Can I use both modes in the same project?

**No**, you can only have one mode active per project. However, you can have different modes in different projects.

### What's the difference in workflows?

**Maestro (4 modes):**
1. 📋 Planning - Read RULEBOOK, route to agents, create plan
2. 💻 Development - Execute plan, write code
3. 🔍 Review - Quality check, security audit, test coverage
4. 📦 Commit - Generate message, enforce gitflow

**Coordinator (3 steps):**
1. 📥 Receive - Parse request, clarify
2. 🎯 Delegate - Route to agents
3. 📊 Report - Summarize results

### Does Maestro require more setup?

Yes, Maestro creates a RULEBOOK on first use, which takes 2-3 minutes. Coordinator has no setup - just start using it.

---

## RULEBOOK

### What is a RULEBOOK?

A project-specific configuration file (`.claude/RULEBOOK.md`) that defines:
- Tech stack
- Architecture patterns
- Coding standards
- Active agents
- Testing approach

### When is it created?

**Automatically** on your first `/maestro` interaction. Maestro will:
1. Scan your project files
2. Detect your stack
3. Ask for missing details
4. Generate RULEBOOK.md

### Can I edit it manually?

**Yes!** The RULEBOOK is a markdown file. Edit it to:
- Add custom patterns
- Update stack info
- Add/remove agents
- Adjust coding standards

### Do I need a RULEBOOK for every project?

**Only for Maestro mode**. Coordinator doesn't use RULEBOOKs.

### Should I commit the RULEBOOK to git?

**No**, it's automatically added to `.gitignore`. RULEBOOKs are project-specific and may contain paths or preferences unique to your setup.

### What if my RULEBOOK gets out of sync?

Regenerate it:
```bash
rm .claude/RULEBOOK.md
# On next /maestro use, it will be recreated
```

Or edit it manually to match your current stack.

### Can I share my RULEBOOK with my team?

Yes, but remove it from `.gitignore` first:
```bash
# In your project's .gitignore, remove or comment out:
# .claude/
```

Then commit `.claude/RULEBOOK.md`.

---

## Agents

### How many agents are there?

**72 agents total:**
- 10 core (always recommended)
- 62 specialized (stack-specific)

See full list: `scripts/test-agent.sh --list`

### How do I know which agents are active?

```bash
scripts/test-agent.sh --active
```

Or check `.claude/agents-active.txt` (Maestro) or `.claude/RULEBOOK.md` (lists active agents).

### How do I activate/deactivate agents?

```bash
scripts/select-agents.sh
```

This opens an interactive menu to toggle agents by category.

### Do I need to activate all agents?

**No!** Only activate agents for your stack. For example:
- Next.js project: nextjs-specialist, react-specialist, typescript-pro, tailwind-expert
- Express API: express-specialist, typescript-pro, postgres-expert, jest-testing-specialist

### Can I create custom agents?

**Yes!** Add a markdown file to `~/.claude-global/agents/specialized/`:

```markdown
# my-custom-agent

## Identity
I'm a specialist in X technology...

## Capabilities
I can help with...

## When to Use
Use me when...
```

Then activate it with `scripts/select-agents.sh`.

### How do agents get selected?

**Maestro:** Reads RULEBOOK, uses agent-router.md routing logic
**Coordinator:** Keyword-based matching

### Can I have too many agents active?

Yes. Having 50+ agents active can:
- Slow down Claude Code
- Increase context usage
- Cause confusion in routing

**Recommendation:** 15-25 agents for most projects.

---

## Scripts

### What scripts are available?

| Script | Purpose |
|--------|---------|
| `init-project.sh` | Initialize new project |
| `select-agents.sh` | Manage active agents |
| `test-agent.sh` | Test/inspect agents |
| `agent-stats.sh` | View agent analytics |
| `healthcheck.sh` | Check installation health |
| `update.sh` | Update toolkit |
| `uninstall.sh` | Remove toolkit |
| `validate-rulebook.sh` | Validate RULEBOOK syntax |

### Where are the scripts?

`~/.claude-global/scripts/`

With bash aliases (if installed):
- `claude-init` → `init-project.sh`
- `claude-agents` → `select-agents.sh`
- `claude-test-agent` → `test-agent.sh`
- `claude-stats` → `agent-stats.sh`
- `claude-health` → `healthcheck.sh`
- `claude-validate` → `validate-rulebook.sh`

### Can I run scripts from anywhere?

**With aliases:** Yes (if installed during setup)
**Without aliases:** Use full path:
```bash
~/.claude-global/scripts/script-name.sh
```

### How do I add bash aliases after installation?

Add to your `~/.bashrc` or `~/.zshrc`:
```bash
# Claude Code Agents Toolkit
alias claude-init="$HOME/.claude-global/scripts/init-project.sh"
alias claude-agents="$HOME/.claude-global/scripts/select-agents.sh"
alias claude-test-agent="$HOME/.claude-global/scripts/test-agent.sh"
alias claude-stats="$HOME/.claude-global/scripts/agent-stats.sh"
alias claude-health="$HOME/.claude-global/scripts/healthcheck.sh"
alias claude-validate="$HOME/.claude-global/scripts/validate-rulebook.sh"
```

Then reload: `source ~/.bashrc` or `source ~/.zshrc`

---

## Troubleshooting

### Claude doesn't recognize `/maestro` or `/coordinator`

**Possible causes:**
1. Project not initialized:
   ```bash
   scripts/init-project.sh
   ```

2. Symlink broken:
   ```bash
   ls -la .claude/commands/
   # Should show symlink to ~/.claude-global/commands/
   ```

3. Claude Code not seeing .claude/:
   - Restart Claude Code
   - Check `.claude/` exists in project root

### "Global installation not found" error

The toolkit isn't installed. Install it:
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)
```

### Symlinks not working

**macOS/Linux:**
```bash
ls -la .claude/commands/maestro.md
# Should show: ... -> /Users/you/.claude-global/commands/maestro.md
```

**Recreate symlinks:**
```bash
rm -rf .claude
scripts/init-project.sh
```

### "Permission denied" when running scripts

Make scripts executable:
```bash
chmod +x ~/.claude-global/scripts/*.sh
```

### Health check fails

```bash
scripts/healthcheck.sh
```

This will show exactly what's wrong. Common issues:
- Missing directories
- Broken symlinks
- Missing RULEBOOK
- Incorrect permissions

### Agents not appearing in Claude

1. Check agents are active:
   ```bash
   scripts/test-agent.sh --active
   ```

2. Verify RULEBOOK lists them (Maestro mode):
   ```bash
   cat .claude/RULEBOOK.md | grep "Active Agents" -A 20
   ```

3. Restart Claude Code

### RULEBOOK generation hangs

**Cause:** Large project with many files

**Solution:**
- Wait (it's scanning files)
- Or create RULEBOOK manually using `templates/RULEBOOK_TEMPLATE.md`

### Update script fails

**If update fails:**
```bash
# Restore from backup
mv ~/.claude-global ~/.claude-global.failed
mv ~/.claude-global.backup.TIMESTAMP ~/.claude-global

# Or reinstall
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)
```

---

## Advanced Usage

### Can I customize agent behavior?

Yes, edit the agent files:
```bash
# Edit globally (affects all projects)
vim ~/.claude-global/agents/specialized/nextjs-specialist.md

# Or create project-specific override
cp ~/.claude-global/agents/specialized/nextjs-specialist.md .claude/agents/
vim .claude/agents/nextjs-specialist.md
```

### Can I have different RULEBOOK templates?

Yes, create custom templates in `templates/`:
```bash
cp templates/RULEBOOK_TEMPLATE.md templates/RULEBOOK_MICROSERVICE.md
# Edit template
vim templates/RULEBOOK_MICROSERVICE.md
```

Then reference it during RULEBOOK generation.

### How do I use this in a monorepo?

**Option 1:** One `.claude/` at root (shared RULEBOOK)
**Option 2:** `.claude/` in each package (separate RULEBOOKs)

```bash
# Option 2 example:
monorepo/
├── packages/
│   ├── frontend/
│   │   └── .claude/  # Next.js RULEBOOK
│   ├── backend/
│   │   └── .claude/  # Express RULEBOOK
│   └── mobile/
│       └── .claude/  # React Native RULEBOOK
```

### Can I use this with multiple Claude Code sessions?

Yes, each project can have different:
- Persona (Maestro vs Coordinator)
- Active agents
- RULEBOOK configuration

### How do I migrate from old version?

```bash
# Backup current
mv ~/.claude-global ~/.claude-global.old

# Install new version
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)

# Reinitialize projects
cd my-project
rm -rf .claude
~/.claude-global/scripts/init-project.sh
```

### Can I use custom routing rules?

Yes, edit `~/.claude-global/commands/agent-routing-rules.json`:
```json
{
  "task_patterns": {
    "my_custom_task": {
      "patterns": ["keyword1", "keyword2"],
      "complexity": "MEDIUM",
      "agents_needed": "2-3"
    }
  }
}
```

### How do I debug agent selection?

**Maestro mode:**
Check the Planning mode output - it shows which agents were selected and why.

**Coordinator mode:**
The Delegate step shows which agents were invoked.

### Can I disable specific agents temporarily?

Yes, deactivate via `scripts/select-agents.sh`, or comment them out in RULEBOOK:
```markdown
## Active Agents
- code-reviewer
- architecture-advisor
# - nextjs-specialist  (temporarily disabled)
- typescript-pro
```

---

## Still Have Questions?

- **Check:** [Troubleshooting Guide](TROUBLESHOOTING.md)
- **Read:** [Architecture Documentation](ARCHITECTURE.md)
- **Ask:** Open an issue on [GitHub](https://github.com/Dsantiagomj/claude-code-agents-toolkit/issues)

---

**Version:** 1.0.0
**Last Updated:** 2026-01-08
**Maintained By:** Claude Code Agents Toolkit Team
