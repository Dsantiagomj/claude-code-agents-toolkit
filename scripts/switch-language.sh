#!/bin/bash

# Claude Code Agents Global Toolkit - Language Switcher
# Version: 1.0.0
# Description: Switch Maestro Mode language without reinstalling

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
    echo -e "${BLUE}║${NC}  🌐 Claude Code Agents Language Switcher        ${BLUE}║${NC}"
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

# Check if Maestro Mode is installed
check_maestro_installed() {
    if [ ! -f ".claude/commands/maestro.md" ]; then
        print_error "Maestro Mode not installed"
        echo ""
        echo "To install Maestro Mode:"
        echo "  ./install.sh"
        echo ""
        exit 1
    fi
}

# Detect current language
detect_current_language() {
    print_info "Detecting current language..."

    if grep -q "Que vaina buena" .claude/commands/maestro.md 2>/dev/null; then
        CURRENT_LANG="es"
        print_success "Current language: Spanish (Colombian)"
    else
        CURRENT_LANG="en"
        print_success "Current language: English"
    fi

    echo ""
}

# Create backup
create_backup() {
    print_info "Creating backup of current maestro.md..."
    cp .claude/commands/maestro.md .claude/commands/maestro.md.backup
    print_success "Backup created: .claude/commands/maestro.md.backup"
    echo ""
}

# Switch to specified language
switch_language() {
    local target_lang=$1

    if [ "$target_lang" = "$CURRENT_LANG" ]; then
        print_warning "Already using $target_lang language"
        echo ""
        read -p "Re-apply language files anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Language switch cancelled."
            exit 0
        fi
        echo ""
    fi

    print_info "Switching to $target_lang..."

    # Copy appropriate maestro file
    if [ "$target_lang" = "es" ]; then
        if [ -f "$TOOLKIT_DIR/commands/maestro.es.md" ]; then
            cp "$TOOLKIT_DIR/commands/maestro.es.md" .claude/commands/maestro.md
            print_success "Switched to Spanish (Colombian)"
            echo -e "    ${BLUE}→${NC} Communication: Spanish"
            echo -e "    ${BLUE}→${NC} Code: English (always)"
        else
            print_error "Spanish maestro file not found in toolkit"
            echo "Please ensure you have the latest toolkit version."
            exit 1
        fi
    else
        if [ -f "$TOOLKIT_DIR/commands/maestro.md" ]; then
            cp "$TOOLKIT_DIR/commands/maestro.md" .claude/commands/maestro.md
            print_success "Switched to English"
            echo -e "    ${BLUE}→${NC} Communication: English"
            echo -e "    ${BLUE}→${NC} Code: English (always)"
        else
            print_error "English maestro file not found in toolkit"
            echo "Please ensure you have the latest toolkit version."
            exit 1
        fi
    fi

    echo ""
}

# Show summary
show_summary() {
    local target_lang=$1

    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Language Switch Complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    echo -e "${GREEN}What changed:${NC}"
    echo "  → Maestro communication language: $CURRENT_LANG → $target_lang"
    echo ""

    echo -e "${GREEN}What stayed the same:${NC}"
    echo "  → All agents (78 agents)"
    echo "  → RULEBOOK.md"
    echo "  → Settings"
    echo "  → Self-enhancement configuration"
    echo "  → Code language: English (always)"
    echo ""

    echo -e "${BLUE}Backup:${NC}"
    echo "  → .claude/commands/maestro.md.backup"
    echo ""

    if [ "$target_lang" = "es" ]; then
        echo -e "${CYAN}¡Listo el pollo! Maestro ahora habla español.${NC}"
        echo -e "${CYAN}Activate with: /maestro in Claude Code${NC}"
    else
        echo -e "${CYAN}Done! Maestro now speaks English.${NC}"
        echo -e "${CYAN}Activate with: /maestro in Claude Code${NC}"
    fi

    echo ""

    echo -e "${BLUE}To restore previous language:${NC}"
    echo "  → mv .claude/commands/maestro.md.backup .claude/commands/maestro.md"
    echo ""
}

# Main flow
main() {
    print_header

    # Parse arguments
    TARGET_LANG=""
    SKIP_BACKUP=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            en|english)
                TARGET_LANG="en"
                shift
                ;;
            es|spanish)
                TARGET_LANG="es"
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            --help)
                echo "Usage: ./switch-language.sh [LANGUAGE] [OPTIONS]"
                echo ""
                echo "Languages:"
                echo "  en, english          Switch to English"
                echo "  es, spanish          Switch to Spanish (Colombian)"
                echo "  (no argument)        Toggle between English and Spanish"
                echo ""
                echo "Options:"
                echo "  --skip-backup        Skip creating backup (not recommended)"
                echo "  --help               Show this help message"
                echo ""
                echo "Examples:"
                echo "  ./switch-language.sh es          # Switch to Spanish"
                echo "  ./switch-language.sh english     # Switch to English"
                echo "  ./switch-language.sh             # Toggle current language"
                echo ""
                echo "What gets switched:"
                echo "  • Maestro Mode communication language"
                echo ""
                echo "What stays the same:"
                echo "  • All agents (unchanged)"
                echo "  • RULEBOOK.md (unchanged)"
                echo "  • Settings (unchanged)"
                echo "  • Self-enhancement (unchanged)"
                echo "  • Code language: English (always)"
                echo ""
                echo "Safety:"
                echo "  • Automatic backup of current maestro.md"
                echo "  • Easy rollback from backup"
                echo "  • No reinstallation required"
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

    # Check location
    check_location

    # Check Maestro installed
    check_maestro_installed

    # Detect current language
    detect_current_language

    # Determine target language
    if [ -z "$TARGET_LANG" ]; then
        # Toggle language
        if [ "$CURRENT_LANG" = "es" ]; then
            TARGET_LANG="en"
            print_info "Toggle mode: Spanish → English"
        else
            TARGET_LANG="es"
            print_info "Toggle mode: English → Spanish"
        fi
        echo ""
    fi

    # Validate target language
    if [ "$TARGET_LANG" != "en" ] && [ "$TARGET_LANG" != "es" ]; then
        print_error "Invalid language: $TARGET_LANG"
        echo "Supported languages: en (English), es (Spanish)"
        exit 1
    fi

    # Show what will change
    echo -e "${YELLOW}Language Switch Configuration:${NC}"
    echo "  • Current language: $CURRENT_LANG"
    echo "  • Target language: $TARGET_LANG"
    echo ""

    if [ "$TARGET_LANG" = "es" ]; then
        echo "  ${BLUE}→${NC} Maestro will speak Spanish (Colombian)"
        echo "  ${BLUE}→${NC} Code will remain in English"
    else
        echo "  ${BLUE}→${NC} Maestro will speak English"
        echo "  ${BLUE}→${NC} Code will remain in English"
    fi

    echo ""

    # Confirm switch
    read -p "Proceed with language switch? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Language switch cancelled."
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

    # Switch language
    switch_language "$TARGET_LANG"

    # Show summary
    show_summary "$TARGET_LANG"
}

# Run main
main "$@"
