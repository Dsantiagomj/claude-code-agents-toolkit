#!/bin/bash

# Claude Code Agents Global Toolkit - Installer
# Version: 1.0.0
# Description: Installs 78 AI agents for Claude Code with auto-detection

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🤖 Claude Code Agents Global Toolkit Installer  ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     78 Specialized Agents for Claude Code          ${BLUE}║${NC}"
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

# Check if we're in a project directory
check_project_directory() {
    if [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "go.mod" ] && [ ! -f "Cargo.toml" ]; then
        print_warning "No project files detected (package.json, pyproject.toml, etc.)"
        read -p "Continue anyway? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            exit 1
        fi
    fi
}

# Create .claude directory if it doesn't exist
create_claude_directory() {
    print_info "Checking for .claude directory..."
    if [ ! -d ".claude" ]; then
        print_info "Creating .claude directory..."
        mkdir -p .claude
        print_success ".claude directory created"
    else
        print_success ".claude directory already exists"
    fi
}

# Install agents
install_agents() {
    print_info "Installing 78 agents..."

    # Create agents-global directory
    mkdir -p .claude/agents-global

    # Copy core agents
    print_info "  → Copying 10 core agents..."
    cp -r agents/core .claude/agents-global/

    # Copy specialized agents
    print_info "  → Copying 68 specialized agents..."
    cp -r agents/pool .claude/agents-global/

    # Copy documentation
    print_info "  → Copying documentation..."
    cp templates/README.md .claude/agents-global/
    cp templates/AGENT_SELECTION_GUIDE.md .claude/agents-global/
    cp templates/MCP_INTEGRATION_GUIDE.md .claude/agents-global/

    print_success "All 78 agents installed successfully"
}

# Install Maestro Mode
install_maestro_mode() {
    print_info "Installing Maestro Mode..."

    mkdir -p .claude/commands

    # Copy command files
    cp commands/maestro.md .claude/commands/
    cp commands/agent-intelligence.md .claude/commands/
    cp commands/agent-router.md .claude/commands/
    cp commands/workflow-modes.md .claude/commands/
    cp commands/self-enhancement.md .claude/commands/

    print_success "Maestro Mode installed (with self-enhancement)"
    print_info "  Activate with: /maestro in Claude Code"
}

# Generate RULEBOOK if it doesn't exist
generate_rulebook() {
    if [ -f ".claude/RULEBOOK.md" ]; then
        print_info "RULEBOOK.md already exists, skipping generation"
        return
    fi

    print_info "Generating RULEBOOK.md from template..."

    # Copy template
    cp templates/RULEBOOK_TEMPLATE.md .claude/RULEBOOK.md

    # Try to detect project name
    PROJECT_NAME=$(basename "$PWD")

    # Replace placeholders
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        sed -i '' "s/\[Project Name\]/$PROJECT_NAME/g" .claude/RULEBOOK.md
        sed -i '' "s/\[Date\]/$(date +%Y-%m-%d)/g" .claude/RULEBOOK.md
    else
        # Linux
        sed -i "s/\[Project Name\]/$PROJECT_NAME/g" .claude/RULEBOOK.md
        sed -i "s/\[Date\]/$(date +%Y-%m-%d)/g" .claude/RULEBOOK.md
    fi

    print_success "RULEBOOK.md generated"
    print_warning "  Please customize .claude/RULEBOOK.md for your project"
}

# Detect tech stack (simple version)
detect_tech_stack() {
    print_info "Detecting tech stack..."

    DETECTED_STACK=""

    # Check for Node.js projects
    if [ -f "package.json" ]; then
        if grep -q "\"next\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Next.js,"
        fi
        if grep -q "\"react\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK React,"
        fi
        if grep -q "\"vue\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Vue,"
        fi
        if grep -q "\"@angular/core\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Angular,"
        fi
        if grep -q "\"typescript\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK TypeScript,"
        fi
        if grep -q "\"express\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Express,"
        fi
        if grep -q "\"fastify\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Fastify,"
        fi
        if grep -q "\"prisma\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Prisma,"
        fi
        if grep -q "\"vitest\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Vitest,"
        fi
        if grep -q "\"jest\"" package.json 2>/dev/null; then
            DETECTED_STACK="$DETECTED_STACK Jest,"
        fi
    fi

    # Check for Python projects
    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        DETECTED_STACK="$DETECTED_STACK Python,"
    fi

    # Check for Go projects
    if [ -f "go.mod" ]; then
        DETECTED_STACK="$DETECTED_STACK Go,"
    fi

    # Check for Rust projects
    if [ -f "Cargo.toml" ]; then
        DETECTED_STACK="$DETECTED_STACK Rust,"
    fi

    if [ -z "$DETECTED_STACK" ]; then
        print_info "  → No tech stack detected"
    else
        # Remove trailing comma
        DETECTED_STACK=${DETECTED_STACK%,}
        print_success "  → Detected: $DETECTED_STACK"
    fi
}

# Show active agents based on detected stack
show_active_agents() {
    print_info ""
    print_info "Active Agents for Your Project:"
    print_info ""

    # Core agents (always active)
    echo -e "${GREEN}Core Agents (Always Active):${NC}"
    echo "  • code-reviewer"
    echo "  • refactoring-specialist"
    echo "  • documentation-engineer"
    echo "  • test-strategist"
    echo "  • architecture-advisor"
    echo "  • security-auditor"
    echo "  • performance-optimizer"
    echo "  • git-workflow-specialist"
    echo "  • dependency-manager"
    echo "  • project-analyzer"

    # Specialized agents (based on detection)
    echo ""
    echo -e "${BLUE}Specialized Agents (Based on Your Stack):${NC}"

    if [ -f "package.json" ]; then
        if grep -q "\"next\"" package.json 2>/dev/null; then
            echo "  • nextjs-specialist (Next.js detected)"
        fi
        if grep -q "\"react\"" package.json 2>/dev/null; then
            echo "  • react-specialist (React detected)"
        fi
        if grep -q "\"typescript\"" package.json 2>/dev/null; then
            echo "  • typescript-pro (TypeScript detected)"
        fi
        if grep -q "\"prisma\"" package.json 2>/dev/null; then
            echo "  • prisma-specialist (Prisma detected)"
        fi
        if grep -q "\"vitest\"" package.json 2>/dev/null; then
            echo "  • vitest-specialist (Vitest detected)"
        fi
        if grep -q "\"tailwindcss\"" package.json 2>/dev/null; then
            echo "  • tailwind-expert (Tailwind detected)"
        fi
    fi

    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ]; then
        echo "  • python-specialist (Python detected)"
    fi

    if [ -f "go.mod" ]; then
        echo "  • go-specialist (Go detected)"
    fi

    if [ -f "Cargo.toml" ]; then
        echo "  • rust-expert (Rust detected)"
    fi

    echo ""
    print_info "Note: Agents auto-activate based on .claude/RULEBOOK.md"
}

# Main installation flow
main() {
    print_header

    # Parse arguments
    AGENTS_ONLY=false
    CUSTOM=false
    SKIP_MAESTRO=false

    while [[ $# -gt 0 ]]; do
        case $1 in
            --agents-only)
                AGENTS_ONLY=true
                shift
                ;;
            --custom)
                CUSTOM=true
                shift
                ;;
            --skip-maestro)
                SKIP_MAESTRO=true
                shift
                ;;
            --help)
                echo "Usage: ./install.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --agents-only      Install only agents (skip Maestro Mode)"
                echo "  --skip-maestro     Skip Maestro Mode installation"
                echo "  --custom           Interactive installation (choose components)"
                echo "  --help             Show this help message"
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

    # Check project directory
    check_project_directory

    # Create .claude directory
    create_claude_directory

    # Install agents
    install_agents

    # Install Maestro Mode (unless skipped)
    if [ "$AGENTS_ONLY" = false ] && [ "$SKIP_MAESTRO" = false ]; then
        echo ""
        if [ "$CUSTOM" = true ]; then
            read -p "Install Maestro Mode? (Y/n): " -n 1 -r
            echo
            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                install_maestro_mode
            else
                print_info "Skipping Maestro Mode installation"
            fi
        else
            install_maestro_mode
        fi
    fi

    # Generate RULEBOOK
    echo ""
    generate_rulebook

    # Detect tech stack
    echo ""
    detect_tech_stack

    # Show active agents
    echo ""
    show_active_agents

    # Installation complete
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  Installation Complete!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    # Next steps
    echo -e "${GREEN}Next Steps:${NC}"
    echo ""
    echo "1. 📝 Customize your RULEBOOK:"
    echo "   ${BLUE}→${NC} Edit .claude/RULEBOOK.md with your project specifics"
    echo ""
    echo "2. 🎭 Activate Maestro Mode (if installed):"
    echo "   ${BLUE}→${NC} Type ${YELLOW}/maestro${NC} in Claude Code"
    echo ""
    echo "3. 🤖 Use specialized agents:"
    echo "   ${BLUE}→${NC} Agents auto-activate based on your RULEBOOK"
    echo "   ${BLUE}→${NC} See .claude/agents-global/AGENT_SELECTION_GUIDE.md"
    echo ""
    echo "4. 📚 Read the documentation:"
    echo "   ${BLUE}→${NC} Check .claude/agents-global/README.md for details"
    echo ""

    print_info "Happy coding! 💪"
    echo ""
}

# Run main installation
main "$@"
