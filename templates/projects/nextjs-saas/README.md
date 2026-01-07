# Next.js SaaS Template

> Pre-configured RULEBOOK for modern SaaS applications built with Next.js 15, Prisma, tRPC, and Tailwind CSS.

## What's Included

This template provides a complete RULEBOOK configuration for building production-ready SaaS applications with:

### Tech Stack
- **Next.js 15** (App Router) - Modern React framework
- **TypeScript 5.5+** - Type-safe development
- **Tailwind CSS 4.0** - Utility-first styling
- **Prisma 5.x** - Type-safe database ORM
- **tRPC** - End-to-end type safety for APIs
- **PostgreSQL** - Robust relational database
- **NextAuth.js v5** - Complete authentication solution
- **Stripe** - Subscription billing & payments
- **Zustand** - Lightweight state management
- **Vitest + Playwright** - Comprehensive testing

### Key Features Covered
✅ User authentication & authorization
✅ Subscription billing with Stripe
✅ Multi-tenant architecture
✅ Admin dashboard patterns
✅ Type-safe API layer (tRPC)
✅ Database schema best practices
✅ Email notifications
✅ File upload handling
✅ Security guidelines (OWASP Top 10)
✅ Performance optimization
✅ Accessibility standards (WCAG 2.1 AA)

## How to Use This Template

### Option 1: Install with Template Flag (Coming Soon)
```bash
cd your-project
./install.sh --template=nextjs-saas
```

### Option 2: Manual Installation
```bash
# 1. Install the toolkit
cd your-project
./install.sh

# 2. Copy the template RULEBOOK
cp /path/to/claude-code-agents-toolkit/templates/projects/nextjs-saas/RULEBOOK.md .claude/RULEBOOK.md

# 3. Validate the RULEBOOK
scripts/validate-rulebook.sh
```

## What Gets Configured

### 1. Complete Folder Structure
The RULEBOOK defines a battle-tested folder structure:
```
src/app/          # Next.js App Router routes
src/components/   # Reusable components
src/lib/          # Utilities & clients
src/server/       # tRPC API layer
src/stores/       # Zustand stores
prisma/           # Database schema & migrations
tests/            # Unit, integration, E2E tests
```

### 2. Active Agents (21 Agents)
**Core Agents (10):**
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

**Stack-Specific Agents (11):**
- nextjs-specialist, react-specialist, typescript-pro
- tailwind-expert, prisma-specialist, postgres-expert
- rest-api-architect, vitest-specialist, playwright-e2e-specialist
- ui-accessibility, vercel-deployment-specialist

### 3. Code Organization Patterns
- Component structure guidelines
- Import order conventions
- File naming standards
- Type definition patterns

### 4. API Architecture
- tRPC router setup
- Protected procedures
- Input validation with Zod
- Error handling patterns

### 5. Database Patterns
- Prisma schema conventions
- Migration strategy
- Seed data structure
- Query optimization

### 6. Authentication Setup
- NextAuth.js configuration
- Protected route patterns
- Session management
- OAuth provider setup

### 7. Payment Integration
- Stripe subscription flow
- Webhook handling
- Invoice generation
- Subscription management

### 8. Testing Strategy
- Unit test patterns (Vitest)
- E2E test flows (Playwright)
- Coverage requirements (70% min)
- API testing utilities

### 9. Security Guidelines
- CSRF protection
- SQL injection prevention
- XSS mitigation
- Rate limiting
- Input validation
- OWASP Top 10 compliance

### 10. Performance Targets
- FCP < 1.5s
- LCP < 2.5s
- TTI < 3.5s
- CLS < 0.1

## Environment Variables Template

The RULEBOOK documents all required environment variables:

```bash
# Database
DATABASE_URL="postgresql://..."

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET=""

# OAuth
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""

# Stripe
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""

# Email
RESEND_API_KEY=""

# Storage (S3/R2)
S3_ACCESS_KEY_ID=""
S3_SECRET_ACCESS_KEY=""
```

## When to Use This Template

✅ **Perfect For:**
- SaaS applications with subscriptions
- Multi-tenant platforms
- B2B software products
- Membership sites
- Premium content platforms

❌ **Not Ideal For:**
- Simple landing pages (too complex)
- Static sites (use Astro template instead)
- Mobile-only apps (use React Native template)
- Pure API projects (use Express template)

## What Makes This Template Special

### 1. **Production-Ready Patterns**
Not just a starter - includes real-world patterns for:
- Subscription management
- Webhook handling
- Multi-tenancy
- Admin dashboards

### 2. **Security First**
Built-in security guidelines covering:
- OWASP Top 10
- PCI DSS basics (for payments)
- GDPR considerations
- Authentication best practices

### 3. **Type Safety Everywhere**
End-to-end type safety:
- tRPC for API
- Prisma for database
- Zod for validation
- TypeScript throughout

### 4. **Modern Stack**
Uses 2026 best practices:
- Next.js 15 App Router
- React Server Components
- Streaming & Suspense
- Server Actions

### 5. **Developer Experience**
Optimized for productivity:
- Fast feedback loops
- Type-safe development
- Auto-generated types
- Comprehensive error handling

## Customization

After installation, customize the RULEBOOK:

1. **Update Project Info**
   ```markdown
   ## Project Overview
   **Name:** Your SaaS Name
   **Description:** Your description
   ```

2. **Adjust Tech Stack**
   - Add/remove technologies
   - Update version numbers
   - Specify custom integrations

3. **Modify Active Agents**
   ```bash
   scripts/select-agents.sh
   # Activate/deactivate agents based on your needs
   ```

4. **Add Custom Sections**
   - Deployment specifics
   - Third-party integrations
   - Team conventions
   - Domain-specific rules

## Getting Help

If you run into issues:

1. **Validate Your RULEBOOK**
   ```bash
   scripts/validate-rulebook.sh
   ```

2. **Check Health**
   ```bash
   scripts/healthcheck.sh
   ```

3. **Consult Troubleshooting Guide**
   ```bash
   cat docs/TROUBLESHOOTING.md
   ```

## Example Projects Using This Template

- **SaaS Starter Kit** - Complete Next.js SaaS boilerplate
- **Subscription Platform** - Membership management system
- **B2B Software** - Enterprise SaaS application
- **Content Platform** - Premium content delivery

## Next Steps

After using this template:

1. ✅ Review the RULEBOOK
2. ✅ Set up environment variables
3. ✅ Initialize your Next.js project
4. ✅ Run migrations: `npx prisma migrate dev`
5. ✅ Start development: `npm run dev`
6. ✅ Let Maestro guide you: `/maestro` in Claude Code

## Related Templates

- **react-dashboard** - Admin dashboards & analytics
- **express-api** - Backend API services
- **react-native-mobile** - Mobile applications
- **python-fastapi** - Python-based SaaS

---

**Template Version:** 1.0.0
**Compatible With:** Claude Code Agents Toolkit v1.0.0+
**Last Updated:** 2026-01-07

**Questions?** Check the main toolkit [README.md](../../../README.md) or [TROUBLESHOOTING.md](../../../docs/TROUBLESHOOTING.md)
