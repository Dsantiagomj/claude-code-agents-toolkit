# RULEBOOK Template

This template is used by Maestro Mode to generate a comprehensive RULEBOOK.md for new projects or enhance existing ones. The RULEBOOK serves as the single source of truth for project patterns, conventions, and standards.

---

# RULEBOOK: [Project Name]

> **Last Updated:** [Date]  
> **Version:** 1.0.0  
> **Tech Stack:** [Brief summary]

## Table of Contents

1. [Project Overview](#project-overview)
2. [Tech Stack](#tech-stack)
3. [Project Structure](#project-structure)
4. [Development Workflow](#development-workflow)
5. [Code Standards](#code-standards)
6. [Testing](#testing)
7. [Git Workflow](#git-workflow)
8. [Deployment](#deployment)
9. [Security](#security)
10. [Performance](#performance)
11. [Active Agents](#active-agents)
12. [MCP Servers](#mcp-servers)

---

## Project Overview

### Purpose
[Brief description of what this project does and why it exists]

### Target Audience
[Who uses this application/service/library]

### Key Features
- [Feature 1]
- [Feature 2]
- [Feature 3]

### Scale & Metrics
- **Expected Users:** [Number/range]
- **Target Performance:** [Response times, throughput, etc.]
- **Uptime Goal:** [e.g., 99.9%]

---

## Tech Stack

### Language
- **Primary:** [Language + version]
- **Type System:** [e.g., TypeScript strict mode]

### Frontend (if applicable)
- **Framework:** [e.g., Next.js 15, React 19]
- **Styling:** [e.g., Tailwind CSS, CSS Modules]
- **State Management:** [e.g., React Context, Zustand, Redux]
- **UI Components:** [e.g., Shadcn/ui, Material-UI]

### Backend (if applicable)
- **Framework:** [e.g., Express.js, FastAPI, NestJS]
- **API Style:** [REST, GraphQL, tRPC, gRPC]
- **Validation:** [e.g., Zod, Joi, Yup]

### Database
- **Primary DB:** [e.g., PostgreSQL 16]
- **ORM/Query Builder:** [e.g., Prisma, TypeORM]
- **Caching:** [e.g., Redis, in-memory]
- **Search:** [e.g., Elasticsearch, none]

### Authentication
- **Method:** [e.g., JWT, sessions, OAuth]
- **Provider/Library:** [e.g., Auth.js, Clerk, custom]

### Testing
- **Unit Tests:** [e.g., Vitest, Jest]
- **Integration Tests:** [e.g., Supertest, testing-library]
- **E2E Tests:** [e.g., Playwright, Cypress]
- **Coverage Target:** [e.g., 80% minimum]

### Infrastructure
- **Hosting:** [e.g., Vercel, AWS, self-hosted]
- **Containerization:** [e.g., Docker, none]
- **CI/CD:** [e.g., GitHub Actions, GitLab CI]
- **Monitoring:** [e.g., Sentry, Datadog, Vercel Analytics]

### Package Manager
- **Tool:** [npm, pnpm, yarn, bun]
- **Lock File:** [package-lock.json, pnpm-lock.yaml, etc.]

---

## Project Structure

### Directory Organization

```
[project-name]/
├── .claude/                  # Claude Code configuration
│   ├── RULEBOOK.md          # This file
│   ├── agents-global/       # Global agent toolkit
│   └── commands/            # Custom slash commands
├── src/                     # Source code
│   ├── [framework-specific structure]
├── tests/                   # Test files
│   ├── unit/
│   ├── integration/
│   └── e2e/
├── public/                  # Static assets (if applicable)
├── docs/                    # Documentation (if applicable)
├── scripts/                 # Utility scripts
├── .env.example             # Environment template
├── .gitignore
├── README.md
├── package.json             # Dependencies
└── [config files]
```

### Feature-Based Architecture (if applicable)

**Pattern:** Organize by feature, not by type

```
src/
├── features/
│   ├── [feature-name]/
│   │   ├── components/       # Feature-specific components
│   │   ├── hooks/           # Feature-specific hooks
│   │   ├── utils/           # Feature-specific utilities
│   │   ├── types.ts         # Feature-specific types
│   │   ├── schemas.ts       # Validation schemas
│   │   └── index.ts         # Public API
│   └── ...
├── components/              # Shared components
├── lib/                     # Shared utilities
├── types/                   # Shared types
└── app/ or pages/          # Routes/pages
```

**Rules:**
- Each feature should be self-contained
- Features export a public API via `index.ts`
- Shared code goes in top-level directories
- Avoid circular dependencies between features

### File Naming Conventions

**Components:**
```
[name].tsx              # Component file
[name].test.tsx         # Component tests
[name].stories.tsx      # Storybook stories (if using)
```

**Utilities:**
```
[name].ts               # Utility module
[name].test.ts          # Unit tests
```

**Types:**
```
types.ts                # Type definitions
schemas.ts              # Validation schemas (Zod, etc.)
```

**Naming Style:**
- Files: `kebab-case.tsx` or `camelCase.ts` [choose one]
- Components: `PascalCase`
- Functions: `camelCase`
- Constants: `UPPER_SNAKE_CASE`
- Types/Interfaces: `PascalCase`

---

## Development Workflow

### Getting Started

```bash
# Clone repository
git clone [repo-url]
cd [project-name]

# Install dependencies
[npm install / pnpm install]

# Set up environment
cp .env.example .env
# Edit .env with your values

# Set up database (if applicable)
[npx prisma migrate dev / run migrations]

# Start development server
[npm run dev]
```

### Available Scripts

```bash
npm run dev           # Start development server
npm run build         # Build for production
npm run start         # Start production server
npm run test          # Run all tests
npm run test:unit     # Run unit tests
npm run test:e2e      # Run E2E tests
npm run lint          # Lint code
npm run format        # Format code
npm run type-check    # TypeScript type checking
```

### Environment Variables

**Required:**
```
DATABASE_URL=          # Database connection string
API_URL=              # API base URL (if applicable)
```

**Optional:**
```
NEXTAUTH_URL=         # Auth URL (if using Auth.js)
NEXTAUTH_SECRET=      # Auth secret (if using Auth.js)
```

**Never commit:** `.env` files with real credentials

---

## Code Standards

### TypeScript (if applicable)

**Configuration:**
```json
{
  "strict": true,
  "noUncheckedIndexedAccess": true,
  "noImplicitReturns": true
}
```

**Rules:**
- Always use `type` for object shapes, `interface` for extendable contracts
- Avoid `any`; use `unknown` if type is truly unknown
- Use `const` assertions for literal types
- Prefer function declarations over arrow functions for top-level functions

**Example:**
```typescript
// ✅ Good
type User = {
  id: string;
  name: string;
};

function getUser(id: string): User {
  // implementation
}

// ❌ Bad
interface User {
  id: any;
  name: string;
}

const getUser = (id) => {
  // implementation
};
```

### Code Style

**Formatting:**
- Use [Prettier / ESLint / other]
- 2-space indentation [or specify]
- Single quotes [or double quotes]
- Trailing commas
- Semicolons [yes/no]

**Linting:**
- Run linter before commit
- No warnings allowed in production build
- Use ESLint recommended rules + [project-specific rules]

### Import Organization

```typescript
// 1. External dependencies
import { useState } from 'react';
import { z } from 'zod';

// 2. Internal aliases
import { Button } from '@/components/ui/button';
import { api } from '@/lib/api';

// 3. Relative imports
import { UserCard } from './user-card';
import type { User } from './types';
```

### Comments & Documentation

**When to comment:**
- Complex algorithms or business logic
- Non-obvious workarounds
- Important architectural decisions
- Public APIs (JSDoc)

**When NOT to comment:**
- Obvious code (the code should be self-documenting)
- Outdated information

**Example:**
```typescript
// ✅ Good - explains WHY
// Using setTimeout instead of setInterval to prevent
// overlapping executions when API is slow
setTimeout(() => fetchData(), 5000);

// ❌ Bad - explains WHAT (obvious from code)
// Set timeout to 5000ms
setTimeout(() => fetchData(), 5000);
```

### Error Handling

**Pattern:**
```typescript
// Use try-catch for async operations
try {
  const result = await riskyOperation();
  return { success: true, data: result };
} catch (error) {
  logger.error('Operation failed', { error });
  return { success: false, error: 'User-friendly message' };
}

// Use error boundaries for React components
// Use proper error types (not just Error)
```

### Validation

**Always validate:**
- User input
- External API responses
- Environment variables

**Use schemas:**
```typescript
import { z } from 'zod';

const userSchema = z.object({
  id: z.string().uuid(),
  email: z.string().email(),
  age: z.number().min(0).max(150),
});

// Validate
const user = userSchema.parse(input);
```

---

## Testing

### Test Structure

```
tests/
├── unit/              # Unit tests (functions, utilities)
├── integration/       # Integration tests (API routes, DB)
└── e2e/              # End-to-end tests (user flows)
```

### Coverage Requirements

- **Overall:** [80%+ / 70%+ / other]
- **Critical paths:** 100% (auth, payment, etc.)
- **Utilities:** 90%+
- **Components:** 80%+
- **E2E:** All major user flows

### Testing Patterns

**Unit Tests:**
```typescript
describe('calculateTotal', () => {
  it('should sum array of numbers', () => {
    expect(calculateTotal([1, 2, 3])).toBe(6);
  });

  it('should return 0 for empty array', () => {
    expect(calculateTotal([])).toBe(0);
  });
});
```

**Component Tests:**
```typescript
describe('Button', () => {
  it('should render children', () => {
    render(<Button>Click me</Button>);
    expect(screen.getByText('Click me')).toBeInTheDocument();
  });

  it('should call onClick when clicked', () => {
    const onClick = vi.fn();
    render(<Button onClick={onClick}>Click</Button>);
    fireEvent.click(screen.getByText('Click'));
    expect(onClick).toHaveBeenCalledOnce();
  });
});
```

**E2E Tests:**
```typescript
test('user can sign up', async ({ page }) => {
  await page.goto('/signup');
  await page.fill('[name="email"]', 'test@example.com');
  await page.fill('[name="password"]', 'securepass123');
  await page.click('[type="submit"]');
  await expect(page).toHaveURL('/dashboard');
});
```

### Test Data

- Use factories/fixtures for test data
- Clean up after tests (database, files, etc.)
- Avoid hardcoded values; use constants

### Running Tests

```bash
# Run all tests
npm test

# Run with coverage
npm run test:coverage

# Run specific test file
npm test path/to/test.test.ts

# Run in watch mode
npm test -- --watch

# Run E2E tests
npm run test:e2e
```

---

## Git Workflow

### Branch Strategy

**Pattern:** [Feature Branch / Git Flow / Trunk-Based]

**Main branches:**
- `main` - Production-ready code
- `develop` - Integration branch (if using Git Flow)

**Feature branches:**
- `feature/[ticket-id]-short-description`
- `fix/[ticket-id]-short-description`
- `refactor/short-description`

**Example:**
```
feature/AUTH-123-add-oauth-login
fix/BUG-456-fix-memory-leak
refactor/improve-api-error-handling
```

### Commit Messages

**Format:** [Conventional Commits](https://www.conventionalcommits.org/)

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `refactor`: Code refactoring
- `docs`: Documentation changes
- `test`: Adding/updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `style`: Code style changes (formatting)

**Examples:**
```
feat(auth): add OAuth Google login
fix(api): handle null response in user endpoint
refactor(database): migrate from TypeORM to Prisma
docs(readme): update installation instructions
test(utils): add tests for date formatting
```

**Rules:**
- Use imperative mood ("add" not "added")
- Lowercase description
- No period at the end
- Keep first line under 72 characters
- Reference ticket/issue in footer if applicable

### Pull Request Process

1. **Create feature branch** from `main` (or `develop`)
2. **Make changes** following code standards
3. **Write tests** to maintain coverage
4. **Run tests locally** - all must pass
5. **Push branch** and create PR
6. **Fill PR template** with description and context
7. **Request review** from [team member / code owner]
8. **Address feedback** if any
9. **Merge** when approved and CI passes

**PR Requirements:**
- [ ] Tests pass
- [ ] Coverage maintained or improved
- [ ] No linting errors
- [ ] Code reviewed and approved
- [ ] Conflicts resolved
- [ ] Description filled out

### Code Review Guidelines

**For reviewers:**
- Check logic correctness
- Verify test coverage
- Look for security issues
- Ensure code follows standards
- Suggest improvements (not blocking if minor)

**For authors:**
- Respond to all comments
- Make requested changes
- Don't take feedback personally
- Ask for clarification if needed

---

## Deployment

### Environments

- **Development:** Local machine
- **Staging:** [URL if applicable]
- **Production:** [URL]

### Deployment Process

**[Automated / Manual / Mixed]**

**Steps:**
```bash
# For automated deployments (e.g., Vercel)
git push origin main  # Auto-deploys to production

# For manual deployments
npm run build
npm run deploy  # or custom script
```

### Environment Configuration

**Production:**
- Environment variables set in [Vercel dashboard / AWS / other]
- Database migrations run automatically [or manually]
- Health checks configured at [endpoint]

### Rollback Procedure

```bash
# Revert to previous deployment
[platform-specific rollback command or git revert]
```

---

## Security

### Authentication & Authorization

- **Auth method:** [JWT / Sessions / OAuth]
- **Token expiry:** [e.g., 7 days]
- **Refresh tokens:** [Yes/No]
- **Password requirements:** [minimum length, complexity]
- **MFA:** [Enabled/Optional/Not implemented]

### Data Protection

- **Encryption at rest:** [Yes/No - what data]
- **Encryption in transit:** [HTTPS everywhere]
- **PII handling:** [how personally identifiable info is handled]
- **GDPR compliance:** [Yes/No/Not applicable]

### Input Validation

- Validate ALL user input (never trust client)
- Use schemas (Zod, Joi, etc.)
- Sanitize data before database insertion
- Prevent SQL injection (use parameterized queries)
- Prevent XSS (escape output, use Content Security Policy)

### Secrets Management

- **Never commit secrets** to Git
- Use `.env` files (local development)
- Use secret managers (production) [e.g., AWS Secrets Manager, Vercel env vars]
- Rotate secrets regularly
- Use different secrets per environment

### Security Headers

```typescript
// Example: Next.js security headers
headers: [
  {
    key: 'X-Frame-Options',
    value: 'DENY',
  },
  {
    key: 'X-Content-Type-Options',
    value: 'nosniff',
  },
  {
    key: 'Referrer-Policy',
    value: 'strict-origin-when-cross-origin',
  },
]
```

### Dependencies

- Run `npm audit` regularly
- Update dependencies monthly
- Review security advisories
- Use `dependabot` or similar for automated updates

---

## Performance

### Targets

- **First Contentful Paint:** [< 1.8s]
- **Largest Contentful Paint:** [< 2.5s]
- **Time to Interactive:** [< 3.8s]
- **API Response Time:** [< 200ms p95]
- **Database Query Time:** [< 50ms p95]

### Optimization Strategies

**Frontend:**
- Code splitting (dynamic imports)
- Image optimization (next/image, formats)
- Lazy loading (components, routes)
- Minimize bundle size (tree shaking)
- Use CDN for static assets

**Backend:**
- Database indexing on frequently queried fields
- Query optimization (N+1 prevention)
- Caching (Redis, in-memory)
- Connection pooling
- Rate limiting

**Database:**
```sql
-- Always index foreign keys
CREATE INDEX idx_user_id ON posts(user_id);

-- Compound indexes for multi-column queries
CREATE INDEX idx_user_created ON posts(user_id, created_at DESC);
```

### Monitoring

- Use [Vercel Analytics / Datadog / New Relic / other]
- Track Core Web Vitals
- Set up alerts for degraded performance
- Review performance monthly

---

## Active Agents

### Core Agents (Always Active)

All 10 core agents from the Global Agents Toolkit:
- code-reviewer
- refactoring-specialist
- documentation-engineer
- test-strategist
- architecture-advisor
- security-auditor
- performance-optimizer
- git-workflow-specialist
- dependency-manager
- project-analyzer

### Specialized Agents (Project-Specific)

**Currently Active:**
- [List activated specialized agents based on tech stack]
- [e.g., nextjs-specialist]
- [e.g., react-specialist]
- [e.g., typescript-pro]
- [e.g., prisma-specialist]
- [e.g., postgres-expert]
- [etc.]

**Rationale:**
[Brief explanation of why these agents are active]

---

## MCP Servers

### Mandatory: context7 (Latest Documentation)

**⚠️ CRITICAL:** The context7 MCP server is MANDATORY for all projects. Claude's training data is from January 2025, and we're now in January 2026. context7 fetches the latest documentation to ensure code uses current syntax and patterns.

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

**Why context7 is mandatory:**
- ✅ Frameworks update frequently (Next.js, React, TypeScript)
- ✅ APIs change, features added, patterns deprecated
- ✅ Best practices evolve
- ✅ Prevents using outdated/deprecated code
- ✅ Ensures compatibility with latest versions

**When Maestro uses context7:**
- Before ANY code generation for frameworks/libraries
- When suggesting API usage patterns
- When implementing features with external dependencies
- When user mentions specific tool versions

**Common tools requiring latest docs:**
- Next.js (App Router changes frequently)
- React (Server Components, Suspense, new hooks)
- TypeScript (new syntax, compiler options)
- Tailwind CSS (utility classes, configuration)
- tRPC, Prisma, Drizzle (API changes)
- Testing libraries (Vitest, Playwright, Jest)
- State management (Zustand, Redux Toolkit)

### Project-Specific MCP Servers

```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]
    },
    "[server-name]": {
      "command": "[command]",
      "args": ["[args]"]
    }
  }
}
```

**Example with multiple servers:**
```json
{
  "mcpServers": {
    "context7": {
      "command": "npx",
      "args": ["-y", "context7-mcp"]
    },
    "postgres": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-postgres", "postgresql://localhost/mydb"]
    },
    "playwright": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-playwright"]
    }
  }
}
```

### MCP Usage Guidelines

- Document required MCP servers for the project
- Include setup instructions in README
- Use environment variables for sensitive connection strings
- Test MCP integrations in CI/CD

---

## Appendix

### Useful Commands

```bash
# [Add project-specific commands]
```

### External Resources

- [Link to API documentation]
- [Link to design system]
- [Link to project management tool]

### Contact & Support

- **Project Lead:** [Name]
- **Team:** [Team name/channel]
- **Repository:** [GitHub/GitLab URL]

---

**Remember:** This RULEBOOK is a living document. Update it as the project evolves, and always ensure it reflects the current state of the project.
