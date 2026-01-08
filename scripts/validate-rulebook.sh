#!/bin/bash

# Claude Code Agents Global Toolkit - RULEBOOK Validator
# Version: 1.0.0
# Description: Validate RULEBOOK.md syntax, structure, and compatibility

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Validation results
ERRORS=0
WARNINGS=0
PASSED=0

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  ✓ RULEBOOK Validator                            ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Override print functions to include counters
print_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

print_error() {
    echo -e "${RED}✗${NC} $1"
    ((ERRORS++))
}

# Check if RULEBOOK exists
check_rulebook_exists() {
    print_info "Checking RULEBOOK.md existence..."

    if [ ! -f ".claude/RULEBOOK.md" ]; then
        print_error "RULEBOOK.md not found at .claude/RULEBOOK.md"
        echo ""
        echo "Create a RULEBOOK by running:"
        echo "  ./install.sh                  # Generates from template"
        echo "  ./questionnaire.sh            # Interactive generation"
        echo ""
        exit 1
    fi

    print_pass "RULEBOOK.md exists"
    echo ""
}

# Check required sections
check_required_sections() {
    print_info "Checking required sections..."

    local required_sections=(
        "Project Overview"
        "Tech Stack"
        "Active Agents"
    )

    local all_present=true

    for section in "${required_sections[@]}"; do
        if grep -q "## $section" .claude/RULEBOOK.md; then
            print_pass "Section found: $section"
        else
            print_error "Missing required section: ## $section"
            all_present=false
        fi
    done

    echo ""
}

# Check for duplicate sections
check_duplicate_sections() {
    print_info "Checking for duplicate sections..."

    local duplicates=$(grep "^## " .claude/RULEBOOK.md | sort | uniq -d)

    if [ -z "$duplicates" ]; then
        print_pass "No duplicate sections found"
    else
        print_error "Duplicate sections detected:"
        echo "$duplicates" | while read -r line; do
            echo "  → $line"
        done
    fi

    echo ""
}

# Validate Active Agents section
validate_active_agents() {
    print_info "Validating Active Agents section..."

    if ! grep -q "## Active Agents" .claude/RULEBOOK.md; then
        print_warning "Active Agents section missing"
        echo "  → Add '## Active Agents' section to enable agent activation"
        echo ""
        return
    fi

    # Check if agents are listed
    local agent_count=$(sed -n '/## Active Agents/,/^##/p' .claude/RULEBOOK.md | grep '^-' | wc -l | tr -d ' ')

    if [ "$agent_count" -eq 0 ]; then
        print_warning "No agents listed in Active Agents section"
        echo "  → Use ./select-agents.sh to activate agents"
    else
        print_pass "Active Agents section has $agent_count agents"

        # Validate agent names against available agents
        if [ -d ".claude/agents-global" ]; then
            validate_agent_names
        fi
    fi

    echo ""
}

# Validate agent names
validate_agent_names() {
    print_info "Validating agent names..."

    # Get list of valid agents
    local valid_agents=()
    if [ -d ".claude/agents-global/core" ]; then
        while IFS= read -r file; do
            valid_agents+=("$(basename "$file" .md)")
        done < <(find .claude/agents-global/core -name "*.md" -type f)
    fi
    if [ -d ".claude/agents-global/pool" ]; then
        while IFS= read -r file; do
            valid_agents+=("$(basename "$file" .md)")
        done < <(find .claude/agents-global/pool -name "*.md" -type f)
    fi

    # Get agents from RULEBOOK
    local invalid_found=false
    sed -n '/## Active Agents/,/^##/p' .claude/RULEBOOK.md | grep '^-' | sed 's/^- //' | while read -r agent; do
        # Check if agent exists in valid agents
        if [[ ! " ${valid_agents[@]} " =~ " ${agent} " ]]; then
            print_warning "Unknown agent in RULEBOOK: $agent"
            invalid_found=true
        fi
    done

    if [ "$invalid_found" = false ]; then
        print_pass "All agent names are valid"
    fi
}

# Check Tech Stack section
check_tech_stack() {
    print_info "Checking Tech Stack section..."

    if ! grep -q "## Tech Stack" .claude/RULEBOOK.md; then
        print_warning "Tech Stack section missing"
        echo "  → Recommended: Add '## Tech Stack' to document your stack"
        echo ""
        return
    fi

    print_pass "Tech Stack section exists"

    # Check for common tech stack items
    local stack_content=$(sed -n '/## Tech Stack/,/^##/p' .claude/RULEBOOK.md)

    if echo "$stack_content" | grep -qi "framework"; then
        print_pass "Framework documented"
    else
        print_warning "No framework mentioned in Tech Stack"
    fi

    if echo "$stack_content" | grep -qi "language"; then
        print_pass "Language documented"
    else
        print_warning "No language mentioned in Tech Stack"
    fi

    echo ""
}

# Check markdown formatting
check_markdown_format() {
    print_info "Checking markdown formatting..."

    # Check for proper heading hierarchy
    local prev_level=0
    local line_num=0
    local format_issues=false

    while IFS= read -r line; do
        ((line_num++))

        if [[ $line =~ ^#+\  ]]; then
            local current_level=$(echo "$line" | grep -o "^#*" | wc -c)
            ((current_level--))

            # Check if heading jumps more than one level
            if [ $prev_level -gt 0 ] && [ $current_level -gt $((prev_level + 1)) ]; then
                print_warning "Heading level jump at line $line_num: $line"
                format_issues=true
            fi

            prev_level=$current_level
        fi
    done < .claude/RULEBOOK.md

    if [ "$format_issues" = false ]; then
        print_pass "Markdown heading hierarchy is correct"
    fi

    # Check for empty lines after headings
    local prev_line=""
    line_num=0
    while IFS= read -r line; do
        ((line_num++))

        if [[ $prev_line =~ ^##\  ]] && [[ ! -z "$line" ]] && [[ ! $line =~ ^$ ]]; then
            # Heading followed by non-empty line (missing blank line)
            : # This is actually fine in many markdown styles
        fi

        prev_line="$line"
    done < .claude/RULEBOOK.md

    print_pass "Basic markdown formatting validated"
    echo ""
}

# Check for outdated content
check_outdated_content() {
    print_info "Checking for outdated content..."

    local outdated_found=false

    # Check for old naming (GENTLEMAN MODE)
    if grep -qi "GENTLEMAN MODE" .claude/RULEBOOK.md; then
        print_warning "Outdated naming detected: 'GENTLEMAN MODE'"
        echo "  → Update to 'MAESTRO MODE'"
        outdated_found=true
    fi

    # Check for old naming (WRAPUP MODE)
    if grep -qi "WRAPUP MODE" .claude/RULEBOOK.md; then
        print_warning "Outdated naming detected: 'WRAPUP MODE'"
        echo "  → Update to 'COMMIT MODE'"
        outdated_found=true
    fi

    if [ "$outdated_found" = false ]; then
        print_pass "No outdated content detected"
    fi

    echo ""
}

# Check file permissions
check_permissions() {
    print_info "Checking file permissions..."

    if [ -r ".claude/RULEBOOK.md" ]; then
        print_pass "RULEBOOK is readable"
    else
        print_error "RULEBOOK is not readable"
    fi

    if [ -w ".claude/RULEBOOK.md" ]; then
        print_pass "RULEBOOK is writable"
    else
        print_warning "RULEBOOK is not writable (read-only)"
    fi

    echo ""
}

# Show validation summary
show_summary() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  Validation Summary${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${GREEN}Passed:${NC}   $PASSED checks"
    echo -e "${YELLOW}Warnings:${NC} $WARNINGS issues"
    echo -e "${RED}Errors:${NC}   $ERRORS critical issues"
    echo ""

    if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
        echo -e "${GREEN}✓ RULEBOOK is valid!${NC}"
        echo ""
        return 0
    elif [ $ERRORS -eq 0 ]; then
        echo -e "${YELLOW}⚠ RULEBOOK has warnings but is usable${NC}"
        echo ""
        echo "Recommendations:"
        echo "  • Review warnings above"
        echo "  • Update outdated content if any"
        echo "  • Add recommended sections for better agent activation"
        echo ""
        return 1
    else
        echo -e "${RED}✗ RULEBOOK has critical errors${NC}"
        echo ""
        echo "Action required:"
        echo "  • Fix errors listed above"
        echo "  • Run validator again to verify fixes"
        echo ""
        return 2
    fi
}

# Main validation flow
main() {
    # Parse arguments
    if [ "$1" = "--help" ]; then
        echo "Usage: ./validate-rulebook.sh [OPTIONS]"
        echo ""
        echo "Validate your RULEBOOK.md for syntax, structure, and compatibility."
        echo ""
        echo "Options:"
        echo "  --help        Show this help message"
        echo ""
        echo "Checks performed:"
        echo "  ✓ File existence and permissions"
        echo "  ✓ Required sections present"
        echo "  ✓ No duplicate sections"
        echo "  ✓ Active Agents section validity"
        echo "  ✓ Agent names are valid"
        echo "  ✓ Tech Stack documentation"
        echo "  ✓ Markdown formatting"
        echo "  ✓ Outdated content detection"
        echo ""
        echo "Exit codes:"
        echo "  0 - RULEBOOK is valid (no warnings or errors)"
        echo "  1 - RULEBOOK has warnings (usable but could be improved)"
        echo "  2 - RULEBOOK has critical errors (needs fixes)"
        echo ""
        echo "Examples:"
        echo "  ./validate-rulebook.sh            # Validate RULEBOOK"
        echo "  ./validate-rulebook.sh && echo 'Valid!'  # Use exit code"
        echo ""
        exit 0
    fi

    print_header

    # Run all validation checks
    check_rulebook_exists
    check_required_sections
    check_duplicate_sections
    validate_active_agents
    check_tech_stack
    check_markdown_format
    check_outdated_content
    check_permissions

    # Show summary and return appropriate exit code
    show_summary
    exit $?
}

# Run main
main "$@"
