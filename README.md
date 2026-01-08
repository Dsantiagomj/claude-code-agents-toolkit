# Claude Code Agents Global Toolkit

> A comprehensive collection of **72 specialized AI agents** for [Claude Code](https://claude.com/claude-code), designed to enhance your development workflow with intelligent task delegation and smart agent selection.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](CONTRIBUTING.md)

---

## 🎯 What Is This?

A production-ready toolkit of **72 specialized AI agents** that work with Claude Code through **two AI personas**:

- **Maestro**: Full-featured with RULEBOOK enforcement, 4-mode workflow, bilingual support
- **Coordinator**: Lightweight task router with generic best practices

**Key Features:**
- ✅ 72 specialized agents (10 core + 62 specialized)
- ✅ Automatic task routing and delegation
- ✅ Production-grade code quality enforcement
- ✅ Global installation (one setup, use everywhere)
- ✅ Context7 integration for latest docs
- ✅ Stack-aware agent activation

---

## 🚀 Quick Start

### Step 1: Global Installation (Once)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)
```

This installs **all 72 agents + both personas** to `~/.claude-global/` in **< 2 minutes**.

### Step 2: Initialize Your Project

```bash
cd your-project
claude-init
```

Choose your persona:
- **[1] Maestro** → Production projects, RULEBOOK enforcement, bilingual
- **[2] Coordinator** → Quick prototypes, generic best practices

### Step 3: Start Coding

```bash
claude              # Open Claude Code
/maestro            # Or /coordinator
```

**First time with Maestro?** It will auto-generate your RULEBOOK by scanning your project (2-3 min).

**Using Coordinator?** Start delegating tasks immediately (no setup).

---

## 🎭 Maestro vs Coordinator

| Feature | Maestro | Coordinator |
|---------|---------|-------------|
| **Best For** | Production, long-term projects | Prototypes, experiments |
| **RULEBOOK** | ✅ Auto-generated & enforced | ❌ Generic best practices |
| **Workflow** | 4-mode (Plan → Dev → Review → Commit) | 3-step (Receive → Delegate → Report) |
| **Agent Selection** | Smart (based on tech stack) | Keyword-based |
| **Languages** | English + Spanish | English only |
| **Learning** | ✅ Adapts to your patterns | ❌ Static behavior |
| **Setup Time** | ~2 min (RULEBOOK generation) | Instant |

### When to Use Maestro

✅ Production-grade projects
✅ Team collaboration with strict patterns
✅ Complex tech stacks
✅ Bilingual teams (English/Spanish)
✅ Want educational feedback

### When to Use Coordinator

✅ Quick prototypes and MVPs
✅ Learning new tech
✅ Prefer faster, simpler setup
✅ Don't need custom patterns

**Switch anytime:** Run `claude-init` and choose a different persona.

---

## 📦 What's Included

### Core Agents (Always Active - 10)

Work on **any** project, regardless of tech stack:

- **code-reviewer** - Code quality review
- **refactoring-specialist** - Code improvement
- **documentation-engineer** - Documentation generation
- **test-strategist** - Test planning & coverage
- **architecture-advisor** - System design
- **security-auditor** - Security scanning
- **performance-optimizer** - Performance analysis
- **git-workflow-specialist** - Git best practices
- **dependency-manager** - Dependency updates
- **project-analyzer** - Codebase analysis

### Specialized Agents (62 agents - Auto-activated)

Automatically activate based on your tech stack:

**Frontend (8):** React, Vue, Angular, Svelte, Tailwind, CSS, UI/UX, Animations
**Backend (8):** Express, NestJS, Fastify, Koa, GraphQL, REST, WebSocket, Microservices
**Full-Stack (6):** Next.js, Nuxt, Remix, Astro, SvelteKit, SolidStart
**Languages (8):** TypeScript, JavaScript, Python, Go, Rust, Java, C#, PHP
**Databases (8):** PostgreSQL, MySQL, MongoDB, Redis, Prisma, Drizzle, TypeORM, Sequelize
**Infrastructure (9):** Docker, Kubernetes, AWS, Vercel, Cloudflare, Terraform, CI/CD, Nginx, Monitoring
**Testing (7):** Jest, Vitest, Playwright, Cypress, React Testing Library, Storybook, Test Automation
**Specialized (8):** React Native, Electron, CLI Tools, Browser Extensions, AI/ML, Web3, Gaming, Data Pipelines

---

## ⚠️ CRITICAL: context7 MCP Server

**Claude's knowledge cutoff is January 2025. We're in January 2026.**

Maestro **requires** context7 to fetch latest framework documentation before generating code.

### Quick Setup

Add to your `.claude/settings.json`:

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

**Without context7:**
❌ Outdated Next.js/React patterns
❌ Deprecated TypeScript syntax
❌ Old Tailwind CSS utilities

**With context7:**
✅ Latest framework docs (2026)
✅ Current API syntax
✅ Accurate code generation

**Tools that REQUIRE context7:** Next.js, React, TypeScript, Tailwind, tRPC, Prisma, Testing libraries

---

## 🛠️ Available Commands

After global installation, these commands work everywhere:

### Project Management
```bash
claude-init         # Initialize project with persona selection
```

### Agent Management
```bash
claude-agents       # Interactive agent selector
claude-test-agent   # Browse/search agents
claude-stats        # Agent statistics
```

### Maintenance
```bash
claude-health       # Health check
claude-update       # Update toolkit
claude-validate     # Validate RULEBOOK
claude-uninstall    # Uninstall toolkit
```

### Customization
```bash
claude-switch-lang  # Switch Maestro language (en/es)
claude-enhancement  # Toggle self-enhancement
```

**Full command list:** [All Commands](#-all-commands)

---

## 📁 Project Structure

**After running `claude-init`:**

```
your-project/
├── .claude/                     # ← Ignored by git
│   ├── commands/
│   │   └── maestro.md          # → Symlink (or coordinator.md)
│   ├── .toolkit-version         # → Symlink
│   ├── RULEBOOK.md             # 📝 Local (Maestro only, auto-generated)
│   ├── agents-active.txt       # 📝 Local (active agents list)
│   └── settings.local.json     # 📝 Local (Claude Code settings)
└── .gitignore                   # .claude/ added automatically
```

**Global installation:**

```
~/.claude-global/
├── agents/                      # 72 agents (single copy for all projects)
│   ├── core/ (10 agents)
│   └── pool/ (62 agents)
└── commands/                    # Shared commands & supporting files
    ├── maestro.md
    ├── maestro.es.md
    ├── coordinator.md
    ├── rulebook-generator.md    # RULEBOOK generation logic
    ├── agent-router.md          # Agent selection logic
    ├── agent-intelligence.md    # Agent coordination
    ├── workflow-modes.md        # 4-mode workflow (Maestro)
    └── self-enhancement.md      # Learning system (Maestro)
```

**Key Points:**
- ✅ `.claude/` is ignored by git (`.gitignore`)
- ✅ RULEBOOK.md stays **local** (not committed)
- ✅ Each developer generates their own RULEBOOK
- ✅ Agents are global (shared via `~/.claude-global/`)
- ✅ Minimal per-project footprint (only 1 symlink + local files)

---

## 🧠 How It Works

### 1. Auto-Detection

Maestro reads `.claude/RULEBOOK.md` (auto-generated on first use) to understand your stack:

```markdown
## Tech Stack
Frontend: Next.js 16, TypeScript, Tailwind CSS
Backend: tRPC, Prisma, PostgreSQL
```

**Auto-activated:** nextjs-specialist, react-specialist, typescript-pro, tailwind-expert, prisma-specialist, postgres-expert

### 2. Smart Routing

Tasks are routed based on complexity:

```
Simple (<50 lines)      → 1-2 agents
Moderate (50-200 lines) → 2-4 agents
Complex (>200 lines)    → 5-10 agents
Critical (security)     → 6-12 agents
```

### 3. Multi-Agent Pipelines

For complex tasks, agents work in coordinated pipelines:

```yaml
Example: "Add analytics dashboard"

Phase 1: architecture-advisor designs feature
Phase 2: nextjs-specialist, postgres-expert implement
Phase 3: test-strategist, playwright-e2e-specialist test
Phase 4: code-reviewer final review
```

---

## 💡 Usage Example

**Your Project:** Next.js 16 + TypeScript + Prisma + PostgreSQL

**RULEBOOK auto-generated:**
```markdown
## Tech Stack
Framework: Next.js 16
Language: TypeScript
Database: PostgreSQL
ORM: Prisma
Testing: Vitest, Playwright
```

**Auto-activated agents:** 19 agents (10 core + 9 specialized)

**Task:** "Add user authentication"

**Pipeline:** 8 agents coordinate
1. architecture-advisor → Design auth system
2. security-auditor → Security requirements
3. nextjs-specialist → Server actions implementation
4. prisma-specialist → Database schema
5. typescript-pro → Type safety
6. test-strategist → Test plan
7. vitest-specialist + playwright-e2e-specialist → Tests
8. code-reviewer → Final review

**Time:** ~3 hours with agent assistance

---

## 🎯 Key Features

### Zero Configuration
For common stacks (Next.js, React, Express), works out-of-the-box in < 2 minutes.

### RULEBOOK-Driven (Maestro Mode)
Everything adapts to **YOUR** project's patterns, conventions, and standards.

### Scalable Complexity
Handles trivial fixes to critical security audits. Simple? No agents. Complex? Full team.

### Production-Grade
- Updated with 2026 framework features
- Security best practices (OWASP Top 10)
- Performance optimization patterns
- Accessibility compliance (WCAG 2.1 AA)

---

## 🏥 Health Check & Validation

```bash
# Verify installation integrity
claude-health

# Validate RULEBOOK after manual edits
claude-validate
```

**Health check validates:**
- ✅ Installation integrity (72 agents present)
- ✅ RULEBOOK structure and customization
- ✅ Settings syntax
- ✅ Version consistency
- ✅ Common issues

**Exit codes:**
- **0** - All checks passed
- **1** - Warnings (mostly healthy)
- **2** - Critical failures (needs attention)

---

## 🔄 Updates & Migration

```bash
# Check for updates
claude-update --check

# Update everything (preserves RULEBOOK, settings, language)
claude-update

# Migrate between major versions (v1 → v2)
claude-migrate
```

**Automatic backups** are created before all updates and migrations.

**What's preserved:**
- ✅ RULEBOOK.md
- ✅ settings.local.json
- ✅ Maestro language preference
- ✅ Self-enhancement state

---

## 📚 Documentation

Detailed guides for specific topics:

- **[Installation Guide](docs/INSTALLATION.md)** - Installation options, dry-run mode, conflict detection
- **[Agent Selection Guide](templates/AGENT_SELECTION_GUIDE.md)** - How to choose the right agents
- **[MCP Integration Guide](templates/MCP_INTEGRATION_GUIDE.md)** - context7 setup and troubleshooting
- **[RULEBOOK Template](templates/RULEBOOK_TEMPLATE.md)** - Customize your RULEBOOK
- **[Maestro Mode Guide](docs/MAESTRO_MODE.md)** - Deep dive into Maestro features
- **[All Commands](#-all-commands)** - Complete command reference (below)

---

## 🛠️ All Commands

<details>
<summary><strong>Click to expand full command reference</strong></summary>

### Project Setup

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-init` | Initialize project with persona selection | First time in a new project |

### Agent Management

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-agents` | Interactive agent selector (activate/deactivate) | Managing which agents are active |
| `claude-test-agent` | Browse, search, and inspect individual agents | Exploring available agents |
| `claude-stats` | Agent statistics and optimization recommendations | Understanding agent usage |

### RULEBOOK Tools

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-validate` | Validate RULEBOOK.md structure and content | After editing RULEBOOK manually |

### Maintenance

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-health` | Run comprehensive health check | Diagnosing issues |
| `claude-update` | Update toolkit to latest version | Regular updates |
| `claude-migrate` | Migrate between major versions | Major version upgrades |
| `claude-uninstall` | Uninstall toolkit (with backup) | Removing toolkit |

### Customization

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-switch-lang` | Switch Maestro language (en/es) | Changing language preference |
| `claude-enhancement` | Toggle self-enhancement on/off | Enabling/disabling learning |

### Import/Export

| Command | Description | When to Use |
|---------|-------------|-------------|
| `claude-export` | Export configuration to portable format | Sharing setup with team |
| `claude-import` | Import configuration from export file | Applying team config |

</details>

---

## 🗑️ Uninstallation

```bash
# Remove agents + personas (keep RULEBOOK)
claude-uninstall

# Remove everything including RULEBOOK
claude-uninstall --full
```

**Automatic backup** created before uninstalling. Easy to restore from backup.

---

## 🤝 Contributing

We welcome contributions! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- How to add new agents
- Agent quality standards
- Submission process

**Areas where we need help:**
- More language specialists (Ruby, Kotlin, Swift)
- Platform-specific agents (iOS, Android native)
- Domain-specific agents (FinTech, HealthTech)
- Framework updates as new versions release

---

## 📄 License

MIT License - Free for personal and commercial use. Attribution appreciated but not required.

---

## 🙏 Acknowledgments

- Inspired by [awesome-claude-code-subagents](https://github.com/VoltAgent/awesome-claude-code-subagents)
- Powered by [Context7](https://context7.com) for latest 2026 documentation
- Built for the Claude Code community

---

## 📊 Project Stats

- **Total Agents:** 72 (10 core + 62 specialized)
- **Framework Coverage:** 20+ frameworks
- **Language Coverage:** 8 languages
- **Database Coverage:** 8 databases
- **Version:** 1.0.0
- **Last Updated:** January 2026

---

## 🔗 Links

- **GitHub:** [Issues](https://github.com/Dsantiagomj/claude-code-agents-toolkit/issues) • [Discussions](https://github.com/Dsantiagomj/claude-code-agents-toolkit/discussions)
- **Claude Code:** https://claude.com/claude-code

---

**Built with ❤️ by the Claude Code community. Let's build software that doesn't suck. 💪**

---

## ⭐ Star History

If this toolkit helps you, consider giving it a star! ⭐
