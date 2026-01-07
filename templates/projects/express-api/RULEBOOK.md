# RULEBOOK - Express REST API

## Project Overview

**Name:** Express REST API
**Type:** Backend API Service
**Description:** Production-ready REST API with authentication, validation, and comprehensive documentation

**Key Features:**
- RESTful API design
- JWT authentication
- Input validation & sanitization
- Rate limiting & security
- Comprehensive API documentation (Swagger)
- Database integration (MongoDB)
- Error handling & logging
- File upload support

---

## Tech Stack

### Backend
- **Framework:** Express.js 5.x
- **Language:** TypeScript 5.5+
- **Database:** MongoDB 7.x
- **ODM:** Mongoose 8.x
- **Authentication:** JWT (jsonwebtoken + bcrypt)
- **Validation:** Joi or Zod
- **Documentation:** Swagger/OpenAPI 3.0
- **Testing:** Jest + Supertest

### Infrastructure
- **Hosting:** AWS (EC2, ECS) or Render
- **Database Hosting:** MongoDB Atlas
- **File Storage:** AWS S3
- **Caching:** Redis
- **Monitoring:** Winston + Sentry
- **CI/CD:** GitHub Actions

---

## Folder Structure

```
src/
├── config/
│   ├── database.ts        # MongoDB connection
│   ├── redis.ts           # Redis client
│   └── swagger.ts         # Swagger configuration
├── controllers/           # Route handlers
│   ├── auth.controller.ts
│   ├── user.controller.ts
│   └── product.controller.ts
├── middleware/
│   ├── auth.middleware.ts
│   ├── validate.middleware.ts
│   ├── error.middleware.ts
│   └── rateLimit.middleware.ts
├── models/                # Mongoose models
│   ├── User.model.ts
│   └── Product.model.ts
├── routes/                # Express routes
│   ├── auth.routes.ts
│   ├── user.routes.ts
│   └── index.ts
├── services/              # Business logic
│   ├── auth.service.ts
│   └── email.service.ts
├── utils/
│   ├── logger.ts
│   ├── errors.ts
│   └── helpers.ts
├── validators/            # Request validators
│   └── user.validator.ts
├── types/                 # TypeScript types
├── app.ts                 # Express app setup
└── server.ts              # Server entry point

tests/
├── unit/                  # Unit tests
├── integration/           # API integration tests
└── fixtures/              # Test data
```

---

## API Architecture

### REST Principles
- **Resources:** Nouns (e.g., `/users`, `/products`)
- **HTTP Methods:** GET, POST, PUT, PATCH, DELETE
- **Status Codes:** 2xx success, 4xx client errors, 5xx server errors
- **Versioning:** `/api/v1/` prefix

### Route Structure
```typescript
// routes/user.routes.ts
import { Router } from 'express'
import { authenticate } from '@/middleware/auth.middleware'
import { validate } from '@/middleware/validate.middleware'
import { userController } from '@/controllers/user.controller'
import { userValidator } from '@/validators/user.validator'

const router = Router()

router.get(
  '/users',
  authenticate,
  userController.getAll
)

router.post(
  '/users',
  authenticate,
  validate(userValidator.create),
  userController.create
)

router.put(
  '/users/:id',
  authenticate,
  validate(userValidator.update),
  userController.update
)

export default router
```

### Controller Pattern
```typescript
// controllers/user.controller.ts
import { Request, Response, NextFunction } from 'express'
import { userService } from '@/services/user.service'
import { AppError } from '@/utils/errors'

export const userController = {
  getAll: async (req: Request, res: Response, next: NextFunction) => {
    try {
      const users = await userService.getAllUsers()
      res.json({ success: true, data: users })
    } catch (error) {
      next(error)
    }
  },

  create: async (req: Request, res: Response, next: NextFunction) => {
    try {
      const user = await userService.createUser(req.body)
      res.status(201).json({ success: true, data: user })
    } catch (error) {
      next(error)
    }
  }
}
```

---

## Authentication

### JWT Setup
```typescript
// middleware/auth.middleware.ts
import jwt from 'jsonwebtoken'
import { Request, Response, NextFunction } from 'express'
import { AppError } from '@/utils/errors'

interface JWTPayload {
  userId: string
  role: string
}

export const authenticate = (req: Request, res: Response, next: NextFunction) => {
  const token = req.headers.authorization?.split(' ')[1]

  if (!token) {
    throw new AppError('Unauthorized', 401)
  }

  try {
    const payload = jwt.verify(token, process.env.JWT_SECRET!) as JWTPayload
    req.user = payload
    next()
  } catch (error) {
    throw new AppError('Invalid token', 401)
  }
}
```

### Password Hashing
```typescript
// services/auth.service.ts
import bcrypt from 'bcrypt'
import jwt from 'jsonwebtoken'

export const authService = {
  async hashPassword(password: string): Promise<string> {
    return bcrypt.hash(password, 10)
  },

  async comparePassword(password: string, hash: string): Promise<boolean> {
    return bcrypt.compare(password, hash)
  },

  generateToken(userId: string, role: string): string {
    return jwt.sign(
      { userId, role },
      process.env.JWT_SECRET!,
      { expiresIn: '7d' }
    )
  }
}
```

---

## Validation

### Zod Schemas
```typescript
// validators/user.validator.ts
import { z } from 'zod'

export const userValidator = {
  create: z.object({
    body: z.object({
      email: z.string().email(),
      password: z.string().min(8),
      name: z.string().min(2).max(50)
    })
  }),

  update: z.object({
    body: z.object({
      name: z.string().min(2).max(50).optional(),
      bio: z.string().max(500).optional()
    }),
    params: z.object({
      id: z.string().regex(/^[0-9a-fA-F]{24}$/) // MongoDB ObjectId
    })
  })
}
```

### Validation Middleware
```typescript
// middleware/validate.middleware.ts
import { Request, Response, NextFunction } from 'express'
import { ZodSchema } from 'zod'
import { AppError } from '@/utils/errors'

export const validate = (schema: ZodSchema) => {
  return (req: Request, res: Response, next: NextFunction) => {
    try {
      schema.parse({
        body: req.body,
        params: req.params,
        query: req.query
      })
      next()
    } catch (error) {
      throw new AppError('Validation failed', 400, error)
    }
  }
}
```

---

## Database (MongoDB + Mongoose)

### Model Definition
```typescript
// models/User.model.ts
import mongoose, { Document, Schema } from 'mongoose'

export interface IUser extends Document {
  email: string
  password: string
  name: string
  role: 'user' | 'admin'
  createdAt: Date
  updatedAt: Date
}

const userSchema = new Schema<IUser>(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true
    },
    password: {
      type: String,
      required: true,
      select: false // Don't include in queries by default
    },
    name: {
      type: String,
      required: true,
      trim: true
    },
    role: {
      type: String,
      enum: ['user', 'admin'],
      default: 'user'
    }
  },
  {
    timestamps: true
  }
)

// Indexes
userSchema.index({ email: 1 })

export const User = mongoose.model<IUser>('User', userSchema)
```

---

## Error Handling

### Custom Error Class
```typescript
// utils/errors.ts
export class AppError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public details?: any
  ) {
    super(message)
    this.name = 'AppError'
  }
}
```

### Error Middleware
```typescript
// middleware/error.middleware.ts
import { Request, Response, NextFunction } from 'express'
import { AppError } from '@/utils/errors'
import { logger } from '@/utils/logger'

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  logger.error(err)

  if (err instanceof AppError) {
    return res.status(err.statusCode).json({
      success: false,
      message: err.message,
      details: err.details
    })
  }

  // Mongoose validation error
  if (err.name === 'ValidationError') {
    return res.status(400).json({
      success: false,
      message: 'Validation error',
      details: err.message
    })
  }

  // Default error
  res.status(500).json({
    success: false,
    message: 'Internal server error'
  })
}
```

---

## Security

### Helmet & CORS
```typescript
// app.ts
import express from 'express'
import helmet from 'helmet'
import cors from 'cors'
import rateLimit from 'express-rate-limit'

const app = express()

// Security headers
app.use(helmet())

// CORS
app.use(cors({
  origin: process.env.ALLOWED_ORIGINS?.split(','),
  credentials: true
}))

// Rate limiting
const limiter = rateLimit({
  windowMs: 15 * 60 * 1000, // 15 minutes
  max: 100 // limit each IP to 100 requests per windowMs
})
app.use('/api', limiter)

// Body parsing
app.use(express.json({ limit: '10mb' }))
app.use(express.urlencoded({ extended: true }))
```

### Input Sanitization
```typescript
import mongoSanitize from 'express-mongo-sanitize'
import xss from 'xss-clean'

// Prevent NoSQL injection
app.use(mongoSanitize())

// Prevent XSS
app.use(xss())
```

---

## Logging

### Winston Configuration
```typescript
// utils/logger.ts
import winston from 'winston'

export const logger = winston.createLogger({
  level: process.env.LOG_LEVEL || 'info',
  format: winston.format.combine(
    winston.format.timestamp(),
    winston.format.errors({ stack: true }),
    winston.format.json()
  ),
  transports: [
    new winston.transports.File({ filename: 'error.log', level: 'error' }),
    new winston.transports.File({ filename: 'combined.log' }),
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.simple()
      )
    })
  ]
})
```

---

## API Documentation (Swagger)

### Swagger Setup
```typescript
// config/swagger.ts
import swaggerJsdoc from 'swagger-jsdoc'

const options = {
  definition: {
    openapi: '3.0.0',
    info: {
      title: 'Express API',
      version: '1.0.0',
      description: 'REST API documentation'
    },
    servers: [
      {
        url: 'http://localhost:3000/api/v1',
        description: 'Development server'
      }
    ],
    components: {
      securitySchemes: {
        bearerAuth: {
          type: 'http',
          scheme: 'bearer',
          bearerFormat: 'JWT'
        }
      }
    }
  },
  apis: ['./src/routes/*.ts']
}

export const swaggerSpec = swaggerJsdoc(options)
```

### Route Documentation
```typescript
/**
 * @swagger
 * /users:
 *   get:
 *     summary: Get all users
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     responses:
 *       200:
 *         description: List of users
 *       401:
 *         description: Unauthorized
 */
router.get('/users', authenticate, userController.getAll)
```

---

## Testing

### Integration Tests
```typescript
// tests/integration/user.test.ts
import request from 'supertest'
import app from '@/app'
import { User } from '@/models/User.model'

describe('User API', () => {
  let authToken: string

  beforeAll(async () => {
    // Login and get token
    const res = await request(app)
      .post('/api/v1/auth/login')
      .send({ email: 'test@example.com', password: 'password' })
    authToken = res.body.token
  })

  it('should get all users', async () => {
    const res = await request(app)
      .get('/api/v1/users')
      .set('Authorization', `Bearer ${authToken}`)

    expect(res.status).toBe(200)
    expect(res.body.success).toBe(true)
    expect(Array.isArray(res.body.data)).toBe(true)
  })
})
```

---

## Environment Variables

```bash
# Server
NODE_ENV="development"
PORT=3000

# Database
MONGODB_URI="mongodb://localhost:27017/myapp"

# Redis
REDIS_URL="redis://localhost:6379"

# JWT
JWT_SECRET="your-secret-key-here"
JWT_EXPIRES_IN="7d"

# CORS
ALLOWED_ORIGINS="http://localhost:3000,http://localhost:5173"

# AWS S3
AWS_ACCESS_KEY_ID=""
AWS_SECRET_ACCESS_KEY=""
AWS_REGION=""
AWS_BUCKET_NAME=""

# Email
EMAIL_SERVICE="sendgrid"
EMAIL_API_KEY=""
EMAIL_FROM="noreply@example.com"

# Monitoring
SENTRY_DSN=""
```

---

## MCP Servers

### Mandatory: context7

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

---

## Active Agents

### Core Agents (10)
- code-reviewer, refactoring-specialist, documentation-engineer
- test-strategist, architecture-advisor, security-auditor
- performance-optimizer, git-workflow-specialist, dependency-manager, project-analyzer

### Stack-Specific Agents (8)
- express-specialist
- typescript-pro
- mongodb-expert
- rest-api-architect
- jest-testing-specialist
- javascript-modernizer
- aws-cloud-specialist
- nginx-load-balancer-specialist

**Total Active Agents:** 18

---

## Deployment

### Docker
```dockerfile
FROM node:20-alpine
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY dist ./dist
EXPOSE 3000
CMD ["node", "dist/server.js"]
```

---

**Template Version:** 1.0.0
**Last Updated:** 2026-01-07
