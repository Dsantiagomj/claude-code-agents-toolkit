# Claude Code Agents Global Toolkit

> A comprehensive collection of 72 specialized AI agents for [Claude Code](https://claude.com/claude-code), designed to enhance your development workflow with intelligent task delegation and smart agent selection.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 🎯 What Is This?

A production-ready toolkit of **72 specialized AI agents** that work seamlessly with Claude Code to:

- ✅ Auto-detect your project's tech stack from RULEBOOK.md
- ✅ Automatically select the right specialists for each task
- ✅ Route complex tasks to multi-agent pipelines
- ✅ Enforce your project's patterns and conventions
- ✅ Maintain code quality through specialized reviews
- ✅ Scale from simple tasks (0 agents) to critical systems (12+ agents)

---

## 🚀 Quick Start

### 📡 Remote Installation (Recommended)

**Global installation is now the default!** Install once, use in all your projects:

```bash
# Interactive mode (with prompts and RULEBOOK wizard)
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh)

# Auto-install mode (no prompts, auto-confirms)
curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh | bash

# With options
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh) --lang=es  # Spanish
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh) --local    # Local install (not recommended)
```

**What gets installed:**

- **Global** (`~/.claude-global/`): All 72 agents, commands, and scripts (installed once)
- **Per-project** (`.claude/`): Symlinks to global + project-specific `RULEBOOK.md`

This keeps your projects clean while sharing agents across all your work!

**Note:** The installer auto-detects if you're piping (`curl | bash`) and enables non-interactive mode automatically. Use `bash <(curl ...)` for interactive prompts.

### 📦 Repository-Based Installation

For development or contributing:

```bash
# 1. Clone the repository
git clone https://github.com/Dsantiagomj/claude-code-agents-toolkit
cd claude-code-agents-toolkit

# 2. Navigate to your project
cd /path/to/your/project

# 3. Run the installer
/path/to/toolkit/install.sh
```

### 🧙 Smart RULEBOOK Wizard

After installation, the wizard will help you set up your RULEBOOK:

```
🧙 RULEBOOK Wizard - Smart Project Setup

📂 Scanning Current Directory
  ✓ Found: package.json
  ✓ Framework: Next.js
  ✓ Language: TypeScript
  ✓ Database/ORM: Prisma

🎯 How would you like to create your RULEBOOK?

  [1] Use detected configuration (auto-generate) → Recommended
  [2] Answer questions interactively
  [3] Start with minimal template
  [4] Skip for now

Enter your choice [1-4]:
```

The wizard:
- ✅ Scans your current directory for project files
- ✅ Detects framework, language, database, tools
- ✅ Shows what it found and if it helped
- ✅ Auto-generates RULEBOOK with recommended agents
- ✅ Works in empty directories (uses interactive mode)
- ✅ Can be run anytime with `scripts/rulebook-wizard.sh`

**Installation time:** < 2 minutes
**Manual configuration:** Zero (for common stacks)

### 🌍 Using in Multiple Projects

Since global installation is the default, setting up new projects is fast and easy:

#### Option 1: Quick Init (Recommended)

If you already have the global installation:

```bash
cd ~/my-new-project
~/.claude-global/scripts/init-project.sh
```

Or download and run remotely:

```bash
cd ~/my-new-project
curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/scripts/init-project.sh | bash
```

**What it does:**
- ✅ Checks for global installation at `~/.claude-global/`
- ✅ Creates `.claude/` with symlinks (instant)
- ✅ Creates `.claude/agents-active.txt` for project-specific agent selection
- ✅ Adds `.claude/` to `.gitignore`
- ✅ Runs RULEBOOK wizard for project config

**Time:** < 10 seconds

#### Option 2: Full Installer

```bash
cd ~/my-new-project
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh)
```

The installer detects existing global installation and skips re-downloading agents.

**Benefits:**
- ✅ Share 72 agents across all your projects
- ✅ Each project has its own `RULEBOOK.md`
- ✅ Each project can activate different agents via `agents-active.txt`
- ✅ Saves disk space (one copy of agents)
- ✅ Update agents once, applies everywhere

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

## ⚠️ CRITICAL: context7 MCP Server (2026 Requirement)

### Why You MUST Use context7

**Claude's knowledge cutoff is January 2025. We're now in January 2026.**

For accurate code generation, you MUST install the context7 MCP server. This allows Maestro to fetch the **latest documentation** for frameworks and libraries before generating code.

### Quick Setup

Add context7 to your `.claude/settings.json`:

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

### Why This Matters

Without context7, Maestro will use **outdated patterns** from January 2025:
- ❌ Old Next.js App Router patterns
- ❌ Deprecated React hooks/APIs
- ❌ Outdated TypeScript syntax
- ❌ Old Tailwind CSS utilities
- ❌ Changed Prisma/tRPC/Drizzle APIs

**With context7:**
- ✅ Latest framework documentation (2026)
- ✅ Current API syntax and patterns
- ✅ Up-to-date best practices
- ✅ Accurate code generation
- ✅ No deprecated warnings

### How Maestro Uses context7

Maestro **automatically fetches latest docs** before generating code:

```bash
# Example workflow when you ask for Next.js code:
1. User: "Create a server action for form submission"
2. Maestro: [Fetches latest Next.js 15 Server Actions docs via context7]
3. Maestro: [Generates code using 2026 patterns]
4. Result: Code works perfectly with current Next.js version
```

### Tools That REQUIRE context7

- **Next.js** - App Router changes frequently
- **React** - Server Components, new hooks, Suspense
- **TypeScript** - New syntax, compiler options
- **Tailwind CSS** - Utility classes, configuration
- **tRPC, Prisma, Drizzle** - API changes
- **Testing libraries** - Vitest, Playwright, Jest
- **State management** - Zustand, Redux Toolkit

### Verification

After installing context7, test it:

```bash
# In Claude Code with Maestro:
/maestro
> "Fetch the latest Next.js App Router documentation"
```

If context7 is working, Maestro will successfully fetch and summarize the latest Next.js docs.

**💡 Pro Tip:** context7 is automatically configured in generated RULEBOOKs. If you used `./install.sh`, you're already set up!

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
# Installs: 72 agents + Maestro Mode + RULEBOOK generator
```

**Option 2: Agents Only**
```bash
./install.sh --agents-only
# Installs: 72 agents (skip Maestro Mode)
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
    ├── agents-global/          # 72 agents
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
scripts/questionnaire.sh
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
$ scripts/questionnaire.sh

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

## 🎯 Agent Management

### Interactive Agent Selector

Easily activate/deactivate specific agents with an interactive menu:

```bash
scripts/select-agents.sh
```

### Features

- **Browse by Category** - Organized by Frontend, Backend, Languages, etc.
- **Visual Selection** - See which agents are active at a glance
- **Bulk Actions** - Activate/deactivate entire categories
- **Auto-save** - Changes saved directly to RULEBOOK.md
- **Safe** - Creates backup before modifying RULEBOOK

### Categories

The agent selector organizes all 72 agents into 9 categories:

1. **Core Agents (10)** - Always recommended for any project
2. **Frontend Frameworks (8)** - React, Vue, Angular, Svelte, etc.
3. **Backend Frameworks (8)** - Express, NestJS, Fastify, etc.
4. **Full-Stack Frameworks (6)** - Next.js, Nuxt, Remix, etc.
5. **Programming Languages (8)** - TypeScript, Python, Go, Rust, etc.
6. **Databases & ORMs (8)** - PostgreSQL, MongoDB, Prisma, etc.
7. **Infrastructure & DevOps (9)** - Docker, Kubernetes, AWS, etc.
8. **Testing Frameworks (7)** - Jest, Playwright, Vitest, etc.
9. **Specialized Domains (8)** - Mobile, Desktop, Web3, AI/ML, etc.

### Usage Example

```bash
$ scripts/select-agents.sh

╔══════════════════════════════════════════════════════╗
║  🎯 Claude Code Agents Selector                  ║
╚══════════════════════════════════════════════════════╝

Select agent category to configure:

  [1] Core Agents (10 agents)
  [2] Frontend Frameworks (8 agents)
  [3] Backend Frameworks (8 agents)
  [4] Full-Stack Frameworks (6 agents)
  [5] Languages (8 agents)
  [6] Databases & ORMs (8 agents)
  [7] Infrastructure & DevOps (9 agents)
  [8] Testing Frameworks (7 agents)
  [9] Specialized Domains (8 agents)

  [A] Activate All Agents
  [D] Deactivate All Agents (keep core)
  [S] Show Current Selection
  [Q] Save & Quit

Select option: 2

# After selecting Frontend Frameworks:

Frontend Frameworks

  [1] [✓] react-specialist
  [2] [ ] vue-specialist
  [3] [ ] angular-specialist
  [4] [✓] svelte-specialist
  [5] [✓] tailwind-expert
  [6] [ ] css-architect
  [7] [✓] ui-accessibility
  [8] [ ] animation-specialist

  [A] Activate All in Category
  [D] Deactivate All in Category
  [B] Back to Main Menu

Select option: 2
# Toggles vue-specialist activation

# Press 'Q' when done to save changes
```

### Quick Actions

- **Activate All Agents** - Press 'A' from main menu to enable all 72 agents
- **Deactivate All** - Press 'D' to keep only core 10 agents
- **Show Current** - Press 'S' to see list of active agents
- **Save & Quit** - Press 'Q' to save to RULEBOOK and exit

### What Gets Modified

The agent selector updates the `## Active Agents` section in your RULEBOOK.md:

**Before:**
```markdown
## Active Agents

- code-reviewer
- refactoring-specialist
- nextjs-specialist
- react-specialist
```

**After (added vue-specialist):**
```markdown
## Active Agents

- code-reviewer
- refactoring-specialist
- nextjs-specialist
- react-specialist
- vue-specialist
```

### Safety

- ✅ **Backup Created** - `.claude/RULEBOOK.md.backup` before saving
- ✅ **No Data Loss** - Only updates Active Agents section
- ✅ **Preserves Custom Content** - All other RULEBOOK sections untouched
- ✅ **Easy Rollback** - Restore from backup if needed

### Agent Testing & Inspection

Inspect individual agents and see example use cases:

```bash
scripts/test-agent.sh
```

**Features:**
- **List All Agents** - See all 72 agents organized by category
- **Search Agents** - Find agents by keyword
- **Agent Details** - View description, examples, and activation status
- **Filter by Category** - Browse agents by type (core, frontend, backend, etc.)
- **Active Agents** - See which agents are currently enabled in RULEBOOK

**Usage Examples:**

```bash
# List all available agents
scripts/test-agent.sh --list

# Search for React-related agents
scripts/test-agent.sh --search react

# Get detailed info about an agent
scripts/test-agent.sh --info nextjs-specialist

# See example use cases
scripts/test-agent.sh --examples code-reviewer

# List agents by category
scripts/test-agent.sh --category frontend

# Show currently active agents
scripts/test-agent.sh --active
```

**Example Output:**

```bash
$ scripts/test-agent.sh --info nextjs-specialist

Agent: nextjs-specialist

Status: ACTIVE
Category: frontend

Description:
Next.js expert: App Router, RSC, Server Actions, ISR, SSR, SSG, routing

Example Use Cases:
  • Implement server actions for this form
  • Optimize this page with ISR
  • Convert this to use App Router

To activate this agent:
  1. Run: scripts/select-agents.sh
  2. Navigate to frontend category
  3. Toggle nextjs-specialist
```

**When to Use:**
- 🔍 Explore available agents before activating
- 📚 Learn what each agent specializes in
- 💡 Find the right agent for your task
- ✅ Verify which agents are currently active

### Agent Statistics & Analytics

Get insights about your agent configuration and optimization recommendations:

```bash
scripts/agent-stats.sh
```

**Features:**
- **Activation Overview** - Total active vs available agents
- **Category Breakdown** - Visual progress bars for each category
- **Performance Analysis** - Context usage and impact estimates
- **Smart Recommendations** - Suggestions based on your stack
- **Project Size Guidance** - Optimal agent counts for small/medium/large projects

**Usage Examples:**

```bash
# Quick summary (default)
scripts/agent-stats.sh

# Detailed breakdown by category
scripts/agent-stats.sh --detailed

# Get optimization recommendations
scripts/agent-stats.sh --recommendations

# Performance impact analysis
scripts/agent-stats.sh --performance
```

**Example Output:**

```bash
$ scripts/agent-stats.sh

📊 Agent Statistics Summary

Overall:
  Total Agents Available: 78
  Total Agents Active:    15
  Activation Rate:        ████████████░░░░░░░░░░░░░░░░  19% (15/72)

By Category:
  Core             ██████████████████████████████████████████  100% (10/10)
  Frontend         ████████████░░░░░░░░░░░░░░░░  38% (3/8)
  Backend          ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/8)
  Full-Stack       ████████████████░░░░░░░░░░░░  33% (2/6)
  Languages        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/8)
  Databases        ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/8)
  Infrastructure   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/9)
  Testing          ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/7)
  Specialized      ░░░░░░░░░░░░░░░░░░░░░░░░░░░░   0% (0/8)

Quick Check:
  ✓  All core agents active
  ✓  Balanced activation (19%)
```

**Performance Analysis:**

```bash
$ scripts/agent-stats.sh --performance

⚡ Performance Impact Analysis

Context Usage:
  Base System:        ~5000 tokens
  Agents (15 active): ~3000 tokens (200 per agent)
  Total Estimated:    ~8000 tokens

Performance Impact:
  ✓ Minimal - Optimal for all project sizes

Recommendations by Project Size:

  Small Projects (< 1000 lines):
    Suggested: 10-15 agents (Core + main stack)
    Your setup: ✓ Optimal (15 agents)

  Medium Projects (1K-10K lines):
    Suggested: 15-25 agents (Core + stack + domain)
    Your setup: ✓ Optimal (15 agents)

  Large Projects (10K+ lines):
    Suggested: 25-40 agents (Core + full stack + specialized)
    Your setup: Room for 15 more specialized agents
```

**Smart Recommendations:**

The recommendations mode analyzes your RULEBOOK to detect your tech stack and suggests relevant agents:

```bash
$ scripts/agent-stats.sh --recommendations

💡 Agent Optimization Recommendations

Current Configuration:
  Active Agents: 15 / 78 (19%)

1. Core Agents (Essential)
   ✓ All core agents active

2. Stack-Specific Agents
   💡 Detected Next.js - consider activating:
      • nextjs-specialist
      • react-specialist

   💡 Detected PostgreSQL - consider activating:
      • postgres-expert
      • prisma-orm-specialist

3. Activation Density
   ✓ Good balance (19%)
```

**When to Use:**
- 📊 Understand your current agent configuration
- 🎯 Optimize agent activation for your project size
- 💡 Get suggestions based on detected tech stack
- ⚡ Analyze performance impact
- 🔧 Fine-tune agent selection

---

## ✓ RULEBOOK Validation

### Validate Your RULEBOOK

Ensure your RULEBOOK.md is properly formatted and configured:

```bash
scripts/validate-rulebook.sh
```

### Validation Checks

The validator performs 8 comprehensive checks:

1. **File Existence** - Verifies RULEBOOK.md exists
2. **Required Sections** - Ensures Project Overview, Tech Stack, Active Agents sections present
3. **No Duplicates** - Detects duplicate section headers
4. **Active Agents Validity** - Validates agent names against available agents
5. **Tech Stack Documentation** - Checks for framework and language documentation
6. **Markdown Formatting** - Validates heading hierarchy and structure
7. **Outdated Content** - Detects old naming (GENTLEMAN MODE, WRAPUP MODE)
8. **File Permissions** - Checks read/write permissions

### Example Output

```bash
$ scripts/validate-rulebook.sh

╔══════════════════════════════════════════════════════╗
║  ✓ RULEBOOK Validator                            ║
╚══════════════════════════════════════════════════════╝

ℹ Checking RULEBOOK.md existence...
✓ RULEBOOK.md exists

ℹ Checking required sections...
✓ Section found: Project Overview
✓ Section found: Tech Stack
✓ Section found: Active Agents

ℹ Checking for duplicate sections...
✓ No duplicate sections found

ℹ Validating Active Agents section...
✓ Active Agents section has 15 agents
ℹ Validating agent names...
✓ All agent names are valid

ℹ Checking Tech Stack section...
✓ Tech Stack section exists
✓ Framework documented
✓ Language documented

ℹ Checking markdown formatting...
✓ Markdown heading hierarchy is correct
✓ Basic markdown formatting validated

ℹ Checking for outdated content...
✓ No outdated content detected

ℹ Checking file permissions...
✓ RULEBOOK is readable
✓ RULEBOOK is writable

═══════════════════════════════════════════════════════
  Validation Summary
═══════════════════════════════════════════════════════

Passed:   16 checks
Warnings: 0 issues
Errors:   0 critical issues

✓ RULEBOOK is valid!
```

### Exit Codes

Use exit codes in scripts or CI/CD pipelines:

- **0** - RULEBOOK is valid (no warnings or errors)
- **1** - RULEBOOK has warnings (usable but could be improved)
- **2** - RULEBOOK has critical errors (needs fixes)

```bash
# Use in CI/CD
scripts/validate-rulebook.sh && echo "RULEBOOK is valid!" || echo "RULEBOOK needs attention"

# Check exit code
scripts/validate-rulebook.sh
if [ $? -eq 0 ]; then
    echo "✓ RULEBOOK validated successfully"
fi
```

### Common Issues & Fixes

**Missing Required Sections:**
```markdown
## Project Overview
Your project description here

## Tech Stack
- Framework: Next.js
- Language: TypeScript

## Active Agents
- code-reviewer
- nextjs-specialist
```

**Invalid Agent Names:**
- Check agent name spelling
- Verify agent exists in `.claude/agents-global/`
- Use `./select-agents.sh` to manage agents

**Outdated Content:**
- Replace "GENTLEMAN MODE" with "MAESTRO MODE"
- Replace "WRAPUP MODE" with "COMMIT MODE"
- Run `./migrate.sh` if upgrading from old versions

### When to Validate

- ✅ After manual RULEBOOK edits
- ✅ Before committing RULEBOOK changes
- ✅ After running `scripts/questionnaire.sh`
- ✅ After using `scripts/select-agents.sh`
- ✅ In CI/CD pipelines for quality checks
- ✅ After migrating from old toolkit versions with `scripts/migrate.sh`

---

## 🌐 Language Switching

### Change Maestro Language Without Reinstalling

Switch between English and Spanish Maestro Mode instantly:

**Toggle Language (Auto-detect current)**
```bash
scripts/switch-language.sh
# Automatically switches to the other language
```

**Switch to Specific Language**
```bash
scripts/switch-language.sh es        # Switch to Spanish
scripts/switch-language.sh english   # Switch to English
```

### What Gets Changed

- ✅ **Maestro Communication** - Language for responses and messages
- ✅ **Automatic Backup** - Creates `.claude/commands/maestro.md.backup`

### What Stays the Same

- ✅ **All Agents** - 72 agents remain unchanged
- ✅ **RULEBOOK** - Your project patterns preserved
- ✅ **Settings** - All configurations intact
- ✅ **Self-Enhancement** - Enabled/disabled state preserved
- ✅ **Code Language** - Always English, regardless of communication language

### Quick Examples

```bash
# Currently English → Switch to Spanish
scripts/switch-language.sh es

# Currently Spanish → Switch to English
scripts/switch-language.sh en

# Don't know current language? Toggle it
scripts/switch-language.sh

# Restore previous language
mv .claude/commands/maestro.md.backup .claude/commands/maestro.md
```

**No reinstallation required!** Changes take effect immediately when you next activate Maestro.

---

## 🔧 Self-Enhancement Toggle

### Enable/Disable Self-Enhancement Without Reinstalling

Control Maestro's learning capability with a simple toggle:

```bash
scripts/toggle-enhancement.sh
```

### What is Self-Enhancement?

Self-enhancement allows Maestro to:
- ✅ **Learn from interactions** - Adapts to your feedback
- ✅ **Remember patterns** - Learns your coding style preferences
- ✅ **Improve over time** - Gets better at helping you
- ✅ **Requires approval** - All changes need your explicit approval

When disabled:
- ⚡ **Static behavior** - Consistent, predictable responses
- ⚡ **No learning** - Same behavior every session
- ⚡ **Faster** - No learning overhead

### Usage

**Toggle Current State**
```bash
scripts/toggle-enhancement.sh
# Auto-detects and switches: enabled → disabled or disabled → enabled
```

**Enable Self-Enhancement**
```bash
scripts/toggle-enhancement.sh on
# or
scripts/toggle-enhancement.sh enable
```

**Disable Self-Enhancement**
```bash
scripts/toggle-enhancement.sh off
# or
scripts/toggle-enhancement.sh disable
```

**Check Current Status**
```bash
scripts/toggle-enhancement.sh status
```

### Example Output

```bash
$ scripts/toggle-enhancement.sh

╔══════════════════════════════════════════════════════╗
║  🔧 Self-Enhancement Toggle                      ║
╚══════════════════════════════════════════════════════╝

ℹ Running from project directory
ℹ Detecting current self-enhancement state...
✓ Self-enhancement is currently: DISABLED

ℹ Toggle mode: DISABLED → ENABLED

ℹ Enabling self-enhancement...
✓ Self-enhancement enabled

What this means:
  • Maestro can now learn from interactions
  • Improvements require your approval
  • Learning is stored in .claude/commands/self-enhancement.md

════════════════════════════════════════════════════════
  Self-Enhancement Enabled!
════════════════════════════════════════════════════════

Next time you use Maestro Mode:
  • Maestro will be able to learn
  • All changes require your approval
  • Learning stored in: .claude/commands/self-enhancement.md

Activate Maestro: /maestro in Claude Code
```

### How It Works

**When Enabled:**
- File exists: `.claude/commands/self-enhancement.md`
- Maestro reads and updates this file as it learns
- All updates require your approval
- Learning persists across sessions

**When Disabled:**
- File removed (backed up to `.backup`)
- Maestro uses static behavior
- No learning or adaptation
- Previous learning preserved in backup

### Safety Features

- ✅ **Automatic Backup** - Creates `.claude/commands/self-enhancement.md.backup` before disabling
- ✅ **No Reinstallation** - Changes take effect immediately
- ✅ **Easy Rollback** - Restore from backup anytime
- ✅ **No Data Loss** - Previous learning always preserved

### Restore Previous Learning

If you disabled self-enhancement and want to restore previous learning:

```bash
mv .claude/commands/self-enhancement.md.backup .claude/commands/self-enhancement.md
```

### When to Use Each Mode

**Enable Self-Enhancement:**
- 👍 Working on a long-term project
- 👍 Want Maestro to learn your patterns
- 👍 Willing to approve improvements
- 👍 Value adaptive assistance

**Disable Self-Enhancement:**
- 👍 Quick tasks or experiments
- 👍 Want consistent behavior
- 👍 Prefer faster responses
- 👍 Don't want to manage approvals

---

## 🪝 Git Hooks Integration

### Automated Code Quality Gates

Automatically validate code and enforce standards on git events:

```bash
scripts/install-git-hooks.sh --all
```

### Available Hooks

**pre-commit** - Runs before each commit
- ✅ Validates RULEBOOK.md if modified
- ✅ Checks for large files (>1MB)
- ✅ Detects merge conflict markers
- ✅ Warns about debugging statements
- ⚠️ Blocks commit if validation fails

**pre-push** - Runs before pushing to remote
- ✅ Comprehensive RULEBOOK validation
- ✅ Checks toolkit version
- ✅ Ensures project is ready for remote
- ⚠️ Blocks push if validation fails

**commit-msg** - Validates commit message format
- ✅ Enforces minimum message length (10 chars)
- ✅ Suggests conventional commits format
- ⚠️ Blocks commit if message too short
- 💡 Warns but allows non-conventional format

**post-merge** - Runs after git pull/merge (informational)
- 📢 Notifies if RULEBOOK.md changed
- 📢 Suggests running healthcheck
- 📢 Detects dependency updates
- ✅ Non-blocking (informational only)

### Installation

```bash
# Install all hooks (recommended)
scripts/install-git-hooks.sh --all

# Install specific hooks
scripts/install-git-hooks.sh --pre-commit
scripts/install-git-hooks.sh --pre-push
scripts/install-git-hooks.sh --commit-msg
scripts/install-git-hooks.sh --post-merge

# Uninstall all hooks
scripts/install-git-hooks.sh --uninstall
```

### Example Output

```bash
$ scripts/install-git-hooks.sh --all

╔══════════════════════════════════════════════════════╗
║  🪝 Git Hooks Installation                        ║
║     Automated code quality & validation           ║
╚══════════════════════════════════════════════════════╝

✓ Git repository detected

ℹ Installing pre-commit hook...
✓ pre-commit hook installed

ℹ Installing pre-push hook...
✓ pre-push hook installed

ℹ Installing commit-msg hook...
✓ commit-msg hook installed

ℹ Installing post-merge hook...
✓ post-merge hook installed

Installed Hooks:

  ✓ pre-commit
  ✓ pre-push
  ✓ commit-msg
  ✓ post-merge

All hooks installed successfully!

Hooks can be skipped with:
  git commit --no-verify
  git push --no-verify
```

### Skipping Hooks

Sometimes you need to bypass hooks (use sparingly):

```bash
# Skip pre-commit and commit-msg hooks
git commit --no-verify -m "emergency fix"

# Skip pre-push hook
git push --no-verify

# Skip all hooks for this commit
git commit --no-verify && git push --no-verify
```

### Safety Features

- ✅ **Automatic Backup** - Existing hooks are backed up before installation
- ✅ **Timestamped Backups** - `.git/hooks/pre-commit.backup.YYYYMMDD-HHMMSS`
- ✅ **Easy Rollback** - Restore from backup if needed
- ✅ **Clean Uninstall** - Remove all toolkit hooks with `--uninstall`

### When to Use

**Install hooks for:**
- 👍 Team projects (enforce quality standards)
- 👍 Open source repositories (maintain consistency)
- 👍 Long-term projects (prevent quality drift)
- 👍 CI/CD pipelines (pre-validation before remote)

**Skip hooks for:**
- 👎 Quick experiments or prototypes
- 👎 Solo projects where you prefer flexibility
- 👎 Emergency hotfixes (use --no-verify)
- 👎 Projects with custom git workflows

### Benefits

**Code Quality:**
- Catch issues before they reach remote
- Enforce RULEBOOK compliance
- Prevent common mistakes
- Maintain commit message standards

**Team Collaboration:**
- Consistent quality gates
- Shared standards enforcement
- Reduce PR review time
- Prevent broken builds

**Developer Experience:**
- Immediate feedback (no waiting for CI)
- Optional bypass with --no-verify
- Informational post-merge notifications
- Easy to install/uninstall

---

## 🏥 Health Check

### Verify Your Installation

Run a comprehensive health check to verify installation integrity:

```bash
scripts/healthcheck.sh
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
scripts/healthcheck.sh --help       # Show help
scripts/healthcheck.sh --verbose    # Show detailed info
```

Use health check to diagnose issues before reporting bugs or after updates.

---

## 🔄 Updates

### Keeping Your Toolkit Up-to-Date

**Check for Updates**
```bash
scripts/update.sh --check
# Shows current and latest versions without installing
```

**Update Everything (Recommended)**
```bash
scripts/update.sh
# Updates: Agents + Maestro Mode
# Preserves: RULEBOOK, settings, language preference
# Creates automatic backup
```

**Partial Updates**
```bash
scripts/update.sh --agents-only      # Update only agents
scripts/update.sh --maestro-only     # Update only Maestro Mode
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
scripts/update.sh --check
```

### Update Safety

- ✅ **Automatic Backup**: Creates `.claude.backup.YYYY-MM-DD-HHMMSS/` before updating
- ✅ **Preserves Customizations**: RULEBOOK and settings remain intact
- ✅ **Language Preserved**: Maestro keeps your language preference
- ✅ **Reversible**: Easy rollback from backup if needed

---

## 🔄 Version Migration

### Migrating Between Major Versions

For major version changes (e.g., v1.0.0 → v2.0.0), use the migration script:

```bash
scripts/migrate.sh
```

### What migrate.sh Does

The migration script handles version-specific updates while preserving all your customizations:

**What Gets Migrated:**
- ✅ **Agents** → Updated to latest version (72 agents)
- ✅ **Documentation** → Latest guides and templates
- ✅ **Agent Formats** → Updated to new format if changed
- ✅ **Maestro Mode** → Updated to latest version
- ✅ **Version File** → Tracks current version

**What Gets Preserved:**
- ✅ **RULEBOOK.md** → Your custom configuration (100% preserved)
- ✅ **settings.json** → Your Claude Code settings
- ✅ **settings.local.json** → Your local overrides
- ✅ **Custom modifications** → All changes preserved

**Safety Features:**
- ✅ **Automatic Backup** → `.claude.migration-backup.YYYY-MM-DD-HHMMSS/`
- ✅ **RULEBOOK Backup** → `.claude/RULEBOOK.md.pre-migration`
- ✅ **Version Detection** → Automatically detects current version
- ✅ **Easy Rollback** → Restore from backup if needed

### When to Use Each Tool

```bash
# Regular updates (same major version)
scripts/update.sh               # v1.0.0 → v1.1.0

# Major version migrations
scripts/migrate.sh              # v1.0.0 → v2.0.0

# Fresh installation
./install.sh              # New installation or complete reinstall
```

### Migration Example

```bash
$ scripts/migrate.sh

🔄 Claude Code Agents Toolkit Migration Tool

✓ Current version detected: 1.0.0
ℹ Target version: 2.0.0

Migration Plan:
  • Backup current installation
  • Preserve RULEBOOK customizations
  • Preserve settings files
  • Update agents to 2.0.0
  • Update documentation
  • Update version file

Proceed with migration? (y/N): y

ℹ Creating migration backup...
✓ Backup created: .claude.migration-backup.2026-01-07-104530

ℹ Preserving RULEBOOK customizations...
⚠ RULEBOOK has custom changes
  → Custom RULEBOOK will be preserved
✓ RULEBOOK backed up: .claude/RULEBOOK.md.pre-migration

...

✓ Migration Complete!

What was updated:
  → Agents: Updated to 2.0.0 (72 agents)
  → Documentation: Latest version
  → Version file: 2.0.0

What was preserved:
  → RULEBOOK.md (your custom version)
  → settings.json / settings.local.json
  → All your customizations

Backup location:
  → .claude.migration-backup.2026-01-07-104530
```

### Rollback from Migration

If you need to rollback after migration:

```bash
# Remove new version
rm -rf .claude

# Restore backup
mv .claude.migration-backup.2026-01-07-104530 .claude

# Verify
cat .claude/.toolkit-version
```

---

## 🗑️ Uninstallation

### Uninstall Options

**Option 1: Standard Uninstall (Keep RULEBOOK)**
```bash
scripts/uninstall.sh
# Removes: Agents + Maestro Mode
# Keeps: RULEBOOK.md
# Creates automatic backup
```

**Option 2: Full Uninstall (Remove Everything)**
```bash
scripts/uninstall.sh --full
# Removes: Agents + Maestro Mode + RULEBOOK
# Creates automatic backup
```

**Option 3: Partial Uninstall**
```bash
scripts/uninstall.sh --agents-only      # Remove only agents
scripts/uninstall.sh --maestro-only     # Remove only Maestro Mode
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

- **Total Agents:** 78 (10 core + 62 specialized)
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
