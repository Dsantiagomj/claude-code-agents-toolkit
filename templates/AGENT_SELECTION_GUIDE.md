# Agent Selection Guide

This guide helps you understand how to select and combine agents effectively for different project types and tasks.

## Table of Contents

1. [Selection Principles](#selection-principles)
2. [By Project Type](#by-project-type)
3. [By Task Type](#by-task-type)
4. [Agent Combinations](#agent-combinations)
5. [MCP Recommendations](#mcp-recommendations)
6. [Performance Considerations](#performance-considerations)

## Selection Principles

### Core Agents (Always Active)

The 10 core agents are **always active** and tech-stack agnostic:

- **code-reviewer** - Every code change benefits from review
- **refactoring-specialist** - Continuous improvement
- **documentation-engineer** - Clear communication
- **test-strategist** - Quality assurance
- **architecture-advisor** - Design decisions
- **security-auditor** - Security first
- **performance-optimizer** - Efficiency matters
- **git-workflow-specialist** - Version control hygiene
- **dependency-manager** - Keep dependencies healthy
- **project-analyzer** - Understand the codebase

### Specialized Agents (Selective Activation)

Specialized agents from the pool are activated based on:

1. **Project detection** - Automatic activation based on dependencies
2. **Task requirements** - Manual activation for specific work
3. **User preference** - Explicit agent requests
4. **RULEBOOK directives** - Project-specific agent lists

## By Project Type

### Frontend React Application

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - react-specialist
  - typescript-pro (if TypeScript detected)
  - tailwind-expert (if Tailwind detected)
  - ui-accessibility
  - jest-specialist OR vitest-expert
  - testing-library-expert
```

**Recommended MCP servers:**
- Browser automation for E2E testing
- Component visualization tools
- Bundle analyzer

**Use cases:**
- SPA development
- Component library building
- Dashboard applications

---

### Full-Stack Next.js Application

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - nextjs-specialist
  - react-specialist
  - typescript-pro
  - prisma-specialist (if Prisma detected)
  - postgres-expert (or other DB detected)
  - rest-api-architect OR graphql-specialist
  - tailwind-expert (if detected)
  - playwright-specialist OR cypress-specialist
```

**Recommended MCP servers:**
- Database GUI/CLI tools
- API testing (Postman/Insomnia)
- Vercel deployment tools
- Performance monitoring

**Use cases:**
- E-commerce platforms
- SaaS applications
- Content management systems

---

### Backend API Service

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - express-specialist OR fastify-expert OR nest-specialist
  - typescript-pro OR javascript-modernizer
  - rest-api-architect OR graphql-specialist
  - postgres-expert OR mongodb-expert (DB detected)
  - prisma-specialist OR typeorm-expert (ORM detected)
  - jest-specialist
  - docker-specialist
  - monitoring-specialist
```

**Recommended MCP servers:**
- Database management tools
- API testing frameworks
- Docker/container tools
- Log aggregation

**Use cases:**
- RESTful APIs
- GraphQL servers
- Microservices

---

### Python Data/ML Project

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - python-specialist
  - ai-ml-integration
  - data-pipeline-architect
  - postgres-expert (if SQL DB)
  - mongodb-expert (if NoSQL)
  - docker-specialist
  - jupyter-notebook-specialist (if using notebooks)
```

**Recommended MCP servers:**
- Data visualization tools
- ML model management
- Jupyter integration
- Database connectors

**Use cases:**
- Machine learning models
- Data pipelines
- Analytics platforms

---

### Mobile Application (React Native)

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - mobile-specialist
  - react-specialist
  - typescript-pro
  - rest-api-architect
  - jest-specialist
  - e2e-architect
```

**Recommended MCP servers:**
- Mobile device testing
- Push notification services
- App store deployment tools

**Use cases:**
- iOS/Android apps
- Cross-platform mobile

---

### Desktop Application (Electron)

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - desktop-electron
  - react-specialist OR vue-specialist
  - typescript-pro
  - jest-specialist
  - playwright-specialist
```

**Recommended MCP servers:**
- Desktop testing frameworks
- Code signing tools
- Distribution platforms

**Use cases:**
- Desktop productivity tools
- Cross-platform applications

---

### CLI Tool

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - cli-builder
  - typescript-pro OR go-specialist OR rust-expert
  - jest-specialist OR go testing
  - documentation-engineer (extra important for CLIs)
```

**Recommended MCP servers:**
- Package managers
- Distribution platforms (npm, cargo, etc.)
- Documentation generators

**Use cases:**
- Developer tools
- System utilities
- Build tools

---

### Microservices Architecture

**Auto-activated agents:**
```
Core: [All 10 core agents]
Specialized:
  - microservices-architect
  - docker-specialist
  - kubernetes-expert
  - rest-api-architect OR graphql-specialist
  - monitoring-specialist
  - ci-cd-architect
  - [Language-specific agent per service]
  - [Database agents as needed]
```

**Recommended MCP servers:**
- Container orchestration
- Service mesh tools
- Distributed tracing
- API gateway tools

**Use cases:**
- Large-scale systems
- Multi-team projects
- Cloud-native applications

## By Task Type

### Adding a New Feature

**Recommended agent activation:**
```
1. architecture-advisor (design the feature)
2. [Framework specialist] (implement)
3. test-strategist (plan tests)
4. [Testing specialist] (write tests)
5. code-reviewer (review implementation)
6. documentation-engineer (document feature)
```

**Workflow:**
```
Maestro Mode → architecture-advisor (design)
              → [specialists] (implement)
              → test-strategist + testing-specialist (test)
              → code-reviewer (review)
              → documentation-engineer (docs)
```

---

### Fixing a Bug

**Recommended agent activation:**
```
1. project-analyzer (understand context)
2. [Framework specialist] (fix bug)
3. test-strategist (add regression test)
4. code-reviewer (verify fix)
5. git-workflow-specialist (proper commit)
```

---

### Refactoring Code

**Recommended agent activation:**
```
1. refactoring-specialist (plan refactoring)
2. architecture-advisor (validate approach)
3. [Framework specialist] (execute refactoring)
4. test-strategist (ensure tests cover refactored code)
5. code-reviewer (review changes)
```

---

### Performance Optimization

**Recommended agent activation:**
```
1. performance-optimizer (analyze + suggest)
2. [Framework specialist] (implement optimizations)
3. monitoring-specialist (add metrics)
4. test-strategist (performance tests)
5. code-reviewer (review)
```

---

### Security Audit

**Recommended agent activation:**
```
1. security-auditor (scan for vulnerabilities)
2. dependency-manager (update vulnerable deps)
3. [Framework specialist] (fix security issues)
4. test-strategist (security test cases)
5. code-reviewer (verify fixes)
```

---

### Adding Tests

**Recommended agent activation:**
```
1. test-strategist (plan test coverage)
2. [Testing specialist] (write tests)
3. code-reviewer (review test quality)
```

---

### Documentation Update

**Recommended agent activation:**
```
1. documentation-engineer (write/update docs)
2. [Framework specialist] (technical accuracy)
3. code-reviewer (review docs)
```

---

### CI/CD Setup

**Recommended agent activation:**
```
1. ci-cd-architect (design pipeline)
2. docker-specialist (containerization)
3. [Cloud specialist] (deployment)
4. test-strategist (test automation)
5. security-auditor (security scans)
```

## Agent Combinations

### Effective Combinations

#### Web Application Stack
```
✅ GOOD:
nextjs-specialist + react-specialist + typescript-pro + prisma-specialist + tailwind-expert

Why: Complementary specialists for each layer of the stack
```

#### API Development
```
✅ GOOD:
rest-api-architect + express-specialist + postgres-expert + jest-specialist

Why: Complete coverage from design to testing
```

#### Infrastructure as Code
```
✅ GOOD:
terraform-specialist + aws-specialist + docker-specialist + kubernetes-expert + ci-cd-architect

Why: Full DevOps pipeline coverage
```

### Redundant Combinations

#### Avoid Framework Conflicts
```
❌ BAD:
react-specialist + vue-specialist + angular-specialist

Why: One project doesn't use multiple frontend frameworks
```

#### Avoid ORM Conflicts
```
❌ BAD:
prisma-specialist + typeorm-expert + sequelize-expert

Why: Projects typically use one ORM
```

#### Avoid Testing Tool Conflicts
```
❌ BAD:
jest-specialist + vitest-expert + mocha-specialist

Why: One test runner per project
```

### Complementary Pairs

```
✅ nextjs-specialist + react-specialist (Next.js builds on React)
✅ typescript-pro + any framework specialist (TypeScript everywhere)
✅ docker-specialist + kubernetes-expert (Containers + orchestration)
✅ rest-api-architect + graphql-specialist (Different API layers)
✅ postgres-expert + prisma-specialist (DB + ORM)
```

## MCP Recommendations

### By Project Type

#### React/Frontend
- **@modelcontextprotocol/server-playwright** - Browser automation
- **@modelcontextprotocol/server-puppeteer** - Browser control
- Component visualization MCP (if available)

#### Next.js/Full-Stack
- All frontend MCPs
- **@modelcontextprotocol/server-postgres** - Database access
- Vercel deployment MCP
- API testing MCPs

#### Backend API
- **@modelcontextprotocol/server-postgres** or DB-specific MCP
- API testing frameworks
- Docker/container MCPs
- Monitoring MCPs

#### Infrastructure
- Cloud provider MCPs (AWS, GCP, Azure)
- Kubernetes MCPs
- Terraform MCPs
- Monitoring and logging MCPs

### By Task Type

#### Testing
- Testing framework MCPs (Playwright, Cypress)
- Coverage reporting tools
- Visual regression testing

#### Deployment
- Cloud platform MCPs
- CI/CD pipeline tools
- Container registry access

#### Monitoring
- Log aggregation MCPs
- APM (Application Performance Monitoring)
- Error tracking (Sentry, etc.)

## Performance Considerations

### Agent Count Impact

- **10 core agents**: Minimal performance impact (always active)
- **+5 specialized agents**: Recommended for most projects
- **+10 specialized agents**: Medium projects, still performant
- **+15+ specialized agents**: Large projects, consider carefully

### Model Selection

Agents can specify different models in YAML frontmatter:

```yaml
---
model: haiku  # Fast, cheap, good for simple tasks
---

---
model: sonnet  # Default, balanced
---

---
model: opus  # Slowest, most capable, expensive
---
```

**Guidelines:**
- Use `haiku` for: Linting, formatting, simple refactoring
- Use `sonnet` for: Most development tasks (default)
- Use `opus` for: Complex architecture, critical security, major refactors

### Lazy Loading

Maestro Mode activates agents **on-demand**:

1. Core agents always ready
2. Specialized agents loaded when needed
3. Unused agents don't consume resources
4. First task may be slower (agent activation)
5. Subsequent tasks are fast (agents cached)

### Optimization Tips

1. **Deactivate unused agents**: Remove from active pool
2. **Use specific agents**: Don't activate entire categories
3. **Profile your workflow**: Monitor which agents are used
4. **Update RULEBOOK**: Document your active agent set
5. **Cache dependencies**: Faster project analysis

## Decision Tree

```
START
│
├─ Is this a new project?
│  ├─ YES → Run Empty Project Questionnaire
│  └─ NO → Continue
│
├─ What's the primary technology?
│  ├─ React/Vue/Angular → Frontend specialists
│  ├─ Next.js/Nuxt/Remix → Full-stack specialists
│  ├─ Express/Fastify/Nest → Backend specialists
│  ├─ Python/Go/Rust → Language specialists
│  └─ Other → Check package.json/requirements.txt
│
├─ What's the task type?
│  ├─ New Feature → architecture-advisor + specialists
│  ├─ Bug Fix → project-analyzer + specialists
│  ├─ Refactor → refactoring-specialist + specialists
│  ├─ Tests → test-strategist + testing specialists
│  ├─ Docs → documentation-engineer
│  ├─ Security → security-auditor + specialists
│  └─ Performance → performance-optimizer + specialists
│
├─ What's the database?
│  ├─ PostgreSQL → postgres-expert
│  ├─ MongoDB → mongodb-expert
│  ├─ MySQL → mysql-specialist
│  └─ Redis → redis-specialist
│
├─ What's the ORM/Query Builder?
│  ├─ Prisma → prisma-specialist
│  ├─ TypeORM → typeorm-expert
│  ├─ Drizzle → drizzle-specialist
│  └─ Other → Check dependencies
│
├─ What's the testing stack?
│  ├─ Jest → jest-specialist
│  ├─ Vitest → vitest-expert
│  ├─ Playwright → playwright-specialist
│  └─ Cypress → cypress-specialist
│
└─ ACTIVATE SELECTED AGENTS
```

## Examples

### Example 1: New Next.js E-commerce Project

**Context:**
- Next.js 15 app router
- TypeScript
- Prisma + PostgreSQL
- Tailwind CSS
- Stripe integration
- Playwright E2E tests

**Activated Agents:**
```
Core: [All 10]
Specialized:
  - nextjs-specialist
  - react-specialist
  - typescript-pro
  - prisma-specialist
  - postgres-expert
  - tailwind-expert
  - rest-api-architect
  - playwright-specialist
  - ui-accessibility
```

**MCP Servers:**
- @modelcontextprotocol/server-postgres
- @modelcontextprotocol/server-playwright
- Stripe API MCP (if available)

**Total:** 10 core + 9 specialized = 19 agents

---

### Example 2: Python ML Pipeline

**Context:**
- Python 3.11
- TensorFlow/PyTorch
- PostgreSQL for metadata
- Docker deployment
- Jupyter notebooks for exploration

**Activated Agents:**
```
Core: [All 10]
Specialized:
  - python-specialist
  - ai-ml-integration
  - data-pipeline-architect
  - postgres-expert
  - docker-specialist
```

**MCP Servers:**
- Jupyter integration
- Data visualization tools
- Model registry MCP

**Total:** 10 core + 5 specialized = 15 agents

---

### Example 3: Microservices Platform

**Context:**
- Multiple services (Node.js, Go, Python)
- Kubernetes deployment
- GraphQL federation
- MongoDB + PostgreSQL
- CI/CD with GitHub Actions

**Activated Agents:**
```
Core: [All 10]
Specialized:
  - microservices-architect
  - kubernetes-expert
  - docker-specialist
  - ci-cd-architect
  - graphql-specialist
  - typescript-pro
  - go-specialist
  - python-specialist
  - mongodb-expert
  - postgres-expert
  - monitoring-specialist
```

**MCP Servers:**
- Kubernetes CLI tools
- Docker registry access
- Multiple database MCPs
- Distributed tracing

**Total:** 10 core + 11 specialized = 21 agents

## Summary

- **Core agents**: Always active, tech-agnostic
- **Specialized agents**: Activated based on project/task
- **Maestro Mode**: Handles selection automatically
- **MCP integration**: Extends agent capabilities
- **Performance**: Balance agent count vs capability
- **Flexibility**: Manual override always available

For detailed MCP integration, see `MCP_INTEGRATION_GUIDE.md`.
For new project setup, see `EMPTY_PROJECT_QUESTIONNAIRE.md`.
