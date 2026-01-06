# Agent Router - Automatic Task Routing System

**Purpose**: Automatically route tasks to the right agents based on project context (from RULEBOOK.md), task type, and complexity.

**Integration**: Works with `gentleman.md` and `agent-intelligence.md` to provide smart agent selection.

---

## Quick Reference

```bash
# The router:
# 1. Reads .claude/RULEBOOK.md to understand your stack
# 2. Analyzes the task type and complexity
# 3. Selects appropriate agents
# 4. Provides delegation instructions
# 5. Returns verification checklist
```

---

## Auto-Detection Rules

### Project Stack Detection

**Source**: `.claude/RULEBOOK.md` - "Tech Stack" section

```yaml
# Router reads RULEBOOK.md and detects:
frontend_framework: [next.js, react, vue, angular, etc.]
backend_framework: [express, fastify, nest, etc.]
language: [typescript, javascript, python, go, etc.]
database: [postgresql, mongodb, mysql, etc.]
orm: [prisma, typeorm, drizzle, etc.]
testing: [vitest, jest, playwright, etc.]
styling: [tailwind, css-modules, etc.]
state_management: [zustand, redux, context, etc.]
```

### Task Type Detection

**Detection patterns**:

```javascript
// New Feature
patterns: ["create", "add", "implement", "build", "new", "feature"]
complexity: HIGH
agents_needed: 5-10

// Bug Fix
patterns: ["fix", "bug", "error", "broken", "not working", "issue"]
complexity: LOW-MEDIUM
agents_needed: 1-3

// Refactoring
patterns: ["refactor", "improve", "clean", "restructure", "optimize code"]
complexity: MEDIUM
agents_needed: 2-4

// Performance
patterns: ["optimize", "performance", "slow", "speed up", "bundle"]
complexity: MEDIUM-HIGH
agents_needed: 2-5

// Security
patterns: ["security", "vulnerability", "audit", "secure", "owasp"]
complexity: HIGH-CRITICAL
agents_needed: 3-6

// Testing
patterns: ["test", "coverage", "testing", "unit test", "e2e"]
complexity: LOW-MEDIUM
agents_needed: 2-3

// Documentation
patterns: ["document", "docs", "readme", "documentation"]
complexity: LOW
agents_needed: 1-2
```

---

## Routing Table

### Route 1: New Feature → Feature Development Pipeline

```yaml
Trigger: User wants to create/add new functionality

Agents Pipeline:
  Step 1 - Architecture:
    agent: architecture-advisor
    task: Design feature architecture
    output: Feature structure, data flow, tech decisions

  Step 2 - Database (if needed):
    agent: [database-orm-specialist from RULEBOOK]
    task: Design database schema and queries
    output: Schema models, migrations, queries

  Step 3 - Backend (if applicable):
    agent: [api-specialist from RULEBOOK]
    task: Design API endpoints
    output: Router structure, input/output schemas

  Step 4 - Frontend (if applicable):
    agents:
      - [framework-specialist from RULEBOOK]: Component architecture
      - [styling-specialist from RULEBOOK]: Styling approach
      - [language-specialist from RULEBOOK]: Type definitions
    output: Component structure, styling plan, types

  Step 5 - Quality:
    agents:
      - test-strategist: Test planning
      - [testing-specialist from RULEBOOK]: Test implementation
    output: Test files, coverage report

  Step 6 - Review:
    agents:
      - code-reviewer: Code quality review
      - security-auditor: Security check (if applicable)
      - [ui-accessibility if UI]: Accessibility audit
    output: Review report, improvements

Gentleman Oversight:
  - Approve architecture (Step 1)
  - Verify RULEBOOK compliance (all steps)
  - Final review before merge

Estimated Time: 2-4 hours (complex feature)
Agent Count: 8-10
```

### Route 2: Bug Fix → Debugging Pipeline

```yaml
Trigger: User reports something broken

Agents Pipeline:
  Step 1 - Investigation:
    agent: project-analyzer
    task: Analyze codebase, find root cause
    output: Bug location, cause analysis

  Step 2 - Fix Implementation:
    agent: [framework-specialist from RULEBOOK]
    task: Implement fix following patterns
    output: Fixed code, explanation

  Step 3 - Regression Prevention:
    agents:
      - test-strategist: Design regression test
      - [testing-specialist from RULEBOOK]: Implement test
    output: Test file covering bug scenario

  Step 4 - Verification:
    agent: code-reviewer
    task: Review fix quality
    output: Approval or revision requests

Gentleman Oversight:
  - Verify fix doesn't violate RULEBOOK
  - Check for similar bugs elsewhere
  - Ensure proper error handling
  - Approve test coverage

Estimated Time: 30min - 2 hours
Agent Count: 3-4
```

### Route 3: Refactoring → Code Improvement Pipeline

```yaml
Trigger: User wants to improve existing code

Agents Pipeline:
  Step 1 - Analysis:
    agents:
      - refactoring-specialist: Analyze refactoring opportunities
      - architecture-advisor: Validate approach
    output: Refactoring plan, improvement metrics

  Step 2 - Implementation:
    agents:
      - [framework-specialist from RULEBOOK]: Execute refactoring
      - [language-specialist from RULEBOOK]: Update types
    output: Refactored code

  Step 3 - Verification:
    agents:
      - test-strategist: Ensure test coverage
      - performance-optimizer: Measure improvements
      - code-reviewer: Review changes
    output: Test report, metrics, review

Gentleman Oversight:
  - Approve refactoring plan
  - Verify RULEBOOK patterns maintained
  - Check improvement metrics
  - Ensure no functionality lost

Estimated Time: 1-3 hours
Agent Count: 5-7
```

### Route 4: Performance → Optimization Pipeline

```yaml
Trigger: User wants to improve performance

Agents Pipeline:
  Step 1 - Profiling:
    agents:
      - performance-optimizer: Identify bottlenecks
      - [framework-specialist from RULEBOOK]: Framework-specific analysis
    output: Performance report, bottleneck list

  Step 2 - Optimization:
    agents:
      - [framework-specialist from RULEBOOK]: Implement optimizations
      - monitoring-observability-specialist: Add metrics
    output: Optimized code, monitoring setup

  Step 3 - Verification:
    agents:
      - performance-optimizer: Measure improvements
      - test-strategist: Add performance tests
    output: Before/after metrics, tests

Gentleman Oversight:
  - Approve optimization tradeoffs
  - Verify metrics improve significantly
  - Ensure no functionality sacrificed
  - Check RULEBOOK compliance

Estimated Time: 2-4 hours
Agent Count: 5-6
```

### Route 5: Security → Security Audit Pipeline

```yaml
Trigger: User needs security audit/fix

Agents Pipeline:
  Step 1 - Comprehensive Audit:
    agents:
      - security-auditor: OWASP Top 10 scan
      - [framework-specialist from RULEBOOK]: Framework security
      - [language-specialist from RULEBOOK]: Type safety audit
    output: Vulnerability report (Critical/High/Medium/Low)

  Step 2 - Prioritized Remediation:
    For each CRITICAL/HIGH vulnerability:
      agents:
        - security-auditor: Implement fix
        - [framework-specialist from RULEBOOK]: Framework-specific fix
      output: Fixed code, security improvements

  Step 3 - Testing:
    agents:
      - test-strategist: Security test planning
      - [testing-specialist from RULEBOOK]: Security test implementation
    output: Security tests, 100% coverage

  Step 4 - Re-Audit:
    agents:
      - security-auditor: Verify all fixes
      - code-reviewer: Review security code
    output: Clean audit report

Gentleman Oversight:
  - CRITICAL: Review EVERY security change
  - Verify OWASP Top 10 compliance
  - Demand 100% test coverage (no exceptions)
  - Multiple verification rounds
  - Final security approval

Estimated Time: 4-8 hours (comprehensive audit)
Agent Count: 6-8
Critical Level: MAXIMUM OVERSIGHT
```

### Route 6: Testing → Test Development Pipeline

```yaml
Trigger: User wants to add/improve tests

Agents Pipeline:
  Step 1 - Strategy:
    agent: test-strategist
    task: Analyze coverage gaps, plan tests
    output: Test strategy, coverage plan

  Step 2 - Implementation:
    agents:
      - [unit-testing-specialist from RULEBOOK]: Unit/integration tests
      - [component-testing-specialist from RULEBOOK]: Component tests
      - [e2e-testing-specialist from RULEBOOK]: E2E tests (if needed)
    output: Test files, coverage report

  Step 3 - Review:
    agents:
      - code-reviewer: Test quality review
      - test-strategist: Coverage verification
    output: Quality report, coverage %

Gentleman Oversight:
  - Enforce coverage minimum (check RULEBOOK)
  - Verify test quality (not just quantity)
  - Check edge cases covered
  - Approve test strategy

Estimated Time: 1-3 hours
Agent Count: 3-4
```

### Route 7: Documentation → Documentation Pipeline

```yaml
Trigger: User needs documentation

Agents Pipeline:
  Step 1 - Documentation:
    agents:
      - documentation-engineer: Write/update docs
      - [framework-specialist from RULEBOOK]: Technical accuracy
    output: Documentation files

  Step 2 - Review:
    agent: code-reviewer
    task: Review documentation quality
    output: Approval or improvements

Gentleman Oversight:
  - Verify documentation standards (check RULEBOOK)
  - Check code examples work
  - Verify completeness

Estimated Time: 30min - 2 hours
Agent Count: 2-3
```

---

## Complexity-Based Routing

### Trivial Tasks (No Agents)

```yaml
Characteristics:
  - Single file change
  - <10 lines of code
  - Clear existing pattern in RULEBOOK
  - No architecture impact

Examples:
  - "Add a prop to Button component"
  - "Fix typo in error message"
  - "Update import path"

Routing Decision: Gentleman handles directly
Agent Count: 0
```

### Simple Tasks (1 Agent)

```yaml
Characteristics:
  - Single file or small module
  - <50 lines of code
  - Existing pattern to follow (in RULEBOOK)
  - Low risk

Examples:
  - "Add validation to input field"
  - "Create simple utility function"
  - "Update component styling"

Routing Decision: Gentleman + 1 specialist for verification
Agent Count: 1
Agent Examples: [framework-specialist from RULEBOOK]
```

### Moderate Tasks (2-4 Agents)

```yaml
Characteristics:
  - Multiple files
  - 50-200 lines of code
  - Some new patterns
  - Medium risk

Examples:
  - "Add filtering to data list"
  - "Create reusable form component"
  - "Refactor store structure"

Routing Decision: Gentleman orchestrates 2-4 specialists
Agent Count: 2-4
Agent Examples (from RULEBOOK):
  - framework-specialist + styling-specialist
  - refactoring-specialist + language-specialist
```

### Complex Tasks (5-10 Agents)

```yaml
Characteristics:
  - Full feature development
  - >200 lines of code
  - New architecture
  - High risk

Examples:
  - "Add analytics dashboard"
  - "Implement multi-tenant system"
  - "Build real-time notifications"

Routing Decision: Full multi-agent pipeline
Agent Count: 5-10
Agent Examples: Full pipeline (architecture → implementation → quality)
```

### Critical Tasks (All Relevant Agents)

```yaml
Characteristics:
  - Security/auth/payments
  - Data integrity
  - Production impact
  - Zero-defect requirement

Examples:
  - "Security audit of auth system"
  - "Payment processing implementation"
  - "Data migration script"

Routing Decision: All relevant agents + maximum oversight
Agent Count: 6-12
Agent Examples: Full audit team + multiple verification rounds
```

---

## Smart Routing Examples

### Example 1: Simple Request

```
User: "Add a loading state to the form"

Router Analysis:
  - Task Type: Simple enhancement
  - Complexity: Low
  - Files Affected: 1 (form component)
  - Lines of Code: ~10
  - Risk: Low

Routing Decision: Trivial → No agents needed

Output to Gentleman:
"Handle directly. Add loading state following existing pattern in RULEBOOK.
Check other forms for consistency.
No agents needed for this simple change."
```

### Example 2: Moderate Request

```
User: "Add filtering by date range and category"

Router Analysis:
  - Task Type: Feature enhancement
  - Complexity: Moderate
  - Files Affected: 3-4 (list component, hooks, types)
  - Lines of Code: ~150
  - Risk: Medium

Routing Decision: Moderate → Delegate to 3 agents

Output to Gentleman:
"Delegate to agent pipeline:
[Read RULEBOOK.md to get framework and styling]
1. [framework-specialist]: Design filter UI components
2. [styling-specialist]: Style filter controls
3. [testing-specialist]: Add filter tests

Your role: Verify state management approach (check RULEBOOK),
approve filter logic, ensure RULEBOOK compliance."
```

### Example 3: Complex Request

```
User: "Add analytics dashboard with charts"

Router Analysis:
  - Task Type: New feature
  - Complexity: High
  - Files Affected: 10+ (new feature module)
  - Lines of Code: ~500
  - Risk: High
  - Architecture Impact: Yes

Routing Decision: Complex → Full pipeline (8 agents)

Output to Gentleman:
"Route to Feature Development Pipeline:
[Read RULEBOOK.md to get stack]
1. architecture-advisor: Design analytics feature
2. [database-specialist from RULEBOOK]: Analytics queries
3. [framework-specialist from RULEBOOK]: Chart components
4. [styling-specialist from RULEBOOK]: Dashboard layout
5. [language-specialist from RULEBOOK]: Analytics types
6. test-strategist: Test strategy
7. [testing-specialist from RULEBOOK]: Test implementation
8. code-reviewer: Final review

Your role: Approve architecture, verify RULEBOOK at each step,
final review. Estimated time: 3-4 hours."
```

### Example 4: Critical Request

```
User: "Security audit of the entire application"

Router Analysis:
  - Task Type: Security audit
  - Complexity: Critical
  - Scope: Entire application
  - Risk: Critical
  - Special Handling: Maximum oversight

Routing Decision: Critical → Security Audit Pipeline

Output to Gentleman:
"CRITICAL TASK - Route to Security Audit Pipeline:
[Read RULEBOOK.md for tech stack]
1. security-auditor: OWASP Top 10 scan
2. [framework-specialist from RULEBOOK]: Framework security
3. [language-specialist from RULEBOOK]: Type safety audit
4. test-strategist: Security test coverage audit
5. [For each vulnerability]:
   - security-auditor: Implement fix
   - [testing-specialist from RULEBOOK]: Add security test
6. security-auditor: Re-audit
7. code-reviewer: Final review

Your role: MAXIMUM OVERSIGHT
- Review EVERY security change
- Demand 100% test coverage (check RULEBOOK requirement)
- Multiple verification rounds
- No compromises on security

Estimated time: 6-8 hours. This is serious business!"
```

---

## Router Decision Logic

```javascript
function routeTask(taskDescription, projectRULEBOOK) {
  // 1. Read RULEBOOK.md
  const stack = parseRULEBOOK(projectRULEBOOK);

  // 2. Detect task type
  const taskType = detectTaskType(taskDescription);

  // 3. Assess complexity
  const complexity = assessComplexity(taskDescription, stack);

  // 4. Check criticality
  const isCritical = checkCriticality(taskDescription);

  // 5. Select routing strategy
  if (isCritical) {
    return routes.CRITICAL_PIPELINE;
  } else if (complexity === 'trivial') {
    return routes.DIRECT_HANDLING;
  } else if (complexity === 'simple') {
    return routes.SINGLE_AGENT;
  } else if (complexity === 'moderate') {
    return routes.MULTI_AGENT;
  } else if (complexity === 'complex') {
    return routes.FULL_PIPELINE;
  }

  // 6. Select specific agents from RULEBOOK
  const agents = selectAgentsFromStack(taskType, complexity, stack);

  // 7. Generate delegation instructions
  return {
    route: selectedRoute,
    agents: agents,
    pipeline: pipelineSteps,
    gentlemanRole: oversightRequirements,
    estimatedTime: timeEstimate
  };
}
```

---

## Integration with Gentleman Mode

### Gentleman Calls Router

```markdown
# In gentleman.md:

## Complex Task Handling

When you encounter a complex task:

1. Read `.claude/RULEBOOK.md` to understand project stack
2. Read `.claude/commands/agent-router.md`
3. Let the router analyze the task
4. Follow the routing decision
5. Maintain your oversight role
```

### Router Auto-Suggest

```
User: [complex task]

Gentleman:
"Let me check the router for the best approach..."
[Reads .claude/RULEBOOK.md for stack]
[Reads agent-router.md for routing logic]
[Gets routing decision]

"Router suggests: Full Feature Pipeline with 8 agents based on your stack.
Want me to proceed with this approach?"
```

---

## Best Practices

### Routing Do's ✅

- Read RULEBOOK.md before routing
- Analyze task thoroughly
- Consider project context
- Match complexity to agent count
- Provide clear delegation instructions
- Verify agent output at each step
- Gentleman maintains oversight always

### Routing Don'ts ❌

- Don't route without reading RULEBOOK
- Don't over-delegate simple tasks
- Don't under-delegate critical tasks
- Don't skip complexity assessment
- Don't ignore RULEBOOK requirements
- Don't let agents override RULEBOOK
- Don't delegate without clear instructions

---

## Summary

The Agent Router provides:

✅ RULEBOOK-driven stack detection
✅ Automatic task type detection
✅ Complexity-based agent selection
✅ Pre-defined routing pipelines
✅ Clear delegation instructions
✅ Verification checklists
✅ Integration with Gentleman Mode

**Remember**:
- RULEBOOK.md is the source of truth
- Router reads it to understand your stack
- Agents are selected based on YOUR project
- Gentleman makes final decisions

---

**Agent Router ready. Route smart. Build fast. Follow the RULEBOOK. 💪**
