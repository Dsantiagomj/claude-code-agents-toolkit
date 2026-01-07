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

# Check if global installation exists
check_global_installation() {
    if [ ! -d "$HOME/.claude-global" ]; then
        print_error "Global installation not found at ~/.claude-global/"
        echo ""
        echo "Please install the toolkit first:"
        echo -e "${CYAN}bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install-remote.sh)${NC}"
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
    
    mkdir -p .claude
    
    # Create symlinks to global installation
    ln -sf "$HOME/.claude-global/agents" .claude/agents
    ln -sf "$HOME/.claude-global/commands" .claude/commands
    ln -sf "$HOME/.claude-global/.toolkit-version" .claude/.toolkit-version
    
    # Create empty agents-active.txt (project-specific)
    touch .claude/agents-active.txt
    
    print_success "Symlinks created to global installation"
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

# Offer RULEBOOK creation
offer_rulebook_wizard() {
    if [ -f "RULEBOOK.md" ]; then
        print_info "RULEBOOK.md already exists"
        echo ""
        read -p "Run RULEBOOK wizard anyway? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            return
        fi
    fi
    
    echo ""
    print_info "Now let's set up your RULEBOOK..."
    echo ""
    read -p "Run RULEBOOK wizard? (Y/n): " -n 1 -r
    echo ""
    
    if [[ ! $REPLY =~ ^[Nn]$ ]]; then
        if [ -f "$HOME/.claude-global/scripts/rulebook-wizard.sh" ]; then
            bash "$HOME/.claude-global/scripts/rulebook-wizard.sh"
        else
            print_warning "RULEBOOK wizard not found"
        fi
    fi
}

# Show completion message
show_completion() {
    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Project Initialized! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    echo "Project directory: ${BLUE}.claude/${NC} (symlinks to global)"
    echo "Global installation: ${BLUE}~/.claude-global/${NC}"
    echo ""
    
    if [ ! -f "RULEBOOK.md" ]; then
        echo -e "${YELLOW}⚠${NC} Don't forget to create your RULEBOOK.md!"
        echo -e "  Run: ${CYAN}~/.claude-global/scripts/rulebook-wizard.sh${NC}"
        echo ""
    fi
    
    echo "Useful commands:"
    echo -e "  ${CYAN}~/.claude-global/scripts/select-agents.sh${NC}      - Activate agents"
    echo -e "  ${CYAN}~/.claude-global/scripts/rulebook-wizard.sh${NC}    - Create/update RULEBOOK"
    echo -e "  ${CYAN}~/.claude-global/scripts/healthcheck.sh${NC}        - Check setup"
    echo ""
    echo "Or add ${CYAN}~/.claude-global/scripts${NC} to your PATH!"
    echo ""
}

# Main flow
main() {
    print_header
    
    print_info "Initializing project in: $(pwd)"
    echo ""
    
    check_global_installation
    check_existing
    create_project_structure
    update_gitignore
    offer_rulebook_wizard
    show_completion
}

main "$@"
