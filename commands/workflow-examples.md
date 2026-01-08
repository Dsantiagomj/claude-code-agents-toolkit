# Workflow Modes - Examples

> **Purpose**: Detailed examples for each workflow mode to demonstrate best practices.
> **Reference**: See `workflow-modes.md` for core definitions.

---

## Example 1: 📋 PLANNING MODE

**Scenario**: User requests "Add user profile editing functionality"

```
═══════════════════════════════════════════════════════════
📋 PLANNING MODE ACTIVE
───────────────────────────────────────────────────────────
Task: Add user profile editing functionality
Complexity: Moderate (3 files, ~150 LOC, existing patterns)
───────────────────────────────────────────────────────────

**Task Analysis:**
- What: Allow users to edit name, email, avatar
- Why: Core user management feature
- Scope: UI form + API endpoint + validation
- Dependencies: User auth system, file upload for avatar

**Project Context (from RULEBOOK.md):**
- Framework: Next.js 16 + React 19
- State: Zustand (global) + TanStack Query (server)
- Styling: Shadcn/ui + Tailwind
- Testing: Vitest + Testing Library (80% coverage)

**Complexity Assessment:**
- Lines of Code: ~150
- Files Affected: 3 new, 2 modified
- New Patterns: No (follow existing profile patterns)
- Risk Level: Medium (touches user data)
→ Complexity: Moderate

**Recommended Agents:**
Phase 1 - Design:
  - architecture-advisor: Review component architecture

Phase 2 - Implementation:
  - react-specialist: Build ProfileEditForm component
  - tailwind-expert: Style the form

Phase 3 - Quality:
  - test-strategist: Plan test coverage
  - vitest-specialist: Write tests
  - code-reviewer: Final review

Total Agents: 5
Estimated Time: 2-3 hours

**Development Plan:**

Step 1: Create ProfileEditForm Component (30min)
- Files: src/features/profile/components/ProfileEditForm/
- Agent: react-specialist
- Output: Form component with validation

Step 2: Add tRPC Mutation (20min)
- Files: src/features/profile/server/router.ts
- Agent: None (follow existing pattern)
- Output: user.updateProfile procedure

Step 3: Add Styling (15min)
- Files: ProfileEditForm.tsx
- Agent: tailwind-expert
- Output: Responsive, accessible form

Step 4: Write Tests (30min)
- Files: ProfileEditForm.test.tsx, router.test.ts
- Agent: vitest-specialist
- Output: 80%+ coverage

Step 5: Code Review (15min)
- Agent: code-reviewer
- Output: Quality verification

Total Estimated Time: 1h 50min

**Questions Before We Proceed:**

1. Should avatar upload be included now or separate feature?
2. Do you want email change to require verification?
3. Any specific validation rules beyond required fields?

Please answer these questions, then say "ok" to proceed.

═══════════════════════════════════════════════════════════
```

---

## Example 2: 💻 DEVELOPMENT MODE

**Scenario**: Executing the approved plan from Planning Mode

```
═══════════════════════════════════════════════════════════
💻 DEVELOPMENT MODE ACTIVE
───────────────────────────────────────────────────────────
Current Step: 1/5 - Create ProfileEditForm Component
Agent: react-specialist
Estimated: 30min
───────────────────────────────────────────────────────────

[Progress indicators shown during execution]

✓ Step 1 Complete: ProfileEditForm Component Created
  Files: src/features/profile/components/ProfileEditForm/
    - index.tsx (120 LOC)
    - schema.ts (validation - 25 LOC)

  Features implemented:
  - Form fields: name, email, bio
  - Client-side validation (Zod)
  - Optimistic updates
  - Error handling
  - Loading states

───────────────────────────────────────────────────────────
Current Step: 2/5 - Add tRPC Mutation
Estimated: 20min
───────────────────────────────────────────────────────────

[Executing Step 2...]

✓ Step 2 Complete: tRPC Mutation Added
  Files: src/features/profile/server/router.ts

  Procedure: user.updateProfile
  - Input validation (Zod schema)
  - Database update (Prisma)
  - Response type safety

───────────────────────────────────────────────────────────
Progress: 2/5 steps complete (40%)
Next: Add Styling
───────────────────────────────────────────────────────────

[Continuing execution...]

═══════════════════════════════════════════════════════════
```

---

## Example 3: 🔍 REVIEW MODE

**Scenario**: All development steps completed, ready for review

```
═══════════════════════════════════════════════════════════
🔍 REVIEW MODE ACTIVE
───────────────────────────────────────────────────────────

**Development Summary:**

✓ All 5 steps completed
✓ Files changed: 5 (3 new, 2 modified)
✓ Total lines: 187 LOC
✓ Tests: 12 test cases, 85% coverage
✓ All tests passing

───────────────────────────────────────────────────────────

**Changes Overview:**

NEW FILES:
  src/features/profile/components/ProfileEditForm/
    ├── index.tsx                    (120 LOC)
    ├── schema.ts                    (25 LOC)
    └── ProfileEditForm.test.tsx     (42 LOC)

MODIFIED FILES:
  src/features/profile/server/router.ts (+35 LOC)
  src/features/profile/server/router.test.ts (+15 LOC)

───────────────────────────────────────────────────────────

**RULEBOOK Compliance Check:**

✓ Framework: Next.js App Router pattern followed
✓ State: TanStack Query used for server state
✓ Styling: Shadcn/ui components + Tailwind
✓ Testing: Vitest + Testing Library, 85% > 80% target
✓ Code Quality: ESLint passing, no TypeScript errors
✓ Accessibility: ARIA labels, keyboard navigation
✓ Performance: Client components optimized

───────────────────────────────────────────────────────────

**Code Quality Metrics:**

Cyclomatic Complexity: 3 (target: < 10) ✓
Type Safety: 100% ✓
Code Duplication: 0% ✓
Security: No vulnerabilities detected ✓

───────────────────────────────────────────────────────────

**Agent Review Results:**

code-reviewer: ✓ Approved
  - Clean code structure
  - Proper error handling
  - Good test coverage

test-strategist: ✓ Approved
  - Edge cases covered
  - Integration tests included
  - Performance tested

───────────────────────────────────────────────────────────

Please review the changes above.

Feedback? Type your comments or "looks good" to proceed to commit.

═══════════════════════════════════════════════════════════
```

---

## Example 4: 📦 COMMIT MODE

**Scenario**: User approved changes, ready to commit

```
═══════════════════════════════════════════════════════════
📦 COMMIT MODE ACTIVE
───────────────────────────────────────────────────────────

**Analyzing Git History:**

Recent commits (git log --oneline -5):
  a1b2c3d feat: add user authentication flow
  d4e5f6g fix: resolve dashboard loading issue
  g7h8i9j refactor: extract profile components
  j0k1l2m docs: update README with deployment steps
  m3n4o5p feat: implement user dashboard

Detected commit style:
  - Conventional Commits (feat/fix/refactor/docs)
  - Lowercase prefix
  - Concise subject line
  - No body for simple changes

───────────────────────────────────────────────────────────

**Proposed Commit:**

Type: feat (new feature)
Scope: profile
Subject: add profile editing functionality

Full commit message:
```
feat(profile): add profile editing functionality

- Create ProfileEditForm component with validation
- Add user.updateProfile tRPC mutation
- Style with Shadcn/ui + Tailwind
- Add comprehensive test coverage (85%)
- Ensure WCAG 2.1 AA accessibility compliance

```

───────────────────────────────────────────────────────────

**Files to be committed:**

M  src/features/profile/server/router.ts
M  src/features/profile/server/router.test.ts
A  src/features/profile/components/ProfileEditForm/index.tsx
A  src/features/profile/components/ProfileEditForm/schema.ts
A  src/features/profile/components/ProfileEditForm/ProfileEditForm.test.tsx

5 files changed, 187 insertions(+)

───────────────────────────────────────────────────────────

Ready to commit? Type "yes" or "commit" to proceed.

═══════════════════════════════════════════════════════════
```

---

## Common Patterns Across Examples

### Mode Indicators
- Always show clear visual separators
- Include task/step context
- Show progress when applicable

### Agent Involvement
- **Planning**: architecture-advisor, relevant specialists
- **Development**: Specialists execute, Maestro coordinates
- **Review**: code-reviewer, test-strategist validate
- **Commit**: git-workflow-specialist (if complex gitflow)

### User Approval Gates
- Planning → Development: User says "ok", "proceed", "let's do it"
- Development → Review: Automatic when all steps complete
- Review → Commit: User says "looks good", "approved"
- Commit → Done: User says "yes", "commit"

### Complexity-Based Variations

**Trivial Tasks** (< 50 LOC):
- May skip Planning Mode
- Minimal agent involvement
- Fast-track to Commit

**Simple Tasks** (50-150 LOC):
- Lightweight planning
- 1-2 agents
- Standard flow

**Moderate Tasks** (150-300 LOC):
- Full planning with questions
- 3-5 agents
- Complete workflow (as shown in examples)

**Complex Tasks** (300-500 LOC):
- Detailed planning with risk assessment
- 5-10 agents in phases
- Extended review phase

**Critical Tasks** (> 500 LOC or high risk):
- Comprehensive planning with alternatives
- 10+ agents in coordinated phases
- Multiple review iterations
- Security audits

---

**For mode transition rules and best practices, see `workflow-modes.md`.**
