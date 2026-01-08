#!/bin/bash

# Claude Code Agents Toolkit - Project Initializer
# Quick setup for new projects when global installation exists

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🚀 Claude Code Agents Toolkit - Project Init   ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_section() {
    echo ""
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Persona selection variables
SELECTED_PERSONA=""
MAESTRO_LANG=""

# Persona selection
select_persona() {
    print_section "🎭 Choose Your AI Persona"
    echo ""
    echo -e "${BLUE}[1]${NC} Maestro - Full-featured with RULEBOOK enforcement"
    echo -e "    ${GREEN}→ Recommended for production projects${NC}"
    echo -e "    • Learns your project patterns (RULEBOOK)"
    echo -e "    • 4-mode workflow (Planning → Dev → Review → Commit)"
    echo -e "    • Smart agent selection based on your stack"
    echo -e "    • Context7 integration for latest docs"
    echo -e "    • Bilingual support (English/Spanish)"
    echo ""
    echo -e "${BLUE}[2]${NC} Coordinator - Lightweight task router"
    echo -e "    ${CYAN}→ Good for quick prototypes or generic projects${NC}"
    echo -e "    • Generic best practices (no RULEBOOK)"
    echo -e "    • Simplified 3-step workflow"
    echo -e "    • Keyword-based agent routing"
    echo -e "    • English only"
    echo ""
    read -p "Enter your choice [1-2]: " persona_choice

    case $persona_choice in
        1)
            SELECTED_PERSONA="maestro"
            print_success "Maestro mode selected"
            select_maestro_language
            ;;
        2)
            SELECTED_PERSONA="coordinator"
            MAESTRO_LANG=""
            print_success "Coordinator mode selected"
            ;;
        *)
            print_error "Invalid choice. Defaulting to Maestro."
            SELECTED_PERSONA="maestro"
            select_maestro_language
            ;;
    esac
}

select_maestro_language() {
    echo ""
    print_info "Maestro supports bilingual mode. Choose your language:"
    echo ""
    echo -e "${BLUE}[1]${NC} English"
    echo -e "${BLUE}[2]${NC} Spanish (Español)"
    echo ""
    read -p "Enter your choice [1-2]: " lang_choice

    case $lang_choice in
        1)
            MAESTRO_LANG="en"
            print_success "English selected"
            ;;
        2)
            MAESTRO_LANG="es"
            print_success "Español seleccionado"
            ;;
        *)
            print_warning "Invalid choice. Defaulting to English."
            MAESTRO_LANG="en"
            ;;
    esac
}

# Check if global installation exists
check_global_installation() {
    if [ ! -d "$HOME/.claude-global" ]; then
        print_error "Global installation not found at ~/.claude-global/"
        echo ""
        echo "Please install the toolkit first:"
        echo -e "${CYAN}bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)${NC}"
        echo ""
        exit 1
    fi
    
    print_success "Global installation found at ~/.claude-global/"
}

# Check if project already initialized
check_existing() {
    if [ -d ".claude" ]; then
        print_warning ".claude directory already exists"
        echo ""
        read -p "Reinitialize? This will recreate symlinks (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Initialization cancelled"
            exit 0
        fi
        rm -rf .claude
    fi
}

# Create project structure
create_project_structure() {
    print_info "Creating project directory..."

    mkdir -p .claude/commands

    # Symlink agents (same for both personas)
    ln -sf "$HOME/.claude-global/agents" .claude/agents
    ln -sf "$HOME/.claude-global/.toolkit-version" .claude/.toolkit-version

    # Persona-specific symlinks
    if [ "$SELECTED_PERSONA" = "maestro" ]; then
        print_info "Setting up Maestro mode..."

        # Symlink Maestro command (language-specific)
        if [ "$MAESTRO_LANG" = "en" ]; then
            ln -sf "$HOME/.claude-global/commands/maestro.md" .claude/commands/maestro.md
        else
            ln -sf "$HOME/.claude-global/commands/maestro.es.md" .claude/commands/maestro.md
        fi

        # Symlink Maestro supporting files
        ln -sf "$HOME/.claude-global/commands/workflow-modes.md" .claude/commands/workflow-modes.md
        ln -sf "$HOME/.claude-global/commands/agent-intelligence.md" .claude/commands/agent-intelligence.md
        ln -sf "$HOME/.claude-global/commands/agent-router.md" .claude/commands/agent-router.md
        ln -sf "$HOME/.claude-global/commands/self-enhancement.md" .claude/commands/self-enhancement.md

        print_success "Maestro mode configured ($MAESTRO_LANG)"
    else
        print_info "Setting up Coordinator mode..."

        # Symlink Coordinator command
        ln -sf "$HOME/.claude-global/commands/coordinator.md" .claude/commands/coordinator.md

        # Symlink minimal supporting files
        ln -sf "$HOME/.claude-global/commands/agent-intelligence.md" .claude/commands/agent-intelligence.md
        ln -sf "$HOME/.claude-global/commands/agent-router.md" .claude/commands/agent-router.md

        print_success "Coordinator mode configured"
    fi

    # Create empty agents-active.txt (project-specific file)
    touch .claude/agents-active.txt

    print_success "Project structure created based on $SELECTED_PERSONA persona"
}

# Add to gitignore
update_gitignore() {
    if [ -f ".gitignore" ]; then
        if ! grep -q ".claude/" .gitignore 2>/dev/null; then
            echo "" >> .gitignore
            echo "# Claude Code Agents Toolkit" >> .gitignore
            echo ".claude/" >> .gitignore
            print_success "Added .claude/ to .gitignore"
        else
            print_info ".claude/ already in .gitignore"
        fi
    else
        cat > .gitignore << 'GITIGNORE_END'
# Claude Code Agents Toolkit
.claude/
GITIGNORE_END
        print_success "Created .gitignore with .claude/"
    fi
}

# Handle RULEBOOK based on persona
handle_rulebook() {
    if [ "$SELECTED_PERSONA" = "maestro" ]; then
        echo ""
        print_section "📖 RULEBOOK Setup (Maestro)"
        echo ""
        print_info "Maestro enforces project-specific patterns using a RULEBOOK."
        print_warning "You'll be prompted to create RULEBOOK on your first Maestro interaction."
        echo ""
        echo "Maestro's hybrid RULEBOOK generation:"
        echo "  1. Scans your project files (package.json, tsconfig.json, etc.)"
        echo "  2. Detects tech stack (framework, language, database, etc.)"
        echo "  3. Shows what it found"
        echo "  4. Asks for missing details (coverage, state mgmt, etc.)"
        echo "  5. Generates RULEBOOK.md at project root"
        echo ""
        print_info "Start Claude Code and type ${CYAN}/maestro${NC} to begin!"
        echo ""
    else
        echo ""
        print_section "ℹ️  No RULEBOOK Needed (Coordinator)"
        echo ""
        print_info "Coordinator uses generic best practices (no RULEBOOK needed)."
        print_success "No RULEBOOK required for Coordinator mode."
        echo ""
        print_info "Start Claude Code and type ${CYAN}/coordinator${NC} to begin!"
        echo ""
    fi
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Project Initialized! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""

    echo "Project configuration:"
    echo "  Persona: ${BLUE}$SELECTED_PERSONA${NC}"
    if [ "$SELECTED_PERSONA" = "maestro" ]; then
        echo "  Language: ${BLUE}$MAESTRO_LANG${NC}"
    fi
    echo "  Directory: ${BLUE}.claude/${NC} (symlinks to global)"
    echo "  Global installation: ${BLUE}~/.claude-global/${NC}"
    echo ""

    echo "Useful commands:"
    echo -e "  ${CYAN}claude-agents${NC}         - Manage active agents"
    echo -e "  ${CYAN}claude-test-agent${NC}     - Browse all 72 agents"
    if [ "$SELECTED_PERSONA" = "maestro" ]; then
        echo -e "  ${CYAN}claude-validate${NC}       - Validate RULEBOOK (after creation)"
    fi
    echo -e "  ${CYAN}claude-health${NC}         - Check setup"
    echo ""
    echo "If aliases don't work, use full paths:"
    echo -e "  ${CYAN}~/.claude-global/scripts/select-agents.sh${NC}"
    echo ""
}

# Main flow
main() {
    print_header

    print_info "Initializing project in: $(pwd)"
    echo ""

    check_global_installation
    check_existing

    # NEW: Persona selection
    select_persona

    create_project_structure
    update_gitignore

    # NEW: Handle RULEBOOK based on persona
    handle_rulebook

    show_completion
}

main "$@"
