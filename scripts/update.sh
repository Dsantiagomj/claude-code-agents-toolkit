#!/bin/bash

# Claude Code Agents Global Toolkit - Updater
# Version: 1.0.0
# Description: Updates agents and Maestro Mode while preserving RULEBOOK

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🔄 Claude Code Agents Toolkit Updater          ${BLUE}║${NC}"
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

print_update() {
    echo -e "${CYAN}↻${NC} $1"
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
        echo "Please run this script from:"
        echo "  • The toolkit repository, OR"
        echo "  • A project directory with installed toolkit"
        exit 1
    fi
}

# Get current version
get_current_version() {
    if [ -f ".claude/.toolkit-version" ]; then
        CURRENT_VERSION=$(cat .claude/.toolkit-version)
        print_info "Current version: $CURRENT_VERSION"
    else
        CURRENT_VERSION="unknown"
        print_warning "No version file found (pre-versioning install)"
    fi
}

# Get latest version from remote
get_latest_version() {
    print_info "Checking for updates..."

    if [ -d ".git" ]; then
        # If we're in a git repository, fetch latest
        git fetch origin main --quiet 2>/dev/null || true

        # Get version from remote install.sh
        LATEST_VERSION=$(git show origin/main:install.sh 2>/dev/null | grep "^# Version:" | head -1 | awk '{print $3}')

        if [ -z "$LATEST_VERSION" ]; then
            LATEST_VERSION="unknown"
            print_warning "Could not determine latest version"
        else
            print_info "Latest version: $LATEST_VERSION"
        fi
    else
        print_warning "Not a git repository - cannot check remote version"
        LATEST_VERSION="unknown"
    fi
}

# Check if update is needed
check_update_needed() {
    if [ "$CURRENT_VERSION" = "unknown" ] || [ "$LATEST_VERSION" = "unknown" ]; then
        print_warning "Version comparison not possible"
        echo ""
        read -p "Continue with update anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Update cancelled."
            exit 0
        fi
        UPDATE_NEEDED=true
    elif [ "$CURRENT_VERSION" = "$LATEST_VERSION" ]; then
        print_success "Already on latest version ($CURRENT_VERSION)"
        echo ""
        read -p "Re-update anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Update cancelled."
            exit 0
        fi
        UPDATE_NEEDED=true
    else
        print_success "Update available: $CURRENT_VERSION → $LATEST_VERSION"
        UPDATE_NEEDED=true
    fi
}

# Create backup before updating
create_backup() {
    local backup_dir=".claude.backup.$(date +%Y-%m-%d-%H%M%S)"

    print_info "Creating backup at $backup_dir..."
    cp -r .claude "$backup_dir"
    print_success "Backup created: $backup_dir"
    echo ""
}

# Preserve RULEBOOK
preserve_rulebook() {
    if [ -f ".claude/RULEBOOK.md" ]; then
        print_info "Preserving RULEBOOK.md..."
        cp .claude/RULEBOOK.md /tmp/rulebook-backup-$$.md
        RULEBOOK_PRESERVED=true
    else
        RULEBOOK_PRESERVED=false
    fi
}

# Restore RULEBOOK
restore_rulebook() {
    if [ "$RULEBOOK_PRESERVED" = true ]; then
        print_info "Restoring RULEBOOK.md..."
        cp /tmp/rulebook-backup-$$.md .claude/RULEBOOK.md
        rm /tmp/rulebook-backup-$$.md
        print_success "RULEBOOK.md restored"
    fi
}

# Preserve settings
preserve_settings() {
    if [ -f ".claude/settings.local.json" ]; then
        print_info "Preserving settings..."
        cp .claude/settings.local.json /tmp/settings-backup-$$.json
        SETTINGS_PRESERVED=true
    else
        SETTINGS_PRESERVED=false
    fi
}

# Restore settings
restore_settings() {
    if [ "$SETTINGS_PRESERVED" = true ]; then
        print_info "Restoring settings..."
        cp /tmp/settings-backup-$$.json .claude/settings.local.json
        rm /tmp/settings-backup-$$.json
        print_success "Settings restored"
    fi
}

# Update agents
update_agents() {
    print_update "Updating agents (72 agents)..."

    # Remove old agents
    if [ -d ".claude/agents-global" ]; then
        rm -rf .claude/agents-global
    fi

    mkdir -p .claude/agents-global

    # Copy new agents
    cp -r "$TOOLKIT_DIR/agents/core" .claude/agents-global/
    cp -r "$TOOLKIT_DIR/agents/pool" .claude/agents-global/

    # Copy documentation
    cp "$TOOLKIT_DIR/templates/README.md" .claude/agents-global/
    cp "$TOOLKIT_DIR/templates/AGENT_SELECTION_GUIDE.md" .claude/agents-global/
    cp "$TOOLKIT_DIR/templates/MCP_INTEGRATION_GUIDE.md" .claude/agents-global/

    print_success "Agents updated (72 agents)"
}

# Update Maestro Mode
update_maestro() {
    print_update "Updating Maestro Mode..."

    mkdir -p .claude/commands

    # Detect current language
    CURRENT_LANG="en"
    if [ -f ".claude/commands/maestro.md" ]; then
        # Check if it's Spanish version (look for Colombian expressions)
        if grep -q "Que vaina buena" .claude/commands/maestro.md 2>/dev/null; then
            CURRENT_LANG="es"
        fi
    fi

    # Copy appropriate maestro file
    if [ "$CURRENT_LANG" = "es" ]; then
        cp "$TOOLKIT_DIR/commands/maestro.es.md" .claude/commands/maestro.md
        print_info "  Language: Spanish (preserved)"
    else
        cp "$TOOLKIT_DIR/commands/maestro.md" .claude/commands/maestro.md
        print_info "  Language: English (preserved)"
    fi

    # Copy other command files
    cp "$TOOLKIT_DIR/commands/agent-intelligence.md" .claude/commands/
    cp "$TOOLKIT_DIR/commands/agent-router.md" .claude/commands/
    cp "$TOOLKIT_DIR/commands/workflow-modes.md" .claude/commands/

    # Check if self-enhancement exists and preserve that choice
    if [ -f ".claude/commands/self-enhancement.md" ]; then
        cp "$TOOLKIT_DIR/commands/self-enhancement.md" .claude/commands/
        print_info "  Self-enhancement: Enabled (preserved)"
    else
        print_info "  Self-enhancement: Disabled (preserved)"
    fi

    print_success "Maestro Mode updated"
}

# Update version file
update_version_file() {
    if [ "$LATEST_VERSION" != "unknown" ]; then
        echo "$LATEST_VERSION" > .claude/.toolkit-version
        print_success "Version file updated: $LATEST_VERSION"
    fi
}

# Show update summary
show_summary() {
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Update Complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    echo -e "${GREEN}What was updated:${NC}"
    echo "$UPDATED_ITEMS"
    echo ""

    echo -e "${GREEN}What was preserved:${NC}"
    echo "  → RULEBOOK.md"
    if [ "$SETTINGS_PRESERVED" = true ]; then
        echo "  → settings.local.json"
    fi
    if [ "$CURRENT_LANG" = "es" ]; then
        echo "  → Maestro language: Spanish"
    else
        echo "  → Maestro language: English"
    fi
    echo ""

    if [ -d ".claude.backup."* ] 2>/dev/null; then
        echo -e "${BLUE}Backup created:${NC}"
        ls -d .claude.backup.* 2>/dev/null | tail -1 | while read backup; do
            echo "  → $backup"
        done
        echo ""
    fi

    if [ "$CURRENT_VERSION" != "unknown" ] && [ "$LATEST_VERSION" != "unknown" ]; then
        echo -e "${CYAN}Version: $CURRENT_VERSION → $LATEST_VERSION${NC}"
        echo ""
    fi

    echo -e "${GREEN}Next steps:${NC}"
    echo "  • Test your setup with /maestro in Claude Code"
    echo "  • Review updated agents in .claude/agents-global/"
    echo "  • Restore backup if needed: mv .claude.backup.* .claude"
    echo ""
}

# Main update flow
main() {
    print_header

    # Parse arguments
    CHECK_ONLY=false
    AGENTS_ONLY=false
    MAESTRO_ONLY=false
    PRESERVE_RULEBOOK=true
    SKIP_BACKUP=false
    UPDATED_ITEMS=""

    while [[ $# -gt 0 ]]; do
        case $1 in
            --check)
                CHECK_ONLY=true
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
            --preserve-rulebook)
                PRESERVE_RULEBOOK=true
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            --help)
                echo "Usage: ./update.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --check              Check for updates without installing"
                echo "  --agents-only        Only update agents (preserve Maestro)"
                echo "  --maestro-only       Only update Maestro Mode (preserve agents)"
                echo "  --preserve-rulebook  Preserve RULEBOOK.md (default behavior)"
                echo "  --skip-backup        Skip creating backup (not recommended)"
                echo "  --help               Show this help message"
                echo ""
                echo "Examples:"
                echo "  ./update.sh                    # Update everything, preserve RULEBOOK"
                echo "  ./update.sh --check            # Just check for updates"
                echo "  ./update.sh --agents-only      # Only update agents"
                echo "  ./update.sh --maestro-only     # Only update Maestro"
                echo ""
                echo "What gets preserved:"
                echo "  • RULEBOOK.md (always)"
                echo "  • settings.local.json (always)"
                echo "  • Maestro language preference (always)"
                echo "  • Self-enhancement setting (always)"
                echo ""
                echo "Safety:"
                echo "  • Automatic backup before update"
                echo "  • All customizations preserved"
                echo "  • Easy rollback from backup"
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

    # Check location
    check_location

    # Get versions
    get_current_version
    get_latest_version
    echo ""

    # Check if update needed
    if [ "$CHECK_ONLY" = true ]; then
        if [ "$CURRENT_VERSION" = "$LATEST_VERSION" ] && [ "$CURRENT_VERSION" != "unknown" ]; then
            print_success "You are on the latest version ($CURRENT_VERSION)"
        else
            print_info "Update available"
            echo "  Current: $CURRENT_VERSION"
            echo "  Latest:  $LATEST_VERSION"
        fi
        exit 0
    fi

    check_update_needed
    echo ""

    # Show update configuration
    echo -e "${YELLOW}Update configuration:${NC}"

    if [ "$AGENTS_ONLY" = true ]; then
        echo "  • Mode: Agents only"
        echo "  • Will update: 72 agents"
        echo "  • Will preserve: Maestro Mode, RULEBOOK"
    elif [ "$MAESTRO_ONLY" = true ]; then
        echo "  • Mode: Maestro only"
        echo "  • Will update: Maestro Mode files"
        echo "  • Will preserve: Agents, RULEBOOK"
    else
        echo "  • Mode: Full update"
        echo "  • Will update: Agents + Maestro Mode"
        echo "  • Will preserve: RULEBOOK, settings, preferences"
    fi

    echo ""

    # Confirm update
    read -p "Proceed with update? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Update cancelled."
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

    # Preserve RULEBOOK and settings
    preserve_rulebook
    preserve_settings
    echo ""

    # Perform update based on flags
    if [ "$AGENTS_ONLY" = true ]; then
        update_agents
        UPDATED_ITEMS="  → Agents (72 agents)\n"
    elif [ "$MAESTRO_ONLY" = true ]; then
        update_maestro
        UPDATED_ITEMS="  → Maestro Mode\n"
    else
        # Full update
        update_agents
        update_maestro
        UPDATED_ITEMS="  → Agents (72 agents)\n  → Maestro Mode\n"
    fi

    # Restore preserved items
    echo ""
    restore_rulebook
    restore_settings

    # Update version file
    echo ""
    update_version_file

    # Show summary
    show_summary
}

# Run main
main "$@"
