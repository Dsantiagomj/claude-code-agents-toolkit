# MCP Integration Guide

Model Context Protocol (MCP) servers extend Claude Code's capabilities by providing access to external tools, data sources, and services. This guide shows how to integrate MCP servers with the Global Agents Toolkit.

## Table of Contents

1. [What is MCP?](#what-is-mcp)
2. [Installing MCP Servers](#installing-mcp-servers)
3. [Agent-Specific Recommendations](#agent-specific-recommendations)
4. [Common MCP Servers](#common-mcp-servers)
5. [Integration Patterns](#integration-patterns)
6. [Custom MCP Servers](#custom-mcp-servers)

## What is MCP?

**Model Context Protocol (MCP)** is a standard protocol that allows Claude to interact with external tools and data sources through server implementations.

### Benefits

- **Extended capabilities**: Database access, browser automation, API interactions
- **Tool integration**: Use existing developer tools within Claude workflows
- **Data access**: Read from external sources (databases, APIs, files)
- **Action execution**: Perform operations (deploy, test, monitor)

### How It Works

```
Claude Code → MCP Server → External Tool/Service → Results → Claude
```

Example:
```
Claude → PostgreSQL MCP → Database Query → Results → Claude analyzes data
```

## Installing MCP Servers

### Via Claude Code Settings

1. Open Claude Code settings configuration
2. Add MCP server configuration:

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://user:pass@localhost/db"]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

3. Restart Claude Code to activate servers

### Via NPM (Global Installation)

```bash
# Install MCP servers globally
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-playwright
npm install -g @modelcontextprotocol/server-puppeteer
```

Then configure in settings:
```json
{
  "mcpServers": {
    "postgres": {
      "command": "mcp-server-postgres",
      "args": ["postgresql://localhost/mydb"]
    }
  }
}
```

### Via Project Dependencies

```bash
# Add to project
npm install --save-dev @modelcontextprotocol/server-playwright

# Or with other package managers
pnpm add -D @modelcontextprotocol/server-playwright
yarn add -D @modelcontextprotocol/server-playwright
```

## Agent-Specific Recommendations

### Core Agents

#### code-reviewer
**No specific MCP required** - Uses Claude's built-in code analysis

**Optional MCPs:**
- Static analysis tools (ESLint, etc.)
- Code quality metrics

---

#### test-strategist
**Recommended MCPs:**
- `@modelcontextprotocol/server-playwright` - Browser E2E testing
- `@modelcontextprotocol/server-puppeteer` - Browser automation
- Coverage reporting tools

**Configuration:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

**Use cases:**
- Generate E2E test scenarios
- Run browser tests
- Capture screenshots for visual testing

---

#### security-auditor
**Recommended MCPs:**
- Security scanning tools
- Vulnerability databases
- OWASP compliance checkers

**Use cases:**
- Automated security scans
- Dependency vulnerability checks
- OWASP Top 10 verification

---

#### performance-optimizer
**Recommended MCPs:**
- Performance profiling tools
- Lighthouse integration
- Bundle analyzers

**Use cases:**
- Performance benchmarking
- Load time analysis
- Bundle size optimization

---

#### dependency-manager
**Recommended MCPs:**
- Package registry APIs (npm, PyPI, etc.)
- Security advisory databases
- Version compatibility checkers

**Use cases:**
- Check for outdated dependencies
- Security vulnerability scanning
- Automated dependency updates

---

#### git-workflow-specialist
**Recommended MCPs:**
- Git service APIs (GitHub, GitLab, Bitbucket)
- CI/CD pipeline integrations

**Use cases:**
- PR automation
- Commit analysis
- Branch management

### Specialized Agents - Frontend

#### react-specialist
**Recommended MCPs:**
- `@modelcontextprotocol/server-playwright`
- Component testing frameworks
- Bundle analyzers

**Configuration:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

---

#### tailwind-expert
**No specific MCP required**

**Optional MCPs:**
- Design token management
- CSS analysis tools

---

#### ui-accessibility
**Recommended MCPs:**
- Accessibility testing tools (axe-core)
- Screen reader simulators

**Use cases:**
- WCAG compliance checking
- Accessibility audits
- Screen reader testing

### Specialized Agents - Backend

#### express-specialist / fastify-expert / nest-specialist
**Recommended MCPs:**
- Database MCPs (see database section)
- API testing tools
- Performance monitoring

---

#### rest-api-architect
**Recommended MCPs:**
- API testing frameworks (Postman, Insomnia)
- OpenAPI/Swagger tools
- Load testing tools

**Use cases:**
- API endpoint testing
- Load testing
- API documentation generation

---

#### graphql-specialist
**Recommended MCPs:**
- GraphQL playground integration
- Schema validation tools

**Use cases:**
- Schema validation
- Query optimization
- Resolver testing

### Specialized Agents - Databases

#### postgres-expert
**Recommended MCPs:**
- `@modelcontextprotocol/server-postgres`

**Configuration:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://user:password@localhost:5432/database"
      ]
    }
  }
}
```

**Use cases:**
- Query execution and analysis
- Schema inspection
- Performance tuning
- Migration assistance

---

#### mongodb-expert
**Recommended MCPs:**
- MongoDB MCP (if available)
- Database GUI tools

**Use cases:**
- Query optimization
- Schema design
- Aggregation pipeline building

---

#### prisma-specialist
**Recommended MCPs:**
- Database MCPs (postgres, mysql, etc.)
- Prisma Studio integration

**Use cases:**
- Schema design
- Migration generation
- Query optimization

### Specialized Agents - Infrastructure

#### docker-specialist
**Recommended MCPs:**
- Docker CLI integration
- Container registry APIs

**Use cases:**
- Dockerfile optimization
- Image building
- Container debugging

---

#### kubernetes-expert
**Recommended MCPs:**
- kubectl integration
- Cluster monitoring tools
- Helm chart tools

**Use cases:**
- Manifest generation
- Cluster management
- Debugging deployments

---

#### ci-cd-architect
**Recommended MCPs:**
- CI/CD platform APIs (GitHub Actions, GitLab CI, etc.)
- Deployment monitoring tools

**Use cases:**
- Pipeline configuration
- Deployment automation
- Build optimization

---

#### aws-specialist / vercel-expert / cloudflare-specialist
**Recommended MCPs:**
- Cloud provider CLI tools
- Deployment APIs
- Monitoring integrations

**Use cases:**
- Resource provisioning
- Deployment automation
- Cost optimization

### Specialized Agents - Testing

#### playwright-specialist
**Recommended MCPs:**
- `@modelcontextprotocol/server-playwright`

**Configuration:**
```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

**Use cases:**
- E2E test generation
- Browser automation
- Screenshot testing
- Cross-browser testing

---

#### cypress-specialist
**Recommended MCPs:**
- Cypress integration (if available)
- Visual testing tools

**Use cases:**
- E2E test creation
- Component testing
- Visual regression

### Specialized Agents - Languages

#### python-specialist
**Recommended MCPs:**
- Python environment management
- PyPI integration
- Jupyter notebook integration

**Use cases:**
- Package management
- Notebook execution
- Environment setup

---

#### typescript-pro
**No specific MCP required**

**Optional MCPs:**
- Type checking tools
- npm registry APIs

## Common MCP Servers

### Official MCP Servers

| Server | Package | Use Case |
|--------|---------|----------|
| PostgreSQL | `@modelcontextprotocol/server-postgres` | Database queries, schema inspection |
| Playwright | `@modelcontextprotocol/server-playwright` | Browser automation, E2E testing |
| Puppeteer | `@modelcontextprotocol/server-puppeteer` | Browser control, scraping |
| Filesystem | `@modelcontextprotocol/server-filesystem` | File operations |
| GitHub | `@modelcontextprotocol/server-github` | GitHub API integration |

### Community MCP Servers

| Domain | Server | Use Case |
|--------|--------|----------|
| Databases | MongoDB MCP | MongoDB operations |
| Testing | Selenium MCP | Browser automation |
| Cloud | AWS MCP | AWS resource management |
| API | Postman MCP | API testing |
| Monitoring | Datadog MCP | Monitoring integration |

### Installation Examples

#### PostgreSQL
```bash
npm install -g @modelcontextprotocol/server-postgres
```

```json
{
  "mcpServers": {
    "postgres": {
      "command": "mcp-server-postgres",
      "args": ["postgresql://localhost/mydb"]
    }
  }
}
```

#### Playwright
```bash
npm install -g @modelcontextprotocol/server-playwright
```

```json
{
  "mcpServers": {
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

#### GitHub
```bash
npm install -g @modelcontextprotocol/server-github
```

```json
{
  "mcpServers": {
    "github": {
      "command": "mcp-server-github",
      "env": {
        "GITHUB_TOKEN": "your_token_here"
      }
    }
  }
}
```

## Integration Patterns

### Pattern 1: Database-Backed Application

**Stack:**
- Next.js frontend
- PostgreSQL database
- Prisma ORM

**MCP Setup:**
```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-postgres",
        "postgresql://localhost/myapp"
      ]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

**Agents activated:**
- nextjs-specialist → Uses Playwright MCP for testing
- postgres-expert → Uses PostgreSQL MCP for queries
- prisma-specialist → Works with PostgreSQL MCP

**Workflow:**
1. postgres-expert analyzes schema via MCP
2. prisma-specialist generates migrations
3. nextjs-specialist creates UI
4. playwright-specialist tests via MCP

---

### Pattern 2: API Development

**Stack:**
- Express.js backend
- REST API
- MongoDB

**MCP Setup:**
```json
{
  "mcpServers": {
    "mongodb": {
      "command": "npx",
      "args": ["-y", "mcp-server-mongodb", "mongodb://localhost/api"]
    },
    "postman": {
      "command": "npx",
      "args": ["-y", "mcp-server-postman"]
    }
  }
}
```

**Agents activated:**
- express-specialist
- rest-api-architect → Uses Postman MCP for testing
- mongodb-expert → Uses MongoDB MCP for queries

---

### Pattern 3: Infrastructure as Code

**Stack:**
- Kubernetes
- Terraform
- AWS

**MCP Setup:**
```json
{
  "mcpServers": {
    "kubectl": {
      "command": "npx",
      "args": ["-y", "mcp-server-kubectl"]
    },
    "aws": {
      "command": "npx",
      "args": ["-y", "mcp-server-aws"],
      "env": {
        "AWS_PROFILE": "default"
      }
    }
  }
}
```

**Agents activated:**
- kubernetes-expert → Uses kubectl MCP
- terraform-specialist
- aws-specialist → Uses AWS MCP

## Custom MCP Servers

### Creating a Custom MCP Server

You can create custom MCP servers for project-specific needs:

```typescript
// custom-mcp-server.ts
import { Server } from '@modelcontextprotocol/sdk/server';

const server = new Server({
  name: 'custom-tool',
  version: '1.0.0',
});

server.setRequestHandler('tools/list', async () => ({
  tools: [
    {
      name: 'custom_operation',
      description: 'Performs a custom operation',
      inputSchema: {
        type: 'object',
        properties: {
          param: { type: 'string' }
        }
      }
    }
  ]
}));

server.setRequestHandler('tools/call', async (request) => {
  // Implement your custom logic
  return {
    content: [
      { type: 'text', text: 'Operation result' }
    ]
  };
});

server.connect();
```

### Register Custom Server

```json
{
  "mcpServers": {
    "custom": {
      "command": "node",
      "args": ["./custom-mcp-server.js"]
    }
  }
}
```

## Best Practices

### 1. Security

- **Never commit credentials**: Use environment variables
- **Rotate tokens**: Regularly update API keys
- **Limit permissions**: Use least-privilege access
- **Audit access**: Monitor MCP server usage

```json
{
  "mcpServers": {
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres"],
      "env": {
        "DATABASE_URL": "${DATABASE_URL}"
      }
    }
  }
}
```

### 2. Performance

- **Cache connections**: MCP servers maintain connections
- **Limit concurrent requests**: Avoid overwhelming external services
- **Use timeouts**: Configure request timeouts
- **Monitor usage**: Track MCP call frequency

### 3. Error Handling

- **Graceful degradation**: Agents should work without MCP when possible
- **Clear error messages**: Help users fix MCP configuration
- **Fallback strategies**: Alternative approaches if MCP unavailable

### 4. Documentation

- **Document requirements**: List required MCP servers in RULEBOOK
- **Provide setup instructions**: Include configuration examples
- **Version compatibility**: Note MCP server version requirements

## Troubleshooting

### MCP Server Not Found

**Error:** `MCP server 'postgres' not found`

**Solutions:**
1. Check server is installed: `npm list -g @modelcontextprotocol/server-postgres`
2. Verify configuration in settings
3. Restart Claude Code after configuration changes

### Connection Errors

**Error:** `Failed to connect to database`

**Solutions:**
1. Verify connection string format
2. Check database is running
3. Verify credentials and permissions
4. Check firewall/network settings

### Permission Denied

**Error:** `Permission denied accessing resource`

**Solutions:**
1. Verify API tokens/credentials
2. Check user permissions
3. Review MCP server logs
4. Use environment variables for sensitive data

## MCP Server Registry

Maintain a list of installed MCP servers in your RULEBOOK:

```markdown
## MCP Servers

### Active
- postgres: `@modelcontextprotocol/server-postgres` - Database operations
- playwright: `@modelcontextprotocol/server-playwright` - E2E testing

### Available
- github: `@modelcontextprotocol/server-github` - GitHub integration
- aws: `mcp-server-aws` - AWS operations

### Installation
\`\`\`bash
npm install -g @modelcontextprotocol/server-postgres
npm install -g @modelcontextprotocol/server-playwright
\`\`\`
```

## Summary

- **MCP extends capabilities**: Access external tools and data
- **Agent-specific recommendations**: Each agent can suggest MCPs
- **Easy installation**: Via npm or configuration
- **Security first**: Use environment variables for credentials
- **Graceful degradation**: Agents work without MCP when possible
- **Document in RULEBOOK**: Track required MCP servers

For agent selection guidance, see `AGENT_SELECTION_GUIDE.md`.
For new project setup with MCP recommendations, see `EMPTY_PROJECT_QUESTIONNAIRE.md`.
