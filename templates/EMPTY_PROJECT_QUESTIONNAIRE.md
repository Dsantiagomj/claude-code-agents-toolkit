# Empty Project Questionnaire

This questionnaire is designed to help set up new projects with the optimal tech stack, agents, MCP servers, and best practices. Maestro Mode uses this to conduct a deep discovery process when working with empty or new projects.

## How It Works

When Maestro Mode detects an empty project (no `package.json`, `requirements.txt`, etc.), it will:

1. Run through this questionnaire interactively
2. Analyze responses to recommend tech stack
3. Activate appropriate specialized agents
4. Suggest relevant MCP servers
5. Generate a RULEBOOK.md with project patterns
6. Create initial project structure

## Questionnaire Sections

### Section 1: Project Overview

#### Q1.1: What type of project are you building?

**Options:**
- [ ] Web Application (frontend + backend)
- [ ] API Service (backend only)
- [ ] Frontend Application (SPA/PWA)
- [ ] Mobile Application
- [ ] Desktop Application
- [ ] CLI Tool
- [ ] Library/Package
- [ ] Data Pipeline / ML Project
- [ ] Microservices Architecture
- [ ] Browser Extension
- [ ] Game
- [ ] Other (please describe)

**Follow-up:** Briefly describe your project's main purpose.

---

#### Q1.2: Who is the target audience?

**Options:**
- [ ] End users (B2C)
- [ ] Business customers (B2B)
- [ ] Internal team/company
- [ ] Developers (library/tool)
- [ ] Mixed audience

---

#### Q1.3: What is the expected scale?

**Options:**
- [ ] Personal/Side project (< 100 users)
- [ ] Small business (100-1K users)
- [ ] Medium scale (1K-100K users)
- [ ] Large scale (100K-1M users)
- [ ] Enterprise scale (1M+ users)
- [ ] Unknown/Not sure

---

### Section 2: Technical Preferences

#### Q2.1: Do you have a preferred programming language?

**Options:**
- [ ] JavaScript/TypeScript
- [ ] Python
- [ ] Go
- [ ] Rust
- [ ] Java
- [ ] C#/.NET
- [ ] PHP
- [ ] Ruby
- [ ] No preference (recommend based on project type)
- [ ] Other: ___________

---

#### Q2.2: Frontend framework preference (if applicable)?

**Options:**
- [ ] React
- [ ] Vue.js
- [ ] Angular
- [ ] Svelte
- [ ] Solid.js
- [ ] Vanilla JS (no framework)
- [ ] No preference (recommend)
- [ ] Not applicable (no frontend)
- [ ] Other: ___________

---

#### Q2.3: Backend framework preference (if applicable)?

**Options:**
- [ ] Express.js (Node.js)
- [ ] Fastify (Node.js)
- [ ] NestJS (Node.js)
- [ ] Next.js API Routes (Node.js)
- [ ] FastAPI (Python)
- [ ] Django (Python)
- [ ] Flask (Python)
- [ ] Gin/Echo (Go)
- [ ] Actix/Rocket (Rust)
- [ ] Spring Boot (Java)
- [ ] ASP.NET Core (C#)
- [ ] Laravel (PHP)
- [ ] Rails (Ruby)
- [ ] No preference (recommend)
- [ ] Not applicable (no backend)
- [ ] Other: ___________

---

#### Q2.4: Full-stack framework preference (if applicable)?

**Options:**
- [ ] Next.js (React)
- [ ] Nuxt.js (Vue)
- [ ] Remix (React)
- [ ] SvelteKit (Svelte)
- [ ] SolidStart (Solid)
- [ ] Astro
- [ ] No preference (recommend)
- [ ] Not using full-stack framework
- [ ] Other: ___________

---

#### Q2.5: Database preference?

**Options:**
- [ ] PostgreSQL
- [ ] MySQL/MariaDB
- [ ] MongoDB
- [ ] SQLite
- [ ] Redis (cache/session)
- [ ] Supabase (PostgreSQL + services)
- [ ] Firebase
- [ ] DynamoDB
- [ ] No database needed
- [ ] No preference (recommend)
- [ ] Other: ___________

---

#### Q2.6: ORM/Query Builder preference (if using SQL)?

**Options:**
- [ ] Prisma
- [ ] TypeORM
- [ ] Drizzle
- [ ] Sequelize
- [ ] Knex.js
- [ ] SQLAlchemy (Python)
- [ ] GORM (Go)
- [ ] Diesel (Rust)
- [ ] Raw SQL (no ORM)
- [ ] No preference (recommend)
- [ ] Other: ___________

---

### Section 3: Features & Requirements

#### Q3.1: Authentication requirements?

**Options:**
- [ ] Email/password authentication
- [ ] OAuth (Google, GitHub, etc.)
- [ ] Magic link/passwordless
- [ ] Multi-factor authentication (MFA)
- [ ] SSO/SAML
- [ ] No authentication needed
- [ ] Other: ___________

**Recommendation prompt:** If yes to any auth, suggest Auth.js, Clerk, Supabase Auth, or custom implementation.

---

#### Q3.2: Will you need real-time features?

**Options:**
- [ ] Yes - Real-time updates (WebSockets/SSE)
- [ ] Yes - Real-time collaboration
- [ ] Yes - Live notifications
- [ ] No
- [ ] Not sure

**Recommendation prompt:** If yes, suggest WebSocket libraries, Pusher, Ably, or Socket.io.

---

#### Q3.3: File upload/storage requirements?

**Options:**
- [ ] Yes - User uploads (images, documents, etc.)
- [ ] Yes - Large file uploads (video, bulk data)
- [ ] No
- [ ] Not sure

**Recommendation prompt:** If yes, suggest Cloudflare R2, AWS S3, Vercel Blob, or UploadThing.

---

#### Q3.4: Payment processing needed?

**Options:**
- [ ] Yes - Stripe
- [ ] Yes - PayPal
- [ ] Yes - Other payment provider
- [ ] No
- [ ] Not sure yet

---

#### Q3.5: Email sending requirements?

**Options:**
- [ ] Yes - Transactional emails (password reset, notifications)
- [ ] Yes - Marketing emails
- [ ] No
- [ ] Not sure

**Recommendation prompt:** If yes, suggest Resend, SendGrid, AWS SES, or Mailgun.

---

#### Q3.6: Analytics/monitoring needs?

**Options:**
- [ ] User analytics (page views, events)
- [ ] Performance monitoring (APM)
- [ ] Error tracking
- [ ] All of the above
- [ ] None needed yet
- [ ] Not sure

**Recommendation prompt:** Suggest Vercel Analytics, Plausible, PostHog (analytics), Sentry (errors), Datadog (APM).

---

### Section 4: Development Practices

#### Q4.1: Testing requirements?

**Options:**
- [ ] Unit tests required
- [ ] Integration tests required
- [ ] E2E tests required
- [ ] All of the above
- [ ] Minimal testing
- [ ] Not sure (recommend)

---

#### Q4.2: Desired test coverage?

**Options:**
- [ ] High (80%+ coverage)
- [ ] Medium (60-80% coverage)
- [ ] Low (40-60% coverage)
- [ ] Minimal (critical paths only)
- [ ] No specific target

---

#### Q4.3: CI/CD requirements?

**Options:**
- [ ] Automated testing on PR
- [ ] Automated deployment
- [ ] Both testing and deployment
- [ ] None yet
- [ ] Not sure (recommend)

**Recommendation prompt:** Suggest GitHub Actions, GitLab CI, or Vercel/Netlify auto-deploy.

---

#### Q4.4: Code quality tools?

**Options:**
- [ ] Linting (ESLint, Pylint, etc.)
- [ ] Formatting (Prettier, Black, etc.)
- [ ] Type checking (TypeScript, mypy, etc.)
- [ ] All of the above
- [ ] None needed
- [ ] Not sure (recommend)

**Default recommendation:** Always suggest linting + formatting + type checking.

---

#### Q4.5: Documentation preferences?

**Options:**
- [ ] Inline code comments
- [ ] README with setup instructions
- [ ] API documentation (OpenAPI/Swagger)
- [ ] Architecture diagrams
- [ ] All of the above
- [ ] Minimal documentation

---

### Section 5: Deployment & Infrastructure

#### Q5.1: Hosting preference?

**Options:**
- [ ] Vercel
- [ ] Netlify
- [ ] AWS
- [ ] Google Cloud Platform
- [ ] Azure
- [ ] DigitalOcean
- [ ] Cloudflare
- [ ] Railway
- [ ] Render
- [ ] Self-hosted
- [ ] No preference (recommend)
- [ ] Other: ___________

---

#### Q5.2: Containerization?

**Options:**
- [ ] Yes - Docker
- [ ] Yes - Docker + Kubernetes
- [ ] No containerization needed
- [ ] Not sure (recommend)

---

#### Q5.3: Environment management?

**Options:**
- [ ] Multiple environments (dev, staging, prod)
- [ ] Two environments (dev, prod)
- [ ] Single environment
- [ ] Not sure (recommend)

---

### Section 6: Team & Workflow

#### Q6.1: Team size?

**Options:**
- [ ] Solo developer
- [ ] 2-3 developers
- [ ] 4-10 developers
- [ ] 10+ developers

---

#### Q6.2: Git workflow preference?

**Options:**
- [ ] Trunk-based development
- [ ] Feature branches + PR
- [ ] Git Flow
- [ ] GitHub Flow
- [ ] No preference (recommend)

**Default recommendation:** Feature branches + PR for teams, trunk-based for solo.

---

#### Q6.3: Code review requirements?

**Options:**
- [ ] All code must be reviewed
- [ ] Critical code only
- [ ] No formal reviews (solo project)
- [ ] Not sure (recommend)

---

## Analysis & Recommendations

After collecting responses, Maestro Mode will:

### 1. Recommend Tech Stack

Based on project type, scale, and preferences, suggest:
- Programming language(s)
- Frontend framework (if applicable)
- Backend framework (if applicable)
- Database and ORM
- Testing tools
- Build tools and bundler
- Deployment platform

### 2. Activate Specialized Agents

Select from the pool based on tech stack:
- Language specialists
- Framework specialists
- Database specialists
- Testing specialists
- Infrastructure specialists

### 3. Suggest MCP Servers

Recommend MCP servers for:
- Database access
- Testing frameworks
- Cloud providers
- API integrations

### 4. Generate RULEBOOK.md

Create comprehensive RULEBOOK with:
- Project structure
- Naming conventions
- Code style guidelines
- Testing requirements
- Git workflow
- Deployment process
- Security best practices

### 5. Create Initial Structure

Generate starter files:
```
project/
├── .claude/
│   ├── RULEBOOK.md
│   └── agents-global/ (copied)
├── src/
│   ├── (framework-specific structure)
├── tests/
├── .gitignore
├── README.md
├── package.json (or equivalent)
└── (other config files)
```

## Example: Web Application Scenario

### User Responses:
- **Q1.1:** Web Application
- **Q1.3:** Medium scale (1K-100K users)
- **Q2.1:** TypeScript
- **Q2.4:** Next.js
- **Q2.5:** PostgreSQL
- **Q2.6:** Prisma
- **Q3.1:** Email/password + OAuth
- **Q4.1:** All testing types
- **Q5.1:** Vercel

### Maestro Mode Recommendations:

**Tech Stack:**
```
Language: TypeScript
Framework: Next.js 15 (App Router)
Database: PostgreSQL
ORM: Prisma
Auth: Auth.js (next-auth)
Styling: Tailwind CSS
Testing: Vitest (unit) + Playwright (E2E)
Deployment: Vercel
```

**Activated Agents:**
```
Core: [All 10 core agents]
Specialized:
  - nextjs-specialist
  - react-specialist
  - typescript-pro
  - prisma-specialist
  - postgres-expert
  - tailwind-expert
  - rest-api-architect
  - vitest-expert
  - playwright-specialist
  - vercel-expert
```

**MCP Servers:**
```
- @modelcontextprotocol/server-postgres (database access)
- @modelcontextprotocol/server-playwright (E2E testing)
```

**Generated RULEBOOK.md Sections:**
- Feature-based architecture
- TypeScript strict mode
- Prisma schema patterns
- Next.js App Router conventions
- Testing coverage requirements (80%)
- Git workflow (feature branches + PR)
- Environment variables management
- Deployment process

**Initial Structure:**
```
project/
├── .claude/
│   ├── RULEBOOK.md
│   └── agents-global/
├── src/
│   ├── app/
│   │   ├── (auth)/
│   │   ├── api/
│   │   └── page.tsx
│   ├── components/
│   ├── lib/
│   └── types/
├── prisma/
│   └── schema.prisma
├── tests/
│   ├── unit/
│   └── e2e/
├── .env.example
├── .gitignore
├── next.config.js
├── tailwind.config.ts
├── tsconfig.json
├── package.json
├── README.md
└── playwright.config.ts
```

## Interactive Workflow

```
User: "I'm starting a new project"

Maestro Mode:
"I've detected an empty project. Let me help you set it up properly.
I'll ask you a series of questions to recommend the best tech stack,
agents, and best practices.

This will take about 5 minutes. Ready to begin?"

User: "Yes"

Maestro Mode:
"Great! Let's start with project overview...

Q1: What type of project are you building?
1. Web Application
2. API Service
3. Frontend Application
...
"

[User answers questions]

Maestro Mode:
"Thank you! Based on your responses, here's what I recommend:

**Tech Stack:**
- Next.js 15 + TypeScript
- PostgreSQL + Prisma
- Tailwind CSS
- Vitest + Playwright

**Activated Agents:**
- Core: All 10 core agents
- Specialized: nextjs-specialist, react-specialist, typescript-pro,
  prisma-specialist, postgres-expert, tailwind-expert, vitest-expert,
  playwright-specialist, vercel-expert

**MCP Servers:**
- @modelcontextprotocol/server-postgres
- @modelcontextprotocol/server-playwright

**Next Steps:**
1. Generate RULEBOOK.md with project patterns
2. Create initial project structure
3. Set up package.json with dependencies
4. Initialize Git repository
5. Create environment templates

Shall I proceed with this setup?"

User: "Yes, go ahead"

Maestro Mode:
"Perfect! I'm now delegating to the specialized agents:
- project-analyzer: Creating project structure
- nextjs-specialist: Setting up Next.js configuration
- prisma-specialist: Initializing database schema
- documentation-engineer: Generating RULEBOOK.md

[Creates all files and structure]

Done! Your project is ready. Here's what I created:
- ✅ RULEBOOK.md with best practices
- ✅ Next.js project structure
- ✅ Prisma schema template
- ✅ Testing configuration
- ✅ Git initialized
- ✅ Environment templates

Next, run:
  npm install
  npx prisma migrate dev

Then start coding! I'm here to help."
```

## Summary

This questionnaire enables:
- **Intelligent tech stack recommendations**
- **Automatic agent activation**
- **MCP server suggestions**
- **RULEBOOK generation**
- **Complete project scaffolding**
- **Best practices from day one**

The goal: **Get developers productive in minutes, not hours.**
