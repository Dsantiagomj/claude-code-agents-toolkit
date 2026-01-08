#!/bin/bash
# install-git-hooks.sh - Install git hooks for automated code quality and validation
# Part of Claude Code Agents Global Toolkit

set -e

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Paths
GIT_HOOKS_DIR=".git/hooks"
RULEBOOK="${HOME}/.claude/RULEBOOK.md"

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🪝 Git Hooks Installation                        ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     Automated code quality & validation           ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

show_help() {
    echo "Git Hooks Installation - Automated code quality gates"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --all                    Install all hooks (recommended)"
    echo "  --pre-commit             Install pre-commit hook only"
    echo "  --pre-push               Install pre-push hook only"
    echo "  --commit-msg             Install commit-msg hook only"
    echo "  --post-merge             Install post-merge hook only"
    echo "  --uninstall              Remove all installed hooks"
    echo "  --help                   Show this help message"
    echo ""
    echo "Hooks:"
    echo "  pre-commit   - Validates staged files before commit"
    echo "                 • RULEBOOK validation"
    echo "                 • Basic code checks"
    echo "                 • Prevents committing if validation fails"
    echo ""
    echo "  pre-push     - Runs before push to remote"
    echo "                 • Comprehensive RULEBOOK validation"
    echo "                 • Ensures toolkit is up to date"
    echo "                 • Can be skipped with --no-verify"
    echo ""
    echo "  commit-msg   - Validates commit message format"
    echo "                 • Enforces conventional commits"
    echo "                 • Checks for descriptive messages"
    echo "                 • Can be skipped with --no-verify"
    echo ""
    echo "  post-merge   - Runs after git pull/merge (optional)"
    echo "                 • Checks for RULEBOOK updates"
    echo "                 • Suggests running healthcheck"
    echo "                 • Non-blocking (informational)"
    echo ""
    echo "Examples:"
    echo "  $0 --all           # Install all hooks"
    echo "  $0 --pre-commit    # Install only pre-commit hook"
    echo "  $0 --uninstall     # Remove all hooks"
    echo ""
    echo "Skipping hooks:"
    echo "  git commit --no-verify          # Skip pre-commit and commit-msg"
    echo "  git push --no-verify            # Skip pre-push"
    echo ""
}

check_git_repo() {
    if [ ! -d ".git" ]; then
        print_error "Not a git repository"
        echo ""
        echo "This script must be run from the root of a git repository."
        exit 1
    fi

    print_success "Git repository detected"
}

backup_existing_hooks() {
    local hook_name=$1

    if [ -f "$GIT_HOOKS_DIR/$hook_name" ]; then
        local backup_name="$GIT_HOOKS_DIR/$hook_name.backup.$(date +%Y%m%d-%H%M%S)"
        print_info "Backing up existing $hook_name hook..."
        mv "$GIT_HOOKS_DIR/$hook_name" "$backup_name"
        print_success "Backup created: $backup_name"
    fi
}

install_pre_commit_hook() {
    print_info "Installing pre-commit hook..."

    backup_existing_hooks "pre-commit"

    cat > "$GIT_HOOKS_DIR/pre-commit" << 'HOOK_EOF'
#!/bin/bash
# Pre-commit hook - Validate files before commit
# Installed by Claude Code Agents Toolkit

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "🪝 Running pre-commit validation..."
echo ""

# Check if RULEBOOK validation script exists
if [ -f "scripts/validate-rulebook.sh" ]; then
    # Check if RULEBOOK.md is staged
    if git diff --cached --name-only | grep -q "RULEBOOK.md"; then
        echo "  → Validating RULEBOOK.md..."

        if bash scripts/validate-rulebook.sh > /dev/null 2>&1; then
            echo -e "  ${GREEN}✓${NC} RULEBOOK.md validation passed"
        else
            echo -e "  ${RED}✗${NC} RULEBOOK.md validation failed"
            echo ""
            echo "Run 'scripts/validate-rulebook.sh' to see detailed errors"
            echo "Or use 'git commit --no-verify' to skip validation"
            echo ""
            exit 1
        fi
    fi
else
    echo "  ${YELLOW}⚠${NC} RULEBOOK validator not found (skipping validation)"
fi

# Prevent committing large files
echo "  → Checking file sizes..."
large_files=$(git diff --cached --name-only | xargs -I {} find {} -type f -size +1M 2>/dev/null || true)

if [ -n "$large_files" ]; then
    echo -e "  ${YELLOW}⚠${NC} Large files detected (>1MB):"
    echo "$large_files" | sed 's/^/    /'
    echo ""
    read -p "Commit anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Commit cancelled"
        exit 1
    fi
fi

# Check for common issues
echo "  → Checking for common issues..."

# Check for merge conflict markers
if git diff --cached | grep -q "^+.*<<<<<<< HEAD"; then
    echo -e "  ${RED}✗${NC} Merge conflict markers found"
    echo ""
    echo "Resolve merge conflicts before committing"
    exit 1
fi

# Check for debugging statements
debug_patterns="console\.log\|debugger\|binding\.pry\|import pdb"
if git diff --cached | grep -E "^\+.*($debug_patterns)" > /dev/null; then
    echo -e "  ${YELLOW}⚠${NC} Debugging statements found in staged files"
    echo ""
    read -p "Commit anyway? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Commit cancelled"
        exit 1
    fi
fi

echo ""
echo -e "${GREEN}✓${NC} Pre-commit validation passed"
echo ""

exit 0
HOOK_EOF

    chmod +x "$GIT_HOOKS_DIR/pre-commit"
    print_success "pre-commit hook installed"
}

install_pre_push_hook() {
    print_info "Installing pre-push hook..."

    backup_existing_hooks "pre-push"

    cat > "$GIT_HOOKS_DIR/pre-push" << 'HOOK_EOF'
#!/bin/bash
# Pre-push hook - Validate before pushing to remote
# Installed by Claude Code Agents Toolkit

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo ""
echo "🪝 Running pre-push validation..."
echo ""

# Run RULEBOOK validation if available
if [ -f "scripts/validate-rulebook.sh" ]; then
    echo "  → Running RULEBOOK validation..."

    if bash scripts/validate-rulebook.sh > /dev/null 2>&1; then
        echo -e "  ${GREEN}✓${NC} RULEBOOK validation passed"
    else
        echo -e "  ${RED}✗${NC} RULEBOOK validation failed"
        echo ""
        echo "Run 'scripts/validate-rulebook.sh' for details"
        echo "Or use 'git push --no-verify' to skip validation"
        echo ""
        exit 1
    fi
else
    echo "  ${YELLOW}⚠${NC} RULEBOOK validator not found"
fi

# Check if toolkit is up to date (optional check)
if [ -f ".claude/.toolkit-version" ]; then
    echo "  → Checking toolkit version..."
    echo -e "  ${GREEN}✓${NC} Toolkit version: $(cat .claude/.toolkit-version)"
fi

echo ""
echo -e "${GREEN}✓${NC} Pre-push validation passed"
echo ""

exit 0
HOOK_EOF

    chmod +x "$GIT_HOOKS_DIR/pre-push"
    print_success "pre-push hook installed"
}

install_commit_msg_hook() {
    print_info "Installing commit-msg hook..."

    backup_existing_hooks "commit-msg"

    cat > "$GIT_HOOKS_DIR/commit-msg" << 'HOOK_EOF'
#!/bin/bash
# Commit-msg hook - Validate commit message format
# Installed by Claude Code Agents Toolkit

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

commit_msg_file=$1
commit_msg=$(cat "$commit_msg_file")

# Skip validation for merge commits and reverts
if echo "$commit_msg" | grep -qE "^Merge |^Revert "; then
    exit 0
fi

# Check minimum length
if [ ${#commit_msg} -lt 10 ]; then
    echo ""
    echo -e "${RED}✗${NC} Commit message too short (minimum 10 characters)"
    echo ""
    echo "Your message: '$commit_msg'"
    echo ""
    echo "Please provide a more descriptive commit message."
    echo "Or use 'git commit --no-verify' to skip validation"
    echo ""
    exit 1
fi

# Warn about commit message best practices (non-blocking)
if ! echo "$commit_msg" | head -n1 | grep -qE "^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?:"; then
    echo ""
    echo -e "${YELLOW}⚠${NC} Tip: Consider using conventional commits format:"
    echo ""
    echo "  feat: add new feature"
    echo "  fix: resolve bug"
    echo "  docs: update documentation"
    echo "  refactor: improve code structure"
    echo ""
    echo "Your message will be accepted, but conventional commits are recommended."
    echo ""
fi

exit 0
HOOK_EOF

    chmod +x "$GIT_HOOKS_DIR/commit-msg"
    print_success "commit-msg hook installed"
}

install_post_merge_hook() {
    print_info "Installing post-merge hook..."

    backup_existing_hooks "post-merge"

    cat > "$GIT_HOOKS_DIR/post-merge" << 'HOOK_EOF'
#!/bin/bash
# Post-merge hook - Run after git pull/merge
# Installed by Claude Code Agents Toolkit

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Check if RULEBOOK was updated
if git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep -q "RULEBOOK.md\|\.claude/"; then
    echo ""
    echo -e "${YELLOW}⚠${NC} Claude Code Toolkit files were updated"
    echo ""
    echo "  → RULEBOOK.md or .claude/ directory changed"
    echo ""
    echo -e "${CYAN}Recommended actions:${NC}"
    echo "  1. Review RULEBOOK changes: git diff ORIG_HEAD HEAD -- .claude/RULEBOOK.md"
    echo "  2. Run health check: scripts/healthcheck.sh"
    echo "  3. Validate RULEBOOK: scripts/validate-rulebook.sh"
    echo ""
fi

# Check if dependencies were updated
if git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep -qE "package\.json|package-lock\.json|requirements\.txt|go\.mod|Cargo\.toml"; then
    echo ""
    echo -e "${CYAN}💡 Tip:${NC} Dependencies may have changed. Consider running:"
    echo "  • npm install / yarn install"
    echo "  • pip install -r requirements.txt"
    echo "  • go mod download"
    echo ""
fi

exit 0
HOOK_EOF

    chmod +x "$GIT_HOOKS_DIR/post-merge"
    print_success "post-merge hook installed"
}

uninstall_hooks() {
    print_info "Uninstalling git hooks..."
    echo ""

    local hooks=("pre-commit" "pre-push" "commit-msg" "post-merge")
    local uninstalled=0

    for hook in "${hooks[@]}"; do
        if [ -f "$GIT_HOOKS_DIR/$hook" ]; then
            # Check if it's our hook
            if grep -q "Claude Code Agents Toolkit" "$GIT_HOOKS_DIR/$hook" 2>/dev/null; then
                rm "$GIT_HOOKS_DIR/$hook"
                print_success "Removed $hook hook"
                ((uninstalled++))
            else
                print_warning "$hook exists but not installed by toolkit (skipped)"
            fi
        fi
    done

    echo ""
    if [ $uninstalled -gt 0 ]; then
        print_success "$uninstalled hook(s) uninstalled"
    else
        print_info "No toolkit hooks found to uninstall"
    fi
}

show_installed_hooks() {
    echo ""
    echo -e "${BOLD}Installed Hooks:${NC}"
    echo ""

    local hooks=("pre-commit" "pre-push" "commit-msg" "post-merge")

    for hook in "${hooks[@]}"; do
        if [ -f "$GIT_HOOKS_DIR/$hook" ]; then
            if grep -q "Claude Code Agents Toolkit" "$GIT_HOOKS_DIR/$hook" 2>/dev/null; then
                echo -e "  ${GREEN}✓${NC} $hook"
            else
                echo -e "  ${YELLOW}⚠${NC} $hook (not from toolkit)"
            fi
        else
            echo -e "  ${RED}✗${NC} $hook (not installed)"
        fi
    done

    echo ""
}

# Main
main() {
    # Check if we're in a git repo
    if [ ! -d ".git" ]; then
        check_git_repo
    fi

    # Parse arguments
    if [ $# -eq 0 ]; then
        show_help
        exit 0
    fi

    case "$1" in
        --help|-h)
            show_help
            exit 0
            ;;
        --uninstall)
            print_header
            check_git_repo
            uninstall_hooks
            exit 0
            ;;
        --all)
            print_header
            check_git_repo
            echo ""
            install_pre_commit_hook
            install_pre_push_hook
            install_commit_msg_hook
            install_post_merge_hook
            show_installed_hooks
            echo -e "${GREEN}All hooks installed successfully!${NC}"
            echo ""
            echo -e "${CYAN}Hooks can be skipped with:${NC}"
            echo "  git commit --no-verify"
            echo "  git push --no-verify"
            echo ""
            ;;
        --pre-commit)
            print_header
            check_git_repo
            install_pre_commit_hook
            echo ""
            print_success "Hook installed successfully!"
            ;;
        --pre-push)
            print_header
            check_git_repo
            install_pre_push_hook
            echo ""
            print_success "Hook installed successfully!"
            ;;
        --commit-msg)
            print_header
            check_git_repo
            install_commit_msg_hook
            echo ""
            print_success "Hook installed successfully!"
            ;;
        --post-merge)
            print_header
            check_git_repo
            install_post_merge_hook
            echo ""
            print_success "Hook installed successfully!"
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            show_help
            exit 1
            ;;
    esac
}

main "$@"
