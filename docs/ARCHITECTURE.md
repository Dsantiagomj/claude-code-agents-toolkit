# Architecture - Claude Code Agents Toolkit

## Overview

The Claude Code Agents Toolkit is a global installation system that provides AI-powered development assistance through specialized agents and workflow modes. This document explains the architecture, design decisions, and how all components work together.

## Table of Contents

- [Core Concepts](#core-concepts)
- [Directory Structure](#directory-structure)
- [Installation Architecture](#installation-architecture)
- [Dual-Persona System](#dual-persona-system)
- [Agent System](#agent-system)
- [RULEBOOK System](#rulebook-system)
- [Script Architecture](#script-architecture)
- [Workflow Modes](#workflow-modes)
- [Data Flow](#data-flow)
- [Design Decisions](#design-decisions)

---

## Core Concepts

### Global Installation with Project Symlinks

The toolkit uses a **global-local hybrid architecture**:

```
~/.claude-global/          # Global installation (ONE copy)
    ├── commands/          # Workflow mode definitions
    ├── agents/            # 72 specialized AI agents
    ├── scripts/           # Management scripts
    └── .toolkit-version   # Version tracking

project/.claude/           # Project-specific (symlinks + local config)
    ├── commands/
    │   └── maestro.md     # Symlink to global
    ├── agents-active.txt  # Project-specific (local file)
    └── RULEBOOK.md        # Project-specific (local file)
```

**Benefits:**
- ✅ Single source of truth (global installation)
- ✅ Easy updates (update global, all projects benefit)
- ✅ Minimal per-project footprint (2 symlinks + 2 local files)
- ✅ Project-specific configuration (RULEBOOK, active agents)

---

## Directory Structure

### Global Installation (`~/.claude-global/`)

```
~/.claude-global/
├── commands/                      # Workflow mode definitions
│   ├── maestro.md                 # English Maestro mode
│   ├── maestro.es.md              # Spanish Maestro mode
│   ├── coordinator.md             # Lightweight Coordinator mode
│   ├── agent-router.md            # Routing logic
│   ├── agent-routing-rules.json   # Routing tables (structured data)
│   ├── agent-intelligence.md      # Agent selection intelligence
│   ├── rulebook-generator.md      # RULEBOOK auto-generation
│   ├── self-enhancement.md        # Self-improvement system
│   ├── workflow-modes.md          # 4-mode workflow definitions
│   └── workflow-examples.md       # Detailed workflow examples
├── agents/                        # 72 specialized agents
│   ├── core/                      # 10 core agents (always active)
│   │   ├── code-reviewer.md
│   │   ├── architecture-advisor.md
│   │   └── ...
│   └── specialized/               # 62 stack-specific agents
│       ├── frontend/              # React, Next.js, Vue, etc.
│       ├── backend/               # Express, NestJS, etc.
│       ├── databases/             # Prisma, MongoDB, etc.
│       └── ...
├── scripts/                       # Management & utility scripts
│   ├── lib/                       # Shared library
│   │   ├── common.sh              # Common functions
│   │   └── README.md              # Library documentation
│   ├── init-project.sh            # Initialize new project
│   ├── select-agents.sh           # Manage active agents
│   ├── test-agent.sh              # Test/inspect agents
│   ├── agent-stats.sh             # Agent analytics
│   ├── healthcheck.sh             # Installation health check
│   └── ...
└── .toolkit-version               # Version tracking
```

### Project Installation (`.claude/`)

```
project/.claude/
├── commands/
│   └── maestro.md              # Symlink → ~/.claude-global/commands/maestro.md
├── .toolkit-version            # Symlink → ~/.claude-global/.toolkit-version
├── agents-active.txt           # Local: List of active agents for this project
└── RULEBOOK.md                 # Local: Project-specific rules and patterns
```

**Key Points:**
- **Symlinks** (2): maestro.md/coordinator.md + .toolkit-version
- **Local Files** (2): agents-active.txt + RULEBOOK.md
- **Git Ignored**: Entire `.claude/` directory

---

## Installation Architecture

### Installation Flow

```
┌─────────────────────────────────────────────────────┐
│ 1. User runs install script                        │
│    bash <(curl -fsSL .../install.sh)               │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 2. Download & extract to ~/.claude-global/         │
│    - Fetch latest release from GitHub              │
│    - Extract commands/, agents/, scripts/          │
│    - Set up bash aliases (optional)                │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 3. Per-project initialization                      │
│    cd my-project && scripts/init-project.sh        │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 4. Persona selection (Maestro or Coordinator)      │
│    - Maestro: Full-featured, RULEBOOK-driven       │
│    - Coordinator: Lightweight, generic best practices│
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 5. Create symlinks                                  │
│    .claude/commands/maestro.md → global            │
│    .claude/.toolkit-version → global               │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 6. Create local files                              │
│    - .claude/agents-active.txt (empty)             │
│    - .claude/RULEBOOK.md (on first /maestro use)   │
└─────────────────────────────────────────────────────┘
```

### Update Flow

```
┌─────────────────────────────────────────────────────┐
│ User runs: scripts/update.sh                       │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 1. Check current version                           │
│    cat ~/.claude-global/.toolkit-version           │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 2. Fetch latest version from GitHub API            │
│    Compare with local version                      │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 3. Backup current installation                     │
│    mv ~/.claude-global ~/.claude-global.backup.*  │
└─────────────────┬───────────────────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────────────────┐
│ 4. Download & install new version                  │
│    All projects auto-update (symlinks!)            │
└─────────────────────────────────────────────────────┘
```

**Update Benefits:**
- ✅ Update once, all projects benefit
- ✅ Automatic backups
- ✅ No per-project updates needed
- ✅ Symlinks ensure instant propagation

---

## Dual-Persona System

The toolkit provides two AI personas with different philosophies:

### Maestro Mode (Full-Featured)

**Philosophy:** Opinionated, enforces project patterns

```yaml
Features:
  - RULEBOOK enforcement (project-specific rules)
  - 4-mode workflow (Planning → Development → Review → Commit)
  - Smart agent selection (based on project stack)
  - Context7 integration (latest docs)
  - Bilingual (English/Spanish)
  - Self-enhancement system

Best For:
  - Production applications
  - Team projects
  - Strict coding standards
  - Pattern enforcement
```

### Coordinator Mode (Lightweight)

**Philosophy:** Professional, generic best practices

```yaml
Features:
  - No RULEBOOK (generic principles)
  - 3-step workflow (Receive → Delegate → Report)
  - Keyword-based routing
  - Context7 integration
  - English only

Best For:
  - Prototypes
  - Learning projects
  - Flexible requirements
  - Quick experiments
```

### Selection Flow

```
User runs: scripts/init-project.sh
    │
    ▼
┌────────────────────────────────┐
│ Choose persona:                │
│ [1] Maestro (Recommended)      │
│ [2] Coordinator (Lightweight)  │
└────────────────┬───────────────┘
                 │
    ┌────────────┴──────────────┐
    │                           │
    ▼                           ▼
Maestro selected          Coordinator selected
    │                           │
    ▼                           ▼
Choose language           Single language
[1] English               (English only)
[2] Spanish
    │                           │
    ▼                           ▼
Symlink:                  Symlink:
maestro.md                coordinator.md
maestro.es.md
```

---

## Agent System

### Agent Categories

**72 Total Agents:**

| Category | Count | Examples |
|----------|-------|----------|
| **Core** | 10 | code-reviewer, architecture-advisor, security-auditor |
| **Frontend** | 8 | nextjs-specialist, react-specialist, vue-specialist |
| **Backend** | 8 | express-specialist, nestjs-specialist, fastify-specialist |
| **Full-Stack** | 6 | remix-specialist, nuxt-specialist, sveltekit-specialist |
| **Languages** | 8 | typescript-pro, python-specialist, go-specialist |
| **Databases** | 8 | postgres-expert, prisma-orm-specialist, mongodb-expert |
| **Infrastructure** | 9 | docker-specialist, kubernetes-expert, aws-cloud-specialist |
| **Testing** | 7 | vitest-specialist, playwright-specialist, jest-testing-specialist |
| **Specialized** | 8 | graphql-specialist, rest-api-architect, ml-specialist |

### Agent Structure

Each agent is a markdown file with:

```markdown
# Agent Name

## Identity
[Who this agent is, expertise area]

## Capabilities
[What this agent can do]

## When to Use
[Scenarios where this agent helps]

## Best Practices
[Agent-specific guidelines]

## Examples
[Usage examples]
```

### Agent Routing

**Maestro Mode** (Smart routing):
1. Read RULEBOOK.md (project stack)
2. Detect task type (new feature, bug fix, etc.)
3. Assess complexity
4. Use agent-routing-rules.json
5. Select agents from RULEBOOK stack
6. Build pipeline

**Coordinator Mode** (Keyword routing):
1. Parse task keywords
2. Match to agent categories
3. Select 1-3 agents
4. Execute sequentially

---

## RULEBOOK System

### What is a RULEBOOK?

A **RULEBOOK** is a project-specific configuration file that defines:
- Tech stack (framework, language, database, etc.)
- Architecture patterns
- Coding standards
- Active agents
- Testing approach
- Coverage targets

### RULEBOOK Generation

**Hybrid Approach** (Auto-detect + User input):

```
1. Scan Project Files
   ├── package.json → Detect framework, language
   ├── tsconfig.json → Detect TypeScript config
   ├── docker-compose.yml → Detect infrastructure
   └── README.md → Extract additional context

2. Detect Stack Components
   ├── Framework: Next.js, React, Vue, etc.
   ├── Language: TypeScript, JavaScript, Python, etc.
   ├── Database: PostgreSQL, MongoDB, etc.
   ├── ORM: Prisma, TypeORM, Drizzle, etc.
   └── Testing: Vitest, Jest, Playwright, etc.

3. Show Findings
   Display detected stack to user

4. Ask for Missing Details
   ├── Coverage target (70%, 80%, 90%?)
   ├── State management (Zustand, Redux, Context?)
   ├── Styling approach (Tailwind, CSS Modules?)
   └── Additional patterns?

5. Generate RULEBOOK.md
   Create comprehensive project guide

6. Load Active Agents
   Populate agents-active.txt based on stack
```

### RULEBOOK Structure

```markdown
# Project RULEBOOK

## Tech Stack
- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript (strict mode)
- **Database:** PostgreSQL 16
- **ORM:** Prisma
- **Styling:** Tailwind CSS
- **Testing:** Vitest + Playwright
- **State:** Zustand

## Architecture Patterns
[Folder structure, naming conventions, etc.]

## Coding Standards
[TypeScript rules, formatting, etc.]

## Testing Strategy
- Coverage target: 80%
- Unit tests: Vitest
- E2E tests: Playwright

## Active Agents
- code-reviewer
- architecture-advisor
- nextjs-specialist
- typescript-pro
- prisma-orm-specialist
- vitest-specialist
- tailwind-expert
```

---

## Script Architecture

### Shared Library Pattern

**`scripts/lib/common.sh`** - Single source of truth

```bash
#!/bin/bash
# All scripts source this

# Colors, print functions
RED='\033[0;31m'
print_success() { ... }

# Path constants
GLOBAL_DIR="${HOME}/.claude-global"
RULEBOOK_LOCAL=".claude/RULEBOOK.md"

# Agent arrays & utilities
CORE_AGENTS=(code-reviewer refactoring-specialist ...)
get_agent_category() { ... }
count_active_in_category() { ... }

# Validation & helpers
check_global_installation() { ... }
draw_progress_bar() { ... }
```

**Benefits:**
- ✅ No code duplication
- ✅ Consistent behavior
- ✅ Easy maintenance
- ✅ Single update point

### Script Categories

| Script | Purpose | Uses common.sh |
|--------|---------|----------------|
| `init-project.sh` | Initialize project | ✅ |
| `select-agents.sh` | Manage active agents | ✅ |
| `test-agent.sh` | Test/inspect agents | ✅ |
| `agent-stats.sh` | Analytics | ✅ |
| `healthcheck.sh` | Health check | ✅ |
| `update.sh` | Update toolkit | ⚠️ (minimal) |
| `uninstall.sh` | Remove toolkit | ⚠️ (minimal) |

---

## Workflow Modes

### Maestro 4-Mode Workflow

```
┌──────────────────────────────────────────────────────┐
│ 📋 PLANNING MODE                                     │
│ - Read RULEBOOK                                      │
│ - Analyze task                                       │
│ - Route to agents (agent-router.md)                 │
│ - Create implementation plan                         │
│ - Get user approval                                  │
└────────────────┬─────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────┐
│ 💻 DEVELOPMENT MODE                                  │
│ - Execute plan                                       │
│ - Delegate to specialized agents                    │
│ - Write code following RULEBOOK                     │
│ - Apply project patterns                            │
└────────────────┬─────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────┐
│ 🔍 REVIEW MODE                                       │
│ - Code quality review (code-reviewer)               │
│ - Security audit (security-auditor)                 │
│ - Performance check (performance-optimizer)         │
│ - Test coverage verification                        │
│ - RULEBOOK compliance check                         │
└────────────────┬─────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────┐
│ 📦 COMMIT MODE                                       │
│ - Generate commit message (git-workflow-specialist) │
│ - Enforce gitflow from RULEBOOK                     │
│ - Run pre-commit checks                             │
│ - Create commit with Co-Authored-By                 │
└──────────────────────────────────────────────────────┘
```

### Coordinator 3-Step Workflow

```
┌──────────────────────────────────────────────────────┐
│ 📥 RECEIVE                                           │
│ - Parse user request                                 │
│ - Ask clarifying questions                          │
│ - Identify task type                                │
└────────────────┬─────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────┐
│ 🎯 DELEGATE                                          │
│ - Select agents (keyword-based)                     │
│ - Invoke agents sequentially                        │
│ - Monitor progress                                   │
└────────────────┬─────────────────────────────────────┘
                 │
                 ▼
┌──────────────────────────────────────────────────────┐
│ 📊 REPORT                                            │
│ - Summarize work                                     │
│ - Show files changed                                 │
│ - Highlight decisions                                │
│ - Provide next steps                                 │
└──────────────────────────────────────────────────────┘
```

---

## Data Flow

### Task Execution Flow (Maestro)

```
User: "Add user authentication"
    │
    ▼
┌──────────────────────────────┐
│ Maestro reads RULEBOOK.md    │
│ Stack: Next.js + Prisma      │
└────────────┬─────────────────┘
             │
             ▼
┌──────────────────────────────┐
│ agent-router.md routes task  │
│ Type: New Feature            │
│ Complexity: High             │
│ Route: Feature Development   │
└────────────┬─────────────────┘
             │
             ▼
┌──────────────────────────────┐
│ Select agents from RULEBOOK  │
│ 1. architecture-advisor      │
│ 2. prisma-orm-specialist     │
│ 3. nextjs-specialist         │
│ 4. security-auditor          │
│ 5. vitest-specialist         │
│ 6. code-reviewer             │
└────────────┬─────────────────┘
             │
             ▼
┌──────────────────────────────┐
│ Execute pipeline sequentially│
│ Each agent reads RULEBOOK    │
│ Each agent follows patterns  │
└────────────┬─────────────────┘
             │
             ▼
┌──────────────────────────────┐
│ Return result to user        │
│ Files changed, decisions     │
│ Tests passing, ready to commit│
└──────────────────────────────┘
```

---

## Design Decisions

### 1. Global Installation vs. Per-Project

**Decision:** Global installation with project symlinks

**Rationale:**
- ✅ Update once, all projects benefit
- ✅ Consistent behavior across projects
- ✅ Minimal per-project footprint
- ✅ Easy version management

### 2. Symlinks vs. File Copies

**Decision:** Symlinks for shared resources, local files for project config

**Rationale:**
- ✅ Instant updates (symlinks point to global)
- ✅ No sync issues
- ✅ Clear separation (shared vs. project-specific)

### 3. RULEBOOK: Auto-generate vs. Manual

**Decision:** Hybrid (auto-detect + user input)

**Rationale:**
- ✅ Fast initial setup (auto-detection)
- ✅ Accurate details (user confirmation)
- ✅ Extensible (user can edit after)

### 4. Dual Personas vs. Single Mode

**Decision:** Two personas (Maestro & Coordinator)

**Rationale:**
- ✅ Flexibility (production vs. prototypes)
- ✅ User choice (opinionated vs. generic)
- ✅ Different use cases covered

### 5. Markdown Agents vs. Code

**Decision:** Markdown files for agent definitions

**Rationale:**
- ✅ Human-readable and editable
- ✅ Version control friendly
- ✅ Easy to customize per project
- ✅ Claude reads markdown natively

### 6. Routing: JSON vs. Code

**Decision:** JSON for routing rules

**Rationale:**
- ✅ Data-driven (easy to modify)
- ✅ No code changes needed
- ✅ Clear structure
- ✅ Validation possible

### 7. Script Library vs. Duplication

**Decision:** Shared `scripts/lib/common.sh`

**Rationale:**
- ✅ DRY principle
- ✅ Consistency across scripts
- ✅ Single update point
- ✅ Easier testing

---

## Future Architecture Considerations

### Scalability

**Current:** 72 agents
**Future:** 100+ agents (specialized domains)

**Strategy:**
- Use lazy loading (only load active agents)
- Categorize further (sub-categories)
- Agent versioning (v1, v2, etc.)

### Multi-Language Support

**Current:** English, Spanish (Maestro only)
**Future:** French, German, Portuguese, etc.

**Strategy:**
- Language files (maestro.{lang}.md)
- Shared logic, localized content
- Automatic language detection

### Agent Marketplace

**Future Idea:** Community-contributed agents

**Considerations:**
- Quality control (review process)
- Versioning and dependencies
- Security (sandbox execution)
- Rating system

---

## Conclusion

The Claude Code Agents Toolkit architecture is designed for:
- **Simplicity**: Easy to understand and use
- **Flexibility**: Multiple personas, extensible agents
- **Maintainability**: Shared library, clear structure
- **Scalability**: Global installation, modular design

The combination of global installation, symlinks, RULEBOOK system, and specialized agents creates a powerful yet maintainable development assistant.

---

**Version:** 1.0.0
**Last Updated:** 2026-01-08
**Maintained By:** Claude Code Agents Toolkit Team
