# Claude Code Global Agents Toolkit

A comprehensive, reusable toolkit of Claude Code subagents designed to work across any project. This Swiss Army knife approach provides intelligent agent selection, project adaptation, and best-practice enforcement.

## Overview

This toolkit implements a **two-tier agent architecture**:

1. **Core Agents** (10 agents, always active) - Tech-stack agnostic agents for fundamental development tasks
2. **Specialized Agent Pool** (60+ agents) - Domain-specific agents activated based on project analysis

All agents are orchestrated through **Gentleman Mode** (`/gentleman` command), which delegates tasks to the appropriate subagents based on project context.

## Quick Start

### For Existing Projects

1. Copy `.claude/agents-global/` to your project's `.claude/` directory
2. Run `/gentleman` to start the main orchestrator
3. The system will:
   - Analyze your project structure and dependencies
   - Detect your tech stack
   - Activate relevant specialized agents from the pool
   - Report which agents are now active
   - Suggest relevant MCP servers for your stack
   - Create/update RULEBOOK.md if needed

### For Empty/New Projects

1. Copy `.claude/agents-global/` to your new project's `.claude/` directory
2. Run `/gentleman`
3. The system will run the **Empty Project Questionnaire** to:
   - Understand your project goals and requirements
   - Recommend appropriate tech stack
   - Suggest specialized agents to activate
   - Recommend MCP servers to install
   - Generate a RULEBOOK.md with best practices
   - Set up initial project structure

## Agent Directory

### Core Agents (Always Active)

Located in `.claude/agents-global/core/`:

1. **code-reviewer** - Code quality, standards, and best practices enforcement
2. **refactoring-specialist** - Code improvement, technical debt reduction, pattern modernization
3. **documentation-engineer** - Documentation creation, maintenance, and clarity
4. **test-strategist** - Test planning, coverage analysis, testing best practices
5. **architecture-advisor** - System design, scalability, architectural decisions
6. **security-auditor** - Security vulnerability detection, OWASP compliance, secure coding
7. **performance-optimizer** - Performance analysis, optimization, profiling
8. **git-workflow-specialist** - Git best practices, commit hygiene, branch management
9. **dependency-manager** - Dependency updates, conflict resolution, security patches
10. **project-analyzer** - Project structure analysis, tech stack detection, agent activation

### Specialized Agent Pool

Located in `.claude/agents-global/pool/` organized by category:

#### 01-frontend/
- react-specialist, vue-specialist, angular-specialist, svelte-specialist
- tailwind-expert, css-architect, ui-accessibility, animation-specialist

#### 02-backend/
- express-specialist, fastify-expert, nest-specialist, koa-expert
- rest-api-architect, graphql-specialist, websocket-expert, microservices-architect

#### 03-fullstack-frameworks/
- nextjs-specialist, nuxt-specialist, remix-specialist
- astro-specialist, sveltekit-specialist, solidstart-specialist

#### 04-languages/
- typescript-pro, javascript-modernizer, python-specialist, go-specialist
- rust-expert, java-specialist, csharp-specialist, php-modernizer

#### 05-databases/
- postgres-expert, mysql-specialist, mongodb-expert, redis-specialist
- prisma-specialist, typeorm-expert, drizzle-specialist, sequelize-expert

#### 06-infrastructure/
- docker-specialist, kubernetes-expert, ci-cd-architect, aws-specialist
- vercel-expert, cloudflare-specialist, terraform-specialist, monitoring-specialist

#### 07-testing/
- jest-specialist, vitest-expert, playwright-specialist
- cypress-specialist, testing-library-expert, e2e-architect

#### 08-specialized/
- mobile-specialist, desktop-electron, cli-builder, browser-extension
- ai-ml-integration, blockchain-specialist, game-dev-specialist, data-pipeline-architect

## How Gentleman Mode Works

**Gentleman Mode** is the main orchestrator agent. Users always interact with Gentleman Mode, never directly with subagents.

### Delegation Pattern

```
User → /gentleman → [Analyzes request] → Delegates to subagents → Reports results
```

### Agent Activation Reporting

Gentleman Mode ALWAYS explicitly reports which agents were activated:

```
I've analyzed your request and activated the following agents:
- Core: code-reviewer, test-strategist
- Specialized: react-specialist, typescript-pro, jest-specialist

Let me delegate the task...
```

### Smart Project Analysis

On first run, Gentleman Mode:
1. Reads `package.json`, `requirements.txt`, `go.mod`, etc.
2. Scans project structure and file types
3. Checks for existing RULEBOOK.md
4. Activates relevant specialized agents
5. Suggests MCP servers for detected technologies
6. Creates RULEBOOK.md if missing

## MCP Integration

Each agent can recommend relevant MCP servers. See `MCP_INTEGRATION_GUIDE.md` for:
- How to install MCP servers
- Agent-specific MCP recommendations
- Integration patterns and examples

Common MCP servers by domain:
- **Frontend**: Browser automation, component testing
- **Backend**: Database tools, API testing
- **Infrastructure**: Cloud CLI tools, monitoring
- **Data**: Analytics, visualization tools

## RULEBOOK System

The **RULEBOOK.md** is the single source of truth for project patterns, conventions, and standards.

- Located at project root: `.claude/RULEBOOK.md`
- Generated automatically for new projects
- Updated/enhanced for existing projects
- Referenced by all agents for consistency
- See `RULEBOOK_TEMPLATE.md` for structure

## Installation

### Manual Installation

```bash
# Copy to your project
cp -r .claude/agents-global /path/to/your/project/.claude/

# Start using
cd /path/to/your/project
# In Claude Code CLI, run:
/gentleman
```

### Script Installation (Coming Soon)

```bash
curl -fsSL https://raw.githubusercontent.com/YOUR_ORG/claude-agents-toolkit/main/install.sh | bash
```

## Customization

### Adding Project-Specific Agents

1. Keep global agents in `.claude/agents-global/`
2. Add project-specific agents to `.claude/agents/` (separate directory)
3. Gentleman Mode will check both locations

### Modifying Agent Behavior

1. Edit agent YAML frontmatter to adjust:
   - `temperature` (creativity vs consistency)
   - `model` (sonnet, opus, haiku)
   - Agent description and delegation criteria
2. Update agent prompt content for specific behaviors

### Custom Agent Pool

Create custom categories in `pool/`:
```bash
mkdir .claude/agents-global/pool/09-custom-domain
```

Add your specialized agents with proper YAML frontmatter.

## Best Practices

### When to Use Which Agents

See `AGENT_SELECTION_GUIDE.md` for detailed guidance on:
- Selecting agents by project type
- Combining agents effectively
- Avoiding agent conflicts
- Performance considerations

### Agent Interaction Patterns

1. **Always go through Gentleman Mode** - Don't call subagents directly
2. **Trust the delegation** - Gentleman Mode selects appropriate agents
3. **Review activation reports** - Know which agents are working on your task
4. **Check RULEBOOK** - Ensure agents follow project conventions
5. **Update agent pool** - Deactivate unused agents for better performance

### Performance Tips

- Only activate specialized agents you need
- Core agents are lightweight and always active
- Use `model: haiku` for simple, repetitive tasks
- Use `model: sonnet` for complex reasoning (default)
- Use `model: opus` for critical, high-stakes decisions

## Troubleshooting

### Agents Not Activating

1. Check project structure - ensure standard file locations
2. Verify `package.json` or dependency files exist
3. Run Gentleman Mode analysis manually
4. Check `.claude/agents-global/` directory structure

### Wrong Agents Activated

1. Review project-analyzer detection logic
2. Manually specify agents in RULEBOOK.md
3. Add custom detection rules to Gentleman Mode

### MCP Servers Not Suggested

1. Verify MCP_INTEGRATION_GUIDE.md mappings
2. Check agent-specific MCP recommendations
3. Install MCP servers manually if needed

### Conflicts with Existing Agents

1. Use separate directories: `agents-global/` vs `agents/`
2. Rename conflicting agents
3. Update Gentleman Mode priority order

## Contributing

This toolkit is designed to be community-driven:

1. **Add new specialized agents** - Create PRs with new domain agents
2. **Improve core agents** - Enhance existing agent prompts
3. **Update documentation** - Keep guides current and comprehensive
4. **Share MCP integrations** - Document useful MCP server combinations
5. **Report issues** - Help improve agent selection logic

## Architecture Decisions

### Why Two-Tier System?

- **Core agents** handle universal development tasks
- **Specialized agents** avoid bloat and improve performance
- **Lazy loading** only activates what's needed
- **Extensibility** easy to add new domains without affecting core

### Why Gentleman Mode?

- **Single interface** - users don't need to know all agents
- **Smart delegation** - automatic agent selection
- **Consistency** - enforces RULEBOOK and standards
- **Reporting** - transparency in which agents are used

### Why MCP Integration?

- **Extended capabilities** - agents can suggest powerful tools
- **Ecosystem leverage** - use existing MCP servers
- **Future-proof** - adapts to new tools and technologies

## License

MIT License - See LICENSE file

## Resources

- **Main Documentation**: This file
- **Agent Selection**: `AGENT_SELECTION_GUIDE.md`
- **MCP Integration**: `MCP_INTEGRATION_GUIDE.md`
- **New Projects**: `EMPTY_PROJECT_QUESTIONNAIRE.md`
- **RULEBOOK Template**: `RULEBOOK_TEMPLATE.md`
- **VoltAgent Reference**: https://github.com/VoltAgent/awesome-claude-code-subagents

## Version

Global Agents Toolkit v1.0.0
