#!/bin/bash

# Claude Code Agents Global Toolkit - Health Check
# Version: 1.0.0
# Description: Verifies installation integrity and diagnoses issues

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Counters
TOTAL_CHECKS=0
PASSED_CHECKS=0
FAILED_CHECKS=0
WARNING_CHECKS=0

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🏥 Claude Code Agents Toolkit Health Check     ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

print_check() {
    echo -n "  $1... "
}

print_pass() {
    echo -e "${GREEN}✓ PASS${NC}"
    ((PASSED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_fail() {
    echo -e "${RED}✗ FAIL${NC}"
    if [ ! -z "$1" ]; then
        echo -e "    ${RED}→${NC} $1"
    fi
    ((FAILED_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_warn() {
    echo -e "${YELLOW}⚠ WARNING${NC}"
    if [ ! -z "$1" ]; then
        echo -e "    ${YELLOW}→${NC} $1"
    fi
    ((WARNING_CHECKS++))
    ((TOTAL_CHECKS++))
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Check if .claude directory exists
check_installation_exists() {
    print_section "Installation Check"

    print_check "Checking .claude directory exists"
    if [ -d ".claude" ]; then
        print_pass
    else
        print_fail "No .claude directory found. Run ./install.sh to install."
        return 1
    fi
}

# Check core directories
check_core_directories() {
    print_section "Core Directory Structure"

    print_check "Checking agents-global directory"
    if [ -d ".claude/agents-global" ]; then
        print_pass
    else
        print_fail "Missing agents-global directory"
    fi

    print_check "Checking agents-global/core directory"
    if [ -d ".claude/agents-global/core" ]; then
        print_pass
    else
        print_fail "Missing core agents directory"
    fi

    print_check "Checking agents-global/pool directory"
    if [ -d ".claude/agents-global/pool" ]; then
        print_pass
    else
        print_fail "Missing pool agents directory"
    fi

    print_check "Checking commands directory"
    if [ -d ".claude/commands" ]; then
        print_pass
    else
        print_warn "Missing commands directory (Maestro Mode not installed)"
    fi
}

# Check core agents (10 agents)
check_core_agents() {
    print_section "Core Agents (10 required)"

    local core_agents=(
        "code-reviewer.md"
        "refactoring-specialist.md"
        "documentation-engineer.md"
        "test-strategist.md"
        "architecture-advisor.md"
        "security-auditor.md"
        "performance-optimizer.md"
        "git-workflow-specialist.md"
        "dependency-manager.md"
        "project-analyzer.md"
    )

    local found_count=0

    for agent in "${core_agents[@]}"; do
        if [ -f ".claude/agents-global/core/$agent" ]; then
            ((found_count++))
        fi
    done

    print_check "Checking core agents count (10 expected)"
    if [ $found_count -eq 10 ]; then
        print_pass
    elif [ $found_count -gt 0 ]; then
        print_warn "Found $found_count/10 core agents"
    else
        print_fail "No core agents found"
    fi
}

# Count specialized agents
check_specialized_agents() {
    print_section "Specialized Agents (68 expected)"

    local pool_count=0

    if [ -d ".claude/agents-global/pool" ]; then
        pool_count=$(find .claude/agents-global/pool -type f -name "*.md" | wc -l | tr -d ' ')
    fi

    print_check "Checking specialized agents count"
    if [ $pool_count -ge 68 ]; then
        print_pass
        echo -e "    ${GREEN}→${NC} Found $pool_count agents"
    elif [ $pool_count -gt 0 ]; then
        print_warn "Found $pool_count/68 specialized agents"
    else
        print_fail "No specialized agents found"
    fi
}

# Check Maestro Mode installation
check_maestro_mode() {
    print_section "Maestro Mode"

    print_check "Checking maestro.md"
    if [ -f ".claude/commands/maestro.md" ]; then
        print_pass

        # Check language version
        if grep -q "Que vaina buena" .claude/commands/maestro.md 2>/dev/null; then
            echo -e "    ${BLUE}→${NC} Language: Spanish (Colombian)"
        else
            echo -e "    ${BLUE}→${NC} Language: English"
        fi
    else
        print_warn "Maestro Mode not installed"
    fi

    print_check "Checking agent-intelligence.md"
    if [ -f ".claude/commands/agent-intelligence.md" ]; then
        print_pass
    else
        print_warn "Agent intelligence not installed"
    fi

    print_check "Checking agent-router.md"
    if [ -f ".claude/commands/agent-router.md" ]; then
        print_pass
    else
        print_warn "Agent router not installed"
    fi

    print_check "Checking workflow-modes.md"
    if [ -f ".claude/commands/workflow-modes.md" ]; then
        print_pass
    else
        print_warn "Workflow modes not installed"
    fi

    print_check "Checking self-enhancement.md"
    if [ -f ".claude/commands/self-enhancement.md" ]; then
        print_pass
        echo -e "    ${BLUE}→${NC} Self-enhancement: Enabled"
    else
        print_warn "Self-enhancement disabled (intentional)"
    fi
}

# Check RULEBOOK
check_rulebook() {
    print_section "RULEBOOK Configuration"

    print_check "Checking RULEBOOK.md exists"
    if [ -f ".claude/RULEBOOK.md" ]; then
        print_pass

        # Validate RULEBOOK structure
        local has_tech_stack=false
        local has_architecture=false

        if grep -q "## Tech Stack" .claude/RULEBOOK.md 2>/dev/null; then
            has_tech_stack=true
        fi

        if grep -q "## Architecture\|## System Architecture" .claude/RULEBOOK.md 2>/dev/null; then
            has_architecture=true
        fi

        print_check "Checking RULEBOOK has Tech Stack section"
        if [ "$has_tech_stack" = true ]; then
            print_pass
        else
            print_warn "Missing Tech Stack section"
        fi

        print_check "Checking RULEBOOK has Architecture section"
        if [ "$has_architecture" = true ]; then
            print_pass
        else
            print_warn "Missing Architecture section (recommended)"
        fi

        # Check file size (should be more than template)
        local file_size=$(wc -c < .claude/RULEBOOK.md | tr -d ' ')
        print_check "Checking RULEBOOK is customized"
        if [ $file_size -gt 5000 ]; then
            print_pass
            echo -e "    ${BLUE}→${NC} Size: $file_size bytes (customized)"
        else
            print_warn "RULEBOOK appears to be default template (not customized)"
        fi
    else
        print_warn "No RULEBOOK.md found (recommended to create one)"
    fi
}

# Check version file
check_version() {
    print_section "Version Information"

    print_check "Checking .toolkit-version file"
    if [ -f ".claude/.toolkit-version" ]; then
        local version=$(cat .claude/.toolkit-version)
        print_pass
        echo -e "    ${BLUE}→${NC} Installed version: $version"
    else
        print_warn "No version file (pre-versioning install)"
    fi
}

# Check settings
check_settings() {
    print_section "Settings Configuration"

    print_check "Checking settings.local.json"
    if [ -f ".claude/settings.local.json" ]; then
        print_pass

        # Validate JSON syntax
        if command -v python3 &> /dev/null; then
            if python3 -m json.tool .claude/settings.local.json > /dev/null 2>&1; then
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

    print_check "Checking for duplicate agent files"
    if [ -d ".claude/agents" ] && [ -d ".claude/agents-global" ]; then
        print_warn "Both .claude/agents and .claude/agents-global exist (possible conflict)"
    else
        print_pass
    fi

    print_check "Checking for old backup directories"
    local backup_count=$(find . -maxdepth 1 -type d -name ".claude.backup.*" 2>/dev/null | wc -l | tr -d ' ')
    if [ $backup_count -gt 5 ]; then
        print_warn "Found $backup_count backup directories (consider cleaning old backups)"
    else
        print_pass
        if [ $backup_count -gt 0 ]; then
            echo -e "    ${BLUE}→${NC} Found $backup_count backup(s)"
        fi
    fi

    print_check "Checking file permissions"
    if [ -r ".claude" ] && [ -x ".claude" ]; then
        print_pass
    else
        print_fail "Incorrect permissions on .claude directory"
    fi
}

# Check documentation
check_documentation() {
    print_section "Documentation"

    print_check "Checking agents-global/README.md"
    if [ -f ".claude/agents-global/README.md" ]; then
        print_pass
    else
        print_warn "Missing agents README"
    fi

    print_check "Checking AGENT_SELECTION_GUIDE.md"
    if [ -f ".claude/agents-global/AGENT_SELECTION_GUIDE.md" ]; then
        print_pass
    else
        print_warn "Missing agent selection guide"
    fi

    print_check "Checking MCP_INTEGRATION_GUIDE.md"
    if [ -f ".claude/agents-global/MCP_INTEGRATION_GUIDE.md" ]; then
        print_pass
    else
        print_warn "Missing MCP integration guide"
    fi
}

# Show summary
show_summary() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}Health Check Summary${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
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
            echo "    → Run ./install.sh to reinstall missing components"
            echo "    → Or run ./update.sh to repair installation"
            echo ""
        fi

        if [ $WARNING_CHECKS -gt 0 ]; then
            echo -e "  ${YELLOW}Warnings:${NC}"
            echo "    → Customize .claude/RULEBOOK.md for your project"
            echo "    → Clean old backups: rm -rf .claude.backup.*"
            echo "    → Review warnings above for optional improvements"
            echo ""
        fi
    fi

    echo -e "${BLUE}Useful Commands:${NC}"
    echo "  • Reinstall: ./install.sh"
    echo "  • Update: ./update.sh"
    echo "  • Uninstall: ./uninstall.sh"
    echo "  • Check for updates: ./update.sh --check"
    echo ""
}

# Main health check flow
main() {
    print_header

    # Parse arguments
    VERBOSE=false
    FIX=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --verbose|-v)
                VERBOSE=true
                shift
                ;;
            --fix)
                FIX=true
                shift
                ;;
            --help)
                echo "Usage: ./healthcheck.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --verbose, -v    Show detailed information"
                echo "  --fix            Attempt to fix common issues (not implemented yet)"
                echo "  --help           Show this help message"
                echo ""
                echo "What gets checked:"
                echo "  • Installation integrity"
                echo "  • Core directory structure"
                echo "  • Core agents (10 required)"
                echo "  • Specialized agents (68 expected)"
                echo "  • Maestro Mode installation"
                echo "  • RULEBOOK configuration"
                echo "  • Version information"
                echo "  • Settings validation"
                echo "  • Common issues"
                echo "  • Documentation files"
                echo ""
                echo "Exit codes:"
                echo "  0 - All checks passed"
                echo "  1 - Warnings found"
                echo "  2 - Critical failures found"
                echo ""
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
    check_core_agents
    check_specialized_agents
    check_maestro_mode
    check_rulebook
    check_version
    check_settings
    check_common_issues
    check_documentation

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
