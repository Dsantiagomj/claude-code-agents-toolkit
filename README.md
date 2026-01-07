# Claude Code Agents Global Toolkit

> A comprehensive collection of 78 specialized AI agents for [Claude Code](https://claude.com/claude-code), designed to enhance your development workflow with intelligent task delegation and smart agent selection.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 🎯 What Is This?

A production-ready toolkit of **78 specialized AI agents** that work seamlessly with Claude Code to:

- ✅ Auto-detect your project's tech stack from RULEBOOK.md
- ✅ Automatically select the right specialists for each task
- ✅ Route complex tasks to multi-agent pipelines
- ✅ Enforce your project's patterns and conventions
- ✅ Maintain code quality through specialized reviews
- ✅ Scale from simple tasks (0 agents) to critical systems (12+ agents)

---

## 🚀 Quick Start

```bash
# 1. Clone the repository
git clone https://github.com/yourusername/claude-code-agents-toolkit
cd claude-code-agents-toolkit

# 2. Run the installer
./install.sh

# 3. That's it! Your project now has 78 agents ready to use.
```

The installer will:
- Copy all 78 agents to `.claude/agents-global/`
- Generate a RULEBOOK.md from template (if you don't have one)
- Detect your tech stack and activate relevant agents
- Set up Maestro Mode (optional)

**Installation time:** < 2 minutes
**Manual configuration:** Zero (for common stacks)

---

## 📦 What's Included

### Core Agents (Always Active - 10 agents)

These agents work on **any** project, regardless of tech stack:

- **code-reviewer** - Comprehensive code quality review
- **refactoring-specialist** - Code improvement and restructuring
- **documentation-engineer** - Documentation generation and maintenance
- **test-strategist** - Test planning and coverage analysis
- **architecture-advisor** - System design and architecture decisions
- **security-auditor** - Security vulnerability scanning
- **performance-optimizer** - Performance analysis and optimization
- **git-workflow-specialist** - Git best practices and workflow
- **dependency-manager** - Dependency updates and security
- **project-analyzer** - Codebase analysis and insights

### Specialized Agents (Auto-Activated - 68 agents)

Agents automatically activate based on your project's tech stack (detected from RULEBOOK.md):

#### Frontend (8 agents)
- react-specialist, vue-specialist, angular-specialist, svelte-specialist
- tailwind-expert, css-architect, ui-accessibility, animation-specialist

#### Backend (8 agents)
- express-specialist, fastify-expert, nest-specialist, koa-expert
- rest-api-architect, graphql-specialist, websocket-expert, microservices-architect

#### Full-Stack Frameworks (6 agents)
- nextjs-specialist, nuxt-specialist, remix-specialist
- astro-specialist, sveltekit-specialist, solidstart-specialist

#### Languages (8 agents)
- typescript-pro, javascript-modernizer, python-specialist, go-specialist
- rust-expert, java-specialist, csharp-specialist, php-modernizer

#### Databases (8 agents)
- postgres-expert, mysql-specialist, mongodb-expert, redis-specialist
- prisma-specialist, typeorm-expert, drizzle-specialist, sequelize-expert

#### Infrastructure (9 agents)
- docker-specialist, kubernetes-expert, cicd-automation-specialist
- aws-cloud-specialist, vercel-deployment-specialist, terraform-iac-specialist
- cloudflare-edge-specialist, monitoring-observability-specialist, nginx-load-balancer-specialist

#### Testing (7 agents)
- jest-testing-specialist, playwright-e2e-specialist, vitest-specialist
- cypress-specialist, testing-library-specialist, storybook-testing-specialist
- test-automation-strategist

#### Specialized Domains (8 agents)
- react-native-mobile-specialist, electron-desktop-specialist
- cli-tools-specialist, browser-extension-specialist
- ai-ml-integration-specialist, blockchain-web3-specialist
- game-development-specialist, data-pipeline-specialist

---

## 🎭 Maestro Mode (Optional)

An opinionated AI personality that:
- Enforces your RULEBOOK patterns strictly
- Speaks Colombian Spanish or direct English
- Won't sugarcoat issues with your code
- Orchestrates agents intelligently
- Educates you on WHY patterns matter
- Uses structured 4-mode workflow

**Activation:** Type `/maestro` in Claude Code (after installation)

**Personality:**
- Direct, confrontational, no filter
- Senior Architect with 15+ years experience
- Genuine educational intent
- Tony Stark/Jarvis dynamic with you

### 4-Mode Workflow

For new features or significant changes:

```
📋 PLANNING MODE
  → Analyze task, create plan, get approval

💻 DEVELOPMENT MODE
  → Execute plan step-by-step

🔍 REVIEW MODE
  → Show changes, get feedback, iterate

📦 COMMIT MODE
  → Generate commit message, get approval, commit
```

**Benefits:**
- Clear communication at each step
- User stays in control
- No surprises or auto-commits
- Proper commit messages matching your project's style
- Quality gates before code, review, and commit

---

## 🧠 How It Works

### 1. Auto-Detection

The toolkit reads your `.claude/RULEBOOK.md` to understand your stack:

```markdown
## Tech Stack

### Frontend
- Framework: Next.js 16
- Language: TypeScript
- Styling: Tailwind CSS

### Backend
- API: tRPC
- Database: PostgreSQL
- ORM: Prisma
```

**Auto-activated agents:**
→ nextjs-specialist, react-specialist, typescript-pro
→ tailwind-expert, prisma-specialist, postgres-expert
→ rest-api-architect (tRPC uses REST-like patterns)

**Total: 10 core + 7 specialized = 17 active agents**

### 2. Smart Routing

Tasks are automatically routed based on complexity:

```
Trivial (<10 lines)     → 0 agents  (Maestro handles directly)
Simple (<50 lines)      → 1 agent   (Quick verification)
Moderate (50-200 lines) → 2-4 agents (Orchestrated workflow)
Complex (>200 lines)    → 5-10 agents (Full pipeline)
Critical (security/auth)→ 6-12 agents (Maximum oversight)
```

### 3. Multi-Agent Pipelines

For complex tasks, agents work in coordinated pipelines:

**Example: "Add analytics dashboard"**
```yaml
Phase 1 - Architecture:
  - architecture-advisor: Design feature

Phase 2 - Implementation:
  - [framework-specialist]: Components
  - [database-specialist]: Queries
  - [styling-specialist]: Layout

Phase 3 - Quality:
  - test-strategist: Test plan
  - [testing-specialist]: Tests
  - code-reviewer: Final review
```

---

## 📚 Documentation

- [Installation Guide](docs/INSTALLATION.md)
- [Agent Selection Guide](templates/AGENT_SELECTION_GUIDE.md)
- [MCP Integration Guide](templates/MCP_INTEGRATION_GUIDE.md)
- [RULEBOOK Template](templates/RULEBOOK_TEMPLATE.md)
- [Maestro Mode Guide](docs/MAESTRO_MODE.md)

---

## 💡 Usage Examples

### Example 1: Next.js + TypeScript + Prisma

**Your RULEBOOK.md:**
```markdown
## Tech Stack
Frontend: Next.js 16, React 19, TypeScript
Backend: tRPC, Prisma
Database: PostgreSQL
Testing: Vitest, Playwright
```

**Auto-activated agents:** 19 agents
**Task:** "Add user authentication"
**Pipeline:** 8 agents (architecture → database → backend → frontend → tests → review)
**Time:** ~3 hours with agent assistance

### Example 2: Express + MongoDB + JavaScript

**Your RULEBOOK.md:**
```markdown
## Tech Stack
Backend: Express.js, JavaScript
Database: MongoDB
Testing: Jest
```

**Auto-activated agents:** 14 agents
**Task:** "Fix API rate limiting bug"
**Pipeline:** 3 agents (analyzer → fix → tests)
**Time:** ~30 minutes

### Example 3: React Native + Expo

**Your RULEBOOK.md:**
```markdown
## Tech Stack
Mobile: React Native, Expo SDK 52
Language: TypeScript
Testing: Jest, Maestro
```

**Auto-activated agents:** 16 agents
**Task:** "Security audit of auth flow"
**Pipeline:** 6 agents (full security audit)
**Time:** ~6 hours (comprehensive)

---

## 🎯 Key Features

### 1. Zero Configuration

For common stacks (Next.js, React, Express, etc.), the toolkit works out-of-the-box:
- Detects your stack automatically
- Activates relevant agents
- Generates RULEBOOK from template
- Ready to use in < 2 minutes

### 2. RULEBOOK-Driven

Everything adapts to **YOUR** project's RULEBOOK:
- Agents read your patterns
- Follow your conventions
- Enforce your standards
- Respect your tech choices

### 3. Scalable Complexity

Handles tasks from trivial to critical:
- Simple fix? No agents needed
- Complex feature? 10 agents coordinate
- Security audit? Full team deploys

### 4. Production-Grade

Built for real projects, not demos:
- All agents updated with 2026 features
- Modern framework patterns (React 19, Next.js 16, etc.)
- Security best practices (OWASP Top 10)
- Performance optimization patterns
- Accessibility compliance (WCAG 2.1 AA)

---

## 🛠️ Installation Details

### System Requirements

- **Claude Code**: Latest version
- **Operating System**: macOS, Linux, Windows (WSL)
- **Node.js**: 18+ (for detection scripts)
- **Git**: For cloning the repository

### Preview Before Installing (Recommended)

**Dry Run Mode - See what will be installed:**
```bash
./install.sh --dry-run
# Shows:
# - What directories will be created
# - What files will be copied
# - What agents will be activated
# - No actual changes made
```

### Installation Options

**Option 1: Full Installation (Recommended)**
```bash
./install.sh
# Installs: 78 agents + Maestro Mode + RULEBOOK generator
```

**Option 2: Agents Only**
```bash
./install.sh --agents-only
# Installs: 78 agents (skip Maestro Mode)
```

**Option 3: Custom Selection (Interactive)**
```bash
./install.sh --custom
# Interactive prompts for:
#   - Install Maestro Mode? (Y/n)
#   - Choose language: English or Spanish (1-2)
#   - Enable self-enhancement? (Y/n)
# Perfect for first-time users who want guided setup
```

**Example Custom Mode Flow:**
```bash
$ ./install.sh --custom

Custom Installation Mode

Install Maestro Mode? (Y/n): y

Choose Maestro communication language:
  [1] English (default)
  [2] Spanish (Colombian)

Select option (1-2) [1]: 1
✓ Selected: English

Enable self-enhancement? (Maestro learns and adapts with your approval)
Enable self-enhancement? (Y/n): y
✓ Self-enhancement: Enabled
```

**Option 4: Preview Installation**
```bash
./install.sh --dry-run
# Preview what will be installed without making changes
```

### What Gets Installed

```
your-project/
└── .claude/
    ├── agents-global/          # 78 agents
    │   ├── core/              # 10 core agents
    │   └── pool/              # 68 specialized agents
    ├── commands/              # Optional: Maestro Mode
    │   ├── maestro.md
    │   ├── agent-intelligence.md
    │   └── agent-router.md
    └── RULEBOOK.md            # Generated from template (if missing)
```

### 🔒 Safety & Automatic Backups

**The installer automatically protects your existing configuration:**

```bash
# If .claude/ directory exists, a backup is created automatically
./install.sh
# ⚠ Existing .claude directory found!
# A backup will be created at: .claude.backup.2026-01-07-143022
# Continue with backup and installation? (y/N):
```

**Backup Features:**
- ✅ **Automatic Detection** - Installer detects existing `.claude/` directories
- ✅ **Timestamped Backups** - Format: `.claude.backup.YYYY-MM-DD-HHMMSS/`
- ✅ **Full Copy** - All agents, RULEBOOK, settings, and customizations preserved
- ✅ **No Data Loss** - Installation won't proceed without backup confirmation
- ✅ **Dry-Run Preview** - See backup plan before making changes

**Skip Backup (Not Recommended)**
```bash
./install.sh --skip-backup
# Skips automatic backup creation
# Only use if you've manually backed up your configuration
```

**Restore From Backup**
```bash
# If something goes wrong, restore from backup:
rm -rf .claude
mv .claude.backup.2026-01-07-143022 .claude
```

**Dry-Run Preview**
```bash
./install.sh --dry-run
# Shows:
# - Whether backup would be created
# - Backup location
# - What files would be installed
# - No actual changes made
```

### 🔍 Conflict Detection

**The installer automatically detects potential conflicts before making changes:**

**Types of Conflicts Detected:**

1. **Version Conflicts**
   - Detects existing toolkit version
   - Recommends using `./update.sh` instead of reinstalling
   - Prevents version mismatches

2. **Partial Installations**
   - Identifies missing critical directories (agents-global/)
   - Detects missing critical files (RULEBOOK.md)
   - Warns about potentially corrupted installations

3. **Custom Agent Conflicts**
   - Counts agents in pool directory
   - Warns if custom agents might be overwritten
   - Preserves your custom work

4. **RULEBOOK Format Issues**
   - Validates required sections exist
   - Detects outdated format (GENTLEMAN MODE → MAESTRO MODE)
   - Ensures compatibility

5. **Multiple Maestro Files**
   - Detects duplicate maestro configurations
   - Ensures clean installation

6. **Permission Conflicts** (Critical)
   - Checks write permissions on .claude directory
   - Provides fix command if needed
   - Prevents installation failure

7. **Symbolic Link Detection**
   - Warns if .claude is a symlink
   - Alerts about potential impact on linked locations

8. **Settings Validation**
   - Validates settings.json syntax
   - Detects invalid JSON
   - Prevents configuration issues

**Example Output:**

```bash
./install.sh

ℹ Checking for potential conflicts...

⚠ Partial installation detected:
  → Missing: .claude/agents-global/
  → Missing: .claude/RULEBOOK.md
  → This may indicate a corrupted installation

⚠ Warnings detected. Review the issues above.

These are non-critical but may require attention.
Continue with installation anyway? (y/N):
```

**Conflict Types:**
- **Critical Conflicts** - Installation cannot proceed (e.g., permission errors)
- **Warnings** - Installation can continue but may need attention

**Resolution:**
- Follow the recommendations provided in warnings
- Use `./update.sh` for version updates
- Fix permissions with suggested commands
- Review and backup custom work before proceeding

---

## 📋 RULEBOOK Questionnaire

### Generate Your Custom RULEBOOK Interactively

Don't want to manually create your RULEBOOK? Use the interactive questionnaire:

```bash
./questionnaire.sh
```

### What It Does

The questionnaire asks about your project and generates a comprehensive, customized RULEBOOK.md with:

- ✅ **Tech Stack** - Framework, language, database, ORM
- ✅ **Architecture** - Folder structure, patterns
- ✅ **State Management** - Redux, Zustand, Context, etc.
- ✅ **Styling** - Tailwind, CSS Modules, Styled Components
- ✅ **Testing** - Vitest, Jest, Playwright setup
- ✅ **API Design** - REST, GraphQL, tRPC patterns
- ✅ **Code Patterns** - Naming conventions, import order
- ✅ **Security & Performance** - Best practices
- ✅ **Active Agents** - Auto-populated based on stack

### Questions Asked

1. **Project Information** - Name and description
2. **Framework** - Next.js, React, Vue, Express, etc.
3. **Language** - TypeScript, JavaScript, Python, Go
4. **State Management** - Redux Toolkit, Zustand, Context
5. **Styling** - Tailwind, CSS Modules, Styled Components
6. **Testing** - Vitest, Jest, Playwright, Cypress
7. **Database** - PostgreSQL, MongoDB, MySQL, Redis
8. **ORM** - Prisma, Drizzle, TypeORM, Sequelize
9. **API Type** - REST, GraphQL, tRPC, gRPC
10. **Deployment** - Vercel, AWS, Docker, etc.
11. **Code Organization** - File naming, structure

### Example Flow

```bash
$ ./questionnaire.sh

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Framework & Language
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

What is your primary framework?

  [1] Next.js
  [2] React (CRA/Vite)
  [3] Vue.js
  [4] Angular
  [5] Svelte/SvelteKit
  [6] Express.js
  [7] Fastify
  [8] NestJS
  [9] Other

Enter choice [1-9]: 1

# ... more questions ...

✓ RULEBOOK generated successfully!
```

### Output

Creates `.claude/RULEBOOK.md` with:
- Complete tech stack documentation
- Recommended folder structure
- Code organization patterns
- Testing requirements
- Security guidelines
- Performance targets
- Activated agents list

**Backup:** If RULEBOOK exists, it creates `.claude/RULEBOOK.md.backup` before overwriting.

---

## 🌐 Language Switching

### Change Maestro Language Without Reinstalling

Switch between English and Spanish Maestro Mode instantly:

**Toggle Language (Auto-detect current)**
```bash
./switch-language.sh
# Automatically switches to the other language
```

**Switch to Specific Language**
```bash
./switch-language.sh es        # Switch to Spanish
./switch-language.sh english   # Switch to English
```

### What Gets Changed

- ✅ **Maestro Communication** - Language for responses and messages
- ✅ **Automatic Backup** - Creates `.claude/commands/maestro.md.backup`

### What Stays the Same

- ✅ **All Agents** - 78 agents remain unchanged
- ✅ **RULEBOOK** - Your project patterns preserved
- ✅ **Settings** - All configurations intact
- ✅ **Self-Enhancement** - Enabled/disabled state preserved
- ✅ **Code Language** - Always English, regardless of communication language

### Quick Examples

```bash
# Currently English → Switch to Spanish
./switch-language.sh es

# Currently Spanish → Switch to English
./switch-language.sh en

# Don't know current language? Toggle it
./switch-language.sh

# Restore previous language
mv .claude/commands/maestro.md.backup .claude/commands/maestro.md
```

**No reinstallation required!** Changes take effect immediately when you next activate Maestro.

---

## 🏥 Health Check

### Verify Your Installation

Run a comprehensive health check to verify installation integrity:

```bash
./healthcheck.sh
```

### What Gets Checked

The health check validates:

- ✅ **Installation Integrity** - Verifies .claude directory exists
- ✅ **Directory Structure** - Checks all required directories
- ✅ **Core Agents** - Validates 10 core agents present
- ✅ **Specialized Agents** - Checks 68 specialized agents
- ✅ **Maestro Mode** - Verifies Maestro installation
- ✅ **RULEBOOK** - Validates RULEBOOK structure and customization
- ✅ **Version Info** - Shows installed version
- ✅ **Settings** - Validates settings.local.json syntax
- ✅ **Common Issues** - Detects duplicate files, old backups
- ✅ **Documentation** - Checks required docs present

### Health Check Output

```bash
# Example output:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Health Check Summary
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  Total Checks: 25
  ✓ Passed: 23
  ⚠ Warnings: 2
  ✗ Failed: 0

════════════════════════════════════════════════════════
  ⚠ GOOD - Minor warnings found
════════════════════════════════════════════════════════
```

### Exit Codes

- **0** - All checks passed (healthy)
- **1** - Warnings found (mostly healthy)
- **2** - Critical failures (needs attention)

### Options

```bash
./healthcheck.sh --help       # Show help
./healthcheck.sh --verbose    # Show detailed info
```

Use health check to diagnose issues before reporting bugs or after updates.

---

## 🔄 Updates

### Keeping Your Toolkit Up-to-Date

**Check for Updates**
```bash
./update.sh --check
# Shows current and latest versions without installing
```

**Update Everything (Recommended)**
```bash
./update.sh
# Updates: Agents + Maestro Mode
# Preserves: RULEBOOK, settings, language preference
# Creates automatic backup
```

**Partial Updates**
```bash
./update.sh --agents-only      # Update only agents
./update.sh --maestro-only     # Update only Maestro Mode
```

### What Gets Preserved

All your customizations are automatically preserved during updates:

- ✅ **RULEBOOK.md** - Your project patterns and conventions
- ✅ **settings.local.json** - Your Claude Code settings
- ✅ **Maestro Language** - English or Spanish preference
- ✅ **Self-Enhancement** - Enabled/disabled state

### Version Management

The toolkit tracks versions in `.claude/.toolkit-version`:

```bash
# Check current version
cat .claude/.toolkit-version

# Compare with latest
./update.sh --check
```

### Update Safety

- ✅ **Automatic Backup**: Creates `.claude.backup.YYYY-MM-DD-HHMMSS/` before updating
- ✅ **Preserves Customizations**: RULEBOOK and settings remain intact
- ✅ **Language Preserved**: Maestro keeps your language preference
- ✅ **Reversible**: Easy rollback from backup if needed

---

## 🗑️ Uninstallation

### Uninstall Options

**Option 1: Standard Uninstall (Keep RULEBOOK)**
```bash
./uninstall.sh
# Removes: Agents + Maestro Mode
# Keeps: RULEBOOK.md
# Creates automatic backup
```

**Option 2: Full Uninstall (Remove Everything)**
```bash
./uninstall.sh --full
# Removes: Agents + Maestro Mode + RULEBOOK
# Creates automatic backup
```

**Option 3: Partial Uninstall**
```bash
./uninstall.sh --agents-only      # Remove only agents
./uninstall.sh --maestro-only     # Remove only Maestro Mode
```

### Safety Features

- ✅ **Automatic Backup**: Creates `.claude.backup.YYYY-MM-DD-HHMMSS/` before uninstalling
- ✅ **Interactive Prompts**: Asks for confirmation before destructive actions
- ✅ **RULEBOOK Protected**: Preserved by default (unless --full flag used)
- ✅ **Reversible**: Easy to restore from backup

### Restore from Backup

If you change your mind:
```bash
# Remove current .claude directory
rm -rf .claude

# Restore from backup
mv .claude.backup.YYYY-MM-DD-HHMMSS .claude

# Or reinstall fresh
./install.sh
```

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to add new agents
- Agent quality standards
- Submission process
- Code of conduct

**Areas where we need help:**
- More language specialists (Ruby, Kotlin, Swift, etc.)
- Platform-specific agents (iOS, Android native)
- Domain-specific agents (FinTech, HealthTech, etc.)
- Framework updates (as new versions release)
- Documentation improvements

---

## 📄 License

MIT License - see [LICENSE](LICENSE) file for details.

Free for personal and commercial use. Attribution appreciated but not required.

---

## 🙏 Acknowledgments

- Inspired by [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
- Built for the Claude Code community
- Powered by [Context7](https://context7.com) for latest 2026 documentation
- All agents created and maintained by the community

---

## 📊 Project Stats

- **Total Agents:** 78 (10 core + 68 specialized)
- **Framework Coverage:** 20+ frameworks
- **Language Coverage:** 8 languages
- **Database Coverage:** 8 databases
- **Lines of Code:** ~50,000+ (agents + docs)
- **Last Updated:** January 2026
- **Version:** 1.0.0

---

## 🔗 Links

- **Documentation:** [docs/](docs/)
- **Issues:** [GitHub Issues](https://github.com/yourusername/claude-code-agents-toolkit/issues)
- **Discussions:** [GitHub Discussions](https://github.com/yourusername/claude-code-agents-toolkit/discussions)
- **Claude Code:** [https://claude.com/claude-code](https://claude.com/claude-code)

---

## ⭐ Star History

If this toolkit helps you, consider giving it a star! ⭐

---

**Built with ❤️ by the Claude Code community. Let's build software that doesn't suck. 💪**
