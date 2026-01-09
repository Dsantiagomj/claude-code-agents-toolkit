# Maestro Workflow V2 - Examples & Scenarios

**Purpose**: Practical examples of the 2-state workflow in action.

**Reference**: See `workflow-maestro-v2.md` for complete workflow documentation.

---

## Table of Contents

1. [Example 1: Simple Feature - Add Dark Mode Toggle](#example-1-simple-feature---add-dark-mode-toggle)
2. [Example 2: Moderate Feature - User Profile Editing](#example-2-moderate-feature---user-profile-editing)
3. [Example 3: Complex Feature with User Feedback](#example-3-complex-feature-with-user-feedback)
4. [Example 4: Handling Plan Changes Mid-Execution](#example-4-handling-plan-changes-mid-execution)
5. [Example 5: Handling Blocking Issues](#example-5-handling-blocking-issues)
6. [Example 6: Multiple Tasks in Sequence](#example-6-multiple-tasks-in-sequence)

---

## Example 1: Simple Feature - Add Dark Mode Toggle

### User Request
```
User: "Add a dark mode toggle to the settings page"
```

### 📋 PLANNING STATE

```
═══════════════════════════════════════════════════════════
📋 PLANNING STATE ACTIVE
───────────────────────────────────────────────────────────
Task: Add dark mode toggle to settings page
═══════════════════════════════════════════════════════════
```

**Step 1: Load Project Context**
```bash
Reading .claude/RULEBOOK.md...
✓ Framework: Next.js 15 App Router
✓ State Management: Zustand
✓ Styling: Tailwind CSS 4.0
✓ Testing: Vitest + React Testing Library
✓ Target Coverage: 80%
```

**Step 2: Analyze Task**
```
Complexity: Simple
Files affected: 3-4
Existing patterns: Found theme hook usage in codebase
Dependencies: None (Tailwind dark mode already configured)
```

**Step 3: Fetch Documentation**
```bash
Documentation source: context7 (verified during startup check)

Using context7 MCP server...
✓ Fetched: "Tailwind CSS 4.0 dark mode configuration"
✓ Fetched: "Zustand persist middleware API"

Key patterns identified:
- Use dark: prefix for dark mode styles
- Store theme in localStorage via Zustand persist
- Use useTheme hook pattern
```

**NOTE**: If context7 was not available, this step would use WebSearch instead:
```bash
Documentation source: WebSearch (context7 not available)

Using WebSearch...
✓ Searched: "Tailwind CSS 4.0 dark mode configuration 2026"
✓ Searched: "Zustand persist middleware API docs"

[Same patterns would be identified from search results]
```

**Step 4: Select Agents**
```markdown
Planning Phase:
- (none needed - straightforward task)

Implementation Phase:
- next-specialist
- code-reviewer

Quality Assurance Phase:
- test-strategist

Git Phase:
- (manual - simple commit)

Total agents: 3
```

**Step 5: Create Implementation Plan**
```markdown
Phase 1: Setup (Steps 1-2)
- 1.1: Create theme store with Zustand → useThemeStore.ts
- 1.2: Add theme toggle component → ThemeToggle.tsx

Phase 2: Integration (Step 3)
- 2.1: Add toggle to settings page → app/settings/page.tsx

Phase 3: Testing (Steps 4-5)
- 3.1: Unit tests for theme store → useThemeStore.test.ts
- 3.2: Component tests for toggle → ThemeToggle.test.tsx

Total Steps: 5
```

**Step 6: Questions**
```
No questions needed - requirements are clear.
```

**Step 7: Validate Against RULEBOOK**
```
✅ Follows Zustand pattern for state
✅ Uses Tailwind for styling
✅ Includes test requirements
✅ File naming follows conventions
```

**Step 8: Create Temporal Reference**
```bash
Created: .claude/CURRENT_PLAN.md

Contents include:
- Project context (Next.js 15, Zustand, Tailwind)
- Documentation references (Tailwind dark mode, Zustand persist)
- Complete 5-step plan
- Expected outcomes
```

**Step 9: Present Plan**
```
═══════════════════════════════════════════════════════════
📋 PLANNING COMPLETE
───────────────────────────────────────────────────────────
Task: Add dark mode toggle to settings page
Complexity: Simple
Total Steps: 5
Agents: 3 agents selected
Documentation: ✅ Latest Tailwind & Zustand docs validated
───────────────────────────────────────────────────────────

IMPLEMENTATION PLAN:

Phase 1: Setup
  1.1: Create theme store with Zustand persist
  1.2: Create ThemeToggle component with sun/moon icons

Phase 2: Integration
  2.1: Add toggle to settings page

Phase 3: Testing
  3.1: Unit tests for theme store (toggleTheme, persist)
  3.2: Component tests for ThemeToggle (click, rendering)

AGENTS TO BE INVOKED:
- Implementation: next-specialist, code-reviewer
- Quality: test-strategist

EXPECTED OUTCOMES:
- Files created: 4 (store, component, 2 test files)
- Files modified: 1 (settings page)
- Test coverage: 85%+

───────────────────────────────────────────────────────────
This plan has been saved to .claude/CURRENT_PLAN.md

Ready to proceed? (Say "ok" or "proceed")
═══════════════════════════════════════════════════════════
```

### User Approval
```
User: "ok, let's do it"
```

---

### ⚙️ EXECUTION STATE

```
═══════════════════════════════════════════════════════════
⚙️ EXECUTION STATE ACTIVE
───────────────────────────────────────────────────────────
Progress: Step 1/5
Current Phase: Phase 1 - Setup
═══════════════════════════════════════════════════════════
```

**Loading Temporal Reference**
```bash
Reading .claude/CURRENT_PLAN.md...
✓ Loaded complete plan
✓ Loaded RULEBOOK context
✓ Loaded documentation references
```

**Executing Phase 1: Setup**

```
───────────────────────────────────────────────────────────
Step 1.1: Create theme store with Zustand persist
───────────────────────────────────────────────────────────
Creating: src/stores/useThemeStore.ts

Using patterns from documentation:
- Zustand create + persist middleware
- localStorage key: 'theme-storage'
- TypeScript types for theme state

✅ Step 1.1 complete - Theme store created
```

```
───────────────────────────────────────────────────────────
Step 1.2: Create ThemeToggle component
───────────────────────────────────────────────────────────
Creating: src/components/ThemeToggle.tsx

Using patterns:
- Tailwind dark: classes
- Lucide icons (Sun/Moon)
- Accessibility: aria-label, role="button"

✅ Step 1.2 complete - ThemeToggle component created
```

**Executing Phase 2: Integration**

```
───────────────────────────────────────────────────────────
Step 2.1: Add toggle to settings page
───────────────────────────────────────────────────────────
Modifying: app/settings/page.tsx

Adding ThemeToggle to page layout

✅ Step 2.1 complete - Toggle integrated in settings
```

**Executing Phase 3: Testing**

```
───────────────────────────────────────────────────────────
Step 3.1: Unit tests for theme store
───────────────────────────────────────────────────────────
Creating: src/stores/useThemeStore.test.ts

Tests:
- Initial state is 'light'
- toggleTheme switches between light/dark
- Theme persists in localStorage

Running tests... ✅ All tests passing
Coverage: 100% for theme store

✅ Step 3.1 complete
```

```
───────────────────────────────────────────────────────────
Step 3.2: Component tests for ThemeToggle
───────────────────────────────────────────────────────────
Creating: src/components/ThemeToggle.test.tsx

Tests:
- Renders with correct icon based on theme
- Clicking toggles theme
- Aria labels present

Running tests... ✅ All tests passing
Coverage: 95% for ThemeToggle

✅ Step 3.2 complete
```

**Final Validation**
```bash
✓ All 5 steps completed
✓ All tests passing (8 tests)
✓ Coverage: 97% (exceeds 80% target)
✓ RULEBOOK compliance verified
✓ No TypeScript errors
```

**Completion Summary**
```
═══════════════════════════════════════════════════════════
✅ EXECUTION COMPLETE
───────────────────────────────────────────────────────────
Task: Add dark mode toggle to settings page
All steps: ✅ Completed (5/5)

SUMMARY:

Files Created: (4)
- src/stores/useThemeStore.ts:1-25
- src/components/ThemeToggle.tsx:1-35
- src/stores/useThemeStore.test.ts:1-40
- src/components/ThemeToggle.test.tsx:1-45

Files Modified: (1)
- app/settings/page.tsx:15-20 (added ThemeToggle)

Tests Added: (8)
- Theme store: 3 tests (100% coverage)
- ThemeToggle: 5 tests (95% coverage)

Test Results:
✅ All 8 tests passing
✅ Coverage: 97% (target: 80%)

RULEBOOK Compliance:
✅ Zustand pattern followed
✅ Tailwind styling used
✅ File naming conventions met
✅ Testing requirements exceeded
✅ TypeScript strict mode passed

───────────────────────────────────────────────────────────
Ready to commit? I'll analyze your git history and prepare
a commit message following your project's style.
═══════════════════════════════════════════════════════════
```

### User Approval for Commit
```
User: "yes, commit"
```

**Git Workflow**
```bash
Running: git status
Modified: 5 files

Running: git log --oneline -5
Analyzing commit style...
Detected: Conventional Commits (feat/fix/chore)

Proposed commit:
═══════════════════════════════════════════════════════════
📦 PROPOSED COMMIT
───────────────────────────────────────────────────────────
feat(settings): add dark mode toggle

- Add Zustand theme store with localStorage persist
- Create ThemeToggle component with sun/moon icons
- Integrate toggle in settings page
- Add comprehensive tests (97% coverage)

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
───────────────────────────────────────────────────────────
Files to commit:
  src/stores/useThemeStore.ts
  src/components/ThemeToggle.tsx
  src/stores/useThemeStore.test.ts
  src/components/ThemeToggle.test.tsx
  app/settings/page.tsx

Ready to commit? (say "yes" or "commit")
═══════════════════════════════════════════════════════════
```

```
User: "commit"
```

```bash
Executing: git add . && git commit -m "..."
✅ Commit created successfully
```

**Cleanup**
```bash
Deleting: .claude/CURRENT_PLAN.md
✅ Temporal reference cleaned up
```

**Ready for Next Task**
```
═══════════════════════════════════════════════════════════
🎯 TASK COMPLETE - READY FOR NEXT TASK
───────────────────────────────────────────────────────────
Previous task: ✅ Add dark mode toggle to settings page
Temporal reference: 🗑️ Cleaned up
State: 🟢 Ready

What's next?
═══════════════════════════════════════════════════════════
```

---

## Example 2: Moderate Feature - User Profile Editing

### User Request
```
User: "Add user profile editing with avatar upload"
```

### 📋 PLANNING STATE

```
═══════════════════════════════════════════════════════════
📋 PLANNING STATE ACTIVE
───────────────────────────────────────────────────────────
Task: Add user profile editing with avatar upload
═══════════════════════════════════════════════════════════
```

**Steps 1-3: Load Context, Analyze, Fetch Docs**
```bash
RULEBOOK: Next.js 15, Prisma, NextAuth, S3 for file storage
Complexity: Moderate (8 files, 200+ LOC)
Documentation: Next.js 15 Server Actions, AWS S3 SDK, NextAuth session
```

**Step 4: Select Agents**
```markdown
Planning Phase:
- architecture-advisor (design S3 integration)

Implementation Phase:
- next-specialist
- database-specialist (Prisma schema)
- security-auditor (file upload validation)

Quality Assurance Phase:
- test-strategist
- code-reviewer

Total agents: 6
```

**Step 5: Create Plan**
```markdown
Phase 1: Database & Schema (Steps 1-2)
- 1.1: Update User model in Prisma schema
- 1.2: Create and run migration

Phase 2: File Upload (Steps 3-4)
- 2.1: Create S3 upload utility
- 2.2: Create avatar upload API route

Phase 3: Profile Form (Steps 5-6)
- 3.1: Create ProfileForm component
- 3.2: Create profile update API route

Phase 4: Integration (Step 7)
- 4.1: Add profile page with form

Phase 5: Testing (Steps 8-10)
- 5.1: Unit tests for S3 utility
- 5.2: API route tests
- 5.3: Component integration tests

Total Steps: 10
```

**Step 6: Questions**
```
Questions before we proceed:

1. What image formats should we accept for avatars?
   (e.g., JPEG, PNG, WebP)

2. What's the maximum file size for avatar uploads?
   (e.g., 2MB, 5MB)

3. Should we generate thumbnails or use the original?

Please answer so I can finalize the plan.
```

### User Answers
```
User: "JPEG and PNG only, 2MB max, generate 200x200 thumbnail"
```

**Step 7: Validate & Step 8: Create Temporal Reference**
```bash
✅ Plan validated against RULEBOOK
✅ Created .claude/CURRENT_PLAN.md with user's answers
```

**Step 9: Present Plan**
```
═══════════════════════════════════════════════════════════
📋 PLANNING COMPLETE
───────────────────────────────────────────────────────────
Task: Add user profile editing with avatar upload
Complexity: Moderate
Total Steps: 10
Agents: 6 agents selected
User Preferences: JPEG/PNG, 2MB max, 200x200 thumbnail
───────────────────────────────────────────────────────────

[Full plan presented...]

Ready to proceed?
═══════════════════════════════════════════════════════════
```

```
User: "proceed"
```

---

### ⚙️ EXECUTION STATE

*(Execution follows similar pattern as Example 1, but with 10 steps across 5 phases)*

**Key difference: More agents involved**

```
Step 2.1: Create S3 upload utility
───────────────────────────────────────────────────────────
Delegating to security-auditor for file validation logic...

Agent response:
✓ Validate MIME type (image/jpeg, image/png only)
✓ Validate file size (max 2MB)
✓ Generate unique filename with UUID
✓ Scan for malicious content

Creating: src/lib/s3-upload.ts
✅ Step 2.1 complete
```

*(Continue through all 10 steps, showing progress, then complete)*

---

## Example 3: Complex Feature with User Feedback

### Scenario: User Provides Feedback During Execution

**Context**: Implementing authentication system, currently at Step 5/15

```
═══════════════════════════════════════════════════════════
⚙️ EXECUTION STATE ACTIVE
───────────────────────────────────────────────────────────
Progress: Step 5/15 - Create login form component
Current Phase: Phase 2 - Core Implementation
═══════════════════════════════════════════════════════════
```

**Step 5: Creating login form**
```
Creating: src/components/auth/LoginForm.tsx

Fields:
- Email (with validation)
- Password (with show/hide toggle)
- Remember me checkbox
- Submit button

✅ Step 5/15 complete
```

**User Provides Feedback (Type A: Minor)**
```
User: "Can you add a 'Forgot password?' link below the form?"
```

**Maestro Response**
```
Sure! That's a minor addition to the form. Adding it now.

Updating: src/components/auth/LoginForm.tsx
Added: Forgot password link → /auth/forgot-password

Continuing with Step 6...
```

---

**Later, at Step 9/15...**

```
═══════════════════════════════════════════════════════════
⚙️ EXECUTION STATE ACTIVE
───────────────────────────────────────────────────────────
Progress: Step 9/15 - Setting up OAuth providers
Current Phase: Phase 3 - OAuth Integration
═══════════════════════════════════════════════════════════
```

**User Provides Feedback (Type B: Plan Change)**
```
User: "Actually, let's skip Google OAuth for now. Just do GitHub OAuth."
```

**Maestro Response**
```
───────────────────────────────────────────────────────────
⚠️ PLAN CHANGE DETECTED
───────────────────────────────────────────────────────────
You're requesting to skip Google OAuth.

Current plan includes:
- Step 9: Setup Google OAuth
- Step 10: Setup GitHub OAuth
- Step 11: Create OAuth callback handler

Options:
a) Update plan now (remove Google OAuth steps)
b) Complete current plan, handle as separate task later

Which would you prefer?
───────────────────────────────────────────────────────────
```

```
User: "Option a, update the plan"
```

**Maestro Updates Plan**
```
Updating: .claude/CURRENT_PLAN.md

Changes:
- ❌ Removed: Step 9 (Google OAuth)
- ✓ Updated: Step 10 → Now Step 9 (GitHub OAuth only)
- ✓ Updated: Step 11 → Now Step 10 (OAuth callback)
- Total steps: 15 → 14

Updated plan:
═══════════════════════════════════════════════════════════
📋 UPDATED PLAN
───────────────────────────────────────────────────────────
Removed Google OAuth integration
Now focusing on GitHub OAuth only

Phase 3 (updated):
  Step 9: Setup GitHub OAuth (was 10)
  Step 10: Create OAuth callback handler (was 11)

Total steps: 14 (was 15)
───────────────────────────────────────────────────────────

Continuing with updated plan...
```

**Execution Continues with Updated Plan**
```
Step 9/14: Setup GitHub OAuth
Creating: src/lib/auth/github.ts
...
```

---

## Example 4: Handling Plan Changes Mid-Execution

### Scenario: User Wants to Add New Feature Mid-Execution

**Context**: Adding blog post editor, currently at Step 6/8

```
User: "Also add a preview mode toggle to the editor"
```

**Maestro Response**
```
───────────────────────────────────────────────────────────
⚠️ PLAN CHANGE DETECTED
───────────────────────────────────────────────────────────
You want to add: Preview mode toggle

Current progress: Step 6/8 complete
Remaining: Steps 7-8

This is a new feature that affects multiple steps.

Options:
a) Pause current execution, update plan to include preview mode
b) Complete current 8 steps first, then handle preview mode as new task
c) Quick implementation: Add basic toggle now, enhance later

Which approach do you prefer?
───────────────────────────────────────────────────────────
```

```
User: "Option a - add it properly to the plan"
```

**Maestro Updates Plan**
```
Pausing execution at step 6/8.

Analyzing preview mode requirements...
- Affects: Editor component, state management
- New steps needed: 3
- Files to modify: 2

Updating: .claude/CURRENT_PLAN.md

═══════════════════════════════════════════════════════════
📋 UPDATED PLAN
───────────────────────────────────────────────────────────
Added preview mode feature

New steps inserted:
  Step 7: Add preview state to editor store
  Step 8: Create preview toggle UI
  Step 9: Implement preview rendering

Old steps renumbered:
  Step 7 → Step 10 (Add tests)
  Step 8 → Step 11 (Documentation)

Total steps: 8 → 11
───────────────────────────────────────────────────────────

Ready to continue with updated plan?
```

```
User: "yes, continue"
```

**Execution Resumes**
```
═══════════════════════════════════════════════════════════
⚙️ EXECUTION STATE ACTIVE (RESUMED)
───────────────────────────────────────────────────────────
Progress: Step 7/11 - Add preview state to editor store
Current Phase: Phase 2 - Editor Features
───────────────────────────────────────────────────────────

Continuing with updated plan...
```

---

## Example 5: Handling Blocking Issues

### Scenario: Dependency Missing During Execution

**Context**: Implementing real-time notifications, Step 4/12

```
Step 4/12: Setup WebSocket connection
───────────────────────────────────────────────────────────

Checking dependencies...
❌ Error: 'ws' package not installed

───────────────────────────────────────────────────────────
⚠️ BLOCKING ISSUE DETECTED
───────────────────────────────────────────────────────────
Issue: Required package 'ws' is not installed

Current step requires: WebSocket server setup
Cannot proceed without: ws package

Options:
a) Install 'ws' package now and continue
b) Use alternative: Socket.io (already installed)
c) Skip WebSocket for now, continue with other steps

Recommendation: Option b (Socket.io) - it's already installed
and provides better browser compatibility.

What would you like to do?
───────────────────────────────────────────────────────────
```

```
User: "Use Socket.io"
```

**Maestro Updates Approach**
```
Updating: .claude/CURRENT_PLAN.md

Changed approach for real-time:
- ❌ ws package → ✅ Socket.io
- Updated steps 4-6 to use Socket.io instead

Continuing with Step 4 (updated approach)...

Step 4/12: Setup Socket.io connection
───────────────────────────────────────────────────────────
Using Socket.io for WebSocket connections
...
✅ Step 4/12 complete
```

---

## Example 6: Multiple Tasks in Sequence

### Scenario: User Requests Multiple Features

```
User: "Add user roles (admin/user), then add a admin dashboard"
```

**Maestro Response**
```
I see two distinct tasks here:
1. Add user roles system
2. Create admin dashboard (depends on #1)

I'll handle these sequentially. Starting with Task 1.

═══════════════════════════════════════════════════════════
📋 PLANNING STATE ACTIVE - Task 1/2
───────────────────────────────────────────────────────────
Task: Add user roles system (admin/user)
═══════════════════════════════════════════════════════════

[Complete planning process for Task 1...]
```

**After Task 1 Completes**
```
═══════════════════════════════════════════════════════════
✅ TASK 1 COMPLETE
───────────────────────────────────────────────────────────
User roles system: ✅ Implemented and tested

Moving to Task 2...

═══════════════════════════════════════════════════════════
📋 PLANNING STATE ACTIVE - Task 2/2
───────────────────────────────────────────────────────────
Task: Create admin dashboard
Dependencies: Uses roles from Task 1
═══════════════════════════════════════════════════════════

[Complete planning process for Task 2...]
```

---

## Key Takeaways from Examples

### Context Preservation Works
- Temporal reference keeps all context in `.claude/CURRENT_PLAN.md`
- Can pause, update, resume without losing information
- User feedback is handled systematically

### Clear State Indicators
- User always knows: PLANNING or EXECUTION
- Progress is always visible (Step X/Y)
- No confusion about current state

### Flexible Execution
- Minor feedback: Applied immediately
- Plan changes: Pause → Update → Resume
- Blocking issues: Propose solutions → Get decision → Continue

### Predictable Flow
- Same inputs + same plan = same outputs
- Easy to understand what's happening
- Clear transition points

### No Context Loss
- Even with multiple user interactions
- Even with plan changes
- Even with blocking issues
- Temporal reference is the single source of truth

---

**End of Examples**
