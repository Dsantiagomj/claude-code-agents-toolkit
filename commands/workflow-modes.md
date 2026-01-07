# Workflow Modes - Structured Development Process

**Purpose**: Define clear modes for task execution to ensure quality, clarity, and proper process.

**Integration**: Works with Maestro Mode and Agent Intelligence to provide structured development workflow.

---

## Overview

Every task goes through **4 distinct modes**:

```
📋 PLANNING MODE → 💻 DEVELOPMENT MODE → 🔍 REVIEW MODE → 📦 COMMIT MODE
```

Each mode has:
- Clear **entry conditions**
- Specific **responsibilities**
- Explicit **exit criteria**
- User **approval gates**

---

## Mode 1: 📋 PLANNING MODE

### When to Enter
- **Automatically** when user requests a new task/feature
- **Manually** when user says "plan this" or "let's plan"

### Mode Indicator
```
═══════════════════════════════════════════════════════════
📋 PLANNING MODE ACTIVE
───────────────────────────────────────────────────────────
Task: [Description]
Complexity: [Trivial/Simple/Moderate/Complex/Critical]
───────────────────────────────────────────────────────────
```

### Responsibilities

**1. Understand the Task**
```markdown
**Task Analysis:**
- What: [What user wants to achieve]
- Why: [Business/technical reasoning]
- Scope: [What's included, what's not]
- Dependencies: [Existing code, external services]
```

**2. Check Project Context**
```bash
# Read project standards
Read .claude/RULEBOOK.md

# Check existing patterns
Grep [relevant patterns]
Glob **/*[similar files]*

# Understand current structure
Read [related files]
```

**3. Assess Complexity**
```yaml
Complexity Assessment:
  Lines of Code: [estimate]
  Files Affected: [count]
  New Patterns: [yes/no]
  Risk Level: [low/medium/high/critical]

  → Complexity: [Trivial/Simple/Moderate/Complex/Critical]
```

**4. Select Agents**
```yaml
Recommended Agents (based on .claude/RULEBOOK.md):
  Phase 1 - Design:
    - architecture-advisor: [specific task]
    - [other agents]: [specific tasks]

  Phase 2 - Implementation:
    - [framework-specialist]: [specific task]
    - [language-specialist]: [specific task]

  Phase 3 - Quality:
    - test-strategist: [specific task]
    - code-reviewer: [specific task]

Total Agents: [count]
Estimated Time: [hours]
```

**5. Create Step-by-Step Plan**
```markdown
**Development Plan:**

**Step 1: [Name]** (Estimated: Xmin)
- Task: [Detailed description]
- Files: [Files to create/modify]
- Agent: [Agent to use, if any]
- Output: [Expected result]

**Step 2: [Name]** (Estimated: Xmin)
- Task: [Detailed description]
- Files: [Files to create/modify]
- Agent: [Agent to use, if any]
- Output: [Expected result]

[Continue for all steps...]

**Total Estimated Time:** [sum of all steps]
```

**6. Ask Clarifying Questions**
```markdown
**Questions Before We Proceed:**

1. [Question about scope/requirements]
2. [Question about preferences/approach]
3. [Question about edge cases/constraints]

Please provide input to refine the plan.
```

### Exit Criteria

User must provide:
- ✅ Answers to clarifying questions (if any)
- ✅ Approval of the plan: "ok", "proceed", "let's do it", "go ahead"
- ✅ OR: Modifications to the plan

### Example Planning Mode Output

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

## Mode 2: 💻 DEVELOPMENT MODE

### When to Enter
- After user approves the plan from Planning Mode
- User says: "ok", "proceed", "let's do it", "approved"

### Mode Indicator
```
═══════════════════════════════════════════════════════════
💻 DEVELOPMENT MODE ACTIVE
───────────────────────────────────────────────────────────
Following plan from Planning Mode
Progress: Step X of Y
───────────────────────────────────────────────────────────
```

### Responsibilities

**1. Execute Plan Step by Step**
```markdown
💻 Development Mode: Step X of Y

**Current Step:** [Step name]
**Agent:** [Agent being used]
**Task:** [What I'm doing now]

[Show progress/output]

✓ Step X complete
→ Moving to Step X+1...
```

**2. Follow RULEBOOK Strictly**
- Read `.claude/RULEBOOK.md` before each step
- Follow project patterns exactly
- Use project's tech stack
- Respect coding standards

**3. Delegate to Agents (if planned)**
```markdown
Delegating to [agent-name]:
- Task: [Specific task]
- Expected output: [What we need]
- RULEBOOK requirements: [From project]

[Agent working...]

Agent output received, verifying against RULEBOOK...
✓ Verified, proceeding.
```

**4. Keep User Informed**
```markdown
Progress Update:
✓ Step 1: Create component structure
✓ Step 2: Add form validation
→ Step 3: Add styling (current)
  Step 4: Write tests
  Step 5: Code review
```

**5. Handle Blockers**
```markdown
⚠️ Blocker Encountered in Step X:
Issue: [What's blocking]
Options:
1. [Option 1]
2. [Option 2]

Which approach do you prefer?
```

### Exit Criteria

- ✅ All planned steps completed
- ✅ Code compiles/builds successfully
- ✅ Basic manual testing done (if applicable)
- ✅ Ready for review

**Automatic transition** to Review Mode when complete.

### Example Development Mode Output

```
═══════════════════════════════════════════════════════════
💻 DEVELOPMENT MODE ACTIVE
───────────────────────────────────────────────────────────
Following plan from Planning Mode
Progress: Step 2 of 5
───────────────────────────────────────────────────────────

Progress Update:
✓ Step 1: Create ProfileEditForm component (30min)
  → Created: src/features/profile/components/ProfileEditForm/
  → Files: ProfileEditForm.tsx, ProfileEditForm.types.ts, index.ts
  → Validation: React Hook Form + Zod (per RULEBOOK)

→ Step 2: Add tRPC Mutation (current - 20min estimated)
  Task: Create user.updateProfile procedure
  Reading RULEBOOK for tRPC patterns...

  [Creating mutation...]

  ✓ Created: src/features/profile/server/router.ts
  ✓ Added: updateProfile procedure with auth check
  ✓ Validation: Zod schema matches frontend
  ✓ Error handling: User-friendly messages

  Step 2: ✓ Complete

→ Moving to Step 3: Add Styling...

═══════════════════════════════════════════════════════════
```

---

## Mode 3: 🔍 REVIEW MODE

### When to Enter
- **Automatically** after Development Mode completes
- All code is written and functional

### Mode Indicator
```
═══════════════════════════════════════════════════════════
🔍 REVIEW MODE ACTIVE
───────────────────────────────────────────────────────────
Development complete, awaiting your review and feedback
───────────────────────────────────────────────────────────
```

### Responsibilities

**1. Summary of Changes**
```markdown
**Development Complete! Here's what was built:**

Files Created:
  • src/features/profile/components/ProfileEditForm/
    - ProfileEditForm.tsx (95 lines)
    - ProfileEditForm.types.ts (15 lines)
    - ProfileEditForm.test.tsx (120 lines)
    - index.ts (2 lines)

Files Modified:
  • src/features/profile/server/router.ts (+45 lines)
  • src/features/profile/index.ts (+2 lines)

Total Changes:
  • Files: 6 (4 new, 2 modified)
  • Lines Added: 277
  • Lines Deleted: 0
  • Test Coverage: 85% (exceeds 80% requirement)

**Key Features:**
  ✓ Profile editing form with validation
  ✓ Email change (no verification yet - as discussed)
  ✓ Avatar upload (placeholder - to be implemented)
  ✓ tRPC mutation with auth check
  ✓ Full test coverage
  ✓ RULEBOOK compliant (Zustand + TanStack Query)
```

**2. RULEBOOK Compliance Check**
```markdown
**RULEBOOK Compliance Verification:**

✓ Component Structure: Folder pattern followed
✓ State Management: TanStack Query for mutation
✓ Styling: Shadcn/ui + Tailwind (per priority)
✓ TypeScript: Strict mode, no `any` types
✓ Testing: 85% coverage (exceeds 80% minimum)
✓ Documentation: TSDoc on all functions
✓ Error Handling: User-friendly messages
✓ Accessibility: WCAG 2.1 AA compliant
✓ Responsive: Mobile-first design

All RULEBOOK requirements met ✓
```

**3. Request User Review**
```markdown
**Please Review:**

1. **Functionality**: Does it work as expected?
2. **Code Quality**: Any improvements needed?
3. **Edge Cases**: Any scenarios I missed?
4. **UX/UI**: Happy with the design?

**Your Feedback:**
- What works well?
- What needs changes?
- Any bugs or issues?

Type your feedback, or say "looks good" / "approved" to proceed to commit mode.
```

**4. Handle Feedback**

User provides feedback → Make adjustments → Show changes → Ask for review again

**Loop until user approves:**
```markdown
Feedback received: [User's feedback]

Making adjustments:
1. [Change 1]
2. [Change 2]
...

Changes made. Please review again.
```

### Exit Criteria

User says:
- ✅ "looks good"
- ✅ "todo ok"
- ✅ "approved"
- ✅ "ship it"
- ✅ Any confirmation that review is complete

**Automatic transition** to Commit Mode when approved.

### Example Review Mode Output

```
═══════════════════════════════════════════════════════════
🔍 REVIEW MODE ACTIVE
───────────────────────────────────────────────────────────
Development complete, awaiting your review and feedback
───────────────────────────────────────────────────────────

**Development Complete! Here's what was built:**

Files Created:
  • src/features/profile/components/ProfileEditForm/
    - ProfileEditForm.tsx (95 lines)
    - ProfileEditForm.types.ts (15 lines)
    - ProfileEditForm.test.tsx (120 lines)
    - index.ts (2 lines)

Files Modified:
  • src/features/profile/server/router.ts (+45 lines)
  • src/features/profile/index.ts (+2 lines)

Total Changes:
  • Files: 6 (4 new, 2 modified)
  • Lines Added: 277
  • Test Coverage: 85%

**RULEBOOK Compliance:**
✓ All requirements met

**Please Review:**
1. Test the form: http://localhost:3000/profile/edit
2. Check validation: Try submitting empty/invalid data
3. Verify styling: Check mobile and desktop views

**Your Feedback:**
What do you think? Any changes needed?

Say "looks good" to proceed to commit, or provide feedback for adjustments.

═══════════════════════════════════════════════════════════
```

---

## Mode 4: 📦 COMMIT MODE

### When to Enter
- After user approves in Review Mode
- User confirms ready to commit

### Mode Indicator
```
═══════════════════════════════════════════════════════════
📦 COMMIT MODE ACTIVE
───────────────────────────────────────────────────────────
Preparing final commit
───────────────────────────────────────────────────────────
```

### Responsibilities

**1. Analyze Existing Commit Style**
```bash
# Read recent commits to match style
git log --oneline -10

# Detect commit format:
# - Conventional Commits? (feat:, fix:, etc.)
# - Semantic? (Add, Update, Fix)
# - Custom format?
```

**2. Generate Commit Message**
```markdown
**Generated Commit Message:**

Following project's commit style (Conventional Commits detected):

─────────────────────────────────────────────────────────
feat(profile): add user profile editing functionality

- Create ProfileEditForm component with validation
- Add user.updateProfile tRPC mutation
- Implement email and name editing
- Add responsive styling with Tailwind
- Include full test coverage (85%)

Changes:
- 4 files created (ProfileEditForm component + tests)
- 2 files modified (router.ts, index.ts)
- 277 lines added

Test coverage: 85% (exceeds 80% requirement)
RULEBOOK compliant: All standards met

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
─────────────────────────────────────────────────────────
```

**3. Show Files to Commit**
```bash
Files to be committed:
  new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.tsx
  new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.types.ts
  new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.test.tsx
  new file:   src/features/profile/components/ProfileEditForm/index.ts
  modified:   src/features/profile/server/router.ts
  modified:   src/features/profile/index.ts
```

**4. Request Final Approval**
```markdown
**Ready to Commit:**

Commit message matches your project's style ✓
All files staged ✓

Do you approve this commit?
- Say "yes" or "commit" to create the commit
- Say "edit message" to modify the commit message
- Provide different message if you want to change it
```

**5. Execute Commit (ONLY after approval)**
```bash
# User approved
git add [files]
git commit -m "[message]"

✓ Commit created: [commit hash]
```

**6. Return to Idle**
```markdown
✓ Commit created successfully!
✓ Task complete!

Returning to normal mode. Ready for next task.
```

### Exit Criteria

- ✅ User approves commit message
- ✅ Commit is created
- ✅ Return to idle/normal mode

### Important Rules

**NEVER commit without user approval:**
- ❌ Don't auto-commit
- ❌ Don't commit on "looks good" (that's for Review Mode)
- ✅ Only commit when user explicitly approves in Commit Mode

### Example Commit Mode Output

```
═══════════════════════════════════════════════════════════
📦 COMMIT MODE ACTIVE
───────────────────────────────────────────────────────────
Preparing final commit
───────────────────────────────────────────────────────────

Analyzing project commit style...
✓ Detected: Conventional Commits format

**Generated Commit Message:**

─────────────────────────────────────────────────────────
feat(profile): add user profile editing functionality

- Create ProfileEditForm component with validation
- Add user.updateProfile tRPC mutation
- Implement email and name editing
- Add responsive styling with Tailwind
- Include full test coverage (85%)

RULEBOOK compliant: ✓
Test coverage: 85%

🤖 Generated with Claude Code
Co-Authored-By: Claude <noreply@anthropic.com>
─────────────────────────────────────────────────────────

**Files to be committed:**

new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.tsx
new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.types.ts
new file:   src/features/profile/components/ProfileEditForm/ProfileEditForm.test.tsx
new file:   src/features/profile/components/ProfileEditForm/index.ts
modified:   src/features/profile/server/router.ts
modified:   src/features/profile/index.ts

**Ready to commit?**
- Say "yes" or "commit" to create the commit
- Say "edit message" to modify it
- Or provide your own commit message

═══════════════════════════════════════════════════════════
```

---

## Mode Transitions

```
User: "Add profile editing"
    ↓
[📋 PLANNING MODE]
  → Analyze task
  → Check RULEBOOK
  → Select agents
  → Create plan
  → Ask questions
    ↓
User: "ok, proceed"
    ↓
[💻 DEVELOPMENT MODE]
  → Execute plan
  → Step by step
  → Keep user informed
  → Handle blockers
    ↓
All steps complete
    ↓
[🔍 REVIEW MODE]
  → Show changes
  → RULEBOOK check
  → Request feedback
    ↓
User: "looks good"
    ↓
[📦 COMMIT MODE]
  → Generate commit message
  → Show files
  → Request approval
    ↓
User: "yes, commit"
    ↓
✓ COMMIT CREATED
    ↓
Return to idle mode
```

---

## Integration with Maestro Mode

Add to `maestro.md`:

```markdown
## Workflow Modes

For structured development, use the 4-mode workflow:

1. 📋 Planning Mode: Analyze, plan, get approval
2. 💻 Development Mode: Execute the plan
3. 🔍 Review Mode: Get user feedback, iterate
4. 📦 Commit Mode: Commit with proper message

See `.claude/commands/workflow-modes.md` for details.

**When to use:**
- Any new feature or significant change
- When user asks to "plan this first"
- For complex or critical tasks

**Benefits:**
- Clear communication about what's happening
- User stays in control
- No surprises
- Proper commit messages
- Quality gates at each step
```

---

## Best Practices

### For Planning Mode
✅ Be thorough but concise
✅ Ask specific questions
✅ Show time estimates
✅ Break down into clear steps
❌ Don't assume user knowledge
❌ Don't skip RULEBOOK check

### For Development Mode
✅ Follow the plan exactly
✅ Keep user informed of progress
✅ Show what you're doing
✅ Handle blockers gracefully
❌ Don't deviate from plan without asking
❌ Don't skip steps silently

### For Review Mode
✅ Show complete summary
✅ Verify RULEBOOK compliance
✅ Ask for specific feedback
✅ Make requested changes
❌ Don't assume approval
❌ Don't skip showing changes

### For Commit Mode
✅ Match project's commit style
✅ Show exactly what will be committed
✅ Get explicit approval
✅ Create meaningful commit messages
❌ NEVER auto-commit
❌ Don't commit on "looks good" from Review Mode

---

## Summary

**4 Modes, Clear Process:**
- 📋 Planning: Think before coding
- 💻 Development: Execute with clarity
- 🔍 Review: Quality and feedback
- 📦 Commit: Proper commits

**Benefits:**
- User always knows what mode you're in
- Clear communication at each step
- Quality gates prevent issues
- Proper commit history
- Professional workflow

**Remember:**
- Each mode has a purpose
- Get approval before transitions
- Never skip modes
- Always indicate current mode clearly

---

**Workflow Modes ready. Structure. Clarity. Quality. 💪**
