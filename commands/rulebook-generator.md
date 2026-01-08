# RULEBOOK Generator - Maestro Mode

> **Purpose**: Guide for automatically generating project RULEBOOK by detecting tech stack.

**This file is read by Maestro on first interaction if `.claude/RULEBOOK.md` doesn't exist.**

---

## Hybrid Approach

The generator uses a **hybrid approach**:
1. **Scan** common configuration files
2. **Detect** tech stack automatically
3. **Ask** for missing information
4. **Generate** complete RULEBOOK

---

## Phase 1: Scan Project Files

Use **Read** and **Glob** tools to scan CURRENT DIRECTORY ONLY (not parent directories).

### Common Configuration Files

Search for these files to detect the stack:

#### JavaScript/TypeScript Ecosystem
```
package.json              → Dependencies (frameworks, libraries)
tsconfig.json             → TypeScript
next.config.js/ts/mjs     → Next.js
vite.config.js/ts         → Vite
nuxt.config.ts            → Nuxt
svelte.config.js          → SvelteKit
astro.config.mjs          → Astro
remix.config.js           → Remix
angular.json              → Angular
vue.config.js             → Vue CLI
.env, .env.local          → Environment variables
```

#### Python
```
pyproject.toml            → Python project metadata (PEP 518)
requirements.txt          → Pip dependencies
setup.py                  → Package info
Pipfile                   → Pipenv
poetry.lock               → Poetry
manage.py                 → Django
```

#### Ruby
```
Gemfile                   → Ruby dependencies (Bundler)
Gemfile.lock              → Locked versions
config/application.rb     → Rails application
Rakefile                  → Rake tasks
config.ru                 → Rack config
```

#### PHP
```
composer.json             → PHP dependencies
composer.lock             → Locked versions
artisan                   → Laravel CLI
wp-config.php             → WordPress
```

#### Go
```
go.mod                    → Go modules
go.sum                    → Dependency checksums
main.go                   → Entry point
```

#### Rust
```
Cargo.toml                → Rust dependencies
Cargo.lock                → Locked versions
```

#### Java
```
pom.xml                   → Maven
build.gradle              → Gradle
build.gradle.kts          → Kotlin DSL Gradle
```

#### .NET
```
*.csproj                  → C# project
*.fsproj                  → F# project
*.sln                     → Solution file
```

#### Docker
```
Dockerfile
docker-compose.yml
docker-compose.yaml
.dockerignore
```

#### Other
```
README.md                 → Project description (first 2-3 paragraphs after title)
.gitignore                → Infer tools being used
Makefile                  → Build commands
```

---

## Phase 2: Detect Tech Stack

### Detection Strategy

**Priority:**
1. **Specific config file** (e.g. `next.config.js` → Next.js confirmed)
2. **Dependencies file** (e.g. `package.json` → analyze dependencies)
3. **Directory structure** (e.g. `app/` + `components/` → possible Next.js App Router)
4. **Characteristic files** (e.g. `manage.py` → Django)

### JavaScript/TypeScript

**From `package.json` (dependencies/devDependencies):**

```javascript
// Frameworks
"next" → Next.js
"react" (without "next") → React
"vue" → Vue.js
"@angular/core" → Angular
"svelte" → Svelte
"astro" → Astro
"@remix-run/react" → Remix
"solid-js" → SolidJS

// Backend Frameworks
"express" → Express.js
"@nestjs/core" → NestJS
"fastify" → Fastify
"koa" → Koa
"hapi" → Hapi

// Databases & ORMs
"prisma" or "@prisma/client" → Prisma
"drizzle-orm" → Drizzle ORM
"typeorm" → TypeORM
"sequelize" → Sequelize
"mongoose" → MongoDB + Mongoose
"pg" or "postgres" → PostgreSQL
"mysql" or "mysql2" → MySQL
"mongodb" → MongoDB
"redis" or "ioredis" → Redis

// GraphQL
"graphql" + "apollo-server" → Apollo GraphQL Server
"@apollo/client" → Apollo Client
"graphql" + "type-graphql" → TypeGraphQL

// Styling
"tailwindcss" → Tailwind CSS
"styled-components" → Styled Components
"@emotion/react" → Emotion
"sass" or "node-sass" → Sass/SCSS

// Testing
"vitest" → Vitest
"jest" → Jest
"@playwright/test" → Playwright
"cypress" → Cypress
"@testing-library/react" → React Testing Library
"@testing-library/vue" → Vue Testing Library

// State Management
"zustand" → Zustand
"@reduxjs/toolkit" → Redux Toolkit
"jotai" → Jotai
"recoil" → Recoil
"mobx" → MobX

// Build Tools
"vite" → Vite
"webpack" → Webpack
"turbopack" → Turbopack
"esbuild" → esbuild
"rollup" → Rollup

// Language
tsconfig.json exists → TypeScript
Only .js files → JavaScript
```

### Python

**From `pyproject.toml` or `requirements.txt`:**

```python
# Frameworks
"fastapi" → FastAPI
"django" → Django
"flask" → Flask
"tornado" → Tornado
"sanic" → Sanic

# ORMs
"sqlalchemy" → SQLAlchemy
"django" (includes built-in ORM)
"peewee" → Peewee
"tortoise-orm" → Tortoise ORM

# Validation
"pydantic" → Pydantic

# Testing
"pytest" → Pytest
"unittest" (built-in)

# Async
"asyncio" (built-in)
"aiohttp" → aiohttp
```

### Ruby

**From `Gemfile`:**

```ruby
# Frameworks
"rails" → Ruby on Rails
"sinatra" → Sinatra
"hanami" → Hanami
"grape" → Grape (API)

# ORMs
"activerecord" → ActiveRecord (Rails)
"sequel" → Sequel
"rom" → Ruby Object Mapper

# Testing
"rspec" → RSpec
"minitest" → Minitest
```

### PHP

**From `composer.json`:**

```php
# Frameworks
"laravel/framework" → Laravel
"symfony/framework-bundle" → Symfony
"slim/slim" → Slim
"cakephp/cakephp" → CakePHP

# ORMs
"doctrine/orm" → Doctrine
"illuminate/database" → Eloquent (Laravel)

# Testing
"phpunit/phpunit" → PHPUnit
"pestphp/pest" → Pest
```

### Go

**From `go.mod`:**

```go
// Frameworks
"github.com/gin-gonic/gin" → Gin
"github.com/gofiber/fiber" → Fiber
"github.com/labstack/echo" → Echo
"net/http" (built-in) → Standard library

// ORMs
"gorm.io/gorm" → GORM
"github.com/jmoiron/sqlx" → sqlx
```

### Java

**From `pom.xml` or `build.gradle`:**

```java
// Frameworks
"spring-boot-starter" → Spring Boot
"quarkus" → Quarkus
"micronaut" → Micronaut

// ORMs
"hibernate" → Hibernate
"spring-data-jpa" → Spring Data JPA
```

### .NET

**From `*.csproj`:**

```csharp
// Frameworks
"Microsoft.AspNetCore" → ASP.NET Core
"Microsoft.EntityFrameworkCore" → Entity Framework Core
```

### Detect if NOTHING was found

If after scanning:
- No known configuration files were found
- No framework/language was detected

**Action:** Ask user for EVERYTHING (framework, language, database, testing, etc.)

---

## Phase 3: Show Detection Results

Display findings in this format:

```
═══════════════════════════════════════════════════════════
📂 PROJECT SCAN RESULTS
───────────────────────────────────────────────────────────
Files scanned: [number]
Helpful files: [number that contained useful info]

Detected configuration:
✓ Framework: [detected framework]
✓ Language: [detected language]
✓ Database/ORM: [detected database/orm]
✓ Styling: [detected styling]
✓ Testing: [detected testing]
✓ Build Tool: [detected build tool]
✓ State Management: [detected state management]

I'll use these as defaults in your RULEBOOK.
═══════════════════════════════════════════════════════════
```

If **NOTHING** or very little was detected:

```
═══════════════════════════════════════════════════════════
📂 PROJECT SCAN RESULTS
───────────────────────────────────────────────────────────
Files scanned: [number]
Detected: [list what little was found]

⚠️ Limited detection - I'll ask you questions to fill in the gaps.
═══════════════════════════════════════════════════════════
```

---

## Phase 4: Ask for Missing Details

Ask **ONLY** for information that wasn't detected.

### Question Rules

1. **ONE question at a time**
2. **WAIT** for user response after each question
3. **DO NOT batch** questions together
4. **DO NOT answer** questions yourself

### Common Questions (only if NOT detected)

**1. Framework/Language (if not detected):**
```
What framework/language are you using in this project?
Examples: Next.js, React, Vue, Ruby on Rails, Laravel, Django, FastAPI

Your answer:
```

**2. Test coverage:**
```
What's your target test coverage? (default: 80%)

Your answer:
```

**3. State management (only for frontend projects):**
```
What's your state management approach?
Options: Zustand, Redux Toolkit, Context API, Jotai, Recoil, Other

Your answer:
```

**4. Security:**
```
Any specific security requirements?
Examples: OWASP compliance, SOC2, PCI-DSS, HIPAA

Your answer (or press Enter to use OWASP Top 10 default):
```

**5. Performance:**
```
Performance targets?
Examples: Lighthouse > 90, LCP < 2.5s, FCP < 1.5s

Your answer (or press Enter to use default targets):
```

**6. Project description:**
```
Project description (if not found in README)?

Your answer (or press Enter to skip):
```

---

## Phase 5: Generate RULEBOOK.md

Using the **Write** tool, create `.claude/RULEBOOK.md` with the template corresponding to the detected stack.

### RULEBOOK Structure

```markdown
# RULEBOOK for [project-name]

*Last Updated: [current-date]*
*Generated by Maestro Mode - Claude Code Agents Toolkit*

## 📋 Project Overview

**Project Name:** [from directory name]
**Type:** [detected framework] application
**Primary Language:** [detected or asked]
**Description:** [from README or user input]

## 🛠️ Tech Stack

[Adapt based on detected stack - see specific sections below]

## 🤖 Active Agents

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

### Stack-Specific Agents (Auto-Selected)

[Auto-select based on detected stack]

## 📂 Project Structure

[Show actual detected structure]

## 📝 Code Organization

[Naming conventions according to language/framework]

## 🧪 Testing Strategy

[Based on detected testing framework]

## 🔒 Security Guidelines

[Based on specified requirements or OWASP Top 10]

## 🚀 Performance Targets

[Based on specified targets or defaults]

## 📚 Documentation Requirements

[Documentation standards]

## 🔄 State Management

[Only if applicable - frontend frameworks]

## 📦 Additional Notes

This RULEBOOK was generated automatically by scanning your project.
Feel free to customize it based on your specific needs.
```

### Stack-Specific Sections

#### For Next.js/React
```markdown
### Frontend
- **Framework:** Next.js [version]
- **Language:** TypeScript/JavaScript
- **Styling:** [detected]
- **State Management:** [detected or asked]
- **Build Tool:** [detected]

### Component Structure
[Next.js/React component pattern]
```

#### For Ruby on Rails
```markdown
### Backend
- **Framework:** Ruby on Rails [version]
- **Language:** Ruby [version]
- **Database:** [detected from database.yml]
- **ORM:** ActiveRecord

### File Structure
[Rails MVC pattern]
```

#### For Django/FastAPI
```markdown
### Backend
- **Framework:** Django/FastAPI
- **Language:** Python [version]
- **Database:** [detected]
- **ORM:** [Django ORM / SQLAlchemy]

### App Structure
[Django apps or FastAPI modules pattern]
```

#### For Laravel
```markdown
### Backend
- **Framework:** Laravel [version]
- **Language:** PHP [version]
- **Database:** [detected]
- **ORM:** Eloquent

### MVC Structure
[Laravel MVC pattern]
```

---

## Phase 6: Confirm, Save & Load

After writing the RULEBOOK, show:

```
═══════════════════════════════════════════════════════════
✓ RULEBOOK GENERATED
───────────────────────────────────────────────────────────
Created: .claude/RULEBOOK.md

Your project is now configured with:
• Tech stack: [list detected stack]
• Active agents: [count] agents activated based on your stack
• Testing target: [coverage]%
• Security: [requirements]

I've read your RULEBOOK and I'm ready to work.

What would you like me to help you with?
═══════════════════════════════════════════════════════════
```

**Then:**
1. Use **Read** tool to read `.claude/RULEBOOK.md`
2. Parse and store all information
3. Proceed with user's original request using the RULEBOOK

---

## Extensibility

### Adding Support for New Stacks

To add support for a new stack (e.g. Elixir/Phoenix):

1. **Add configuration files** to Phase 1
2. **Add detection rules** to Phase 2
3. **Create template section** for that stack in Phase 5

**Example: Elixir/Phoenix**

```markdown
#### Elixir/Phoenix
```
mix.exs                   → Elixir dependencies
config/config.exs         → Phoenix config
```

**Detection:**
```elixir
# From mix.exs
"{:phoenix," → Phoenix Framework
"{:ecto," → Ecto ORM
"{:postgrex," → PostgreSQL
```

**RULEBOOK Template:**
```markdown
### Backend
- **Framework:** Phoenix [version]
- **Language:** Elixir [version]
- **Database:** [detected]
- **ORM:** Ecto

### Context Structure
[Phoenix contexts pattern]
```

---

## Important Considerations

### Multi-language Projects

If project uses **multiple languages** (e.g. Next.js frontend + FastAPI backend):

1. Detect **both** stacks
2. Ask which is **primary**
3. Generate RULEBOOK with **Frontend** and **Backend** sections

### Monorepos

If a monorepo is detected (Nx, Turborepo, Lerna):

1. Scan root and main workspaces
2. Ask if they want a **global** or **per-workspace** RULEBOOK
3. Generate according to preference

### Legacy Projects

If a very old stack or no modern config files are detected:

1. Indicate it's a **legacy** project
2. Ask for **all** information manually
3. Suggest updating to modern tools (optional)

---

**End of RULEBOOK Generator Guide**
