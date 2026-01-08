#!/bin/bash

# Claude Code Agents Global Toolkit - Health Check
# Version: 1.0.0
# Description: Verifies installation integrity and diagnoses issues

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# ============================================================================
# HEALTH CHECK PRINT FUNCTIONS
# ============================================================================

# Override/extend print functions for health check counters
hc_print_pass() {
    print_pass
    ((PASSED_CHECKS++))
    ((TOTAL_CHECKS++))
}

hc_print_fail() {
    print_fail "$1"
    ((FAILED_CHECKS++))
    ((TOTAL_CHECKS++))
}

hc_print_warn() {
    print_warn "$1"
    ((WARNING_CHECKS++))
    ((TOTAL_CHECKS++))
}

# ============================================================================
# CHECK FUNCTIONS
# ============================================================================

# Check if .claude directory exists
check_installation_exists() {
    print_section "Installation Check"

    print_check "Checking .claude directory exists"
    if [ -d ".claude" ]; then
        hc_print_pass
    else
        hc_print_fail "No .claude directory found. Run install script to install."
        return 1
    fi
}

# Check core directories
check_core_directories() {
    print_section "Core Directory Structure"

    print_check "Checking commands directory"
    if [ -d "$COMMANDS_LOCAL_SYMLINK" ]; then
        hc_print_pass
    else
        hc_print_warn "Missing commands directory (Maestro/Coordinator not installed)"
    fi
}

# Check version file
check_version() {
    print_section "Version Information"

    print_check "Checking .toolkit-version file"
    local version_file="$VERSION_LOCAL_FILE"

    if [ -f "$version_file" ]; then
        local version=$(cat "$version_file")
        hc_print_pass
        echo -e "    ${BLUE}→${NC} Installed version: $version"
    else
        hc_print_warn "No version file (pre-versioning install)"
    fi
}

# Check Maestro/Coordinator Mode installation
check_mode_installation() {
    print_section "Mode Configuration"

    # Check for Maestro
    print_check "Checking Maestro mode (maestro.md)"
    if [ -f "${COMMANDS_LOCAL_SYMLINK}/maestro.md" ] || [ -L "${COMMANDS_LOCAL_SYMLINK}/maestro.md" ]; then
        hc_print_pass

        # Check language version
        if [ -L "${COMMANDS_LOCAL_SYMLINK}/maestro.md" ]; then
            local target=$(readlink "${COMMANDS_LOCAL_SYMLINK}/maestro.md")
            if [[ "$target" == *"maestro.es.md" ]]; then
                echo -e "    ${BLUE}→${NC} Language: Spanish (symlink)"
            else
                echo -e "    ${BLUE}→${NC} Language: English (symlink)"
            fi
        fi
    else
        print_check "Checking Coordinator mode (coordinator.md)"
        if [ -f "${COMMANDS_LOCAL_SYMLINK}/coordinator.md" ] || [ -L "${COMMANDS_LOCAL_SYMLINK}/coordinator.md" ]; then
            hc_print_pass
            echo -e "    ${BLUE}→${NC} Mode: Coordinator (lightweight)"
        else
            hc_print_warn "Neither Maestro nor Coordinator mode installed"
        fi
    fi
}

# Check RULEBOOK
check_rulebook() {
    print_section "RULEBOOK Configuration"

    print_check "Checking RULEBOOK.md exists"
    if [ -f "$RULEBOOK_LOCAL" ]; then
        hc_print_pass

        # Validate RULEBOOK structure
        local has_tech_stack=false
        local has_architecture=false

        if grep -q "## Tech Stack" "$RULEBOOK_LOCAL" 2>/dev/null; then
            has_tech_stack=true
        fi

        if grep -q "## Architecture\|## System Architecture" "$RULEBOOK_LOCAL" 2>/dev/null; then
            has_architecture=true
        fi

        print_check "Checking RULEBOOK has Tech Stack section"
        if [ "$has_tech_stack" = true ]; then
            hc_print_pass
        else
            hc_print_warn "Missing Tech Stack section"
        fi

        print_check "Checking RULEBOOK has Architecture section"
        if [ "$has_architecture" = true ]; then
            hc_print_pass
        else
            hc_print_warn "Missing Architecture section (recommended)"
        fi

        # Check file size (should be more than template)
        local file_size=$(wc -c < "$RULEBOOK_LOCAL" | tr -d ' ')
        print_check "Checking RULEBOOK is customized"
        if [ $file_size -gt 5000 ]; then
            hc_print_pass
            echo -e "    ${BLUE}→${NC} Size: $file_size bytes (customized)"
        else
            hc_print_warn "RULEBOOK appears to be default template (not customized)"
        fi
    else
        hc_print_warn "No RULEBOOK.md found (recommended to create one)"
    fi
}

# Check settings
check_settings() {
    print_section "Settings Configuration"

    print_check "Checking settings.local.json"
    if [ -f "$SETTINGS_LOCAL_FILE" ]; then
        hc_print_pass

        # Validate JSON syntax
        if command -v python3 &> /dev/null; then
            if python3 -m json.tool $SETTINGS_LOCAL_FILE > /dev/null 2>&1; then
                echo -e "    ${GREEN}→${NC} Valid JSON syntax"
            else
                echo -e "    ${RED}→${NC} Invalid JSON syntax"
            fi
        fi
    else
        print_info "No custom settings (using defaults)"
    fi
}

# Check for common issues
check_common_issues() {
    print_section "Common Issues Check"

    print_check "Checking for old backup directories"
    local backup_count=$(find . -maxdepth 1 -type d -name ".claude.backup.*" 2>/dev/null | wc -l | tr -d ' ')
    if [ $backup_count -gt 5 ]; then
        hc_print_warn "Found $backup_count backup directories (consider cleaning old backups)"
    else
        hc_print_pass
        if [ $backup_count -gt 0 ]; then
            echo -e "    ${BLUE}→${NC} Found $backup_count backup(s)"
        fi
    fi

    print_check "Checking file permissions"
    if [ -r ".claude" ] && [ -x ".claude" ]; then
        hc_print_pass
    else
        hc_print_fail "Incorrect permissions on .claude directory"
    fi
}

# Check global installation
check_global_installation() {
    print_section "Global Installation"

    print_check "Checking global installation at ~/.claude-global"
    if [ -d "$GLOBAL_DIR" ]; then
        hc_print_pass

        # Check for key global directories
        print_check "Checking global commands directory"
        if [ -d "$COMMANDS_DIR_GLOBAL" ]; then
            hc_print_pass
        else
            hc_print_warn "Missing global commands directory"
        fi

        print_check "Checking global agents directory"
        if [ -d "$AGENTS_DIR_GLOBAL" ]; then
            hc_print_pass

            # Count agents
            local agent_count=$(find "$AGENTS_DIR_GLOBAL" -type f -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
            echo -e "    ${BLUE}→${NC} Found $agent_count agent files"
        else
            hc_print_warn "Missing global agents directory"
        fi
    else
        hc_print_warn "No global installation found (project-specific setup)"
    fi
}

# Check agents-active.txt
check_agents_active() {
    print_section "Active Agents Configuration"

    print_check "Checking agents-active.txt"
    if [ -f "$AGENTS_ACTIVE_FILE" ]; then
        hc_print_pass

        local count=$(wc -l < "$AGENTS_ACTIVE_FILE" 2>/dev/null | tr -d ' ')
        if [ $count -gt 0 ]; then
            echo -e "    ${BLUE}→${NC} $count active agents listed"
        else
            echo -e "    ${GRAY}→${NC} No agents currently active"
        fi
    else
        hc_print_warn "No agents-active.txt found (recommended for project tracking)"
    fi
}

# ============================================================================
# SUMMARY
# ============================================================================

show_summary() {
    echo ""
    print_section "Health Check Summary"
    echo ""

    echo -e "  Total Checks: $TOTAL_CHECKS"
    echo -e "  ${GREEN}✓ Passed:${NC} $PASSED_CHECKS"
    echo -e "  ${YELLOW}⚠ Warnings:${NC} $WARNING_CHECKS"
    echo -e "  ${RED}✗ Failed:${NC} $FAILED_CHECKS"
    echo ""

    # Overall status
    if [ $FAILED_CHECKS -eq 0 ] && [ $WARNING_CHECKS -eq 0 ]; then
        echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
        echo -e "${GREEN}  ✓ EXCELLENT - Installation is healthy!${NC}"
        echo -e "${GREEN}════════════════════════════════════════════════════════${NC}"
    elif [ $FAILED_CHECKS -eq 0 ]; then
        echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
        echo -e "${YELLOW}  ⚠ GOOD - Minor warnings found${NC}"
        echo -e "${YELLOW}════════════════════════════════════════════════════════${NC}"
    else
        echo -e "${RED}════════════════════════════════════════════════════════${NC}"
        echo -e "${RED}  ✗ ISSUES FOUND - Installation needs attention${NC}"
        echo -e "${RED}════════════════════════════════════════════════════════${NC}"
    fi

    echo ""

    # Recommendations
    if [ $FAILED_CHECKS -gt 0 ] || [ $WARNING_CHECKS -gt 0 ]; then
        echo -e "${BLUE}Recommendations:${NC}"
        echo ""

        if [ $FAILED_CHECKS -gt 0 ]; then
            echo -e "  ${RED}Critical Issues:${NC}"
            echo "    → Run the installation script to fix missing components"
            echo ""
        fi

        if [ $WARNING_CHECKS -gt 0 ]; then
            echo -e "  ${YELLOW}Warnings:${NC}"
            echo "    → Review warnings above for optional improvements"
            echo "    → Create/customize RULEBOOK.md for better agent selection"
            echo ""
        fi
    fi

    echo -e "${BLUE}Useful Commands:${NC}"
    echo "  • Initialize project: scripts/init-project.sh"
    echo "  • Manage agents: scripts/select-agents.sh"
    echo "  • View statistics: scripts/agent-stats.sh"
    echo ""
}

# ============================================================================
# HELP
# ============================================================================

show_help() {
    print_box_header "Health Check - Installation Verification"

    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --verbose, -v    Show detailed information"
    echo "  --help           Show this help message"
    echo ""
    echo "What gets checked:"
    echo "  • Installation integrity"
    echo "  • Core directory structure"
    echo "  • Maestro/Coordinator mode"
    echo "  • RULEBOOK configuration"
    echo "  • Version information"
    echo "  • Settings validation"
    echo "  • Global installation"
    echo "  • Active agents"
    echo "  • Common issues"
    echo ""
    echo "Exit codes:"
    echo "  0 - All checks passed"
    echo "  1 - Warnings found"
    echo "  2 - Critical failures found"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    # Print header
    print_box_header "🏥 Claude Code Agents Toolkit Health Check"

    # Parse arguments
    VERBOSE=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                echo "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Run checks
    check_installation_exists || exit 2
    check_core_directories
    check_mode_installation
    check_rulebook
    check_version
    check_settings
    check_global_installation
    check_agents_active
    check_common_issues

    # Show summary
    show_summary

    # Exit with appropriate code
    if [ $FAILED_CHECKS -gt 0 ]; then
        exit 2
    elif [ $WARNING_CHECKS -gt 0 ]; then
        exit 1
    else
        exit 0
    fi
}

# Run main
main "$@"
