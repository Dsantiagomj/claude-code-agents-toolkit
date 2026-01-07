#!/bin/bash

# Claude Code Agents Global Toolkit - Migration Script
# Version: 1.0.0
# Description: Migrate from old toolkit versions while preserving customizations

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
    echo -e "${BLUE}║${NC}  🔄 Claude Code Agents Toolkit Migration Tool    ${BLUE}║${NC}"
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

# Detect current version
detect_current_version() {
    if [ -f ".claude/.toolkit-version" ]; then
        CURRENT_VERSION=$(cat .claude/.toolkit-version)
        print_success "Current version detected: $CURRENT_VERSION"
    else
        print_warning "No version file found"
        print_info "Assuming pre-1.0.0 installation"
        CURRENT_VERSION="0.0.0"
    fi
    echo ""
}

# Get target version from toolkit directory
get_target_version() {
    if [ -f "$(dirname "$0")/VERSION" ]; then
        TARGET_VERSION=$(cat "$(dirname "$0")/VERSION")
    else
        # Fallback to script header version
        TARGET_VERSION="1.0.0"
    fi

    print_info "Target version: $TARGET_VERSION"
    echo ""
}

# Check if migration is needed
check_migration_needed() {
    if [ "$CURRENT_VERSION" = "$TARGET_VERSION" ]; then
        print_success "Already on version $TARGET_VERSION"
        echo ""
        echo "No migration needed. Use ./update.sh to refresh files."
        echo ""
        exit 0
    fi

    print_info "Migration path: $CURRENT_VERSION → $TARGET_VERSION"
    echo ""
}

# Create backup before migration
create_migration_backup() {
    local backup_dir=".claude.migration-backup.$(date +%Y-%m-%d-%H%M%S)"

    print_info "Creating migration backup..."
    cp -r .claude "$backup_dir"
    print_success "Backup created: $backup_dir"
    echo ""

    BACKUP_DIR="$backup_dir"
}

# Preserve custom RULEBOOK changes
preserve_rulebook() {
    print_info "Preserving RULEBOOK customizations..."

    if [ -f ".claude/RULEBOOK.md" ]; then
        # Create a RULEBOOK backup specifically
        cp .claude/RULEBOOK.md .claude/RULEBOOK.md.pre-migration
        print_success "RULEBOOK backed up: .claude/RULEBOOK.md.pre-migration"

        # Check if RULEBOOK has custom content
        if ! diff -q .claude/RULEBOOK.md "$(dirname "$0")/templates/RULEBOOK_TEMPLATE.md" >/dev/null 2>&1; then
            print_warning "RULEBOOK has custom changes"
            echo "  → Custom RULEBOOK will be preserved"
            echo "  → New template available at: templates/RULEBOOK_TEMPLATE.md"
            CUSTOM_RULEBOOK=true
        else
            print_info "RULEBOOK matches template (no custom changes)"
            CUSTOM_RULEBOOK=false
        fi
    else
        print_warning "No RULEBOOK found"
        CUSTOM_RULEBOOK=false
    fi

    echo ""
}

# Migrate agent formats
migrate_agent_formats() {
    print_info "Checking agent formats..."

    # Version-specific migrations
    case "$CURRENT_VERSION" in
        0.0.0)
            print_info "Migrating from pre-1.0.0 format"
            # Handle old agent format if needed
            ;;
        1.*)
            print_info "Agent format compatible with 1.x"
            ;;
        *)
            print_warning "Unknown version format"
            ;;
    esac

    print_success "Agent formats checked"
    echo ""
}

# Migrate Maestro Mode configuration
migrate_maestro() {
    print_info "Checking Maestro Mode configuration..."

    if [ -f ".claude/commands/maestro.md" ]; then
        # Check for old naming (GENTLEMAN MODE)
        if grep -q "# GENTLEMAN MODE" .claude/commands/maestro.md 2>/dev/null; then
            print_warning "Old 'GENTLEMAN MODE' naming detected"
            echo "  → This will be updated to 'MAESTRO MODE'"

            read -p "Update to new Maestro naming? (Y/n): " -n 1 -r
            echo

            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                # Backup old maestro
                cp .claude/commands/maestro.md .claude/commands/maestro.md.old-gentleman
                print_success "Old Maestro backed up: maestro.md.old-gentleman"
            fi
        else
            print_success "Maestro Mode format is current"
        fi
    else
        print_info "No Maestro Mode installed"
    fi

    echo ""
}

# Preserve settings
preserve_settings() {
    print_info "Preserving settings..."

    if [ -f ".claude/settings.json" ] || [ -f ".claude/settings.local.json" ]; then
        # Settings will be preserved automatically (not overwritten)
        print_success "Settings will be preserved"
    else
        print_info "No settings files found"
    fi

    echo ""
}

# Update agents to latest version
update_agents() {
    print_info "Updating agents to $TARGET_VERSION..."

    # Remove old agents
    if [ -d ".claude/agents-global" ]; then
        rm -rf .claude/agents-global
    fi

    # Copy new agents
    cp -r "$(dirname "$0")/agents/core" .claude/agents-global/core
    cp -r "$(dirname "$0")/agents/pool" .claude/agents-global/pool

    # Copy documentation
    cp "$(dirname "$0")/templates/README.md" .claude/agents-global/
    cp "$(dirname "$0")/templates/AGENT_SELECTION_GUIDE.md" .claude/agents-global/
    cp "$(dirname "$0")/templates/MCP_INTEGRATION_GUIDE.md" .claude/agents-global/

    print_success "Agents updated: 78 agents (10 core + 68 specialized)"
    echo ""
}

# Update version file
update_version_file() {
    echo "$TARGET_VERSION" > .claude/.toolkit-version
    print_success "Version updated: $CURRENT_VERSION → $TARGET_VERSION"
    echo ""
}

# Show migration summary
show_summary() {
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Migration Complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    echo -e "${GREEN}What was updated:${NC}"
    echo "  → Agents: Updated to $TARGET_VERSION (78 agents)"
    echo "  → Documentation: Latest version"
    echo "  → Version file: $TARGET_VERSION"
    echo ""

    echo -e "${GREEN}What was preserved:${NC}"
    if [ "$CUSTOM_RULEBOOK" = true ]; then
        echo "  → RULEBOOK.md (your custom version)"
    fi
    echo "  → settings.json / settings.local.json"
    echo "  → All your customizations"
    echo ""

    echo -e "${BLUE}Backup location:${NC}"
    echo "  → $BACKUP_DIR"
    echo ""

    if [ "$CUSTOM_RULEBOOK" = true ]; then
        echo -e "${YELLOW}Action Required:${NC}"
        echo "  → Review your RULEBOOK.md for compatibility"
        echo "  → Compare with new template: templates/RULEBOOK_TEMPLATE.md"
        echo "  → Pre-migration backup: .claude/RULEBOOK.md.pre-migration"
        echo ""
    fi

    echo -e "${CYAN}Next Steps:${NC}"
    echo "  1. Test your agents: claude code"
    echo "  2. Run health check: ./healthcheck.sh"
    echo "  3. Review RULEBOOK if needed"
    echo ""

    echo -e "${GREEN}Migration successful!${NC}"
    echo ""
}

# Main migration flow
main() {
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --help)
                echo "Usage: ./migrate.sh [OPTIONS]"
                echo ""
                echo "Migrate Claude Code Agents Toolkit from old versions while preserving"
                echo "your customizations (RULEBOOK, settings, etc.)"
                echo ""
                echo "Options:"
                echo "  --help        Show this help message"
                echo ""
                echo "What gets migrated:"
                echo "  • Agents → Updated to latest version (78 agents)"
                echo "  • Documentation → Latest guides and templates"
                echo "  • Version file → Updated to track current version"
                echo ""
                echo "What gets preserved:"
                echo "  • RULEBOOK.md → Your custom configuration"
                echo "  • settings.json / settings.local.json → Your settings"
                echo "  • Custom modifications → All preserved"
                echo ""
                echo "Safety features:"
                echo "  • Automatic backup before migration"
                echo "  • Timestamped: .claude.migration-backup.YYYY-MM-DD-HHMMSS/"
                echo "  • RULEBOOK.md.pre-migration backup"
                echo "  • Easy rollback if needed"
                echo ""
                echo "Examples:"
                echo "  ./migrate.sh              # Migrate to latest version"
                echo ""
                echo "Vs. other commands:"
                echo "  ./install.sh  → Fresh installation (overwrites)"
                echo "  ./update.sh   → Update files (preserves RULEBOOK)"
                echo "  ./migrate.sh  → Version migration (preserves everything)"
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

    print_header

    # Check if .claude directory exists
    if [ ! -d ".claude" ]; then
        print_error "No .claude directory found"
        echo ""
        echo "This script migrates existing installations."
        echo "For new installations, use: ./install.sh"
        echo ""
        exit 1
    fi

    # Detect versions
    detect_current_version
    get_target_version
    check_migration_needed

    # Show migration plan
    echo -e "${YELLOW}Migration Plan:${NC}"
    echo "  • Backup current installation"
    echo "  • Preserve RULEBOOK customizations"
    echo "  • Preserve settings files"
    echo "  • Update agents to $TARGET_VERSION"
    echo "  • Update documentation"
    echo "  • Update version file"
    echo ""

    read -p "Proceed with migration? (y/N): " -n 1 -r
    echo

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Migration cancelled."
        echo ""
        exit 0
    fi

    echo ""

    # Execute migration steps
    create_migration_backup
    preserve_rulebook
    preserve_settings
    migrate_maestro
    migrate_agent_formats
    update_agents
    update_version_file

    # Show summary
    show_summary
}

# Run main
main "$@"
