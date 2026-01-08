# Scripts Library - Common Functions

This directory contains shared functions and utilities used across all scripts in the toolkit.

## Files

### `common.sh`

Shared bash library with common functions, colors, and constants.

**Usage:**

```bash
#!/bin/bash
set -e

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Now you can use any common.sh function
print_success "Setup complete!"
```

## Available Functions

### Colors

All standard terminal colors are available:

```bash
RED, GREEN, YELLOW, BLUE, CYAN, GRAY, MAGENTA, BOLD, NC
```

### Print Functions

**Basic printing:**
```bash
print_success "Operation successful"
print_error "Something went wrong"
print_warning "Be careful"
print_info "Just FYI"
print_section "Section Title"
```

**Health check printing (with counters):**
```bash
print_pass          # Prints ✓ PASS
print_fail "msg"    # Prints ✗ FAIL with optional message
print_warn "msg"    # Prints ⚠ WARNING with optional message
print_check "msg"   # Prints checking message (no newline)
```

**Special formatting:**
```bash
print_box_header "My Title"  # Prints a boxed header
```

### Paths

Pre-defined path constants:

```bash
GLOBAL_DIR              # ${HOME}/.claude-global
RULEBOOK_LOCAL          # .claude/RULEBOOK.md
RULEBOOK_GLOBAL         # ${GLOBAL_DIR}/RULEBOOK.md
AGENTS_DIR_GLOBAL       # ${GLOBAL_DIR}/agents
AGENTS_DIR_LOCAL        # .claude/agents
COMMANDS_DIR            # ${GLOBAL_DIR}/commands
SCRIPTS_DIR             # ${GLOBAL_DIR}/scripts
TOOLKIT_VERSION_FILE    # ${GLOBAL_DIR}/.toolkit-version
```

### Agent Management

**Agent categories as arrays:**
```bash
CORE_AGENTS[@]            # 10 core agents
FRONTEND_AGENTS[@]        # 8 frontend framework agents
BACKEND_AGENTS[@]         # 8 backend framework agents
FULLSTACK_AGENTS[@]       # 6 full-stack framework agents
LANGUAGE_AGENTS[@]        # 8 programming language agents
DATABASE_AGENTS[@]        # 8 database/ORM agents
INFRASTRUCTURE_AGENTS[@]  # 9 infrastructure/DevOps agents
TESTING_AGENTS[@]         # 7 testing framework agents
SPECIALIZED_AGENTS[@]     # 8 specialized domain agents
```

**Agent category counts:**
```bash
CORE_TOTAL=10
FRONTEND_TOTAL=8
BACKEND_TOTAL=8
FULLSTACK_TOTAL=6
LANGUAGE_TOTAL=8
DATABASE_TOTAL=8
INFRASTRUCTURE_TOTAL=9
TESTING_TOTAL=7
SPECIALIZED_TOTAL=8
TOTAL_AGENTS=72
```

**Agent utility functions:**

```bash
# Get agent category
category=$(get_agent_category "nextjs-specialist")
# Returns: "frontend"

# Get all agents (newline-separated)
all_agents=$(get_all_agents)

# Count active agents in a category
count=$(count_active_in_category "core" "/path/to/RULEBOOK.md")
# Returns: number of active core agents

# Check if agent is active
if is_agent_active "nextjs-specialist" "/path/to/RULEBOOK.md"; then
    echo "Agent is active"
fi
```

### Validation Functions

```bash
# Check if RULEBOOK exists
if check_rulebook_exists "/path/to/RULEBOOK.md"; then
    echo "RULEBOOK found"
fi

# Check if global installation exists
if check_global_installation; then
    echo "Global installation found"
fi

# Get toolkit version
version=$(get_toolkit_version)
# Returns: "1.0.0" or "unknown"
```

### Progress Bar

```bash
# Draw a progress bar
draw_progress_bar 30 100
# Outputs: █████████████░░░░░░░░░░░░░░░  30% (30/100)
```

The bar color changes based on percentage:
- < 30%: Red
- 30-60%: Yellow
- > 60%: Green

### Helper Functions

```bash
# Confirm action (interactive)
if confirm_action "Delete all files?"; then
    echo "User confirmed"
else
    echo "User declined"
fi
```

## Best Practices

1. **Always source at the beginning:**
   ```bash
   SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
   source "${SCRIPT_DIR}/lib/common.sh"
   ```

2. **Use common functions instead of duplicating:**
   - ❌ Define colors again
   - ✅ Use colors from common.sh
   - ❌ Hardcode agent lists
   - ✅ Use agent arrays from common.sh

3. **Override when needed:**
   ```bash
   # You can override or extend common functions
   my_custom_function() {
       print_section "My Custom Section"
       # ... custom logic
   }
   ```

4. **Path references:**
   ```bash
   # ✅ Good - Use constants
   if [ -f "$RULEBOOK_LOCAL" ]; then

   # ❌ Bad - Hardcode paths
   if [ -f ".claude/RULEBOOK.md" ]; then
   ```

## Scripts Using common.sh

Currently, the following scripts use `common.sh`:

- `test-agent.sh` - Agent testing and inspection
- `agent-stats.sh` - Agent statistics and analytics
- `healthcheck.sh` - Installation health check
- `init-project.sh` - Project initialization

## Maintenance

When adding new shared functionality:

1. Add it to `common.sh`
2. Document it in this README
3. Update affected scripts to use the new function
4. Test all scripts after changes

## Version History

- **1.0.0** (2026-01-08): Initial creation with core functions
  - Colors and print functions
  - Path constants
  - Agent management utilities
  - Validation functions
  - Progress bar
  - Helper functions
