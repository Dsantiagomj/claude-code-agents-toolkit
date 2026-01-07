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
    echo -e "${BLUE}║${NC}  🤖 Claude Code Agents Toolkit - Repo Installer  ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     78 Specialized Agents for Claude Code          ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     Installing from cloned repository              ${BLUE}║${NC}"
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

# Check if we're in a project directory (informational only)
check_project_directory() {
    if [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "go.mod" ] && [ ! -f "Cargo.toml" ]; then
        print_info "No project files detected in current directory"
        print_info "The toolkit can be installed in empty directories"
        print_info "The RULEBOOK wizard will help you set up your project"
    else
        print_success "Project files detected - will use for RULEBOOK setup"
    fi
}

# Detect conflicts before installation
detect_conflicts() {
    local conflicts_found=false
    local warnings_found=false

    echo ""
    print_info "Checking for potential conflicts..."
    echo ""

    # Check 1: Version conflicts
    if [ -f ".claude/.toolkit-version" ]; then
        local current_version=$(cat .claude/.toolkit-version 2>/dev/null || echo "unknown")
        local new_version="1.0.0"  # This should match the version at the top of this script

        if [ "$current_version" != "$new_version" ]; then
            print_warning "Version conflict detected:"
            echo "  → Current: $current_version"
            echo "  → New: $new_version"
            echo "  → Recommendation: Use ./update.sh instead of ./install.sh"
            warnings_found=true
        fi
    fi

    # Check 2: Partial installation
    if [ -d ".claude" ]; then
        local missing_files=()

        # Check for critical directories
        if [ ! -d ".claude/agents-global" ]; then
            missing_files+=("agents-global/")
        fi

        # Check for critical files
        if [ ! -f ".claude/RULEBOOK.md" ]; then
            missing_files+=("RULEBOOK.md")
        fi

        if [ ${#missing_files[@]} -gt 0 ]; then
            print_warning "Partial installation detected:"
            for file in "${missing_files[@]}"; do
                echo "  → Missing: .claude/$file"
            done
            echo "  → This may indicate a corrupted installation"
            warnings_found=true
        fi
    fi

    # Check 3: Custom agents that might conflict
    if [ -d ".claude/agents-global/pool" ]; then
        # Count files in pool directory
        local custom_count=$(find .claude/agents-global/pool -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
        local expected_count=68

        if [ "$custom_count" -gt "$expected_count" ]; then
            print_warning "Custom agents detected:"
            echo "  → Found: $custom_count agents (expected: $expected_count)"
            echo "  → You may have custom agents that could be overwritten"
            warnings_found=true
        fi
    fi

    # Check 4: RULEBOOK format issues
    if [ -f ".claude/RULEBOOK.md" ]; then
        # Check if RULEBOOK has required sections
        if ! grep -q "## Active Agents" .claude/RULEBOOK.md 2>/dev/null; then
            print_warning "RULEBOOK format issue:"
            echo "  → Missing '## Active Agents' section"
            echo "  → RULEBOOK may need manual review after installation"
            warnings_found=true
        fi

        # Check for very old RULEBOOK format
        if grep -q "# GENTLEMAN MODE" .claude/RULEBOOK.md 2>/dev/null; then
            print_warning "Outdated RULEBOOK detected:"
            echo "  → Contains old 'GENTLEMAN MODE' references"
            echo "  → Should be updated to 'MAESTRO MODE'"
            warnings_found=true
        fi
    fi

    # Check 5: Multiple maestro files
    if [ -d ".claude/commands" ]; then
        local maestro_count=$(find .claude/commands -name "maestro*.md" 2>/dev/null | wc -l | tr -d ' ')

        if [ "$maestro_count" -gt 1 ]; then
            print_warning "Multiple Maestro configurations detected:"
            echo "  → Found: $maestro_count maestro files"
            echo "  → Only one should exist: maestro.md"
            warnings_found=true
        fi
    fi

    # Check 6: Permission conflicts
    if [ -d ".claude" ] && [ ! -w ".claude" ]; then
        print_error "Permission conflict:"
        echo "  → .claude directory is not writable"
        echo "  → Fix with: chmod -R u+w .claude"
        conflicts_found=true
    fi

    # Check 7: Symlinks that might break
    if [ -d ".claude" ]; then
        if [ -L ".claude" ]; then
            print_warning "Symbolic link detected:"
            echo "  → .claude is a symbolic link"
            echo "  → Installation may affect linked location"
            warnings_found=true
        fi
    fi

    # Check 8: Conflicting settings
    if [ -f ".claude/settings.json" ]; then
        # Check if settings.json is valid JSON
        if ! python3 -m json.tool .claude/settings.json >/dev/null 2>&1; then
            print_warning "Settings conflict:"
            echo "  → settings.json appears to be invalid JSON"
            echo "  → May cause issues after installation"
            warnings_found=true
        fi
    fi

    echo ""

    # Summary
    if [ "$conflicts_found" = true ]; then
        print_error "Critical conflicts found! Installation cannot proceed."
        echo ""
        echo "Please resolve the issues above and try again."
        echo ""
        return 1
    elif [ "$warnings_found" = true ]; then
        print_warning "Warnings detected. Review the issues above."
        echo ""
        echo "These are non-critical but may require attention."
        read -p "Continue with installation anyway? (y/N): " -n 1 -r
        echo

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            echo ""
            echo "Recommendation: Review conflicts and use ./update.sh if updating"
            exit 0
        fi
        echo ""
        return 0
    else
        print_success "No conflicts detected"
        echo ""
        return 0
    fi
}

# Backup existing .claude directory
backup_existing() {
    if [ -d ".claude" ]; then
        local backup_dir=".claude.backup.$(date +%Y-%m-%d-%H%M%S)"

        print_warning "Existing .claude directory found!"
        echo ""
        echo "This installation will overwrite existing files."
        echo "A backup will be created at: $backup_dir"
        echo ""
        read -p "Continue with backup and installation? (y/N): " -n 1 -r
        echo

        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            echo "Installation cancelled."
            echo ""
            echo "To proceed without backup, remove .claude directory first:"
            echo "  rm -rf .claude"
            exit 0
        fi

        echo ""
        print_info "Creating backup of existing .claude directory..."
        cp -r .claude "$backup_dir"
        print_success "Backup created: $backup_dir"
        echo ""

        return 0
    fi

    return 1
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
    local lang=$1
    local skip_self_enhancement=$2

    if [ "$lang" = "es" ]; then
        print_info "Installing Maestro Mode (Spanish version)..."
    else
        print_info "Installing Maestro Mode (English version)..."
    fi

    mkdir -p .claude/commands

    # Copy appropriate maestro file based on language
    if [ "$lang" = "es" ]; then
        cp commands/maestro.es.md .claude/commands/maestro.md
        if [ "$skip_self_enhancement" = "true" ]; then
            print_success "Maestro Mode installed (Spanish - without self-enhancement)"
        else
            print_success "Maestro Mode installed (Spanish - with self-enhancement)"
        fi
        print_info "  Communication: Spanish (Colombian)"
        print_info "  Code: English (always)"
    else
        cp commands/maestro.md .claude/commands/maestro.md
        if [ "$skip_self_enhancement" = "true" ]; then
            print_success "Maestro Mode installed (English - without self-enhancement)"
        else
            print_success "Maestro Mode installed (English - with self-enhancement)"
        fi
        print_info "  Communication: English"
        print_info "  Code: English (always)"
    fi

    # Copy other command files
    cp commands/agent-intelligence.md .claude/commands/
    cp commands/agent-router.md .claude/commands/
    cp commands/workflow-modes.md .claude/commands/

    # Conditionally copy self-enhancement
    if [ "$skip_self_enhancement" != "true" ]; then
        cp commands/self-enhancement.md .claude/commands/
        print_info "  Self-enhancement: Enabled (requires approval for changes)"
    else
        print_info "  Self-enhancement: Disabled"
    fi

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
    SKIP_SELF_ENHANCEMENT=false
    SKIP_BACKUP=false
    SKIP_WIZARD=false
    LANGUAGE="en"
    DRY_RUN=false

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
            --skip-self-enhancement)
                SKIP_SELF_ENHANCEMENT=true
                shift
                ;;
            --skip-backup)
                SKIP_BACKUP=true
                shift
                ;;
            --skip-wizard)
                SKIP_WIZARD=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --lang=*)
                LANGUAGE="${1#*=}"
                if [ "$LANGUAGE" != "en" ] && [ "$LANGUAGE" != "es" ]; then
                    print_error "Unsupported language: $LANGUAGE"
                    echo "Supported languages: en (English), es (Spanish)"
                    exit 1
                fi
                shift
                ;;
            --help)
                echo "Usage: ./install.sh [OPTIONS]"
                echo ""
                echo "Options:"
                echo "  --agents-only              Install only agents (skip Maestro Mode)"
                echo "  --skip-maestro             Skip Maestro Mode installation"
                echo "  --skip-self-enhancement    Skip self-enhancement system (Maestro won't learn/adapt)"
                echo "  --skip-backup              Skip automatic backup (not recommended)"
                echo "  --skip-wizard              Skip RULEBOOK wizard (create manually later)"
                echo "  --custom                   Interactive installation (choose components)"
                echo "  --lang=LANG                Set Maestro language (en or es, default: en)"
                echo "                             en: English communication, English code"
                echo "                             es: Spanish communication (Colombian), English code"
                echo "  --dry-run                  Preview installation without making changes"
                echo "  --help                     Show this help message"
                echo ""
                echo "Examples:"
                echo "  ./install.sh                              # Full installation (English)"
                echo "  ./install.sh --lang=es                    # Spanish Maestro with self-enhancement"
                echo "  ./install.sh --skip-self-enhancement      # Maestro without learning capability"
                echo "  ./install.sh --agents-only                # Only agents, no Maestro"
                echo "  ./install.sh --skip-wizard                # Skip RULEBOOK setup wizard"
                echo "  ./install.sh --dry-run                    # Preview what will be installed"
                echo ""
                echo "Safety:"
                echo "  • Existing .claude/ directories are backed up automatically"
                echo "  • Backups are timestamped: .claude.backup.YYYY-MM-DD-HHMMSS/"
                echo "  • Use --skip-backup to disable (not recommended)"
                echo ""
                echo "Note: For remote installation without cloning, see install-remote.sh"
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

    # Show dry-run notification
    if [ "$DRY_RUN" = true ]; then
        echo ""
        echo -e "${YELLOW}╔══════════════════════════════════════════════════════╗${NC}"
        echo -e "${YELLOW}║${NC}  🔍 DRY RUN MODE - No changes will be made      ${YELLOW}║${NC}"
        echo -e "${YELLOW}╚══════════════════════════════════════════════════════╝${NC}"
        echo ""
    fi

    # Check project directory
    check_project_directory

    # Detect conflicts before installation
    if [ "$DRY_RUN" = true ]; then
        if [ -d ".claude" ]; then
            print_info "[DRY RUN] Would check for conflicts..."
            echo "  ${BLUE}→${NC} Version conflicts"
            echo "  ${BLUE}→${NC} Partial installations"
            echo "  ${BLUE}→${NC} Custom agent conflicts"
            echo "  ${BLUE}→${NC} RULEBOOK format issues"
            echo "  ${BLUE}→${NC} Permission conflicts"
            print_success "Would detect and report conflicts"
            echo ""
        fi
    else
        detect_conflicts
    fi

    # Backup existing .claude directory (unless skipped)
    if [ "$SKIP_BACKUP" = false ]; then
        if [ "$DRY_RUN" = true ]; then
            if [ -d ".claude" ]; then
                echo ""
                print_info "[DRY RUN] Would backup existing .claude directory..."
                echo "  ${BLUE}→${NC} Backup location: .claude.backup.$(date +%Y-%m-%d-%H%M%S)"
                print_success "Would create backup before installation"
            fi
        else
            backup_existing
        fi
    else
        if [ -d ".claude" ]; then
            print_warning "Skipping backup (--skip-backup flag used)"
            echo ""
        fi
    fi

    # Create .claude directory
    if [ "$DRY_RUN" = true ]; then
        echo ""
        print_info "[DRY RUN] Would create .claude directory..."
        print_success ".claude/ directory"
    else
        create_claude_directory
    fi

    # Install agents
    if [ "$DRY_RUN" = true ]; then
        echo ""
        print_info "[DRY RUN] Would install 78 agents..."
        echo "  ${BLUE}→${NC} 10 core agents (code-reviewer, refactoring-specialist, etc.)"
        echo "  ${BLUE}→${NC} 68 specialized agents (framework-specific, language-specific)"
        echo "  ${BLUE}→${NC} Documentation files"
        print_success "Would copy: agents/core → .claude/agents-global/core"
        print_success "Would copy: agents/pool → .claude/agents-global/pool"
    else
        install_agents
    fi

    # Install Maestro Mode (unless skipped)
    if [ "$AGENTS_ONLY" = false ] && [ "$SKIP_MAESTRO" = false ]; then
        echo ""
        if [ "$DRY_RUN" = true ]; then
            print_info "[DRY RUN] Would install Maestro Mode..."
            echo "  ${BLUE}→${NC} Language: $LANGUAGE"
            echo "  ${BLUE}→${NC} Self-enhancement: $([ "$SKIP_SELF_ENHANCEMENT" = true ] && echo "Disabled" || echo "Enabled")"
            if [ "$LANGUAGE" = "es" ]; then
                print_success "Would copy: commands/maestro.es.md → .claude/commands/maestro.md"
            else
                print_success "Would copy: commands/maestro.md → .claude/commands/maestro.md"
            fi
            print_success "Would copy: agent-intelligence.md, agent-router.md, workflow-modes.md"
            if [ "$SKIP_SELF_ENHANCEMENT" != true ]; then
                print_success "Would copy: self-enhancement.md"
            fi
        elif [ "$CUSTOM" = true ]; then
            echo ""
            print_info "Custom Installation Mode"
            echo ""

            # Ask about Maestro Mode installation
            read -p "Install Maestro Mode? (Y/n): " -n 1 -r
            echo

            if [[ $REPLY =~ ^[Yy]$ ]] || [[ -z $REPLY ]]; then
                # Ask about language preference
                echo ""
                echo "Choose Maestro communication language:"
                echo "  [1] English (default)"
                echo "  [2] Spanish (Colombian)"
                echo ""
                read -p "Select option (1-2) [1]: " -n 1 -r LANG_CHOICE
                echo

                if [ "$LANG_CHOICE" = "2" ]; then
                    LANGUAGE="es"
                    print_success "Selected: Spanish (Colombian)"
                else
                    LANGUAGE="en"
                    print_success "Selected: English"
                fi

                # Ask about self-enhancement
                echo ""
                echo "Enable self-enhancement? (Maestro learns and adapts with your approval)"
                read -p "Enable self-enhancement? (Y/n): " -n 1 -r
                echo

                if [[ $REPLY =~ ^[Nn]$ ]]; then
                    SKIP_SELF_ENHANCEMENT=true
                    print_success "Self-enhancement: Disabled"
                else
                    SKIP_SELF_ENHANCEMENT=false
                    print_success "Self-enhancement: Enabled"
                fi

                echo ""
                install_maestro_mode "$LANGUAGE" "$SKIP_SELF_ENHANCEMENT"
            else
                print_info "Skipping Maestro Mode installation"
            fi
        else
            install_maestro_mode "$LANGUAGE" "$SKIP_SELF_ENHANCEMENT"
        fi
    fi

    # Run RULEBOOK wizard
    echo ""
    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would run RULEBOOK wizard..."
        echo "  ${BLUE}→${NC} Options: Auto-generate, Interactive, Template, Skip"
        echo "  ${BLUE}→${NC} Would scan current directory for project context"
        print_success "Would create: .claude/RULEBOOK.md"
    elif [ "$SKIP_WIZARD" = false ]; then
        if [ -f "scripts/rulebook-wizard.sh" ]; then
            bash scripts/rulebook-wizard.sh
        else
            print_warning "RULEBOOK wizard not found, using template..."
            generate_rulebook
        fi
    else
        print_info "RULEBOOK wizard skipped (--skip-wizard)"
        print_warning "You can run it later with: scripts/rulebook-wizard.sh"
    fi

    # Detect tech stack
    echo ""
    detect_tech_stack

    # Show active agents
    echo ""
    show_active_agents

    # Installation complete
    echo ""
    if [ "$DRY_RUN" = true ]; then
        print_success "════════════════════════════════════════════════════════"
        print_success "  Dry Run Complete - Preview Only!"
        print_success "════════════════════════════════════════════════════════"
        echo ""
        echo -e "${GREEN}Summary of what WOULD be installed:${NC}"
        echo ""
        echo "📁 Directories:"
        echo "  ${BLUE}→${NC} .claude/"
        echo "  ${BLUE}→${NC} .claude/agents-global/"
        echo "  ${BLUE}→${NC} .claude/commands/"
        echo ""
        echo "📦 Files:"
        echo "  ${BLUE}→${NC} 78 agents (10 core + 68 specialized)"
        if [ "$AGENTS_ONLY" = false ] && [ "$SKIP_MAESTRO" = false ]; then
            echo "  ${BLUE}→${NC} Maestro Mode ($LANGUAGE, self-enhancement: $([ "$SKIP_SELF_ENHANCEMENT" = true ] && echo "disabled" || echo "enabled"))"
        fi
        echo "  ${BLUE}→${NC} RULEBOOK.md (from template)"
        echo "  ${BLUE}→${NC} Documentation files"
        echo ""
        echo -e "${YELLOW}To actually install:${NC}"
        echo "  ${BLUE}→${NC} Run without --dry-run flag:"
        echo "     ./install.sh"
        echo ""
    else
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

        if [ "$AGENTS_ONLY" = false ] && [ "$SKIP_MAESTRO" = false ]; then
            echo "2. 🎭 Activate Maestro Mode (if installed):"
            echo "   ${BLUE}→${NC} Type ${YELLOW}/maestro${NC} in Claude Code"
            if [ "$LANGUAGE" = "es" ]; then
                echo "   ${BLUE}→${NC} Language: Spanish (Colombian) | Code: English"
            else
                echo "   ${BLUE}→${NC} Language: English | Code: English"
            fi
            if [ "$SKIP_SELF_ENHANCEMENT" = false ]; then
                echo "   ${BLUE}→${NC} Self-Enhancement: Enabled (learns with your approval)"
            else
                echo "   ${BLUE}→${NC} Self-Enhancement: Disabled (static behavior)"
            fi
            echo ""
        fi

        echo "3. 🤖 Use specialized agents:"
        echo "   ${BLUE}→${NC} Agents auto-activate based on your RULEBOOK"
        echo "   ${BLUE}→${NC} See .claude/agents-global/AGENT_SELECTION_GUIDE.md"
        echo ""
        echo "4. 📚 Read the documentation:"
        echo "   ${BLUE}→${NC} Check .claude/agents-global/README.md for details"
        echo ""

        if [ "$LANGUAGE" = "es" ]; then
            echo "💡 ${BLUE}Tip:${NC} To switch to English, reinstall with: ./install.sh"
        else
            echo "💡 ${BLUE}Tip:${NC} To switch to Spanish, reinstall with: ./install.sh --lang=es"
        fi

        if [ "$SKIP_SELF_ENHANCEMENT" = true ]; then
            echo "💡 ${BLUE}Tip:${NC} To enable self-enhancement, reinstall without --skip-self-enhancement"
        fi

        echo "💡 ${BLUE}Note:${NC} Code will ALWAYS be in English regardless of language setting"
        echo ""

        print_info "Happy coding! 💪"
        echo ""
    fi
}

# Run main installation
main "$@"
