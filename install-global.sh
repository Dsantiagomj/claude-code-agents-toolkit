#!/bin/bash

# Claude Code Agents Global Toolkit - Global Installer
# Version: 1.0.0
# Description: Installs agents globally and creates symlinks for multiple projects

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Global installation directory
GLOBAL_DIR="${HOME}/.claude-global"
LOCAL_DIR=".claude"

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🌍 Global Installation Mode                      ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     Install once, use in multiple projects        ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

show_help() {
    echo "Global Installation - Install once, use in multiple projects"
    echo ""
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  --link-only              Only create symlinks (don't reinstall global)"
    echo "  --lang=LANG              Set Maestro language (en or es, default: en)"
    echo "  --skip-self-enhancement  Disable self-enhancement in Maestro Mode"
    echo "  --help                   Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0                       # Full global installation"
    echo "  $0 --lang=es             # Global install with Spanish Maestro"
    echo "  $0 --link-only           # Just link existing global install to this project"
    echo ""
    echo "How it works:"
    echo "  1. Installs agents to ~/.claude-global/"
    echo "  2. Creates symlinks from .claude/ to ~/.claude-global/"
    echo "  3. Per-project RULEBOOK.md (not shared)"
    echo "  4. Shared agents across all projects"
    echo "  5. Update once with 'scripts/update.sh', applies to all projects"
    echo ""
    echo "Benefits:"
    echo "  • Share agents across multiple projects"
    echo "  • Update agents once, affect all projects"
    echo "  • Save disk space (one copy of agents)"
    echo "  • Per-project RULEBOOK customization"
    echo ""
}

check_existing_local() {
    if [ -d "$LOCAL_DIR" ] && [ ! -L "$LOCAL_DIR/agents-global" ]; then
        print_warning "Existing local .claude/ directory found"
        echo ""
        echo "This directory appears to be a standalone installation."
        echo "Global installation will:"
        echo "  1. Back up your current .claude/ directory"
        echo "  2. Create symlinks to ~/.claude-global/"
        echo "  3. Preserve your RULEBOOK.md"
        echo ""
        read -p "Continue with global installation? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 1
        fi

        # Create backup
        local backup_dir=".claude.backup.$(date +%Y-%m-%d-%H%M%S)"
        print_info "Creating backup: $backup_dir"
        cp -r "$LOCAL_DIR" "$backup_dir"
        print_success "Backup created"
        echo ""
    fi
}

install_global() {
    local lang=$1
    local skip_self_enhancement=$2

    print_info "Installing to global directory: $GLOBAL_DIR"
    echo ""

    # Check if global installation already exists
    if [ -d "$GLOBAL_DIR" ]; then
        print_warning "Global installation already exists at $GLOBAL_DIR"
        read -p "Reinstall? This will overwrite existing installation. (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Skipping global installation, will link existing installation"
            return 0
        fi

        # Backup existing global
        local backup_global="${GLOBAL_DIR}.backup.$(date +%Y-%m-%d-%H%M%S)"
        print_info "Backing up existing global installation..."
        mv "$GLOBAL_DIR" "$backup_global"
        print_success "Backup created: $backup_global"
        echo ""
    fi

    # Create global directory
    mkdir -p "$GLOBAL_DIR"

    # Install agents
    print_info "Installing 78 agents to global directory..."

    if [ ! -d "agents/core" ] || [ ! -d "agents/pool" ]; then
        print_error "Installation files not found. Are you in the toolkit repository directory?"
        exit 1
    fi

    # Copy agents
    mkdir -p "$GLOBAL_DIR/agents-global"
    cp -r agents/core "$GLOBAL_DIR/agents-global/"
    cp -r agents/pool "$GLOBAL_DIR/agents-global/"

    # Copy documentation
    cp templates/README.md "$GLOBAL_DIR/agents-global/" 2>/dev/null || true
    cp templates/AGENT_SELECTION_GUIDE.md "$GLOBAL_DIR/agents-global/" 2>/dev/null || true
    cp templates/MCP_INTEGRATION_GUIDE.md "$GLOBAL_DIR/agents-global/" 2>/dev/null || true

    print_success "Agents installed globally"
    echo ""

    # Install Maestro Mode
    print_info "Installing Maestro Mode to global directory..."
    mkdir -p "$GLOBAL_DIR/commands"

    if [ "$lang" = "es" ]; then
        cp commands/maestro.es.md "$GLOBAL_DIR/commands/maestro.md"
        print_success "Maestro Mode installed (Spanish)"
    else
        cp commands/maestro.md "$GLOBAL_DIR/commands/maestro.md"
        print_success "Maestro Mode installed (English)"
    fi

    # Self-enhancement
    if [ "$skip_self_enhancement" != "true" ]; then
        cp commands/self-enhancement.md "$GLOBAL_DIR/commands/"
        print_success "Self-enhancement enabled"
    fi

    echo ""

    # Create version file
    echo "1.0.0" > "$GLOBAL_DIR/.toolkit-version"
    print_success "Global installation complete!"
    echo ""
}

link_to_global() {
    print_info "Creating symlinks to global installation..."
    echo ""

    # Check if global installation exists
    if [ ! -d "$GLOBAL_DIR" ]; then
        print_error "Global installation not found at $GLOBAL_DIR"
        echo ""
        echo "Please run without --link-only first to create global installation:"
        echo "  $0"
        exit 1
    fi

    # Remove existing .claude if it exists (after backup)
    if [ -d "$LOCAL_DIR" ] && [ ! -L "$LOCAL_DIR" ]; then
        # Keep RULEBOOK.md if it exists
        local keep_rulebook=false
        if [ -f "$LOCAL_DIR/RULEBOOK.md" ]; then
            keep_rulebook=true
            cp "$LOCAL_DIR/RULEBOOK.md" /tmp/rulebook.backup.tmp
        fi

        # Remove local directory
        rm -rf "$LOCAL_DIR"

        # Restore RULEBOOK if we saved it
        if [ "$keep_rulebook" = true ]; then
            mkdir -p "$LOCAL_DIR"
            mv /tmp/rulebook.backup.tmp "$LOCAL_DIR/RULEBOOK.md"
        fi
    fi

    # Create .claude directory if it doesn't exist
    mkdir -p "$LOCAL_DIR"

    # Create symlinks
    print_info "Linking agents-global..."
    ln -sf "$GLOBAL_DIR/agents-global" "$LOCAL_DIR/agents-global"
    print_success "agents-global linked"

    print_info "Linking commands..."
    ln -sf "$GLOBAL_DIR/commands" "$LOCAL_DIR/commands"
    print_success "commands linked"

    # Create local RULEBOOK if it doesn't exist
    if [ ! -f "$LOCAL_DIR/RULEBOOK.md" ]; then
        print_info "Creating project-specific RULEBOOK..."

        # Copy template
        if [ -f "templates/RULEBOOK_TEMPLATE.md" ]; then
            cp templates/RULEBOOK_TEMPLATE.md "$LOCAL_DIR/RULEBOOK.md"
            print_success "RULEBOOK.md created (customize for this project)"
        else
            print_warning "RULEBOOK template not found, skipping"
        fi
    else
        print_success "Existing RULEBOOK.md preserved"
    fi

    # Create settings symlink if global settings exist
    if [ -f "$GLOBAL_DIR/settings.json" ]; then
        ln -sf "$GLOBAL_DIR/settings.json" "$LOCAL_DIR/settings.json"
        print_success "settings.json linked"
    fi

    # Create version symlink
    if [ -f "$GLOBAL_DIR/.toolkit-version" ]; then
        ln -sf "$GLOBAL_DIR/.toolkit-version" "$LOCAL_DIR/.toolkit-version"
    fi

    echo ""
    print_success "Symlinks created successfully!"
    echo ""
}

verify_links() {
    print_info "Verifying installation..."
    echo ""

    local all_good=true

    # Check agents-global
    if [ -L "$LOCAL_DIR/agents-global" ] && [ -d "$LOCAL_DIR/agents-global" ]; then
        print_success "agents-global: linked correctly → $GLOBAL_DIR/agents-global"
    else
        print_error "agents-global: link broken or missing"
        all_good=false
    fi

    # Check commands
    if [ -L "$LOCAL_DIR/commands" ] && [ -d "$LOCAL_DIR/commands" ]; then
        print_success "commands: linked correctly → $GLOBAL_DIR/commands"
    else
        print_error "commands: link broken or missing"
        all_good=false
    fi

    # Check RULEBOOK
    if [ -f "$LOCAL_DIR/RULEBOOK.md" ]; then
        if [ -L "$LOCAL_DIR/RULEBOOK.md" ]; then
            print_success "RULEBOOK.md: linked (shared across projects)"
        else
            print_success "RULEBOOK.md: local copy (project-specific) ✓ Recommended"
        fi
    else
        print_warning "RULEBOOK.md: missing"
    fi

    echo ""

    if [ "$all_good" = true ]; then
        print_success "All links verified!"
    else
        print_error "Some links are broken. Please reinstall."
        exit 1
    fi
}

show_usage_info() {
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Global Installation Complete!${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${BOLD}Installation Summary:${NC}"
    echo ""
    echo "  ${GREEN}✓${NC} Global Directory: $GLOBAL_DIR"
    echo "  ${GREEN}✓${NC} Local Directory: $LOCAL_DIR (symlinked)"
    echo "  ${GREEN}✓${NC} Agents: 78 (shared across projects)"
    echo "  ${GREEN}✓${NC} Maestro Mode: Installed"
    echo "  ${GREEN}✓${NC} RULEBOOK: Project-specific"
    echo ""

    echo -e "${GREEN}How to use in other projects:${NC}"
    echo ""
    echo "1. Navigate to another project directory"
    echo "   ${BLUE}→${NC} cd ~/my-other-project"
    echo ""
    echo "2. Run the global installer with --link-only"
    echo "   ${BLUE}→${NC} cd /path/to/toolkit && ./install-global.sh --link-only"
    echo ""
    echo "   Or create symlinks manually:"
    echo "   ${BLUE}→${NC} mkdir -p .claude"
    echo "   ${BLUE}→${NC} ln -s $GLOBAL_DIR/agents-global .claude/agents-global"
    echo "   ${BLUE}→${NC} ln -s $GLOBAL_DIR/commands .claude/commands"
    echo "   ${BLUE}→${NC} cp /path/to/toolkit/templates/RULEBOOK_TEMPLATE.md .claude/RULEBOOK.md"
    echo ""

    echo -e "${GREEN}Updating agents (affects all projects):${NC}"
    echo ""
    echo "  ${BLUE}→${NC} Navigate to toolkit directory"
    echo "  ${BLUE}→${NC} Run: git pull && ./install-global.sh"
    echo "  ${BLUE}→${NC} All linked projects will use updated agents immediately"
    echo ""

    echo -e "${GREEN}Benefits:${NC}"
    echo ""
    echo "  ${GREEN}•${NC} One copy of 78 agents (save ~500KB per project)"
    echo "  ${GREEN}•${NC} Update once, apply to all projects"
    echo "  ${GREEN}•${NC} Per-project RULEBOOK customization"
    echo "  ${GREEN}•${NC} Shared Maestro Mode configuration"
    echo ""

    echo -e "${CYAN}💡 Tip:${NC} Each project can have its own RULEBOOK.md while sharing agents"
    echo -e "${CYAN}💡 Tip:${NC} Use scripts/select-agents.sh in each project for project-specific agent activation"
    echo ""
    print_info "Happy coding across all your projects! 💪"
    echo ""
}

# Main
main() {
    # Parse arguments
    LINK_ONLY=false
    LANGUAGE="en"
    SKIP_SELF_ENHANCEMENT=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --link-only)
                LINK_ONLY=true
                shift
                ;;
            --lang=*)
                LANGUAGE="${1#*=}"
                shift
                ;;
            --skip-self-enhancement)
                SKIP_SELF_ENHANCEMENT=true
                shift
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                echo ""
                show_help
                exit 1
                ;;
        esac
    done

    print_header

    # Check for existing local installation
    if [ "$LINK_ONLY" = false ]; then
        check_existing_local
    fi

    # Install globally (unless link-only)
    if [ "$LINK_ONLY" = false ]; then
        install_global "$LANGUAGE" "$SKIP_SELF_ENHANCEMENT"
    fi

    # Link to global installation
    link_to_global

    # Verify links
    verify_links

    # Show usage information
    show_usage_info
}

main "$@"
