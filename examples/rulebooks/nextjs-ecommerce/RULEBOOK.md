# RULEBOOK - E-Commerce Platform (Next.js)

## Project Overview

**Name:** ShopFast E-Commerce Platform
**Type:** Full-Stack E-Commerce Application
**Description:** Production e-commerce platform with product catalog, shopping cart, checkout, payments, and admin dashboard

**Business Context:**
- B2C e-commerce platform
- 10,000+ products across 50+ categories
- Expected traffic: 100,000+ monthly visitors
- Average order value: $75
- Payment processing via Stripe
- Multi-currency support (USD, EUR, GBP)

**Key Features:**
- Product catalog with advanced filtering
- Shopping cart with session persistence
- Secure checkout flow
- Stripe payment integration
- Order management & tracking
- Customer accounts & profiles
- Admin dashboard for inventory management
- Email notifications (order confirmations, shipping updates)
- Product reviews & ratings
- Wishlist functionality

---

## Tech Stack

### Frontend
- **Framework:** Next.js 15 (App Router with React Server Components)
- **Language:** TypeScript 5.5+ (strict mode)
- **Styling:** Tailwind CSS 4.0 + shadcn/ui components
- **State Management:**
  - Zustand for client state (cart, UI preferences)
  - React Query (TanStack Query) for server state
- **Forms:** React Hook Form + Zod validation
- **Images:** Next.js Image component with Cloudinary

### Backend
- **API:** tRPC for type-safe API layer
- **Database:** PostgreSQL 16 (managed by Neon)
- **ORM:** Prisma 5.x with connection pooling
- **Authentication:** NextAuth.js v5 (email, Google, GitHub)
- **Payments:** Stripe (checkout, webhooks, subscriptions)
- **File Storage:** Cloudinary for product images
- **Email:** Resend for transactional emails
- **Search:** Algolia for product search

### Infrastructure
- **Hosting:** Vercel (Edge Functions + ISR)
- **Database:** Neon (serverless Postgres)
- **CDN:** Cloudflare for static assets
- **Monitoring:** Sentry + Vercel Analytics
- **CI/CD:** GitHub Actions + Vercel

### Testing
- **Unit/Integration:** Vitest + Testing Library
- **E2E:** Playwright (critical flows: checkout, payment)
- **API Testing:** tRPC testing utilities
- **Load Testing:** k6 (checkout flow)

---

## Folder Structure

```
src/
├── app/
│   ├── (auth)/
│   │   ├── login/
│   │   └── register/
│   ├── (shop)/
│   │   ├── products/
│   │   │   └── [slug]/
│   │   ├── category/
│   │   │   └── [name]/
│   │   ├── cart/
│   │   └── checkout/
│   ├── (account)/
│   │   ├── profile/
│   │   ├── orders/
│   │   └── wishlist/
│   ├── (admin)/
│   │   ├── dashboard/
│   │   ├── products/
│   │   └── orders/
│   └── api/
│       ├── trpc/
│       └── webhooks/
│           └── stripe/
├── components/
│   ├── ui/              # shadcn/ui components
│   ├── cart/            # Cart-related components
│   ├── product/         # Product display components
│   ├── checkout/        # Checkout flow components
│   └── admin/           # Admin dashboard components
├── server/
│   ├── api/
│   │   ├── routers/
│   │   │   ├── product.ts
│   │   │   ├── cart.ts
│   │   │   ├── order.ts
│   │   │   └── user.ts
│   │   └── trpc.ts
│   └── services/
│       ├── stripe.ts
│       ├── email.ts
│       └── algolia.ts
├── lib/
│   ├── db.ts            # Prisma client
│   ├── auth.ts          # NextAuth config
│   ├── stripe.ts        # Stripe client
│   └── utils.ts
├── stores/
│   ├── cart.ts          # Shopping cart store
│   └── ui.ts            # UI preferences
├── hooks/
│   ├── useCart.ts
│   └── useCheckout.ts
└── types/
    ├── product.ts
    ├── order.ts
    └── cart.ts

prisma/
├── schema.prisma
├── migrations/
└── seed.ts
```

---

## Database Schema

### Key Models

```prisma
model Product {
  id          String   @id @default(cuid())
  name        String
  slug        String   @unique
  description String   @db.Text
  price       Decimal  @db.Decimal(10, 2)
  compareAtPrice Decimal? @db.Decimal(10, 2)
  images      String[]
  category    Category @relation(fields: [categoryId], references: [id])
  categoryId  String
  inventory   Int      @default(0)
  sku         String   @unique
  isActive    Boolean  @default(true)
  createdAt   DateTime @default(now())
  updatedAt   DateTime @updatedAt

  orderItems  OrderItem[]
  reviews     Review[]

  @@index([categoryId])
  @@index([slug])
  @@map("products")
}

model Category {
  id        String    @id @default(cuid())
  name      String
  slug      String    @unique
  parentId  String?
  parent    Category? @relation("CategoryTree", fields: [parentId], references: [id])
  children  Category[] @relation("CategoryTree")
  products  Product[]

  @@map("categories")
}

model Order {
  id              String      @id @default(cuid())
  orderNumber     String      @unique
  userId          String
  user            User        @relation(fields: [userId], references: [id])
  status          OrderStatus @default(PENDING)
  total           Decimal     @db.Decimal(10, 2)
  subtotal        Decimal     @db.Decimal(10, 2)
  shipping        Decimal     @db.Decimal(10, 2)
  tax             Decimal     @db.Decimal(10, 2)

  // Stripe
  stripePaymentIntentId String?

  // Shipping
  shippingAddress Json

  items           OrderItem[]
  createdAt       DateTime    @default(now())
  updatedAt       DateTime    @updatedAt

  @@index([userId])
  @@index([orderNumber])
  @@map("orders")
}

model OrderItem {
  id        String  @id @default(cuid())
  orderId   String
  order     Order   @relation(fields: [orderId], references: [id])
  productId String
  product   Product @relation(fields: [productId], references: [id])
  quantity  Int
  price     Decimal @db.Decimal(10, 2)

  @@index([orderId])
  @@index([productId])
  @@map("order_items")
}

enum OrderStatus {
  PENDING
  PROCESSING
  SHIPPED
  DELIVERED
  CANCELLED
}
```

---

## Shopping Cart Implementation

### Cart Store (Zustand)

```typescript
// stores/cart.ts
import { create } from 'zustand'
import { persist } from 'zustand/middleware'

interface CartItem {
  productId: string
  name: string
  price: number
  quantity: number
  image: string
}

interface CartStore {
  items: CartItem[]
  addItem: (item: CartItem) => void
  removeItem: (productId: string) => void
  updateQuantity: (productId: string, quantity: number) => void
  clearCart: () => void
  total: () => number
}

export const useCartStore = create<CartStore>()(
  persist(
    (set, get) => ({
      items: [],

      addItem: (item) => set((state) => {
        const existing = state.items.find(i => i.productId === item.productId)
        if (existing) {
          return {
            items: state.items.map(i =>
              i.productId === item.productId
                ? { ...i, quantity: i.quantity + item.quantity }
                : i
            )
          }
        }
        return { items: [...state.items, item] }
      }),

      removeItem: (productId) => set((state) => ({
        items: state.items.filter(i => i.productId !== productId)
      })),

      updateQuantity: (productId, quantity) => set((state) => ({
        items: state.items.map(i =>
          i.productId === productId ? { ...i, quantity } : i
        )
      })),

      clearCart: () => set({ items: [] }),

      total: () => get().items.reduce((sum, item) => sum + (item.price * item.quantity), 0)
    }),
    {
      name: 'cart-storage'
    }
  )
)
```

---

## Checkout Flow

### Multi-Step Checkout Process

1. **Cart Review** → Verify items and quantities
2. **Shipping Information** → Collect address
3. **Payment** → Stripe checkout
4. **Confirmation** → Order placed

### Stripe Integration

```typescript
// server/api/routers/checkout.ts
import { z } from 'zod'
import { createTRPCRouter, protectedProcedure } from '../trpc'
import { stripe } from '@/lib/stripe'

export const checkoutRouter = createTRPCRouter({
  createPaymentIntent: protectedProcedure
    .input(z.object({
      items: z.array(z.object({
        productId: z.string(),
        quantity: z.number()
      }))
    }))
    .mutation(async ({ ctx, input }) => {
      // Calculate total
      const products = await ctx.db.product.findMany({
        where: { id: { in: input.items.map(i => i.productId) } }
      })

      const total = products.reduce((sum, product) => {
        const item = input.items.find(i => i.productId === product.id)!
        return sum + (Number(product.price) * item.quantity)
      }, 0)

      // Create Stripe payment intent
      const paymentIntent = await stripe.paymentIntents.create({
        amount: Math.round(total * 100), // Convert to cents
        currency: 'usd',
        metadata: {
          userId: ctx.session.user.id
        }
      })

      return {
        clientSecret: paymentIntent.client_secret
      }
    })
})
```

### Webhook Handling

```typescript
// app/api/webhooks/stripe/route.ts
import { headers } from 'next/headers'
import { stripe } from '@/lib/stripe'
import { db } from '@/lib/db'

export async function POST(req: Request) {
  const body = await req.text()
  const sig = headers().get('stripe-signature')!

  let event

  try {
    event = stripe.webhooks.constructEvent(
      body,
      sig,
      process.env.STRIPE_WEBHOOK_SECRET!
    )
  } catch (err) {
    return new Response('Webhook Error', { status: 400 })
  }

  switch (event.type) {
    case 'payment_intent.succeeded':
      const paymentIntent = event.data.object

      // Create order in database
      await db.order.create({
        data: {
          userId: paymentIntent.metadata.userId,
          status: 'PROCESSING',
          stripePaymentIntentId: paymentIntent.id,
          // ... order details
        }
      })

      // Send confirmation email
      // await sendOrderConfirmation(...)

      break

    // Handle other events
  }

  return new Response(null, { status: 200 })
}
```

---

## Product Search (Algolia)

### Index Configuration

```typescript
// server/services/algolia.ts
import algoliasearch from 'algoliasearch'

const client = algoliasearch(
  process.env.ALGOLIA_APP_ID!,
  process.env.ALGOLIA_ADMIN_KEY!
)

const productsIndex = client.initIndex('products')

// Configure searchable attributes
await productsIndex.setSettings({
  searchableAttributes: [
    'name',
    'description',
    'category',
    'sku'
  ],
  attributesForFaceting: [
    'category',
    'price',
    'inStock'
  ]
})

// Sync products to Algolia
export async function syncProductToAlgolia(product: Product) {
  await productsIndex.saveObject({
    objectID: product.id,
    name: product.name,
    description: product.description,
    price: Number(product.price),
    category: product.category.name,
    image: product.images[0],
    inStock: product.inventory > 0
  })
}
```

---

## Performance Optimization

### ISR (Incremental Static Regeneration)

```typescript
// app/(shop)/products/[slug]/page.tsx
export const revalidate = 3600 // Revalidate every hour

export async function generateStaticParams() {
  const products = await db.product.findMany({
    select: { slug: true },
    take: 100 // Pre-render top 100 products
  })

  return products.map(p => ({ slug: p.slug }))
}
```

### Image Optimization

```typescript
<Image
  src={product.images[0]}
  alt={product.name}
  width={800}
  height={800}
  priority={isAboveFold}
  loading={isAboveFold ? undefined : 'lazy'}
  placeholder="blur"
  blurDataURL={product.blurHash}
/>
```

### Database Query Optimization

```prisma
// Include relations efficiently
const products = await db.product.findMany({
  include: {
    category: {
      select: { name: true, slug: true }
    }
  },
  where: { isActive: true },
  take: 20,
  skip: page * 20
})
```

---

## Security Considerations

### Payment Security
- ✅ Never store card details (Stripe handles)
- ✅ Use Stripe Elements for PCI compliance
- ✅ Verify webhook signatures
- ✅ HTTPS only in production

### Data Protection
- ✅ User passwords hashed with bcrypt
- ✅ JWT tokens for session management
- ✅ Rate limiting on API endpoints
- ✅ Input validation with Zod

### Admin Access
```typescript
// middleware for admin routes
export async function requireAdmin(ctx: Context) {
  if (ctx.session?.user?.role !== 'ADMIN') {
    throw new TRPCError({ code: 'FORBIDDEN' })
  }
}
```

---

## Environment Variables

```bash
# Database
DATABASE_URL="postgresql://..."
DIRECT_URL="postgresql://..."

# NextAuth
NEXTAUTH_URL="https://shopfast.com"
NEXTAUTH_SECRET=""

# Stripe
NEXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=""
STRIPE_SECRET_KEY=""
STRIPE_WEBHOOK_SECRET=""

# Cloudinary
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=""
CLOUDINARY_API_KEY=""
CLOUDINARY_API_SECRET=""

# Algolia
NEXT_PUBLIC_ALGOLIA_APP_ID=""
NEXT_PUBLIC_ALGOLIA_SEARCH_KEY=""
ALGOLIA_ADMIN_KEY=""

# Email
RESEND_API_KEY=""
```

---

## Active Agents

### Core Agents (10)
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

### Stack-Specific Agents (14)
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
- microservices-architect (for potential future scaling)
- testing-library-specialist
- storybook-testing-specialist

**Total Active Agents:** 24

---

## Testing Strategy

### E2E Test Coverage (Critical Flows)

```typescript
// tests/e2e/checkout.spec.ts
test('complete checkout flow', async ({ page }) => {
  // Add product to cart
  await page.goto('/products/test-product')
  await page.click('[data-testid="add-to-cart"]')

  // Go to cart
  await page.goto('/cart')
  expect(await page.textContent('[data-testid="cart-total"]')).toContain('$29.99')

  // Proceed to checkout
  await page.click('[data-testid="checkout-button"]')

  // Fill shipping
  await page.fill('[name="address"]', '123 Main St')
  await page.fill('[name="city"]', 'New York')
  await page.fill('[name="zip"]', '10001')
  await page.click('[data-testid="continue-to-payment"]')

  // Mock Stripe payment (test mode)
  await page.fill('[name="cardNumber"]', '4242424242424242')
  await page.fill('[name="exp"]', '12/25')
  await page.fill('[name="cvc"]', '123')
  await page.click('[data-testid="submit-payment"]')

  // Verify order confirmation
  await expect(page).toHaveURL(/\/order\/success/)
  await expect(page.locator('[data-testid="order-number"]')).toBeVisible()
})
```

---

**Last Updated:** 2026-01-07
**Project Status:** Production
**Team Size:** 5 developers
