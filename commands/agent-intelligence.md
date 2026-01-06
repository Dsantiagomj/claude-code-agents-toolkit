# Agent Intelligence System

**Purpose**: Enhance Gentleman Mode with automatic agent selection and smart task routing WITHOUT changing core behavior.

**Usage**: Import this intelligence when Gentleman Mode needs agent assistance for complex tasks.

---

## How It Works

This system works **alongside** Gentleman Mode, not replacing it:

- Gentleman Mode handles: personality, RULEBOOK enforcement, direct tasks
- Agent Intelligence handles: complex task breakdown, specialist selection, coordination

---

## Project Context Detection

### Auto-Detection Strategy

**The system reads your project's RULEBOOK.md to understand the stack:**

```bash
# 1. Read .claude/RULEBOOK.md
# 2. Parse "Tech Stack" section
# 3. Auto-activate relevant agents based on detected technologies

Example RULEBOOK.md:
---
## Tech Stack

### Frontend
- Framework: Next.js 16
- Library: React 19
- Language: TypeScript
- Styling: Tailwind CSS + Shadcn/ui
- State: Zustand + TanStack Query

### Backend
- API: tRPC
- ORM: Prisma
- Database: PostgreSQL
- Auth: Auth.js

### Testing
- Unit: Vitest
- Component: Testing Library
- E2E: Playwright
---

Auto-Activated Agents:
→ nextjs-specialist (Next.js detected)
→ react-specialist (React detected)
→ typescript-pro (TypeScript detected)
→ tailwind-expert (Tailwind detected)
→ prisma-specialist (Prisma detected)
→ postgres-expert (PostgreSQL detected)
→ rest-api-architect (tRPC uses REST-like patterns)
→ vitest-specialist (Vitest detected)
→ testing-library-specialist (Testing Library detected)
```

### Always Active (Core - 10 agents)

These agents are **always active** regardless of stack:

```yaml
Core Agents (Tech-Agnostic):
  - code-reviewer           # Code quality review
  - refactoring-specialist  # Code improvement
  - documentation-engineer  # Documentation
  - test-strategist         # Test planning
  - architecture-advisor    # Architecture decisions
  - security-auditor        # Security review
  - performance-optimizer   # Performance analysis
  - git-workflow-specialist # Git best practices
  - dependency-manager      # Dependency management
  - project-analyzer        # Codebase analysis
```

### Stack-Specific Activation

**Frontend Frameworks:**
```yaml
Next.js → nextjs-specialist + react-specialist
Nuxt    → nuxt-specialist + vue-specialist
Remix   → remix-specialist + react-specialist
Astro   → astro-specialist
React   → react-specialist
Vue     → vue-specialist
Angular → angular-specialist
Svelte  → svelte-specialist
```

**Backend Frameworks:**
```yaml
Express → express-specialist
Fastify → fastify-expert
NestJS  → nest-specialist
tRPC    → rest-api-architect (REST-like patterns)
GraphQL → graphql-specialist
```

**Databases:**
```yaml
PostgreSQL → postgres-expert
MySQL      → mysql-specialist
MongoDB    → mongodb-expert
Redis      → redis-specialist

Prisma   → prisma-specialist
TypeORM  → typeorm-expert
Drizzle  → drizzle-specialist
```

**Testing:**
```yaml
Jest       → jest-testing-specialist
Vitest     → vitest-specialist
Playwright → playwright-e2e-specialist
Cypress    → cypress-specialist
```

**Languages:**
```yaml
TypeScript → typescript-pro
JavaScript → javascript-modernizer
Python     → python-specialist
Go         → go-specialist
Rust       → rust-expert
```

---

## Task Type Detection & Agent Selection

### 1. New Feature Development

**Detection Keywords**: "create", "add", "implement", "build", "new feature"

**Agent Selection**:
```yaml
Phase 1 - Design:
  - architecture-advisor: Design feature architecture
  - [review against RULEBOOK]

Phase 2 - Implementation:
  - [framework-specialist]: Framework patterns (from RULEBOOK)
  - [language-specialist]: Language-specific implementation
  - [styling-specialist]: UI styling (if applicable)
  - [database-specialist]: Data layer (if applicable)

Phase 3 - Quality:
  - test-strategist: Test planning
  - [testing-specialist]: Test implementation
  - code-reviewer: Code review
  - documentation-engineer: Documentation

Gentleman Oversight:
  - Verify RULEBOOK compliance at each phase
  - Approve architecture before implementation
  - Final review before completion
```

### 2. Bug Fixing

**Detection Keywords**: "fix", "bug", "error", "broken", "not working"

**Agent Selection**:
```yaml
Phase 1 - Investigation:
  - project-analyzer: Analyze codebase context
  - [framework-specialist]: Framework-specific debugging

Phase 2 - Fix:
  - [framework-specialist]: Implement fix
  - test-strategist: Design regression test

Phase 3 - Verification:
  - code-reviewer: Review fix
  - [testing-specialist]: Verify tests pass

Gentleman Oversight:
  - Verify fix doesn't violate RULEBOOK
  - Ensure proper error handling
  - Check for similar bugs elsewhere
```

### 3. Refactoring

**Detection Keywords**: "refactor", "improve", "restructure", "clean up"

**Agent Selection**:
```yaml
Phase 1 - Analysis:
  - refactoring-specialist: Analyze current code
  - architecture-advisor: Validate refactoring approach

Phase 2 - Implementation:
  - [framework-specialist]: Execute refactoring
  - [language-specialist]: Update type definitions

Phase 3 - Verification:
  - test-strategist: Ensure test coverage
  - code-reviewer: Review changes

Gentleman Oversight:
  - Approve refactoring plan
  - Verify improvement metrics
  - Ensure RULEBOOK patterns followed
```

### 4. Performance Optimization

**Detection Keywords**: "optimize", "performance", "slow", "speed up", "bundle size"

**Agent Selection**:
```yaml
Phase 1 - Analysis:
  - performance-optimizer: Identify bottlenecks
  - [framework-specialist]: Framework-specific optimizations
  - monitoring-observability-specialist: Add metrics

Phase 2 - Implementation:
  - [framework-specialist]: Implement optimizations
  - code-reviewer: Review changes

Phase 3 - Verification:
  - performance-optimizer: Measure improvements
  - test-strategist: Add performance tests

Gentleman Oversight:
  - Approve optimization tradeoffs
  - Verify metrics improve
  - Ensure no functionality loss
```

### 5. Security Audit/Fix

**Detection Keywords**: "security", "vulnerability", "audit", "OWASP", "secure"

**Agent Selection**:
```yaml
Phase 1 - Audit:
  - security-auditor: Comprehensive security scan
  - [framework-specialist]: Framework security
  - [language-specialist]: Language security patterns

Phase 2 - Remediation:
  - security-auditor: Fix vulnerabilities
  - [framework-specialist]: Implement fixes

Phase 3 - Verification:
  - test-strategist: Security test coverage
  - code-reviewer: Review security fixes

Gentleman Oversight:
  - CRITICAL: Review ALL security changes
  - Verify OWASP Top 10 compliance
  - Ensure RULEBOOK security patterns
  - Demand 100% test coverage for auth/security
```

### 6. Testing

**Detection Keywords**: "test", "coverage", "testing", "unit test", "e2e"

**Agent Selection**:
```yaml
Phase 1 - Strategy:
  - test-strategist: Plan test coverage
  - [determine test type]: unit/integration/e2e

Phase 2 - Implementation:
  - [testing-specialist]: Implement tests
  - (vitest-specialist, jest-specialist, playwright-specialist, etc.)

Phase 3 - Review:
  - code-reviewer: Review test quality
  - test-strategist: Verify coverage (80% minimum from RULEBOOK)

Gentleman Oversight:
  - Enforce coverage minimum (check RULEBOOK)
  - Demand 100% for critical paths
  - Verify test quality, not just quantity
```

### 7. Documentation

**Detection Keywords**: "document", "docs", "documentation", "readme"

**Agent Selection**:
```yaml
Phase 1 - Documentation:
  - documentation-engineer: Write/update docs
  - [framework-specialist]: Technical accuracy

Phase 2 - Review:
  - code-reviewer: Review documentation
  - [check against RULEBOOK]: Doc standards compliance

Gentleman Oversight:
  - Verify documentation standards (check RULEBOOK)
  - Ensure code examples work
  - Check completeness
```

---

## Agent Delegation Decision Tree

```
START: Task received

├─ Is task trivial? (simple change, <10 lines, clear pattern in RULEBOOK)
│  └─ YES → Gentleman handles directly (no agents)
│
├─ Is task simple? (clear pattern exists in RULEBOOK, <50 lines, single file)
│  └─ YES → Gentleman handles + maybe 1 agent for verification
│
├─ Is task moderate? (multiple files, existing patterns, <200 lines)
│  └─ YES → Delegate specific parts to 2-3 agents
│              Gentleman orchestrates + verifies RULEBOOK
│
├─ Is task complex? (new patterns, architecture, >200 lines)
│  └─ YES → Full multi-agent delegation (5+ agents)
│              Gentleman supervises all phases
│
└─ Is task critical? (security, auth, payments, data integrity)
   └─ YES → Multi-agent review + Gentleman 100% oversight
               RULEBOOK compliance mandatory
               Multiple verification rounds
```

---

## Agent Communication Protocols

### 1. Task Delegation Template

```markdown
Agent: [agent-name]
Project: [detected from RULEBOOK.md]
Context: [current work context]

Task:
[Detailed task description]

RULEBOOK Requirements (from .claude/RULEBOOK.md):
- [specific RULEBOOK rules that apply]
- [patterns that must be followed]
- [standards that must be met]

Constraints:
[Project-specific constraints from RULEBOOK]

Expected Output:
[What Gentleman needs back]

Return Format:
- Code with file paths
- Explanation of approach
- Any RULEBOOK conflicts (if discovered)
- Test coverage report
```

### 2. Agent Response Verification Checklist

```markdown
Agent: [agent-name]
Task: [task summary]
Output received: [timestamp]

RULEBOOK Compliance (check .claude/RULEBOOK.md):
□ Follows project structure pattern
□ Meets documentation standards
□ Follows language/framework conventions
□ Tests included (coverage requirement from RULEBOOK)
□ Follows state management pattern (from RULEBOOK)
□ Error handling implemented
□ Security best practices followed

Code Quality:
□ Follows existing patterns (Grep/Glob verified)
□ Proper imports
□ No circular dependencies

Decision:
[ ] APPROVE - Proceed with implementation
[ ] REVISE - Changes needed (specify below)
[ ] REJECT - Does not meet standards (specify below)

Notes:
[Gentleman's review notes]
```

---

## Intelligent Agent Selection Examples

### Example 1: "Add analytics dashboard"

**Task Analysis**:
- Type: New Feature (complex)
- Scope: Multiple components, new queries, visualization
- Complexity: High (new domain, requires architecture)

**Detection Process**:
```bash
1. Read .claude/RULEBOOK.md
2. Detect: Next.js + React + Prisma + PostgreSQL
3. Select relevant specialists
```

**Selected Agents**:
```yaml
Phase 1 - Architecture:
  - architecture-advisor:
      Task: "Design analytics feature architecture following RULEBOOK pattern"

Phase 2 - Database:
  - prisma-specialist: "Design analytics queries"
  - postgres-expert: "Optimize queries, recommend indexes"

Phase 3 - Implementation:
  - react-specialist: "Design dashboard components"
  - [styling-specialist from RULEBOOK]: "Design responsive layout"
  - typescript-pro: "Define analytics types"

Phase 4 - Quality:
  - test-strategist: "Plan analytics testing"
  - [testing-specialist from RULEBOOK]: "Implement tests"
  - code-reviewer: "Review entire feature"
```

**Gentleman's Role**:
- Review architecture against RULEBOOK
- Verify component structure follows RULEBOOK patterns
- Approve data fetching strategy (check RULEBOOK for state management rules)
- Verify test coverage meets RULEBOOK requirements
- Final RULEBOOK compliance check

---

### Example 2: "Fix bug: form not validating"

**Task Analysis**:
- Type: Bug Fix (simple)
- Scope: Single component, validation logic
- Complexity: Low (existing patterns)

**Selected Agents**:
```yaml
Phase 1 - Investigation:
  - project-analyzer: "Analyze form validation logic"

Phase 2 - Fix:
  - [framework-specialist from RULEBOOK]: "Fix validation"

Phase 3 - Testing:
  - test-strategist: "Design regression test"
  - [testing-specialist from RULEBOOK]: "Implement test"
```

**Gentleman's Role**:
- Verify fix follows RULEBOOK patterns (validation schema location, error handling)
- Check test coverage
- Ensure error messages follow RULEBOOK UX guidelines
- Verify no similar bugs in other forms

---

### Example 3: "Security audit"

**Task Analysis**:
- Type: Security Audit (critical)
- Scope: Entire auth system
- Complexity: High (critical system)

**Selected Agents**:
```yaml
Phase 1 - Comprehensive Audit:
  - security-auditor: "Full OWASP Top 10 audit"
  - [framework-specialist from RULEBOOK]: "Framework-specific security"
  - [language-specialist from RULEBOOK]: "Language security patterns"
  - test-strategist: "Audit security test coverage"

Phase 2 - Remediation:
  - security-auditor: Implement fixes
  - [framework-specialist]: Framework-specific fixes
  - [testing-specialist]: Add security tests

Phase 3 - Verification:
  - security-auditor: Re-audit
  - code-reviewer: Final review
```

**Gentleman's Role**:
- CRITICAL: Review every single security change
- Verify OWASP Top 10 compliance
- Check against RULEBOOK security patterns
- Demand 100% test coverage (RULEBOOK requirement for security)
- Multiple verification rounds

---

## Integration with Gentleman Mode

### Option 1: Manual Activation

Gentleman Mode reads this file when needed:

```
User: "Create an analytics dashboard"

Gentleman Mode:
"This is complex. Let me consult the agent intelligence system.

[Reads agent-intelligence.md]
[Reads .claude/RULEBOOK.md for stack detection]
[Selects agents per pattern]
[Delegates to architecture-advisor]

Architecture advisor suggests... [continues]"
```

### Option 2: Auto-Detection

Gentleman Mode auto-detects complex tasks:

```
User: "Security audit"

Gentleman Mode:
"Security is serious business. This needs proper specialists.

[Reads .claude/RULEBOOK.md to understand stack]
[Reads agent-intelligence.md for Security Audit pipeline]

I'm calling in:
- security-auditor (OWASP audit)
- [framework]-specialist (framework security)
- [language]-specialist (language security)

Want me to run a full security audit with the team?"
```

---

## Best Practices

### When to Use Agents

✅ **Use agents when**:
- Task requires deep expertise (security, performance, architecture)
- Multiple domains involved (backend + frontend + database)
- Critical systems (auth, payments, data integrity)
- Large scope (>200 lines of code)
- New patterns needed (no existing RULEBOOK pattern)

❌ **Don't use agents when**:
- Task is trivial (<10 lines)
- Clear pattern exists in RULEBOOK
- Simple CRUD operation
- Documentation-only change
- Quick bug fix in existing pattern

### Agent Coordination Rules

1. **Never delegate without context** - Always include RULEBOOK requirements
2. **Verify agent output** - Don't blindly accept recommendations
3. **RULEBOOK overrides agents** - If agent suggests anti-pattern, reject
4. **One task per agent** - Don't overwhelm agents with multi-part tasks
5. **Sequential for dependencies** - Parallel for independent work

### Quality Gates

Every agent output must pass:
- [ ] RULEBOOK compliance check (read .claude/RULEBOOK.md)
- [ ] Follows project structure (from RULEBOOK)
- [ ] Meets test coverage requirements (from RULEBOOK)
- [ ] Follows documentation standards (from RULEBOOK)
- [ ] Security review (for critical code)
- [ ] Accessibility check (if UI, check RULEBOOK for standards)

---

## Summary

This agent intelligence system **enhances** Gentleman Mode without changing its core:

- Gentleman Mode: Personality, RULEBOOK enforcement, direct tasks
- Agent Intelligence: Complex task breakdown, specialist coordination
- RULEBOOK.md: Single source of truth for project patterns and stack
- Together: Production-grade software at scale

**Remember**:
- Agents are tools
- RULEBOOK is law
- Gentleman is the architect
- Everything is driven by YOUR project's .claude/RULEBOOK.md

---

**Agent Intelligence System ready. Adapt to any stack. Build software that doesn't suck. 💪**
