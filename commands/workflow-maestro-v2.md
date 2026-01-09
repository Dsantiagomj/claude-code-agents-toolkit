# Maestro Workflow V2 - Simplified 2-State Model

**Purpose**: Simplified, context-preserving workflow with 2 clear states and temporal reference management.

**Problem Solved**: The previous 4-mode workflow lost context after multiple user interactions, especially in steps 2-3 (Development/Review). This new workflow maintains a temporal reference as the source of truth throughout execution.

---

## Overview

Every task goes through **2 distinct states**:

```
📋 PLANNING → ⚙️ EXECUTION
```

### Key Innovation: Temporal Reference

During PLANNING, we create a **temporal reference file** (`.claude/CURRENT_PLAN.md`) that contains:
- Complete implementation plan
- Selected agents
- Documentation references (from context7/websearch)
- RULEBOOK validation
- Expected outcomes

This temporal reference becomes the **single source of truth** during EXECUTION, preventing context loss.

---

## State 1: 📋 PLANNING

### Entry Conditions
- User requests a new task/feature
- User says "plan this" or "let's plan"
- Starting work on a new requirement

### State Indicator
```
═══════════════════════════════════════════════════════════
📋 PLANNING STATE ACTIVE
───────────────────────────────────────────────────────────
Task: [Brief description]
───────────────────────────────────────────────────────────
```

### Workflow Steps

#### Step 1: Load Project Context
```bash
1. Read .claude/RULEBOOK.md
2. Parse tech stack, patterns, conventions
3. Identify active agents for this project
4. Store as base context
```

#### Step 2: Analyze Task
```bash
1. Understand user's request
2. Identify scope and dependencies
3. Assess complexity (Trivial/Simple/Moderate/Complex/Critical)
4. Identify files that will be affected (Grep/Glob)
5. Check existing patterns in codebase
```

#### Step 3: Fetch Latest Documentation
**CRITICAL**: Before planning implementation, fetch current documentation.

**NOTE**: Documentation source was determined during startup check (Step 4 of "RULEBOOK & CONTEXT7 VERIFICATION ON FIRST INTERACTION").

```bash
# If context7 is available (from startup check):
Use context7 to fetch documentation for:
- Primary framework (e.g., "Next.js 15 App Router API")
- Relevant libraries (e.g., "React 19 Server Components")
- Database/ORM if applicable (e.g., "Prisma 5.x latest")

# If context7 is NOT available (use WebSearch fallback):
Use WebSearch to find:
- Official documentation (2026 version)
- Best practices for current year
- Breaking changes from previous versions

# Store: Create summary of relevant patterns/APIs for this task
```

**Why this matters:**
- Your training data is from January 2025
- We are now in 2026
- APIs, patterns, and best practices have evolved
- Without current docs, you'll use outdated patterns

**Documentation source priority:**
1. context7 MCP server (preferred - more accurate and structured)
2. WebSearch (fallback - if context7 unavailable)

#### Step 4: Select Agents
Based on RULEBOOK and task complexity, determine which agents will be used:

```markdown
### Agent Selection

**Planning Phase:**
- architecture-advisor (if architectural decisions needed)
- [framework]-specialist (based on RULEBOOK tech stack)

**Implementation Phase:**
- [framework]-specialist
- code-reviewer
- test-strategist

**Quality Assurance Phase:**
- security-auditor (if applicable)
- performance-optimizer (if applicable)

**Git Phase:**
- git-workflow-specialist

Total agents: [count]
```

#### Step 5: Create Implementation Plan
Create detailed, step-by-step plan:

```markdown
### Implementation Plan

**Phase 1: Preparation**
- Step 1.1: [Action] → Files: [list] → Agent: [name]
- Step 1.2: [Action] → Files: [list] → Agent: [name]

**Phase 2: Core Implementation**
- Step 2.1: [Action] → Files: [list] → Agent: [name]
- Step 2.2: [Action] → Files: [list] → Agent: [name]

**Phase 3: Testing & Validation**
- Step 3.1: [Action] → Files: [list] → Agent: [name]
- Step 3.2: [Action] → Files: [list] → Agent: [name]

**Phase 4: Documentation & Cleanup**
- Step 4.1: [Action] → Files: [list] → Agent: [name]

**Total Steps**: [count]
```

#### Step 6: Ask Clarifying Questions
If anything is unclear or needs user input:

```markdown
### Questions

1. [Question about approach/preference]
2. [Question about requirements]
3. [Question about constraints]

Please answer these questions so I can finalize the plan.
```

**CRITICAL**: WAIT for user response. Do NOT proceed until questions are answered.

#### Step 7: Validate Against RULEBOOK
```bash
1. Check plan follows RULEBOOK patterns
2. Verify selected agents match RULEBOOK active agents
3. Ensure conventions are respected
4. Confirm no anti-patterns are used
5. Document validation results
```

#### Step 8: Create Temporal Reference
Write everything to `.claude/CURRENT_PLAN.md`:

```markdown
# Current Task Plan

**Task**: [User's request]
**Created**: [timestamp]
**Status**: PLANNING → EXECUTION

---

## Context

### Project (from RULEBOOK)
- **Framework**: [from RULEBOOK]
- **Language**: [from RULEBOOK]
- **State Management**: [from RULEBOOK]
- **Testing Framework**: [from RULEBOOK]
- **Styling**: [from RULEBOOK]

### Documentation References
- [Framework]: [Summary of relevant docs from context7/websearch]
- [Library]: [Summary of relevant docs]
- Key patterns to use: [list]
- Deprecated patterns to avoid: [list]

---

## Selected Agents

### Planning
- [agent-name]: [role]

### Implementation
- [agent-name]: [role]

### Quality Assurance
- [agent-name]: [role]

### Git
- [agent-name]: [role]

---

## Implementation Plan

[Paste the detailed plan from Step 5]

---

## RULEBOOK Validation

- ✅ Follows project structure conventions
- ✅ Uses approved state management pattern
- ✅ Includes testing requirements (coverage: [X]%)
- ✅ Follows naming conventions
- ✅ Security requirements met
- ✅ Performance targets considered

---

## Expected Outcomes

### Files Created
- [file1]: [purpose]
- [file2]: [purpose]

### Files Modified
- [file1]: [what will change]
- [file2]: [what will change]

### Tests Added
- [test1]: [coverage]
- [test2]: [coverage]

### Success Criteria
- [ ] All steps completed
- [ ] Tests passing
- [ ] RULEBOOK compliance verified
- [ ] No regressions introduced
- [ ] Documentation updated

---

## User Approvals

### Planning Approval
- Date: [pending]
- User response: [pending]

### Execution Completion
- Date: [pending]
- User feedback: [pending]
```

#### Step 9: Present Plan to User
Show the complete plan and ask for approval:

```
═══════════════════════════════════════════════════════════
📋 PLANNING COMPLETE
───────────────────────────────────────────────────────────
Task: [description]
Complexity: [level]
Total Steps: [count]
Agents: [count] agents selected
Documentation: ✅ Latest docs fetched and validated
───────────────────────────────────────────────────────────

IMPLEMENTATION PLAN:

[Show Phase 1, 2, 3, 4 with steps]

AGENTS TO BE INVOKED:
- Planning: [list]
- Implementation: [list]
- Quality: [list]
- Git: [list]

EXPECTED OUTCOMES:
- Files created: [count]
- Files modified: [count]
- Test coverage: [X]%

───────────────────────────────────────────────────────────
This plan has been saved to .claude/CURRENT_PLAN.md and
validated against your RULEBOOK.

Ready to proceed? (Say "ok" or "proceed" to start execution)

Have questions or want changes? Let me know now.
═══════════════════════════════════════════════════════════
```

### Exit Criteria
- User says **"ok"**, **"proceed"**, **"yes"**, **"let's do it"**, or similar approval
- All questions answered
- Plan validated and stored in temporal reference

### If User Requests Changes
- Update the plan based on feedback
- Re-validate against RULEBOOK
- Update `.claude/CURRENT_PLAN.md`
- Present updated plan
- Wait for approval again

---

## State 2: ⚙️ EXECUTION

### Entry Conditions
- User approved the plan from PLANNING state
- `.claude/CURRENT_PLAN.md` exists and is valid

### State Indicator
```
═══════════════════════════════════════════════════════════
⚙️ EXECUTION STATE ACTIVE
───────────────────────────────────────────────────────────
Progress: Step X/Y - [Step description]
Current Phase: [phase name]
───────────────────────────────────────────────────────────
```

### Critical Principle: Single Source of Truth

**During EXECUTION, these are your ONLY sources of truth:**
1. `.claude/CURRENT_PLAN.md` (temporal reference)
2. `.claude/RULEBOOK.md` (project rules)

**DO NOT:**
- Re-interpret user's original request
- Deviate from the plan without user approval
- Second-guess decisions made in planning
- Lose context by forgetting the plan

**DO:**
- Follow the plan step by step
- Reference temporal file constantly
- Keep plan file open in context
- Update plan file only if user explicitly requests changes

### Workflow Steps

#### Step 1: Load Temporal Reference
```bash
1. Read .claude/CURRENT_PLAN.md
2. Load RULEBOOK context
3. Load documentation references
4. Review complete implementation plan
5. Identify first step to execute
```

#### Step 2: Execute Plan Phase by Phase
For each phase in the plan:

```
───────────────────────────────────────────────────────────
⚙️ EXECUTING: Phase [N] - [Phase Name]
───────────────────────────────────────────────────────────
```

For each step in the phase:

```bash
1. Announce step: "Step X.Y: [description]"
2. Identify agent (from plan): [agent-name]
3. Delegate to agent OR execute directly:

   # If delegating to agent:
   Use Task tool with prompt:
   """
   Context from CURRENT_PLAN.md:
   - Project: [framework] with [patterns]
   - Documentation: [relevant doc summary]
   - RULEBOOK patterns: [relevant rules]

   Task: [specific step description]

   Files to modify: [from plan]
   Expected outcome: [from plan]

   Follow these patterns: [from documentation references]
   """

   # If executing directly:
   - Follow plan instructions
   - Use documentation patterns from temporal reference
   - Follow RULEBOOK conventions

4. Verify step completion
5. Show progress: "✅ Step X.Y complete"
```

#### Step 3: Handle User Feedback During Execution

**Type A: Feedback about implementation details (NOT plan changes)**
```bash
User: "Can you add a comment explaining this function?"

You:
- Add the comment (small adjustment)
- Continue with plan
- No need to update temporal reference
```

**Type B: Feedback requesting plan changes**
```bash
User: "Actually, let's also add pagination to this list"

You:
1. Pause execution
2. Show current state:
   "We're at step 3 of 8. You're requesting a plan change."
3. Ask: "Should I:
   a) Update the plan and continue
   b) Finish current plan first, then handle this as new task"
4. If (a):
   - Update .claude/CURRENT_PLAN.md
   - Show updated plan
   - Get approval
   - Continue
5. If (b):
   - Note the request for later
   - Complete current plan
   - Handle as new task
```

**Type C: Blocking issues discovered**
```bash
Scenario: Dependency missing, pattern unclear, etc.

You:
1. Pause execution
2. Explain the blocker clearly
3. Reference plan: "Step X requires Y, but Z is missing"
4. Propose solutions:
   "Options:
   a) [solution 1]
   b) [solution 2]
   c) Skip this step, continue with rest"
5. Wait for user decision
6. Update plan if needed
7. Continue
```

#### Step 4: Continuous Progress Updates
After every 2-3 steps, show summary:

```
───────────────────────────────────────────────────────────
PROGRESS UPDATE
───────────────────────────────────────────────────────────
Completed: Steps 1-3
Current: Step 4/10
Remaining: Steps 5-10

Phase 1: ✅ Complete
Phase 2: 🔄 In Progress (Step 4/6)
Phase 3: ⏳ Pending
Phase 4: ⏳ Pending
───────────────────────────────────────────────────────────
```

#### Step 5: Complete All Steps
**DO NOT exit EXECUTION until:**
- ✅ All plan steps executed
- ✅ All tests written and passing
- ✅ All files created/modified as planned
- ✅ RULEBOOK compliance verified
- ✅ Documentation updated
- ✅ No blocking issues remain

**CRITICAL**: The task is NOT done until EVERYTHING in the plan is complete.

#### Step 6: Final Validation
```bash
1. Re-read CURRENT_PLAN.md
2. Check all success criteria
3. Run final tests
4. Verify RULEBOOK compliance
5. Generate summary of work done
```

#### Step 7: Present Completion Summary
```
═══════════════════════════════════════════════════════════
✅ EXECUTION COMPLETE
───────────────────────────────────────────────────────────
Task: [description]
All steps: ✅ Completed

SUMMARY:

Files Created: ([count])
[list with file:line references]

Files Modified: ([count])
[list with file:line references]

Tests Added: ([count])
[list with coverage]

Test Results:
✅ All tests passing
✅ Coverage: [X]% (target: [Y]%)

RULEBOOK Compliance:
✅ Project structure followed
✅ Naming conventions met
✅ State management pattern used
✅ Testing requirements satisfied
✅ Security checks passed
✅ Performance targets met

───────────────────────────────────────────────────────────
Ready to commit? (I'll analyze git history and prepare
commit message following your project's style)

Or need any adjustments? Let me know.
═══════════════════════════════════════════════════════════
```

#### Step 8: Git Workflow (If User Approves Commit)
```bash
1. Run: git status
2. Run: git diff
3. Run: git log --oneline -5 (analyze commit style)
4. Delegate to git-workflow-specialist (if complex) OR generate commit message directly
5. Show proposed commit:

   ═══════════════════════════════════════════════════════
   📦 PROPOSED COMMIT
   ───────────────────────────────────────────────────────
   [commit message following project style]

   Files to commit:
   [list]

   Ready to commit? (say "yes" or "commit")
   ═══════════════════════════════════════════════════════

6. WAIT for user approval
7. If approved: git commit
8. Show result
```

#### Step 9: Cleanup & Enhancement
```bash
1. Check if RULEBOOK needs updates
   - Did we use new patterns worth documenting?
   - Did we find better approaches?
   - Did user provide valuable corrections?

2. If RULEBOOK update needed:
   - Propose changes
   - Get user approval
   - Update RULEBOOK
   - Show what was learned

3. Delete temporal reference:
   rm .claude/CURRENT_PLAN.md

4. Reset state: Ready for next task
```

#### Step 10: Ready for Next Task
```
═══════════════════════════════════════════════════════════
🎯 TASK COMPLETE - READY FOR NEXT TASK
───────────────────────────────────────────────────────────
Previous task: ✅ [description]
Temporal reference: 🗑️ Cleaned up
State: 🟢 Ready

What's next?
═══════════════════════════════════════════════════════════
```

### Exit Criteria
- All plan steps executed successfully
- Tests passing
- User satisfied with results
- Commit created (if applicable)
- Cleanup complete
- Ready for new task

---

## State Transitions

```
┌─────────────────────────────────────────────────────────┐
│                    USER REQUEST                          │
└──────────────────────┬──────────────────────────────────┘
                       ↓
         ┌─────────────────────────┐
         │  📋 PLANNING STATE      │
         │                         │
         │  1. Load RULEBOOK       │
         │  2. Analyze task        │
         │  3. Fetch docs          │
         │  4. Select agents       │
         │  5. Create plan         │
         │  6. Ask questions       │
         │  7. Validate            │
         │  8. Create temp ref     │
         │  9. Get approval        │
         └──────────┬──────────────┘
                    │
         User says "ok" / "proceed"
                    │
                    ↓
         ┌─────────────────────────┐
         │  ⚙️ EXECUTION STATE     │
         │                         │
         │  1. Load temp ref       │
         │  2. Execute phases      │
         │  3. Handle feedback     │
         │  4. Show progress       │
         │  5. Complete all        │
         │  6. Validate            │
         │  7. Show summary        │
         │  8. Git workflow        │
         │  9. Cleanup/enhance     │
         │  10. Ready for next     │
         └──────────┬──────────────┘
                    │
                    ↓
         ┌─────────────────────────┐
         │  ✅ DONE                │
         │  (Ready for new task)   │
         └─────────────────────────┘
```

### Handling Edge Cases

**Case 1: User wants to change plan mid-execution**
```bash
Action: Pause → Update CURRENT_PLAN.md → Get approval → Resume
```

**Case 2: Blocking issue discovered**
```bash
Action: Pause → Explain issue → Propose solutions → Get decision → Continue
```

**Case 3: User provides feedback on implementation**
```bash
If minor: Apply feedback, continue
If major (plan change): Pause → Update plan → Get approval → Resume
```

**Case 4: User wants to abandon task**
```bash
Action: Cleanup temp reference → Ask if save progress → Return to ready state
```

**Case 5: Multiple tasks requested**
```bash
Action:
- Planning for task 1
- Get approval
- Execute task 1
- Complete task 1
- Planning for task 2
- ... (repeat)
```

---

## Benefits of 2-State Model

### ✅ Context Preservation
- Temporal reference keeps ALL context in one place
- No context loss during user feedback loops
- Clear source of truth throughout execution

### ✅ Simplified Mental Model
- Only 2 states instead of 4
- Clear transition points
- Easy to understand where you are

### ✅ Better User Experience
- User knows exactly what's happening
- Progress is always visible
- Feedback is handled systematically

### ✅ Reduced Cognitive Load (for AI)
- Don't need to remember complex state transitions
- Temporal reference is the memory
- RULEBOOK + CURRENT_PLAN = complete context

### ✅ Predictable Behavior
- Same input + same plan = same output
- Reproducible results
- Easier to debug issues

### ✅ Flexible Execution
- Can pause/resume easily
- Can handle plan changes without losing context
- Can manage user feedback systematically

---

## Comparison: Old vs New

### Old 4-Mode Workflow
```
📋 PLANNING → 💻 DEVELOPMENT → 🔍 REVIEW → 📦 COMMIT
Problems:
❌ Context lost between modes
❌ Review loop caused confusion
❌ Multiple approval gates
❌ Hard to resume after interruptions
```

### New 2-State Workflow
```
📋 PLANNING → ⚙️ EXECUTION
Benefits:
✅ Context preserved via temporal reference
✅ Single execution phase with continuous validation
✅ Clear approval points (after planning, after execution)
✅ Easy to resume (just read temp reference)
```

---

## Integration with Maestro Mode

This workflow integrates seamlessly with Maestro Mode:

1. **RULEBOOK is still king**: Always loaded, always respected
2. **context7 mandatory**: Documentation fetched during planning
3. **Agent delegation**: Planned during PLANNING, executed during EXECUTION
4. **Self-enhancement**: Triggered after completion if patterns emerged
5. **Tone & style**: Maintained throughout (direct, confrontational, educational)

---

## Usage Examples

### Example 1: Simple Feature
```
User: "Add a dark mode toggle"

Maestro:
1. PLANNING:
   - Reads RULEBOOK (Next.js 15, Zustand, Tailwind)
   - Fetches context7 docs for Tailwind dark mode
   - Plans: 3 files, 2 agents, 5 steps
   - Creates CURRENT_PLAN.md
   - Gets approval

2. EXECUTION:
   - Loads CURRENT_PLAN.md
   - Executes 5 steps
   - Shows progress
   - Completes all
   - Proposes commit
   - Cleans up
```

### Example 2: Complex Feature with Feedback
```
User: "Implement user authentication"

Maestro:
1. PLANNING:
   - Analyzes task: Complex
   - Fetches docs: NextAuth.js, JWT, security best practices
   - Plans: 12 files, 6 agents, 15 steps
   - Asks: "JWT or sessions?" "OAuth providers?"
   - User responds
   - Updates plan
   - Gets approval

2. EXECUTION:
   - Step 3/15: Implementing login form
   - User: "Add remember me checkbox"
   - Maestro: "Small change, adding it now"
   - Continues execution
   - Step 8/15: Setting up OAuth
   - User: "Actually, let's skip Google OAuth for now"
   - Maestro: "Plan change detected. Updating CURRENT_PLAN.md..."
   - Shows updated plan
   - Gets approval
   - Continues with updated plan
   - Completes all 15 steps (adjusted)
   - Shows summary
   - Proposes commit
```

---

## Best Practices

### For PLANNING State
1. **Always fetch latest docs** (use context7 if available from startup check, otherwise websearch)
2. **Create comprehensive temporal reference** (don't skip details)
3. **Validate against RULEBOOK** before presenting plan
4. **Ask all questions upfront** (avoid mid-execution surprises)
5. **Get explicit approval** (don't assume "ok")

### For EXECUTION State
1. **Keep temporal reference open** (reference it constantly)
2. **Show progress frequently** (every 2-3 steps)
3. **Handle feedback systematically** (minor vs. plan change)
4. **Don't terminate early** (complete ALL steps)
5. **Validate continuously** (against RULEBOOK and plan)

### For Both States
1. **Be transparent** (user always knows what's happening)
2. **Be educational** (explain WHY, not just WHAT)
3. **Follow RULEBOOK** (project patterns are law)
4. **Use latest patterns** (from context7 docs)
5. **Communicate clearly** (progress, blockers, completions)

---

**End of Maestro Workflow V2**
