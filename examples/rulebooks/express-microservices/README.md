# Express Microservices Example

Real-world microservices architecture handling 50,000+ orders/day.

## Project Context

- **Scale:** 50,000+ orders/day, 1,000 req/sec peak
- **Services:** 5 microservices (Order, Inventory, Payment, Notification, User)
- **Team:** 12 developers, 2-3 per service
- **Uptime:** 99.9% SLA

## Architecture Highlights

- **Saga Pattern** for distributed transactions
- **Circuit Breaker** for fault tolerance
- **Service Discovery** with Consul
- **Message Queue** (RabbitMQ) for async communication
- **API Gateway** (Kong) for routing & rate limiting
- **Distributed Tracing** (Jaeger)
- **Kubernetes** deployment

## Key Decisions

1. **RabbitMQ vs Kafka:** RabbitMQ (lower latency, simpler)
2. **Saga vs 2PC:** Saga (better availability)
3. **Service-per-Database:** True independence

## Use This Example When

✅ Building microservices architecture
✅ Need distributed transaction patterns
✅ Require fault tolerance (circuit breakers)
✅ Want service discovery implementation
✅ Need Kubernetes deployment examples

---

**Based on:** Real e-commerce microservices platform
**Last Updated:** 2026-01-07
