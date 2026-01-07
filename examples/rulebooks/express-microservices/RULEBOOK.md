# RULEBOOK - Microservices Architecture (Express)

## Project Overview

**Name:** OrderFlow Microservices Platform
**Type:** Microservices-Based E-Commerce Backend
**Description:** Distributed system handling orders, inventory, payments, and notifications for e-commerce platform

**Business Context:**
- Processes 50,000+ orders/day
- 99.9% uptime SLA
- Peak traffic: 1,000 req/sec (Black Friday)
- 5 microservices, 12 developers
- Multi-region deployment (US, EU)

**Services:**
1. **Order Service** - Order creation, tracking
2. **Inventory Service** - Stock management, reservations
3. **Payment Service** - Stripe integration, refunds
4. **Notification Service** - Emails, SMS, push notifications
5. **User Service** - Authentication, profiles

---

## Tech Stack

### Core
- **Framework:** Express.js 5 + TypeScript
- **API Gateway:** Kong
- **Message Queue:** RabbitMQ
- **Service Discovery:** Consul
- **Load Balancer:** NGINX

### Databases (Per Service)
- **Order Service:** PostgreSQL
- **Inventory Service:** PostgreSQL
- **Payment Service:** PostgreSQL + Redis (idempotency)
- **Notification Service:** MongoDB (logs)
- **User Service:** PostgreSQL + Redis (sessions)

### Infrastructure
- **Containers:** Docker
- **Orchestration:** Kubernetes (GKE)
- **Monitoring:** Prometheus + Grafana
- **Logging:** ELK Stack (Elasticsearch, Logstash, Kibana)
- **Tracing:** Jaeger (distributed tracing)

---

## Service Communication

### Synchronous (HTTP)
```typescript
// Order Service calls Inventory Service
const inventoryClient = axios.create({
  baseURL: process.env.INVENTORY_SERVICE_URL,
  timeout: 3000,
  headers: { 'X-Service': 'order-service' }
})

async function reserveInventory(productId: string, quantity: number) {
  try {
    const response = await inventoryClient.post('/reserve', {
      productId,
      quantity
    })
    return response.data
  } catch (error) {
    // Fallback or circuit breaker
    throw new ServiceUnavailableError('Inventory service down')
  }
}
```

### Asynchronous (Message Queue)
```typescript
// Publish event when order created
await rabbitmq.publish('orders.created', {
  orderId,
  userId,
  total,
  items
})

// Payment Service subscribes
rabbitmq.subscribe('orders.created', async (message) => {
  const { orderId, total } = message
  await processPayment(orderId, total)

  // Publish next event
  await rabbitmq.publish('payments.processed', { orderId })
})
```

---

## Saga Pattern (Distributed Transactions)

### Order Creation Saga

```typescript
// Order Service orchestrates the saga
async function createOrderSaga(orderData) {
  const saga = new Saga()

  try {
    // Step 1: Reserve inventory
    const inventoryReservation = await saga.step({
      action: () => inventoryService.reserve(orderData.items),
      compensate: (reservationId) => inventoryService.cancelReservation(reservationId)
    })

    // Step 2: Process payment
    const payment = await saga.step({
      action: () => paymentService.charge(orderData.total),
      compensate: (paymentId) => paymentService.refund(paymentId)
    })

    // Step 3: Create order
    const order = await saga.step({
      action: () => orderRepository.create(orderData),
      compensate: (orderId) => orderRepository.cancel(orderId)
    })

    // Step 4: Send notification
    await notificationService.sendOrderConfirmation(order.id)

    return order
  } catch (error) {
    // Run compensations in reverse order
    await saga.compensate()
    throw error
  }
}
```

**Why Saga?**
- No distributed transactions across services
- Each step can be rolled back
- Handles partial failures gracefully

---

## Circuit Breaker Pattern

```typescript
// lib/circuitBreaker.ts
import CircuitBreaker from 'opossum'

const options = {
  timeout: 3000, // 3s timeout
  errorThresholdPercentage: 50, // Open circuit if 50% fail
  resetTimeout: 30000 // Try again after 30s
}

export function createCircuitBreaker<T>(fn: (...args: any[]) => Promise<T>) {
  const breaker = new CircuitBreaker(fn, options)

  breaker.on('open', () => {
    logger.error('Circuit breaker opened')
    metrics.increment('circuit_breaker.open')
  })

  breaker.fallback(() => {
    throw new ServiceUnavailableError('Service temporarily unavailable')
  })

  return breaker
}

// Usage
const getInventory = createCircuitBreaker(
  async (productId: string) => {
    return await inventoryService.get(productId)
  }
)
```

---

## Service Discovery

```typescript
// lib/serviceDiscovery.ts
import Consul from 'consul'

const consul = new Consul()

// Register service on startup
export async function registerService() {
  await consul.agent.service.register({
    name: 'order-service',
    port: 3000,
    check: {
      http: 'http://localhost:3000/health',
      interval: '10s'
    }
  })
}

// Discover other services
export async function discoverService(serviceName: string): Promise<string> {
  const services = await consul.catalog.service.nodes(serviceName)
  const healthy = services.filter(s => s.ServicePort)

  // Load balance (round-robin)
  const service = healthy[Math.floor(Math.random() * healthy.length)]
  return `http://${service.ServiceAddress}:${service.ServicePort}`
}
```

---

## Distributed Tracing

```typescript
// middleware/tracing.ts
import { initTracer } from 'jaeger-client'

const tracer = initTracer({
  serviceName: 'order-service',
  sampler: { type: 'const', param: 1 }
}, {})

export function tracingMiddleware(req, res, next) {
  const span = tracer.startSpan(`${req.method} ${req.path}`)

  // Inject trace context for downstream services
  const headers = {}
  tracer.inject(span, FORMAT_HTTP_HEADERS, headers)
  req.traceHeaders = headers

  res.on('finish', () => {
    span.setTag('http.status_code', res.statusCode)
    span.finish()
  })

  next()
}
```

---

## API Gateway (Kong)

```yaml
# kong.yml
services:
  - name: order-service
    url: http://order-service:3000
    routes:
      - name: orders
        paths: [/api/orders]
    plugins:
      - name: rate-limiting
        config:
          minute: 100
      - name: jwt
      - name: cors

  - name: inventory-service
    url: http://inventory-service:3000
    routes:
      - name: inventory
        paths: [/api/inventory]
```

---

## Deployment (Kubernetes)

```yaml
# order-service deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: order-service
spec:
  replicas: 3
  selector:
    matchLabels:
      app: order-service
  template:
    metadata:
      labels:
        app: order-service
    spec:
      containers:
      - name: order-service
        image: orderflow/order-service:latest
        ports:
        - containerPort: 3000
        env:
        - name: DATABASE_URL
          valueFrom:
            secretKeyRef:
              name: order-service-secrets
              key: database-url
        - name: RABBITMQ_URL
          valueFrom:
            secretKeyRef:
              name: shared-secrets
              key: rabbitmq-url
        resources:
          requests:
            memory: "512Mi"
            cpu: "500m"
          limits:
            memory: "1Gi"
            cpu: "1000m"
        livenessProbe:
          httpGet:
            path: /health
            port: 3000
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 3000
          initialDelaySeconds: 5
          periodSeconds: 5
---
apiVersion: v1
kind: Service
metadata:
  name: order-service
spec:
  selector:
    app: order-service
  ports:
  - port: 3000
    targetPort: 3000
  type: ClusterIP
```

---

## Monitoring & Observability

### Prometheus Metrics

```typescript
// lib/metrics.ts
import { Registry, Counter, Histogram } from 'prom-client'

const register = new Registry()

export const httpRequestDuration = new Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  labelNames: ['method', 'route', 'status_code'],
  registers: [register]
})

export const ordersCreated = new Counter({
  name: 'orders_created_total',
  help: 'Total number of orders created',
  registers: [register]
})

// Expose metrics endpoint
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType)
  res.end(await register.metrics())
})
```

---

## Active Agents

### Core (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific (10)
- express-specialist
- typescript-pro
- postgres-expert
- mongodb-expert
- rest-api-architect
- microservices-architect
- docker-specialist
- kubernetes-expert
- jest-testing-specialist
- aws-cloud-specialist

**Total Active Agents:** 20

---

## Key Decisions

### 1. RabbitMQ vs Kafka
- **Chose:** RabbitMQ
- **Why:** Lower latency (< 10ms), simpler setup
- **Tradeoff:** Kafka better for event sourcing (didn't need)

### 2. Saga vs 2PC
- **Chose:** Saga pattern
- **Why:** No distributed lock manager, better availability
- **Tradeoff:** More complex rollback logic

### 3. Service-per-Database
- **Chose:** Each service owns its database
- **Why:** True independence, easier scaling
- **Tradeoff:** No JOIN queries across services

---

**Last Updated:** 2026-01-07
**Project Status:** Production (3 years)
**Team Size:** 12 developers (2-3 per service)
**Traffic:** 50,000+ orders/day, 1,000 req/sec peak
