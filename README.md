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
- Set up Gentleman Mode (optional)

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

## 🎭 Gentleman Mode (Optional)

An opinionated AI personality that:
- Enforces your RULEBOOK patterns strictly
- Speaks Colombian Spanish or direct English
- Won't sugarcoat issues with your code
- Orchestrates agents intelligently
- Educates you on WHY patterns matter

**Activation:** Type `/gentleman` in Claude Code (after installation)

**Personality:**
- Direct, confrontational, no filter
- Senior Architect with 15+ years experience
- Genuine educational intent
- Tony Stark/Jarvis dynamic with you

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
Trivial (<10 lines)     → 0 agents  (Gentleman handles directly)
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
- [Gentleman Mode Guide](docs/GENTLEMAN_MODE.md)

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

### Installation Options

**Option 1: Full Installation (Recommended)**
```bash
./install.sh
# Installs: 78 agents + Gentleman Mode + RULEBOOK generator
```

**Option 2: Agents Only**
```bash
./install.sh --agents-only
# Installs: 78 agents (skip Gentleman Mode)
```

**Option 3: Custom Selection**
```bash
./install.sh --custom
# Interactive: Choose which agent categories to install
```

### What Gets Installed

```
your-project/
└── .claude/
    ├── agents-global/          # 78 agents
    │   ├── core/              # 10 core agents
    │   └── pool/              # 68 specialized agents
    ├── commands/              # Optional: Gentleman Mode
    │   ├── gentleman.md
    │   ├── agent-intelligence.md
    │   └── agent-router.md
    └── RULEBOOK.md            # Generated from template (if missing)
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
