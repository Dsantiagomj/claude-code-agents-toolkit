# Troubleshooting Guide

This guide covers common issues you might encounter when using the Claude Code Agents Toolkit and their solutions.

---

## Table of Contents

1. [Installation Issues](#installation-issues)
2. [Agent Activation Problems](#agent-activation-problems)
3. [Maestro Mode Issues](#maestro-mode-issues)
4. [context7 MCP Server Problems](#context7-mcp-server-problems)
5. [Script Execution Errors](#script-execution-errors)
6. [Platform-Specific Issues](#platform-specific-issues)
7. [RULEBOOK Problems](#rulebook-problems)
8. [Common Error Messages](#common-error-messages)
9. [Performance Issues](#performance-issues)
10. [Getting Additional Help](#getting-additional-help)

---

## Installation Issues

### Problem: Permission Denied When Running install.sh

**Error Message:**
```
-bash: ./install.sh: Permission denied
```

**Cause:** The script doesn't have execute permissions.

**Solution:**
```bash
# Add execute permission
chmod +x install.sh

# Run the installer
./install.sh
```

**Prevention:** All scripts in the toolkit should have execute permissions by default. If you cloned the repo, run:
```bash
chmod +x install.sh scripts/*.sh
```

---

### Problem: .claude Directory Already Exists

**Error Message:**
```
⚠ Existing .claude directory found!
A backup will be created at: .claude.backup.2026-01-07-143022
Continue with backup and installation? (y/N):
```

**Cause:** You already have a `.claude/` directory in your project.

**Solution:**

**Option 1: Accept Backup (Recommended)**
```bash
# Let the installer create a backup
./install.sh
# Type 'y' when prompted
```

**Option 2: Manual Backup**
```bash
# Create your own backup first
cp -r .claude .claude.my-backup

# Then run installer
./install.sh
```

**Option 3: Use Update Script Instead**
```bash
# If you're updating an existing installation
scripts/update.sh
```

**Prevention:** Check if `.claude/` exists before running install.sh

---

### Problem: Backup Creation Fails

**Error Message:**
```
✗ Failed to create backup
Error: No space left on device
```

**Cause:** Insufficient disk space.

**Solution:**
```bash
# Check disk space
df -h

# Free up space or skip backup (not recommended)
./install.sh --skip-backup
```

**Prevention:** Ensure you have at least 100MB free space before installation.

---

### Problem: Git Not Found

**Error Message:**
```
git: command not found
```

**Cause:** Git is not installed.

**Solution:**

**macOS:**
```bash
# Install via Homebrew
brew install git

# Or install Xcode Command Line Tools
xcode-select --install
```

**Linux (Ubuntu/Debian):**
```bash
sudo apt update
sudo apt install git
```

**Linux (Fedora/RHEL):**
```bash
sudo dnf install git
```

**Windows (WSL):**
```bash
sudo apt update
sudo apt install git
```

---

### Problem: Node.js or npm Not Found

**Error Message:**
```
npm: command not found
```

**Cause:** Node.js is not installed (required for context7 MCP server).

**Solution:**

**macOS:**
```bash
# Via Homebrew
brew install node

# Or via nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20
```

**Linux:**
```bash
# Via nvm (recommended)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
nvm install 20

# Or via package manager
sudo apt install nodejs npm  # Ubuntu/Debian
sudo dnf install nodejs      # Fedora/RHEL
```

**Verification:**
```bash
node --version  # Should show v18.0.0 or higher
npm --version   # Should show 9.0.0 or higher
```

---

## Agent Activation Problems

### Problem: Agents Not Appearing in Claude Code

**Symptoms:** After installation, agents don't show up or aren't being used.

**Cause:** Agents might not be properly linked or RULEBOOK is not configured.

**Solution:**

1. **Verify Installation:**
```bash
scripts/healthcheck.sh
```

2. **Check Directory Structure:**
```bash
ls -la .claude/
# Should show:
# agents-global/
# RULEBOOK.md
# commands/
```

3. **Verify Agent Files:**
```bash
ls -la .claude/agents-global/core/
ls -la .claude/agents-global/pool/
```

4. **Check RULEBOOK:**
```bash
cat .claude/RULEBOOK.md | grep "## Active Agents"
```

5. **Validate RULEBOOK:**
```bash
scripts/validate-rulebook.sh
```

**Prevention:** Always run `scripts/healthcheck.sh` after installation.

---

### Problem: Invalid Agent Names in RULEBOOK

**Error Message:**
```
⚠ Invalid agent: "next-js-specialist"
  → Did you mean: "nextjs-specialist"?
```

**Cause:** Agent name misspelled or doesn't exist.

**Solution:**

1. **Check Available Agents:**
```bash
ls .claude/agents-global/pool/ | sort
```

2. **Use Agent Selector:**
```bash
scripts/select-agents.sh
# Interactive menu shows all valid agent names
```

3. **Fix RULEBOOK Manually:**
```markdown
## Active Agents

- code-reviewer
- nextjs-specialist  ← Correct spelling (no dashes between next and js)
```

4. **Validate:**
```bash
scripts/validate-rulebook.sh
```

**Prevention:** Use `scripts/select-agents.sh` instead of manually editing agent names.

---

### Problem: Too Many Agents Active (Performance Issues)

**Symptoms:** Claude Code feels slow or unresponsive.

**Cause:** Too many agents activated (> 30).

**Solution:**

1. **Check Active Agent Count:**
```bash
grep -c "^- " .claude/RULEBOOK.md
```

2. **Deactivate Unnecessary Agents:**
```bash
scripts/select-agents.sh
# Deactivate agents you're not using
```

3. **Recommended Agent Counts:**
   - **Small Projects:** 12-18 agents
   - **Medium Projects:** 18-25 agents
   - **Large Projects:** 25-35 agents

**Prevention:** Only activate agents relevant to your tech stack.

---

## Maestro Mode Issues

### Problem: /maestro Command Not Working

**Symptoms:** Typing `/maestro` in Claude Code doesn't activate Maestro Mode.

**Cause:** Maestro Mode not installed or command file is missing.

**Solution:**

1. **Check if Maestro is Installed:**
```bash
ls .claude/commands/maestro.md
```

2. **If Missing, Reinstall:**
```bash
# If you initially installed with --agents-only
./install.sh --maestro-only

# Or reinstall everything
./install.sh
```

3. **Verify Maestro Command File:**
```bash
cat .claude/commands/maestro.md | head -n 5
# Should start with "# Maestro Mode"
```

4. **Restart Claude Code:**
   - Close Claude Code completely
   - Reopen your project
   - Try `/maestro` again

**Prevention:** Don't use `--agents-only` flag if you want Maestro Mode.

---

### Problem: Maestro Not Responding or Acting Strange

**Symptoms:** Maestro gives generic responses or doesn't follow RULEBOOK.

**Cause:** Corrupted maestro.md file or wrong language version.

**Solution:**

1. **Check Current Language:**
```bash
head -n 1 .claude/commands/maestro.md
# English version: "# Maestro Mode"
# Spanish version: "# Modo Maestro"
```

2. **Switch Language if Needed:**
```bash
scripts/switch-language.sh en  # Switch to English
scripts/switch-language.sh es  # Switch to Spanish
```

3. **Reinstall Maestro:**
```bash
# Backup current version
cp .claude/commands/maestro.md .claude/commands/maestro.md.backup

# Reinstall
cp commands/maestro.md .claude/commands/maestro.md
```

4. **Verify RULEBOOK Exists:**
```bash
ls .claude/RULEBOOK.md
```

**Prevention:** Don't manually edit maestro.md unless you know what you're doing.

---

### Problem: Wrong Language Activated

**Symptoms:** Maestro responds in Spanish when you want English (or vice versa).

**Cause:** Wrong language version installed.

**Solution:**
```bash
# Switch to English
scripts/switch-language.sh en

# Switch to Spanish
scripts/switch-language.sh es

# Or just toggle
scripts/switch-language.sh
```

**Verification:**
```bash
head -n 1 .claude/commands/maestro.md
```

---

### Problem: Self-Enhancement Not Working

**Symptoms:** Maestro doesn't learn or adapt from feedback.

**Cause:** Self-enhancement is disabled or file is missing.

**Solution:**

1. **Check if Enabled:**
```bash
scripts/toggle-enhancement.sh status
```

2. **Enable if Disabled:**
```bash
scripts/toggle-enhancement.sh on
```

3. **Verify File Exists:**
```bash
ls .claude/commands/self-enhancement.md
```

4. **Restore from Backup if Deleted:**
```bash
mv .claude/commands/self-enhancement.md.backup .claude/commands/self-enhancement.md
```

---

## context7 MCP Server Problems

### Problem: context7 Not Installed

**Error Message:**
```
Error: context7 MCP server not found
```

**Cause:** context7 MCP server is not configured in settings.json.

**Solution:**

1. **Add to settings.json:**
```bash
# Edit .claude/settings.json
```

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]
    }
  }
}
```

2. **Verify Node.js is Installed:**
```bash
node --version  # Should show v18+
npx --version
```

3. **Test context7:**
```bash
npx -y context7-mcp
# Should not show errors
```

---

### Problem: npx Command Not Found

**Error Message:**
```
npx: command not found
```

**Cause:** Node.js/npm not installed properly.

**Solution:**
```bash
# Install Node.js (includes npx)
brew install node  # macOS
sudo apt install nodejs npm  # Linux

# Verify
npx --version
```

---

### Problem: Network Connection Issues

**Error Message:**
```
Error: Failed to fetch documentation from context7
Error: ETIMEDOUT / ECONNREFUSED
```

**Cause:** Network connectivity issues or proxy problems.

**Solution:**

1. **Check Internet Connection:**
```bash
ping google.com
```

2. **If Behind Proxy, Configure npm:**
```bash
npm config set proxy http://proxy.company.com:8080
npm config set https-proxy http://proxy.company.com:8080
```

3. **Clear npm Cache:**
```bash
npm cache clean --force
```

4. **Try Manual Fetch:**
```bash
npx -y context7-mcp
```

---

### Problem: Documentation Fetch Failures

**Error Message:**
```
⚠ Failed to fetch Next.js documentation
```

**Cause:** context7 service issues or invalid query.

**Solution:**

1. **Check context7 Status:**
   - Visit https://context7.com for service status

2. **Try Alternative Documentation Sources:**
   - Use official docs directly
   - Check framework GitHub repositories

3. **Retry Later:**
   - Service might be temporarily down

---

## Script Execution Errors

### Problem: scripts/healthcheck.sh: command not found

**Error Message:**
```
scripts/healthcheck.sh: No such file or directory
```

**Cause:** Script doesn't exist or wrong path.

**Solution:**

1. **Check if Script Exists:**
```bash
ls scripts/
```

2. **If Missing, Update/Reinstall:**
```bash
scripts/update.sh
```

3. **Use Correct Path:**
```bash
# From project root
scripts/healthcheck.sh

# Not from scripts/ directory
cd scripts && ./healthcheck.sh  # This works too
```

---

### Problem: Permission Denied on Script Execution

**Error Message:**
```
-bash: scripts/update.sh: Permission denied
```

**Solution:**
```bash
# Fix permissions for all scripts
chmod +x scripts/*.sh

# Or specific script
chmod +x scripts/update.sh
```

---

### Problem: Dry-Run Mode Not Working

**Symptoms:** `./install.sh --dry-run` makes actual changes.

**Cause:** Incorrect flag or bug.

**Solution:**

1. **Verify Flag:**
```bash
./install.sh --dry-run  # Correct
./install.sh -dry-run   # Wrong (single dash)
```

2. **Check Output:**
   - Should say "DRY RUN MODE" at top
   - Should say "No actual changes made" at end

3. **If Still Installing, Report Bug:**
   - Create backup first
   - Report issue on GitHub

---

### Problem: Questionnaire Hangs

**Symptoms:** `scripts/questionnaire.sh` freezes or doesn't accept input.

**Cause:** Terminal input buffer issues.

**Solution:**

1. **Kill Process:**
```bash
Ctrl+C
```

2. **Restart Terminal:**
   - Close and reopen terminal

3. **Run Again:**
```bash
scripts/questionnaire.sh
```

4. **Alternative: Manual RULEBOOK:**
   - Copy template: `cp templates/RULEBOOK_TEMPLATE.md .claude/RULEBOOK.md`
   - Edit manually

---

## Platform-Specific Issues

### macOS: Gatekeeper Blocking Scripts

**Error Message:**
```
"install.sh" cannot be opened because it is from an unidentified developer
```

**Solution:**

**Option 1: Right-Click Method**
1. Right-click on `install.sh`
2. Click "Open"
3. Click "Open" in dialog

**Option 2: Terminal**
```bash
# Remove quarantine attribute
xattr -d com.apple.quarantine install.sh

# Or for all scripts
find . -name "*.sh" -exec xattr -d com.apple.quarantine {} \;
```

**Option 3: System Preferences**
1. System Preferences → Security & Privacy
2. Click "Allow Anyway" for the blocked script

---

### Linux: Permission Issues

**Problem:** Cannot write to `.claude/` directory.

**Solution:**

1. **Check Ownership:**
```bash
ls -la .claude/
```

2. **Fix Ownership:**
```bash
sudo chown -R $USER:$USER .claude/
```

3. **Fix Permissions:**
```bash
chmod -R 755 .claude/
```

---

### WSL (Windows Subsystem for Linux): Path Problems

**Problem:** Scripts fail with "No such file or directory" despite existing.

**Cause:** Windows line endings (CRLF) in Linux environment.

**Solution:**

1. **Convert Line Endings:**
```bash
# Install dos2unix
sudo apt install dos2unix

# Convert all scripts
find . -name "*.sh" -exec dos2unix {} \;
```

2. **Or Use sed:**
```bash
find . -name "*.sh" -exec sed -i 's/\r$//' {} \;
```

3. **Configure Git for Future:**
```bash
git config --global core.autocrlf input
```

---

### Windows Git Bash: Command Not Found

**Problem:** Running scripts in Git Bash on Windows fails.

**Solution:**

1. **Use Correct Path:**
```bash
# Use forward slashes
./install.sh

# Not backslashes
.\install.sh  # Windows CMD syntax, won't work in Git Bash
```

2. **Ensure Git Bash is Updated:**
   - Download latest Git for Windows
   - Reinstall

3. **Alternative: Use WSL:**
   - Install Windows Subsystem for Linux
   - Run toolkit in WSL environment

---

## RULEBOOK Problems

### Problem: Validation Failures

**Error Message:**
```
✗ RULEBOOK validation failed
✗ Missing required section: Tech Stack
```

**Cause:** RULEBOOK is missing required sections.

**Solution:**

1. **Run Validator:**
```bash
scripts/validate-rulebook.sh
# Shows all missing sections
```

2. **Add Missing Sections:**
```markdown
## Tech Stack
- Framework: Next.js 15
- Language: TypeScript

## Active Agents
- code-reviewer
- nextjs-specialist
```

3. **Validate Again:**
```bash
scripts/validate-rulebook.sh
```

---

### Problem: Missing Required Sections

**Error Message:**
```
⚠ Missing section: Project Overview
⚠ Missing section: Active Agents
```

**Solution:**

Use the template as reference:
```bash
cat templates/RULEBOOK_TEMPLATE.md
```

Required sections:
- `## Project Overview`
- `## Tech Stack`
- `## Active Agents`

---

### Problem: Duplicate Sections Detected

**Error Message:**
```
⚠ Duplicate section found: ## Tech Stack (lines 45, 128)
```

**Cause:** Section header appears multiple times.

**Solution:**

1. **Find Duplicates:**
```bash
grep -n "## Tech Stack" .claude/RULEBOOK.md
```

2. **Merge or Remove:**
   - Merge content into one section
   - Or remove duplicate

3. **Validate:**
```bash
scripts/validate-rulebook.sh
```

---

### Problem: Invalid Markdown Formatting

**Error Message:**
```
⚠ Invalid heading hierarchy at line 56
```

**Cause:** Incorrect markdown heading levels (e.g., jumping from `#` to `###`).

**Solution:**

Follow proper hierarchy:
```markdown
# H1 - RULEBOOK Title (only one per file)
## H2 - Main Sections
### H3 - Subsections
#### H4 - Details
```

Never skip levels:
```markdown
# H1
### H3  ← Wrong! Should be ## H2
```

---

### Problem: Outdated Content Detected

**Error Message:**
```
⚠ Outdated content detected:
  → "GENTLEMAN MODE" should be "MAESTRO MODE"
  → "WRAPUP MODE" should be "COMMIT MODE"
```

**Cause:** Using old naming conventions.

**Solution:**

**Option 1: Manual Fix**
```bash
# Edit .claude/RULEBOOK.md
# Replace old terms with new
```

**Option 2: Use Migration Script**
```bash
scripts/migrate.sh
```

---

## Common Error Messages

### "No such file or directory"

**Full Error:**
```
-bash: ./install.sh: No such file or directory
```

**Possible Causes:**
1. Not in project root directory
2. File doesn't exist
3. Wrong path

**Solution:**
```bash
# Check current directory
pwd

# List files
ls

# Navigate to toolkit directory
cd /path/to/claude-code-agents-toolkit

# Verify file exists
ls -la install.sh
```

---

### "RULEBOOK.md not found"

**Full Error:**
```
✗ RULEBOOK.md not found in .claude/ directory
```

**Solution:**

1. **Generate from Template:**
```bash
cp templates/RULEBOOK_TEMPLATE.md .claude/RULEBOOK.md
```

2. **Or Use Questionnaire:**
```bash
scripts/questionnaire.sh
```

3. **Or Use Project Template:**
```bash
cp templates/projects/nextjs-saas/RULEBOOK.md .claude/RULEBOOK.md
```

---

### "Invalid JSON in settings"

**Full Error:**
```
✗ Invalid JSON syntax in .claude/settings.json
```

**Cause:** JSON syntax error.

**Solution:**

1. **Validate JSON:**
```bash
cat .claude/settings.json | python -m json.tool
```

2. **Common Issues:**
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]  // Remove trailing comma
    },  ← Remove this comma
  }
}
```

3. **Use JSON Validator:**
   - https://jsonlint.com
   - Paste your settings.json
   - Fix errors

---

### "Agent not found in pool"

**Full Error:**
```
✗ Agent "next-specialist" not found in pool
  → Available agents: nextjs-specialist, react-specialist, ...
```

**Cause:** Agent name is incorrect.

**Solution:**

1. **List Available Agents:**
```bash
ls .claude/agents-global/pool/
```

2. **Fix RULEBOOK:**
```markdown
## Active Agents
- nextjs-specialist  ← Correct name
```

3. **Or Use Selector:**
```bash
scripts/select-agents.sh
```

---

## Performance Issues

### Problem: Claude Code is Slow

**Symptoms:**
- Long response times
- Timeouts
- Freezing

**Possible Causes:**
1. Too many agents active
2. Large RULEBOOK
3. System resources

**Solution:**

1. **Reduce Active Agents:**
```bash
scripts/select-agents.sh
# Keep only agents you're actually using (12-25 recommended)
```

2. **Optimize RULEBOOK:**
   - Remove unnecessary sections
   - Keep only relevant documentation
   - Target: < 1000 lines

3. **Check System Resources:**
```bash
# macOS
top

# Linux
htop
```

4. **Restart Claude Code:**
   - Close completely
   - Wait 10 seconds
   - Reopen

---

### Problem: Scripts Take Too Long

**Symptoms:** healthcheck.sh, validate-rulebook.sh run slowly.

**Solution:**

1. **Check Disk I/O:**
```bash
# macOS
iostat 1 10

# Linux
iotop
```

2. **Optimize Agent Count:**
   - Healthcheck validates all agents
   - Reduce agent count if > 40

3. **Run Specific Checks:**
```bash
# Instead of full healthcheck
ls .claude/agents-global/core/  # Just check core agents
```

---

## Getting Additional Help

### Before Asking for Help

Run diagnostics:
```bash
# 1. Health check
scripts/healthcheck.sh > healthcheck.log 2>&1

# 2. Validate RULEBOOK
scripts/validate-rulebook.sh > validation.log 2>&1

# 3. Check versions
cat .claude/.toolkit-version
node --version
git --version
```

### Where to Get Help

1. **GitHub Issues**
   - https://github.com/yourusername/claude-code-agents-toolkit/issues
   - Search existing issues first
   - Provide diagnostic logs

2. **GitHub Discussions**
   - https://github.com/yourusername/claude-code-agents-toolkit/discussions
   - General questions
   - Feature requests

3. **Documentation**
   - [README.md](../README.md) - Main documentation
   - [INSTALLATION.md](INSTALLATION.md) - Installation guide
   - [MAESTRO_MODE.md](MAESTRO_MODE.md) - Maestro guide

### When Reporting Issues

Include:
1. **Environment:**
   - OS and version
   - Node.js version
   - Toolkit version

2. **Steps to Reproduce:**
   - Exact commands run
   - Expected vs actual behavior

3. **Diagnostic Logs:**
   ```bash
   scripts/healthcheck.sh > healthcheck.log 2>&1
   ```
   - Attach healthcheck.log

4. **RULEBOOK Info:**
   ```bash
   scripts/validate-rulebook.sh > validation.log 2>&1
   ```
   - Attach validation.log (if relevant)

---

## Quick Reference

### Diagnostic Commands

```bash
# Full health check
scripts/healthcheck.sh

# Validate RULEBOOK
scripts/validate-rulebook.sh

# Check toolkit version
cat .claude/.toolkit-version

# List active agents
grep "^- " .claude/RULEBOOK.md

# Check Maestro language
head -n 1 .claude/commands/maestro.md

# Self-enhancement status
scripts/toggle-enhancement.sh status

# Test context7
npx -y context7-mcp
```

### Quick Fixes

```bash
# Fix script permissions
chmod +x install.sh scripts/*.sh

# Reinstall toolkit
./install.sh

# Update toolkit
scripts/update.sh

# Switch Maestro language
scripts/switch-language.sh en  # or 'es'

# Enable self-enhancement
scripts/toggle-enhancement.sh on

# Validate after changes
scripts/validate-rulebook.sh
```

---

**Last Updated:** 2026-01-07
**Toolkit Version:** 1.0.0+

For more help, visit the [main README](../README.md) or create an issue on GitHub.
