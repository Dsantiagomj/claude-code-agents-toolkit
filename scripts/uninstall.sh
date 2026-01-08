#!/bin/bash

# Claude Code Agents Global Toolkit - Uninstaller
# Version: 1.0.0
# Description: Safely removes agents and Maestro Mode with multiple options

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🗑️  Claude Code Agents Toolkit Uninstaller      ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if .claude directory exists
check_installation() {
    if [ ! -d ".claude" ]; then
        print_error "No .claude directory found in current directory"
        echo "Are you in the correct project directory?"
        exit 1
    fi

    print_success "Found .claude directory"
}

# Create backup before uninstalling
create_backup() {
    local backup_dir=".claude.backup.$(date +%Y-%m-%d-%H%M%S)"

    print_info "Creating backup at $backup_dir..."
    cp -r .claude "$backup_dir"
    print_success "Backup created: $backup_dir"
    echo ""
}

# Remove agents
remove_agents() {
    if [ -d ".claude/agents-global" ]; then
        print_info "Removing agents (72 agents)..."
        rm -rf .claude/agents-global
        print_success "Agents removed"
    else
        print_warning "No agents found to remove"
    fi
}

# Remove Maestro Mode
remove_maestro() {
    local removed_count=0

    print_info "Removing Maestro Mode files..."

    if [ -f ".claude/commands/maestro.md" ]; then
        rm .claude/commands/maestro.md
        ((removed_count++))
    fi

    if [ -f ".claude/commands/agent-intelligence.md" ]; then
        rm .claude/commands/agent-intelligence.md
        ((removed_count++))
    fi

    if [ -f ".claude/commands/agent-router.md" ]; then
        rm .claude/commands/agent-router.md
        ((removed_count++))
    fi

    if [ -f ".claude/commands/workflow-modes.md" ]; then
        rm .claude/commands/workflow-modes.md
        ((removed_count++))
    fi

    if [ -f ".claude/commands/self-enhancement.md" ]; then
        rm .claude/commands/self-enhancement.md
        ((removed_count++))
    fi

    # Remove commands directory if empty
    if [ -d ".claude/commands" ] && [ -z "$(ls -A .claude/commands)" ]; then
        rmdir .claude/commands
        print_info "  Removed empty commands directory"
    fi

    if [ $removed_count -gt 0 ]; then
        print_success "Maestro Mode removed ($removed_count files)"
    else
        print_warning "No Maestro Mode files found"
    fi
}

# Remove RULEBOOK
remove_rulebook() {
    if [ -f ".claude/RULEBOOK.md" ]; then
        print_info "Removing RULEBOOK.md..."
        rm .claude/RULEBOOK.md
        print_success "RULEBOOK.md removed"
    else
        print_warning "No RULEBOOK.md found"
    fi
}

# Remove settings
remove_settings() {
    if [ -f ".claude/settings.local.json" ]; then
        print_warning "Found .claude/settings.local.json"
        read -p "Remove settings file? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            rm .claude/settings.local.json
            print_success "Settings removed"
        else
            print_info "Settings preserved"
        fi
    fi
}

# Clean up empty .claude directory
cleanup_claude_dir() {
    if [ -d ".claude" ] && [ -z "$(ls -A .claude)" ]; then
        print_info "Removing empty .claude directory..."
        rmdir .claude
        print_success ".claude directory removed"
    elif [ -d ".claude" ]; then
        print_info "Keeping .claude directory (contains other files)"
        echo "  Contents:"
        ls -la .claude | tail -n +4 | awk '{print "    " $9}'
    fi
}

# Show summary
show_summary() {
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Uninstallation Complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    if [ -d ".claude.backup."* ] 2>/dev/null; then
        echo -e "${GREEN}Backup created:${NC}"
        ls -d .claude.backup.* 2>/dev/null | while read backup; do
            echo "  → $backup"
        done
        echo ""
    fi

    echo -e "${BLUE}What was removed:${NC}"
    echo "$REMOVED_ITEMS"
    echo ""

    if [ -d ".claude" ]; then
        echo -e "${YELLOW}What remains:${NC}"
        ls -la .claude | tail -n +4 | awk '{print "  → " $9}'
        echo ""
    fi

    echo -e "${GREEN}Next steps:${NC}"
    echo "  • To reinstall: ./install.sh"
    echo "  • To restore backup: mv .claude.backup.* .claude"
    echo ""
}

# Main uninstallation flow
main() {
    print_header

    # Parse arguments
    KEEP_RULEBOOK=false
    FULL_UNINSTALL=false
    AGENTS_ONLY=false
    MAESTRO_ONLY=false
    SKIP_BACKUP=false
    REMOVED_ITEMS=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --keep-rulebook)
                KEEP_RULEBOOK=true
                shift
                ;;
            --full)
                FULL_UNINSTALL=true
                shift
                ;;
            --agents-only)
                AGENTS_ONLY=true
                shift
                ;;
            --maestro-only)
                MAESTRO_ONLY=true
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            --help)
                echo "Usage: ./uninstall.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --keep-rulebook    Keep RULEBOOK.md when uninstalling"
                echo "  --full             Remove everything including RULEBOOK"
                echo "  --agents-only      Only remove agents (keep Maestro Mode)"
                echo "  --maestro-only     Only remove Maestro Mode (keep agents)"
                echo "  --skip-backup      Skip creating backup (not recommended)"
                echo "  --help             Show this help message"
                echo ""
                echo "Examples:"
                echo "  ./uninstall.sh                    # Remove all, keep RULEBOOK"
                echo "  ./uninstall.sh --full             # Remove everything including RULEBOOK"
                echo "  ./uninstall.sh --agents-only      # Only remove agents"
                echo "  ./uninstall.sh --maestro-only     # Only remove Maestro"
                echo ""
                echo "Safety:"
                echo "  • A backup is created automatically (use --skip-backup to disable)"
                echo "  • Interactive prompts for destructive actions"
                echo "  • RULEBOOK is preserved by default"
                echo ""
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Check installation
    check_installation

    # Show what will be removed
    echo -e "${YELLOW}Uninstall configuration:${NC}"

    if [ "$AGENTS_ONLY" = true ]; then
        echo "  • Mode: Agents only"
        echo "  • Will remove: 72 agents"
        echo "  • Will keep: Maestro Mode, RULEBOOK"
    elif [ "$MAESTRO_ONLY" = true ]; then
        echo "  • Mode: Maestro only"
        echo "  • Will remove: Maestro Mode files"
        echo "  • Will keep: Agents, RULEBOOK"
    elif [ "$FULL_UNINSTALL" = true ]; then
        echo "  • Mode: Full uninstall"
        echo "  • Will remove: Agents, Maestro Mode, RULEBOOK, everything"
    else
        echo "  • Mode: Standard (keep RULEBOOK)"
        echo "  • Will remove: Agents, Maestro Mode"
        echo "  • Will keep: RULEBOOK.md"
    fi

    echo ""

    # Confirm uninstallation
    read -p "Proceed with uninstallation? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Uninstallation cancelled."
        exit 0
    fi

    echo ""

    # Create backup (unless skipped)
    if [ "$SKIP_BACKUP" = false ]; then
        create_backup
    else
        print_warning "Skipping backup (--skip-backup flag used)"
        echo ""
    fi

    # Perform uninstallation based on flags
    if [ "$AGENTS_ONLY" = true ]; then
        remove_agents
        REMOVED_ITEMS="  → Agents (72 agents)\n"
    elif [ "$MAESTRO_ONLY" = true ]; then
        remove_maestro
        REMOVED_ITEMS="  → Maestro Mode\n"
    else
        # Remove agents and Maestro
        remove_agents
        remove_maestro
        REMOVED_ITEMS="  → Agents (72 agents)\n  → Maestro Mode\n"

        # Remove RULEBOOK if full uninstall
        if [ "$FULL_UNINSTALL" = true ]; then
            remove_rulebook
            remove_settings
            REMOVED_ITEMS="${REMOVED_ITEMS}  → RULEBOOK.md\n"
        fi
    fi

    # Cleanup
    echo ""
    cleanup_claude_dir

    # Show summary
    show_summary
}

# Run main
main "$@"
