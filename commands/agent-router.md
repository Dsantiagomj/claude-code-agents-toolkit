# Agent Router - Automatic Task Routing System

**Purpose**: Automatically route tasks to the right agents based on project context (from RULEBOOK.md), task type, and complexity.

**Integration**: Works with `maestro.md` and `agent-intelligence.md` to provide smart agent selection.

**Routing Rules**: See `agent-routing-rules.json` for detailed routing tables.

---

## Quick Reference

```bash
# The router:
# 1. Reads .claude/RULEBOOK.md to understand your stack
# 2. Analyzes the task type and complexity
# 3. Selects appropriate agents from agent-routing-rules.json
# 4. Provides delegation instructions
# 5. Returns verification checklist
```

---

## How It Works

### Step 1: Read Project Context

**Source**: `.claude/RULEBOOK.md`

Extract:
- Frontend framework (Next.js, React, Vue, etc.)
- Backend framework (Express, NestJS, Fastify, etc.)
- Language (TypeScript, JavaScript, Python, etc.)
- Database & ORM (PostgreSQL + Prisma, MongoDB, etc.)
- Testing stack (Vitest, Jest, Playwright, etc.)
- Styling approach (Tailwind, CSS Modules, etc.)
- State management (Zustand, Redux, Context, etc.)

### Step 2: Detect Task Type

**Patterns** (from `agent-routing-rules.json`):

| Task Type | Keywords | Complexity | Agents |
|-----------|----------|------------|--------|
| New Feature | create, add, implement, build | HIGH | 5-10 |
| Bug Fix | fix, bug, error, broken | LOW-MEDIUM | 1-3 |
| Refactoring | refactor, improve, clean | MEDIUM | 2-4 |
| Performance | optimize, performance, slow | MEDIUM-HIGH | 2-5 |
| Security | security, vulnerability, audit | HIGH-CRITICAL | 3-6 |
| Testing | test, coverage, unit test | LOW-MEDIUM | 2-3 |
| Documentation | document, docs, readme | LOW | 1-2 |

### Step 3: Assess Complexity

```yaml
Factors:
  - Lines of Code (LOC estimate)
  - Files Affected (count)
  - New Patterns (yes/no)
  - Risk Level (low/medium/high/critical)

Complexity Levels:
  Trivial: < 10 LOC, 1 file, no agents
  Simple: 10-50 LOC, 1 file, 1 agent
  Moderate: 50-200 LOC, 2-4 files, 2-4 agents
  Complex: 200-500 LOC, 5-10 files, 5-10 agents
  Critical: > 500 LOC, > 10 files, 10+ agents
```

### Step 4: Select Route

**Routes** (from `agent-routing-rules.json`):

1. **New Feature** → Feature Development Pipeline (7 steps)
2. **Bug Fix** → Debugging Pipeline (4 steps)
3. **Refactoring** → Code Improvement Pipeline (4 steps)
4. **Performance** → Optimization Pipeline (5 steps)
5. **Security** → Security Audit Pipeline (6 steps)
6. **Testing** → Test Development Pipeline (3 steps)
7. **Documentation** → Documentation Pipeline (3 steps)

Each route defines:
- Agent sequence
- Task for each agent
- Expected output
- Review checkpoints

### Step 5: Delegate to Agents

**Format**:

```yaml
Task: [user request]
Route: [selected route name]
Complexity: [level]

Agents Pipeline:
  Step 1 - [Phase]:
    agent: [agent-name]
    task: [specific task]
    output: [expected result]

  Step 2 - [Phase]:
    agent: [agent-name]
    task: [specific task]
    output: [expected result]

  [... more steps ...]

Total Agents: [count]
Estimated Time: [hours]
```

---

## Router Decision Logic

```javascript
function routeTask(userRequest, rulebook) {
  // 1. Detect task type
  const taskType = detectTaskType(userRequest);

  // 2. Assess complexity
  const complexity = assessComplexity(userRequest, rulebook);

  // 3. Handle based on complexity
  if (complexity === 'trivial') {
    return { agents: [], approach: 'direct_fix' };
  }

  if (complexity === 'simple') {
    return {
      agents: [selectSingleSpecialist(taskType, rulebook)],
      approach: 'single_agent'
    };
  }

  // 4. Select route from routing rules
  const route = ROUTING_RULES.routes[taskType];

  // 5. Resolve agents from RULEBOOK
  const resolvedAgents = route.steps.map(step => {
    return resolveAgent(step.agent, rulebook);
  });

  return {
    route: route.name,
    agents: resolvedAgents,
    steps: route.steps,
    approach: 'multi_agent_pipeline'
  };
}
```

---

## Integration with Maestro Mode

### Maestro Calls Router

When Maestro enters **PLANNING MODE**, it calls the router:

```yaml
# Maestro internal call:
routing = agent_router.route(
  user_request = "add user profile editing",
  rulebook = read(".claude/RULEBOOK.md")
)

# Router returns:
{
  task_type: "new_feature",
  complexity: "moderate",
  route: "Feature Development Pipeline",
  agents: [
    architecture-advisor,
    prisma-specialist,
    nextjs-specialist,
    tailwind-expert,
    vitest-specialist,
    code-reviewer
  ],
  steps: [...],
  estimated_time: "2-3 hours"
}

# Maestro uses this to build the plan
```

---

## Complex Task Handling

### Multi-Route Tasks

Some tasks require multiple routes:

**Example**: "Add authentication + profile editing"

```yaml
Router breaks down:
  Task 1: Add authentication
    Route: Feature Development Pipeline
    Focus: Auth system

  Task 2: Add profile editing
    Route: Feature Development Pipeline
    Focus: Profile feature
    Dependency: Requires Task 1

Suggestion: Split into 2 separate tasks or combine agents
```

### Router Auto-Suggest

For complex requests, router can suggest:

```yaml
User: "Make the app faster"

Router Analysis:
  Too vague - multiple routes possible:
  1. Performance Route (optimize existing code)
  2. Refactoring Route (improve code structure)
  3. Infrastructure Route (caching, CDN, etc.)

Router Response:
  "Can you clarify what aspect of performance?
   - Page load speed?
   - API response time?
   - Bundle size?
   - Database queries?"
```

---

## Best Practices

### Routing Do's ✅

- **Always read RULEBOOK first** - Stack context is critical
- **Match agents to stack** - Use detected specialists
- **Scale with complexity** - More complex = more agents
- **Use routes from JSON** - Consistent agent pipelines
- **Verify outputs** - Each agent has expected output

### Routing Don'ts ❌

- **Don't hardcode agents** - Always resolve from RULEBOOK
- **Don't skip complexity assessment** - Drives agent count
- **Don't ignore task type** - Different routes for different tasks
- **Don't over-route trivial tasks** - Direct fix when possible
- **Don't under-route critical tasks** - Use all relevant agents

---

## Quick Routing Guide

**For Maestro/Coordinator**: When routing a task, follow this pattern:

```markdown
1. Read .claude/RULEBOOK.md
2. Detect task type (see agent-routing-rules.json)
3. Assess complexity
4. Select route from agent-routing-rules.json
5. Resolve agents from RULEBOOK stack
6. Build pipeline with steps from route
7. Delegate to agents in sequence
8. Verify each output
```

---

**For detailed routing tables and rules, see `agent-routing-rules.json`.**
