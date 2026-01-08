# Workflow Modes - Structured Development Process

**Purpose**: Define clear modes for task execution to ensure quality, clarity, and proper process.

**Integration**: Works with Maestro Mode and Agent Intelligence to provide structured development workflow.

**Examples**: See `workflow-examples.md` for detailed scenarios.

---

## Overview

Every task goes through **4 distinct modes**:

```
📋 PLANNING → 💻 DEVELOPMENT → 🔍 REVIEW → 📦 COMMIT
```

Each mode has:
- Clear **entry conditions**
- Specific **responsibilities**
- Explicit **exit criteria**
- User **approval gates**

---

## Mode 1: 📋 PLANNING MODE

### When to Enter
- **Automatically**: User requests a new task/feature
- **Manually**: User says "plan this" or "let's plan"

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

1. **Understand the Task**
   - What: User's goal
   - Why: Business/technical reasoning
   - Scope: Inclusions and exclusions
   - Dependencies: Existing code, external services

2. **Check Project Context**
   - Read `.claude/RULEBOOK.md`
   - Check existing patterns (Grep/Glob)
   - Understand current structure

3. **Assess Complexity**
   - Lines of Code: [estimate]
   - Files Affected: [count]
   - New Patterns: [yes/no]
   - Risk Level: [low/medium/high/critical]
   - → Final Complexity: [Trivial/Simple/Moderate/Complex/Critical]

4. **Select Agents** (based on RULEBOOK)
   - Phase 1 - Design: architecture-advisor, etc.
   - Phase 2 - Implementation: framework specialists
   - Phase 3 - Quality: test-strategist, code-reviewer

5. **Create Step-by-Step Plan**
   - Each step: Name, files, agent, estimated time
   - Include questions for clarification
   - Show total estimated time

### Exit Criteria
- User answers clarifying questions
- User says **"ok"**, **"proceed"**, or **"let's do it"**

### Example
See `workflow-examples.md` → Example 1

---

## Mode 2: 💻 DEVELOPMENT MODE

### When to Enter
- After user approves the plan from Planning Mode

### Mode Indicator
```
═══════════════════════════════════════════════════════════
💻 DEVELOPMENT MODE ACTIVE
───────────────────────────────────────────────────────────
Current Step: X/Y - [Step Name]
Agent: [agent-name]
Estimated: [time]
───────────────────────────────────────────────────────────
```

### Responsibilities

1. **Execute Plan Step by Step**
   - Follow RULEBOOK patterns strictly
   - Delegate to agents as planned
   - Show progress after each step

2. **Handle Blockers**
   - If blocker found: Pause and ask user
   - Suggest alternatives
   - Wait for user decision

3. **Keep User Informed**
   - Progress updates (X/Y steps complete)
   - Show what's being created
   - Highlight any deviations from plan

### Exit Criteria
- All plan steps completed successfully
- **Automatic transition** to Review Mode

### Example
See `workflow-examples.md` → Example 2

---

## Mode 3: 🔍 REVIEW MODE

### When to Enter
- Automatically after all development steps complete
- Manually if user says "review this"

### Mode Indicator
```
═══════════════════════════════════════════════════════════
🔍 REVIEW MODE ACTIVE
───────────────────────────────────────────────────────────
```

### Responsibilities

1. **Show Complete Summary**
   - Files changed (new, modified, deleted)
   - Lines of code added/removed
   - Test coverage achieved
   - Test results

2. **Verify RULEBOOK Compliance**
   - Framework patterns followed?
   - Styling conventions met?
   - Testing requirements satisfied?
   - Code quality standards met?
   - Accessibility/Performance targets?

3. **Run Agent Reviews**
   - code-reviewer: Code quality check
   - test-strategist: Test coverage validation
   - security-auditor: Security scan (if applicable)

4. **Request Feedback**
   - Show all changes
   - Ask for user feedback
   - Make adjustments if needed

5. **Iterate Until Approved**
   - User provides feedback → Make changes → Show updated review
   - Repeat until user approves

6. **Adjust RULEBOOK if Needed**
   - If new patterns emerged, update RULEBOOK
   - Initiate self-enhancement process (Maestro mode)

### Exit Criteria
- User says **"looks good"**, **"approved"**, **"lgtm"**, or similar

### Example
See `workflow-examples.md` → Example 3

---

## Mode 4: 📦 COMMIT MODE

### When to Enter
- After user approves changes in Review Mode

### Mode Indicator
```
═══════════════════════════════════════════════════════════
📦 COMMIT MODE ACTIVE
───────────────────────────────────────────────────────────
```

### Responsibilities

1. **Analyze Commit Style**
   - Run `git log --oneline -5`
   - Detect patterns: Conventional Commits, Angular, custom
   - Match project's existing style

2. **Delegate to Specialized Agents** (if needed)
   - For complex changes: Evaluate and generate commit messages
   - For gitflow enforcement: Ensure branch strategy compliance

3. **Generate Commit Message**
   - Follow detected style
   - Clear, descriptive subject
   - Body if needed (complex changes)
   - Include Co-Authored-By line

4. **Show Files to Commit**
   - List all staged files
   - Show change statistics
   - Preview commit message

5. **Request Final Approval**
   - Show proposed commit
   - Ask user to confirm

6. **CRITICAL**: **Only commit after user says "yes" or "commit"**
   - Never auto-commit
   - Always wait for explicit approval

### Exit Criteria
- User says **"yes"**, **"commit"**, or **"go ahead"**
- Commit created successfully

### Example
See `workflow-examples.md` → Example 4

---

## Mode Transitions

### Transition Map

```
User Request
     ↓
📋 PLANNING MODE
     ↓ (user approves with "ok")
💻 DEVELOPMENT MODE
     ↓ (all steps complete - automatic)
🔍 REVIEW MODE
     ↓ (user approves with "looks good")
📦 COMMIT MODE
     ↓ (user confirms with "yes")
✓ DONE
```

### Transition Rules

**Planning → Development**
- **Trigger**: User says "ok", "proceed", "yes", "let's do it"
- **Action**: Start executing first step of plan

**Development → Review**
- **Trigger**: All plan steps completed successfully
- **Action**: Automatic transition, show complete summary

**Review → Development**
- **Trigger**: User requests changes
- **Action**: Return to Development, apply feedback

**Review → Commit**
- **Trigger**: User says "looks good", "approved", "lgtm"
- **Action**: Prepare commit message

**Commit → Done**
- **Trigger**: User says "yes", "commit", "go ahead"
- **Action**: Execute git commit

**Any Mode → Planning**
- **Trigger**: User says "replan" or "start over"
- **Action**: Discard current work, create new plan

---

## Complexity-Based Adaptations

### Trivial Tasks (< 50 LOC)
- **Planning**: Optional (can skip if obvious)
- **Agents**: 0-1 agents
- **Flow**: Request → Quick Dev → Quick Review → Commit

### Simple Tasks (50-150 LOC)
- **Planning**: Lightweight (brief plan)
- **Agents**: 1-2 agents
- **Flow**: Standard 4-mode workflow

### Moderate Tasks (150-300 LOC)
- **Planning**: Full planning with questions
- **Agents**: 3-5 agents
- **Flow**: Complete 4-mode workflow
- **Example**: See `workflow-examples.md`

### Complex Tasks (300-500 LOC)
- **Planning**: Detailed with risk assessment
- **Agents**: 5-10 agents in phases
- **Flow**: Extended review phase

### Critical Tasks (> 500 LOC or high risk)
- **Planning**: Comprehensive with alternatives
- **Agents**: 10+ agents, coordinated phases
- **Flow**: Multiple review iterations, security audits

---

## Best Practices

### Always Show Current Mode
- Use mode indicators at start of each response
- Keep user oriented on where they are in the workflow

### Respect Approval Gates
- Never skip user approval
- Always wait for explicit confirmation
- Use clear prompts ("say 'ok' to proceed")

### Be Adaptive
- Small changes don't need full ceremony
- Complex changes benefit from structure
- Let complexity guide thoroughness

### Keep Communication Clear
- Show progress frequently
- Explain what you're doing
- Ask questions when uncertain

### Follow RULEBOOK
- Every mode must respect project patterns
- Check RULEBOOK in Planning
- Verify compliance in Review

---

**For detailed examples of each mode in action, see `workflow-examples.md`.**
