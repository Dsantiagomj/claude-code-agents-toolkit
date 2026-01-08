#!/bin/bash

# Claude Code Agents Global Toolkit - Self-Enhancement Toggle
# Version: 1.0.0
# Description: Enable/disable self-enhancement without reinstalling

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🔧 Self-Enhancement Toggle                      ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Check if we're in the toolkit directory or a project directory
check_location() {
    if [ -f "install.sh" ] && [ -d "agents" ] && [ -d "commands" ]; then
        # We're in the toolkit repository itself
        TOOLKIT_DIR="."
        PROJECT_MODE=false
        print_info "Running from toolkit repository"
    elif [ -d ".claude" ]; then
        # We're in a project directory with installed toolkit
        TOOLKIT_DIR=$(cd "$(dirname "$0")" && pwd)
        PROJECT_MODE=true
        print_info "Running from project directory"
    else
        print_error "Not in toolkit repository or project directory"
        echo ""
        echo "Please run this script from:"
        echo "  • The toolkit repository, OR"
        echo "  • A project directory with installed toolkit"
        echo ""
        exit 1
    fi
}

# Check if Maestro Mode is installed
check_maestro_installed() {
    if [ ! -f ".claude/commands/maestro.md" ]; then
        print_error "Maestro Mode not installed"
        echo ""
        echo "Self-enhancement is part of Maestro Mode."
        echo "To install Maestro Mode:"
        echo "  ./install.sh"
        echo ""
        exit 1
    fi
}

# Detect current self-enhancement state
detect_current_state() {
    print_info "Detecting current self-enhancement state..."

    if [ -f ".claude/commands/self-enhancement.md" ]; then
        CURRENT_STATE="enabled"
        print_success "Self-enhancement is currently: ENABLED"
    else
        CURRENT_STATE="disabled"
        print_success "Self-enhancement is currently: DISABLED"
    fi

    echo ""
}

# Enable self-enhancement
enable_enhancement() {
    if [ "$CURRENT_STATE" = "enabled" ]; then
        print_warning "Self-enhancement is already enabled"
        echo ""
        return 0
    fi

    print_info "Enabling self-enhancement..."

    # Copy self-enhancement.md from toolkit
    if [ -f "$TOOLKIT_DIR/commands/self-enhancement.md" ]; then
        cp "$TOOLKIT_DIR/commands/self-enhancement.md" .claude/commands/
        print_success "Self-enhancement enabled"
        echo ""
        echo -e "${GREEN}What this means:${NC}"
        echo "  • Maestro can now learn from interactions"
        echo "  • Improvements require your approval"
        echo "  • Learning is stored in .claude/commands/self-enhancement.md"
        echo ""
    else
        print_error "self-enhancement.md not found in toolkit"
        echo "Please ensure you have the latest toolkit version."
        exit 1
    fi
}

# Disable self-enhancement
disable_enhancement() {
    if [ "$CURRENT_STATE" = "disabled" ]; then
        print_warning "Self-enhancement is already disabled"
        echo ""
        return 0
    fi

    print_info "Disabling self-enhancement..."

    # Backup before removing
    if [ -f ".claude/commands/self-enhancement.md" ]; then
        cp .claude/commands/self-enhancement.md .claude/commands/self-enhancement.md.backup
        print_info "Backup created: .claude/commands/self-enhancement.md.backup"
    fi

    # Remove self-enhancement.md
    rm -f .claude/commands/self-enhancement.md
    print_success "Self-enhancement disabled"
    echo ""
    echo -e "${YELLOW}What this means:${NC}"
    echo "  • Maestro will have static behavior"
    echo "  • No learning or adaptation"
    echo "  • Previous learning preserved in backup"
    echo ""
    echo -e "${BLUE}To restore learning:${NC}"
    echo "  mv .claude/commands/self-enhancement.md.backup .claude/commands/self-enhancement.md"
    echo ""
}

# Toggle self-enhancement
toggle_enhancement() {
    if [ "$CURRENT_STATE" = "enabled" ]; then
        disable_enhancement
    else
        enable_enhancement
    fi
}

# Show current status
show_status() {
    print_header

    check_maestro_installed
    detect_current_state

    echo -e "${CYAN}Current Configuration:${NC}"
    echo ""

    if [ "$CURRENT_STATE" = "enabled" ]; then
        echo -e "  Status: ${GREEN}ENABLED${NC}"
        echo "  File: .claude/commands/self-enhancement.md"
        echo ""
        echo "  Maestro can:"
        echo "    ✓ Learn from interactions"
        echo "    ✓ Adapt to your patterns"
        echo "    ✓ Improve with your approval"
    else
        echo -e "  Status: ${YELLOW}DISABLED${NC}"
        echo "  File: Not present"
        echo ""
        echo "  Maestro will:"
        echo "    • Have static behavior"
        echo "    • Not learn or adapt"
    fi

    echo ""
}

# Show summary after toggle
show_summary() {
    local action=$1

    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Self-Enhancement ${action^}!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    if [ "$action" = "enabled" ]; then
        echo -e "${GREEN}Next time you use Maestro Mode:${NC}"
        echo "  • Maestro will be able to learn"
        echo "  • All changes require your approval"
        echo "  • Learning stored in: .claude/commands/self-enhancement.md"
        echo ""
        echo -e "${CYAN}Activate Maestro: /maestro in Claude Code${NC}"
    else
        echo -e "${YELLOW}Next time you use Maestro Mode:${NC}"
        echo "  • Maestro will have static behavior"
        echo "  • No learning or adaptation"
        echo "  • Previous learning backed up"
        echo ""
        echo -e "${BLUE}To re-enable:${NC}"
        echo "  ./toggle-enhancement.sh on"
    fi

    echo ""
}

# Main flow
main() {
    # Parse arguments
    ACTION=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            on|enable)
                ACTION="enable"
                shift
                ;;
            off|disable)
                ACTION="disable"
                shift
                ;;
            status)
                ACTION="status"
                shift
                ;;
            --help)
                echo "Usage: ./toggle-enhancement.sh [ACTION]"
                echo ""
                echo "Enable or disable Maestro self-enhancement without reinstalling."
                echo ""
                echo "Actions:"
                echo "  on, enable       Enable self-enhancement"
                echo "  off, disable     Disable self-enhancement"
                echo "  status           Show current status"
                echo "  (no argument)    Toggle current state"
                echo ""
                echo "What is self-enhancement?"
                echo "  • Allows Maestro to learn from interactions"
                echo "  • Adapts to your coding patterns and preferences"
                echo "  • All improvements require your approval"
                echo "  • Learning stored in .claude/commands/self-enhancement.md"
                echo ""
                echo "Examples:"
                echo "  ./toggle-enhancement.sh           # Toggle current state"
                echo "  ./toggle-enhancement.sh on        # Enable self-enhancement"
                echo "  ./toggle-enhancement.sh off       # Disable self-enhancement"
                echo "  ./toggle-enhancement.sh status    # Show current status"
                echo ""
                echo "Safety:"
                echo "  • Backup created before disabling"
                echo "  • No reinstallation required"
                echo "  • Easy rollback"
                echo ""
                echo "When enabled:"
                echo "  ✓ Maestro learns from your feedback"
                echo "  ✓ Adapts to your project patterns"
                echo "  ✓ Requires approval for all changes"
                echo ""
                echo "When disabled:"
                echo "  • Maestro has static behavior"
                echo "  • No learning or adaptation"
                echo "  • Faster response (no learning overhead)"
                echo ""
                exit 0
                ;;
            *)
                print_error "Unknown argument: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Show header
    print_header

    # Check location
    check_location

    # Check Maestro installed
    check_maestro_installed

    # Detect current state
    detect_current_state

    # Execute action
    if [ "$ACTION" = "enable" ]; then
        enable_enhancement
        show_summary "enabled"
    elif [ "$ACTION" = "disable" ]; then
        disable_enhancement
        show_summary "disabled"
    elif [ "$ACTION" = "status" ]; then
        show_status
    else
        # Toggle mode
        if [ "$CURRENT_STATE" = "enabled" ]; then
            print_info "Toggle mode: ENABLED → DISABLED"
            echo ""
            disable_enhancement
            show_summary "disabled"
        else
            print_info "Toggle mode: DISABLED → ENABLED"
            echo ""
            enable_enhancement
            show_summary "enabled"
        fi
    fi
}

# Run main
main "$@"
