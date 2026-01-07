# RULEBOOK - Next.js SaaS Application

## Project Overview

**Name:** Next.js SaaS Starter
**Type:** Full-Stack SaaS Application
**Description:** Modern SaaS application with authentication, payments, and multi-tenancy

**Key Features:**
- User authentication & authorization
- Subscription billing (Stripe)
- Multi-tenant architecture
- Admin dashboard
- API routes with tRPC
- Database with Prisma ORM
- Email notifications
- File uploads (S3)

---

## Tech Stack

### Frontend
- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript 5.5+
- **Styling:** Tailwind CSS 4.0
- **UI Components:** shadcn/ui
- **State Management:** Zustand
- **Forms:** React Hook Form + Zod validation
- **Data Fetching:** tRPC + React Query

### Backend
- **API:** tRPC (type-safe API layer)
- **Database:** PostgreSQL 16
- **ORM:** Prisma 5.x
- **Authentication:** NextAuth.js v5 (Auth.js)
- **File Storage:** AWS S3 or Cloudflare R2
- **Email:** Resend or SendGrid
- **Payments:** Stripe (subscriptions + one-time)

### Infrastructure
- **Hosting:** Vercel (recommended) or AWS
- **Database Hosting:** Neon, Supabase, or Railway
- **CDN:** Vercel Edge Network or Cloudflare
- **Monitoring:** Sentry + Vercel Analytics
- **CI/CD:** GitHub Actions + Vercel

### Testing
- **Unit/Integration:** Vitest
- **E2E:** Playwright
- **Component Testing:** Testing Library
- **API Testing:** tRPC testing utilities

---

## Folder Structure

```
src/
├── app/                    # Next.js 15 App Router
│   ├── (auth)/            # Auth routes (login, signup)
│   ├── (dashboard)/       # Protected dashboard routes
│   ├── (marketing)/       # Public marketing pages
│   ├── api/               # API routes & webhooks
│   ├── layout.tsx         # Root layout
│   └── page.tsx           # Homepage
├── components/
│   ├── ui/                # shadcn/ui components
│   ├── auth/              # Auth-related components
│   ├── dashboard/         # Dashboard components
│   └── shared/            # Reusable components
├── lib/
│   ├── db.ts              # Prisma client
│   ├── auth.ts            # NextAuth configuration
│   ├── stripe.ts          # Stripe client
│   ├── s3.ts              # S3 client
│   └── utils.ts           # Utility functions
├── server/
│   ├── api/
│   │   ├── routers/       # tRPC routers
│   │   ├── trpc.ts        # tRPC setup
│   │   └── root.ts        # Root router
│   └── services/          # Business logic
├── stores/                # Zustand stores
├── hooks/                 # Custom React hooks
├── types/                 # TypeScript types
└── styles/                # Global styles

prisma/
├── schema.prisma          # Database schema
├── migrations/            # Prisma migrations
└── seed.ts                # Database seed data

tests/
├── unit/                  # Unit tests
├── integration/           # Integration tests
└── e2e/                   # End-to-end tests
```

---

## Code Organization

### File Naming
- **Components:** PascalCase (`UserProfile.tsx`)
- **Utilities:** camelCase (`formatCurrency.ts`)
- **API Routes:** kebab-case (`user-settings.ts`)
- **Types:** PascalCase with `.types.ts` suffix

### Import Order
1. React & Next.js imports
2. Third-party libraries
3. Internal components
4. Internal utilities
5. Types
6. Styles

Example:
```typescript
import { useState } from 'react'
import { useSession } from 'next-auth/react'

import { Button } from '@/components/ui/button'
import { trpc } from '@/lib/trpc'

import { formatCurrency } from '@/lib/utils'
import type { User } from '@/types/user.types'

import styles from './UserProfile.module.css'
```

### Component Structure
```typescript
// 1. Imports
import { useState } from 'react'

// 2. Types
interface UserProfileProps {
  userId: string
}

// 3. Component
export function UserProfile({ userId }: UserProfileProps) {
  // Hooks first
  const [isLoading, setIsLoading] = useState(false)
  const { data } = trpc.user.getById.useQuery({ id: userId })

  // Event handlers
  const handleUpdate = async () => {}

  // Early returns
  if (!data) return <div>Loading...</div>

  // Main render
  return <div>{/* JSX */}</div>
}
```

---

## State Management

### Zustand Stores
```typescript
// stores/userStore.ts
import { create } from 'zustand'

interface UserState {
  user: User | null
  setUser: (user: User) => void
  clearUser: () => void
}

export const useUserStore = create<UserState>((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  clearUser: () => set({ user: null })
}))
```

**Store Types:**
- `authStore` - Authentication state
- `uiStore` - UI state (modals, toasts)
- `subscriptionStore` - Subscription/billing state

---

## API Architecture

### tRPC Router Structure
```typescript
// server/api/routers/user.ts
import { z } from 'zod'
import { createTRPCRouter, protectedProcedure } from '../trpc'

export const userRouter = createTRPCRouter({
  getById: protectedProcedure
    .input(z.object({ id: z.string() }))
    .query(async ({ ctx, input }) => {
      return ctx.db.user.findUnique({
        where: { id: input.id }
      })
    }),

  update: protectedProcedure
    .input(z.object({
      id: z.string(),
      name: z.string().optional()
    }))
    .mutation(async ({ ctx, input }) => {
      return ctx.db.user.update({
        where: { id: input.id },
        data: { name: input.name }
      })
    })
})
```

---

## Database Schema (Prisma)

### Key Models
```prisma
model User {
  id            String    @id @default(cuid())
  email         String    @unique
  name          String?
  image         String?
  createdAt     DateTime  @default(now())
  updatedAt     DateTime  @updatedAt

  accounts      Account[]
  sessions      Session[]
  subscription  Subscription?

  @@map("users")
}

model Subscription {
  id                String   @id @default(cuid())
  userId            String   @unique
  stripeCustomerId  String   @unique
  stripePriceId     String
  stripeCurrentPeriodEnd DateTime
  status            String

  user              User     @relation(fields: [userId], references: [id])

  @@map("subscriptions")
}
```

---

## Authentication

### NextAuth.js Configuration
- **Providers:** Email (magic link), Google, GitHub
- **Session Strategy:** JWT
- **Callbacks:** Custom session data
- **Protection:** Middleware for protected routes

### Protected Routes
```typescript
// middleware.ts
export { default } from 'next-auth/middleware'

export const config = {
  matcher: ['/dashboard/:path*', '/api/trpc/:path*']
}
```

---

## Payments (Stripe)

### Subscription Flow
1. User selects plan
2. Create Stripe Checkout Session
3. Redirect to Stripe
4. Handle webhook on successful payment
5. Create/update subscription in database
6. Grant access to features

### Webhook Handling
```typescript
// app/api/webhooks/stripe/route.ts
import { headers } from 'next/headers'
import { stripe } from '@/lib/stripe'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = headers().get('stripe-signature')!

  const event = stripe.webhooks.constructEvent(body, sig, process.env.STRIPE_WEBHOOK_SECRET!)

  switch (event.type) {
    case 'checkout.session.completed':
      // Handle successful checkout
      break
    case 'customer.subscription.updated':
      // Handle subscription update
      break
    // ...
  }

  return new Response(null, { status: 200 })
}
```

---

## Testing

### Testing Strategy
- **Unit Tests:** All utility functions, business logic
- **Integration Tests:** API routes, database queries
- **E2E Tests:** Critical user flows (signup, checkout)
- **Component Tests:** Interactive components

### Coverage Requirements
- **Minimum:** 70% overall
- **Critical Paths:** 90% (auth, payments)

### Example Test
```typescript
// tests/unit/utils/formatCurrency.test.ts
import { describe, it, expect } from 'vitest'
import { formatCurrency } from '@/lib/utils'

describe('formatCurrency', () => {
  it('formats USD correctly', () => {
    expect(formatCurrency(1000, 'USD')).toBe('$10.00')
  })
})
```

---

## Environment Variables

```bash
# Database
DATABASE_URL="postgresql://..."

# NextAuth
NEXTAUTH_URL="http://localhost:3000"
NEXTAUTH_SECRET="your-secret-here"

# OAuth Providers
GOOGLE_CLIENT_ID=""
GOOGLE_CLIENT_SECRET=""
GITHUB_CLIENT_ID=""
GITHUB_CLIENT_SECRET=""

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""

# Email
RESEND_API_KEY=""

# S3 / R2
S3_ACCESS_KEY_ID=""
S3_SECRET_ACCESS_KEY=""
S3_BUCKET_NAME=""
S3_REGION=""
```

---

## Security

### Critical Security Measures
1. ✅ **CSRF Protection:** NextAuth.js handles this
2. ✅ **SQL Injection:** Prisma prevents this
3. ✅ **XSS:** React escapes by default
4. ✅ **Rate Limiting:** Implement on API routes
5. ✅ **Input Validation:** Zod schemas everywhere
6. ✅ **Secrets Management:** Environment variables only
7. ✅ **Webhook Verification:** Verify Stripe signatures

### OWASP Top 10 Compliance
- Follow OWASP guidelines for web application security
- Regular dependency updates with `npm audit`
- No sensitive data in client-side code
- HTTPS only in production

---

## Performance

### Performance Targets
- **First Contentful Paint (FCP):** < 1.5s
- **Largest Contentful Paint (LCP):** < 2.5s
- **Time to Interactive (TTI):** < 3.5s
- **Cumulative Layout Shift (CLS):** < 0.1

### Optimization Strategies
1. ✅ **Image Optimization:** Next.js Image component
2. ✅ **Code Splitting:** Automatic with Next.js App Router
3. ✅ **React Server Components:** Default in App Router
4. ✅ **Database Query Optimization:** Prisma includes
5. ✅ **Caching:** tRPC + React Query
6. ✅ **CDN:** Static assets via Vercel Edge

---

## Accessibility

- **WCAG 2.1 AA Compliance:** Minimum standard
- **Keyboard Navigation:** All interactive elements
- **Screen Reader Support:** Semantic HTML + ARIA
- **Color Contrast:** 4.5:1 for normal text

---

## MCP Servers

### Mandatory: context7 (Latest Documentation)

**⚠️ CRITICAL:** The context7 MCP server is MANDATORY for this project. Claude's training data is from January 2025, and we're now in January 2026. context7 fetches the latest documentation to ensure code uses current syntax and patterns.

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

**Why context7 is mandatory for this stack:**
- ✅ Next.js 15 App Router (frequent changes)
- ✅ React 19 Server Components (new APIs)
- ✅ TypeScript 5.5+ (latest features)
- ✅ Tailwind CSS 4.0 (new utilities)
- ✅ Prisma 5.x (API updates)
- ✅ tRPC latest (breaking changes)

---

## Active Agents

### Core Agents (Always Active)
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

### Stack-Specific Agents
- nextjs-specialist
- react-specialist
- typescript-pro
- tailwind-expert
- prisma-specialist
- postgres-expert
- rest-api-architect
- vitest-specialist
- playwright-e2e-specialist
- ui-accessibility
- vercel-deployment-specialist

**Total Active Agents:** 21

---

## Deployment

### Vercel Deployment
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy
vercel

# Production
vercel --prod
```

### Environment Variables
- Set in Vercel dashboard under Project Settings → Environment Variables
- Separate variables for Preview and Production

---

## Monitoring & Analytics

### Vercel Analytics
- Page views & visitors
- Web Vitals tracking

### Sentry
- Error tracking
- Performance monitoring
- User feedback

### Stripe Dashboard
- Subscription metrics
- Failed payments
- MRR tracking

---

## Documentation Standards

### Code Comments
- **When:** Complex logic, non-obvious solutions
- **What:** Explain "why", not "what"
- **Format:** TSDoc for functions

### README Requirements
- Project setup instructions
- Environment variable documentation
- Development workflow
- Deployment guide

---

## Git Workflow

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development branch
- `feature/*` - Feature branches
- `hotfix/*` - Emergency fixes

### Commit Messages
```
feat: add subscription management page
fix: resolve payment webhook timeout
docs: update environment variables guide
chore: upgrade dependencies
```

---

## Notes

- This RULEBOOK is designed for Next.js SaaS applications
- All agents will follow these patterns strictly
- Update this document as the project evolves
- Use context7 to fetch latest framework documentation before coding

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-07
**Maintained By:** Claude Code Agents Toolkit
