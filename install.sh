#!/bin/bash

# Claude Code Agents Toolkit - Remote Installer
# Version: 1.0.0
# Description: Lightweight installer - downloads and installs without cloning repo
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/install.sh | bash
#   wget -qO- https://raw.githubusercontent.com/YOUR_REPO/main/install.sh | bash
#
#   Or with options:
#   curl -fsSL URL | bash -s -- --global
#   curl -fsSL URL | bash -s -- --lang=es

set -e

# Configuration
REPO_URL="${TOOLKIT_REPO_URL:-https://github.com/Dsantiagomj/claude-code-agents-toolkit}"
REPO_RAW_URL="${REPO_URL/github.com/raw.githubusercontent.com}/main"
VERSION="1.0.0"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Installation options
MAESTRO_LANG="en"
SELF_ENHANCEMENT=true
DRY_RUN=false
YES=false

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🚀 Claude Code Agents Toolkit - Remote Install  ${BLUE}║${NC}"
    echo -e "${BLUE}║${NC}     Lightweight installation without repo clone    ${BLUE}║${NC}"
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

# Show help
show_help() {
    cat << EOF
Claude Code Agents Toolkit - Remote Installer

USAGE:
    curl -fsSL URL/install.sh | bash
    curl -fsSL URL/install.sh | bash -s -- [OPTIONS]

OPTIONS:
    --lang=LANG            Set Maestro language (en or es) [default: en]
    --skip-self-enhancement Disable self-enhancement mode
    --yes                  Skip all prompts (auto-confirm)
    --dry-run              Show what would be installed without making changes
    --help                 Show this help message

NOTE: The toolkit installs globally to ~/.claude-global/ and creates
symlinks in your projects. This keeps your projects clean and allows
sharing agents across multiple projects.

EXAMPLES:
    # Standard installation (recommended)
    curl -fsSL URL/install.sh | bash

    # Spanish Maestro mode
    bash <(curl -fsSL URL/install.sh) --lang=es

    # Auto-confirm (no prompts)
    curl -fsSL URL/install.sh | bash -s -- --yes

ENVIRONMENT VARIABLES:
    TOOLKIT_REPO_URL       Override repository URL

For more information, visit: $REPO_URL
EOF
    exit 0
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --lang=*)
                MAESTRO_LANG="${1#*=}"
                shift
                ;;
            --skip-self-enhancement)
                SELF_ENHANCEMENT=false
                shift
                ;;
            --yes|-y)
                YES=true
                shift
                ;;
            --dry-run)
                DRY_RUN=true
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done

    # Validate language
    if [[ ! "$MAESTRO_LANG" =~ ^(en|es)$ ]]; then
        print_error "Invalid language: $MAESTRO_LANG (must be 'en' or 'es')"
        exit 1
    fi
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."

    # Check for curl or wget
    if ! command -v curl &> /dev/null && ! command -v wget &> /dev/null; then
        print_error "Neither curl nor wget found. Please install one of them."
        exit 1
    fi

    # Check for git (optional but recommended)
    if ! command -v git &> /dev/null; then
        print_warning "git not found - some features may be limited"
    fi

    print_success "Prerequisites check passed"
}

# Download file with curl or wget
download_file() {
    local url=$1
    local output=$2

    if command -v curl &> /dev/null; then
        curl -fsSL "$url" -o "$output" 2>/dev/null || return 1
    elif command -v wget &> /dev/null; then
        wget -q "$url" -O "$output" 2>/dev/null || return 1
    fi

    return 0
}

# Create directory structure
create_directories() {
    local base_dir=$1

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would create directories in: $base_dir"
        return
    fi

    print_info "Creating directory structure..."

    mkdir -p "$base_dir/agents/core"
    mkdir -p "$base_dir/agents/pool"
    mkdir -p "$base_dir/commands"
    mkdir -p "$base_dir/scripts"

    print_success "Directory structure created"
}

# Download agents
download_agents() {
    local base_dir=$1

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download 72 agents to: $base_dir/agents/"
        return
    fi

    print_info "Downloading agents..."

    # Download core agents manifest
    local core_agents=(
        "code-reviewer.md"
        "refactoring-specialist.md"
        "documentation-engineer.md"
        "test-strategist.md"
        "architecture-advisor.md"
        "security-auditor.md"
        "performance-optimizer.md"
        "git-workflow-specialist.md"
        "dependency-manager.md"
        "project-analyzer.md"
    )

    # Download core agents
    for agent in "${core_agents[@]}"; do
        if download_file "$REPO_RAW_URL/agents/core/$agent" "$base_dir/agents/core/$agent"; then
            echo -e "  ${GREEN}✓${NC} Downloaded: core/$agent"
        else
            print_warning "Failed to download: core/$agent"
        fi
    done

    # Download pool agents by category
    print_info "Downloading specialized agents pool..."

    local pool_agents=(
        "01-frontend/react-specialist.md" "01-frontend/vue-specialist.md" "01-frontend/angular-specialist.md"
        "01-frontend/svelte-specialist.md" "01-frontend/tailwind-expert.md" "01-frontend/css-architect.md"
        "01-frontend/ui-accessibility.md" "01-frontend/animation-specialist.md"
        "02-backend/express-specialist.md" "02-backend/nest-specialist.md" "02-backend/fastify-expert.md"
        "02-backend/koa-expert.md" "02-backend/graphql-specialist.md" "02-backend/rest-api-architect.md"
        "02-backend/microservices-architect.md" "02-backend/websocket-expert.md"
        "03-fullstack-frameworks/nextjs-specialist.md" "03-fullstack-frameworks/nuxt-specialist.md"
        "03-fullstack-frameworks/remix-specialist.md" "03-fullstack-frameworks/sveltekit-specialist.md"
        "03-fullstack-frameworks/astro-specialist.md" "03-fullstack-frameworks/solidstart-specialist.md"
        "04-languages/typescript-pro.md" "04-languages/javascript-modernizer.md" "04-languages/python-specialist.md"
        "04-languages/rust-expert.md" "04-languages/go-specialist.md" "04-languages/java-specialist.md"
        "04-languages/php-modernizer.md" "04-languages/csharp-specialist.md"
        "05-databases/postgres-expert.md" "05-databases/mysql-specialist.md" "05-databases/mongodb-expert.md"
        "05-databases/redis-specialist.md" "05-databases/prisma-specialist.md" "05-databases/drizzle-specialist.md"
        "05-databases/typeorm-expert.md" "05-databases/sequelize-expert.md"
        "06-infrastructure/docker-specialist.md" "06-infrastructure/kubernetes-expert.md"
        "06-infrastructure/aws-cloud-specialist.md" "06-infrastructure/vercel-deployment-specialist.md"
        "06-infrastructure/cloudflare-edge-specialist.md" "06-infrastructure/terraform-iac-specialist.md"
        "06-infrastructure/cicd-automation-specialist.md" "06-infrastructure/nginx-load-balancer-specialist.md"
        "06-infrastructure/monitoring-observability-specialist.md"
        "07-testing/jest-testing-specialist.md" "07-testing/vitest-specialist.md" "07-testing/cypress-specialist.md"
        "07-testing/playwright-e2e-specialist.md" "07-testing/testing-library-specialist.md"
        "07-testing/storybook-testing-specialist.md" "07-testing/test-automation-strategist.md"
        "08-specialized/react-native-mobile-specialist.md" "08-specialized/electron-desktop-specialist.md"
        "08-specialized/cli-tools-specialist.md" "08-specialized/browser-extension-specialist.md"
        "08-specialized/ai-ml-integration-specialist.md" "08-specialized/blockchain-web3-specialist.md"
        "08-specialized/data-pipeline-specialist.md" "08-specialized/game-development-specialist.md"
    )

    local downloaded=0
    for agent in "${pool_agents[@]}"; do
        local dir=$(dirname "$agent")
        mkdir -p "$base_dir/agents/pool/$dir"
        if download_file "$REPO_RAW_URL/agents/pool/$agent" "$base_dir/agents/pool/$agent"; then
            ((downloaded++))
        fi
    done

    print_success "Downloaded $downloaded/${#pool_agents[@]} pool agents"
}

# Download AI personas (Maestro + Coordinator)
download_personas() {
    local base_dir=$1
    local lang=$2

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download Maestro Mode ($lang) and Coordinator Mode"
        return
    fi

    print_info "Downloading AI personas..."

    # Download both Maestro language versions (en and es)
    if download_file "$REPO_RAW_URL/commands/maestro.md" "$base_dir/commands/maestro.md"; then
        echo -e "  ${GREEN}✓${NC} Downloaded: maestro.md (English)"
    else
        print_warning "Failed to download maestro.md"
    fi

    if download_file "$REPO_RAW_URL/commands/maestro.es.md" "$base_dir/commands/maestro.es.md"; then
        echo -e "  ${GREEN}✓${NC} Downloaded: maestro.es.md (Spanish)"
    else
        print_warning "Failed to download maestro.es.md"
    fi

    # Download Coordinator
    if download_file "$REPO_RAW_URL/commands/coordinator.md" "$base_dir/commands/coordinator.md"; then
        echo -e "  ${GREEN}✓${NC} Downloaded: coordinator.md"
    else
        print_warning "Failed to download coordinator.md"
    fi

    # Download supporting files
    local supporting_files=(
        "agent-intelligence.md"
        "agent-router.md"
        "workflow-modes.md"
    )

    for file in "${supporting_files[@]}"; do
        if download_file "$REPO_RAW_URL/commands/$file" "$base_dir/commands/$file"; then
            echo -e "  ${GREEN}✓${NC} Downloaded: $file"
        else
            print_warning "Failed to download $file"
        fi
    done

    print_success "AI personas downloaded (Maestro en/es + Coordinator)"
}

# Download self-enhancement
download_self_enhancement() {
    local base_dir=$1

    if [ "$SELF_ENHANCEMENT" = false ]; then
        print_info "Self-enhancement disabled (skipped)"
        return
    fi

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download self-enhancement"
        return
    fi

    print_info "Downloading self-enhancement mode..."

    if download_file "$REPO_RAW_URL/commands/self-enhancement.md" "$base_dir/commands/self-enhancement.md"; then
        print_success "Self-enhancement mode downloaded"
    else
        print_warning "Failed to download self-enhancement"
    fi
}

# Download scripts
download_scripts() {
    local base_dir=$1

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download management scripts"
        return
    fi

    print_info "Downloading management scripts..."

    # Scripts go to base_dir/scripts for global installs
    local scripts_dir="$base_dir/scripts"
    mkdir -p "$scripts_dir"
    mkdir -p "$scripts_dir/lib"

    local scripts=(
        "init-project.sh"
        "select-agents.sh"
        "validate-rulebook.sh"
        "test-agent.sh"
        "agent-stats.sh"
        "export-config.sh"
        "import-config.sh"
        "install-git-hooks.sh"
        "migrate.sh"
        "switch-language.sh"
        "toggle-enhancement.sh"
        "healthcheck.sh"
        "update.sh"
        "uninstall.sh"
    )

    for script in "${scripts[@]}"; do
        if download_file "$REPO_RAW_URL/scripts/$script" "$scripts_dir/$script"; then
            chmod +x "$scripts_dir/$script"
            echo -e "  ${GREEN}✓${NC} Downloaded: $script"
        else
            print_warning "Failed to download: $script"
        fi
    done

    # Download lib/common.sh (required by all scripts)
    if download_file "$REPO_RAW_URL/scripts/lib/common.sh" "$scripts_dir/lib/common.sh"; then
        echo -e "  ${GREEN}✓${NC} Downloaded: lib/common.sh"
    else
        print_warning "Failed to download: lib/common.sh"
    fi

    print_success "Management scripts downloaded"
}

# Create version file
create_version_file() {
    local base_dir=$1

    if [ "$DRY_RUN" = true ]; then
        return
    fi

    echo "$VERSION" > "$base_dir/.toolkit-version"
}

# Setup shell integration (aliases and PATH)
setup_shell_integration() {
    local shell_config=""

    # Detect shell configuration file
    if [ -n "$BASH_VERSION" ]; then
        if [ -f "$HOME/.bashrc" ]; then
            shell_config="$HOME/.bashrc"
        elif [ -f "$HOME/.bash_profile" ]; then
            shell_config="$HOME/.bash_profile"
        fi
    elif [ -n "$ZSH_VERSION" ]; then
        shell_config="$HOME/.zshrc"
    fi

    # If we couldn't detect, try common ones
    if [ -z "$shell_config" ]; then
        if [ -f "$HOME/.zshrc" ]; then
            shell_config="$HOME/.zshrc"
        elif [ -f "$HOME/.bashrc" ]; then
            shell_config="$HOME/.bashrc"
        fi
    fi

    if [ -n "$shell_config" ]; then
        # Check if already added
        if grep -q "claude-code-agents-toolkit" "$shell_config" 2>/dev/null; then
            print_info "Shell integration already configured in $shell_config"
            return
        fi

        # Auto-add if --yes flag, otherwise ask
        if [ "$YES" = true ]; then
            cat >> "$shell_config" << 'SHELL_CONFIG'

# Claude Code Agents Toolkit
export PATH="$HOME/.claude-global/scripts:$PATH"

# Main commands
alias claude-init='~/.claude-global/scripts/init-project.sh'

# Agent management
alias claude-agents='~/.claude-global/scripts/select-agents.sh'
alias claude-test-agent='~/.claude-global/scripts/test-agent.sh'
alias claude-stats='~/.claude-global/scripts/agent-stats.sh'

# RULEBOOK
alias claude-validate='~/.claude-global/scripts/validate-rulebook.sh'

# Configuration
alias claude-export='~/.claude-global/scripts/export-config.sh'
alias claude-import='~/.claude-global/scripts/import-config.sh'
alias claude-switch-lang='~/.claude-global/scripts/switch-language.sh'
alias claude-enhancement='~/.claude-global/scripts/toggle-enhancement.sh'

# Git hooks
alias claude-hooks='~/.claude-global/scripts/install-git-hooks.sh'

# Utilities
alias claude-health='~/.claude-global/scripts/healthcheck.sh'
alias claude-update='~/.claude-global/scripts/update.sh'
alias claude-migrate='~/.claude-global/scripts/migrate.sh'
alias claude-uninstall='~/.claude-global/scripts/uninstall.sh'
SHELL_CONFIG

            print_success "Shell integration added to $shell_config"
        else
            echo ""
            echo "Add comprehensive claude-* aliases to your shell?"
            echo ""
            echo "This will add ${CYAN}13 aliases${NC} for quick access:"
            echo "  ${CYAN}claude-init${NC}          - Initialize project (choose Maestro/Coordinator)"
            echo "  ${CYAN}claude-agents${NC}        - Manage active agents"
            echo "  ${CYAN}claude-test-agent${NC}    - Browse all 72 agents"
            echo "  ${CYAN}claude-stats${NC}         - View agent statistics"
            echo "  ${CYAN}claude-validate${NC}      - Validate RULEBOOK"
            echo "  ${CYAN}claude-export/import${NC} - Configuration management"
            echo "  ${CYAN}claude-switch-lang${NC}   - Switch Maestro language"
            echo "  ${CYAN}claude-enhancement${NC}   - Toggle self-enhancement"
            echo "  ${CYAN}claude-hooks${NC}         - Install git hooks"
            echo "  ${CYAN}claude-health${NC}        - Check installation"
            echo "  ${CYAN}claude-update${NC}        - Update toolkit"
            echo "  ${CYAN}claude-migrate${NC}       - Migrate versions"
            echo "  ${CYAN}claude-uninstall${NC}     - Uninstall toolkit"
            echo ""
            read -p "Add to $shell_config? (Y/n): " -n 1 -r
            echo

            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                cat >> "$shell_config" << 'SHELL_CONFIG'

# Claude Code Agents Toolkit
export PATH="$HOME/.claude-global/scripts:$PATH"

# Main commands
alias claude-init='~/.claude-global/scripts/init-project.sh'

# Agent management
alias claude-agents='~/.claude-global/scripts/select-agents.sh'
alias claude-test-agent='~/.claude-global/scripts/test-agent.sh'
alias claude-stats='~/.claude-global/scripts/agent-stats.sh'

# RULEBOOK
alias claude-validate='~/.claude-global/scripts/validate-rulebook.sh'

# Configuration
alias claude-export='~/.claude-global/scripts/export-config.sh'
alias claude-import='~/.claude-global/scripts/import-config.sh'
alias claude-switch-lang='~/.claude-global/scripts/switch-language.sh'
alias claude-enhancement='~/.claude-global/scripts/toggle-enhancement.sh'

# Git hooks
alias claude-hooks='~/.claude-global/scripts/install-git-hooks.sh'

# Utilities
alias claude-health='~/.claude-global/scripts/healthcheck.sh'
alias claude-update='~/.claude-global/scripts/update.sh'
alias claude-migrate='~/.claude-global/scripts/migrate.sh'
alias claude-uninstall='~/.claude-global/scripts/uninstall.sh'
SHELL_CONFIG

                print_success "Shell integration added to $shell_config"
                echo ""
                echo "Reload your shell or run:"
                echo -e "  ${CYAN}source $shell_config${NC}"
                echo ""
                echo "Then use any ${CYAN}claude-*${NC} command!"
            else
                print_info "Skipped shell integration"
                echo ""
                echo "All scripts are still available in PATH:"
                echo -e "  ${CYAN}\$HOME/.claude-global/scripts/${NC}"
                echo ""
                echo "Or run directly:"
                echo -e "  ${CYAN}~/.claude-global/scripts/init-project.sh${NC}"
            fi
        fi
    else
        print_info "Could not detect shell config file"
        echo ""
        echo "To add aliases manually, add to your shell config:"
        echo -e "  ${CYAN}export PATH=\"\$HOME/.claude-global/scripts:\$PATH\"${NC}"
        echo -e "  ${CYAN}# Then add claude-* aliases (see ~/.claude-global/scripts/)${NC}"
    fi

    echo ""
}

# Install globally
install_global() {
    print_info "Installing globally to: ~/.claude-global"

    local base_dir="$HOME/.claude-global"

    # Check if already installed
    if [ -d "$base_dir" ] && [ "$DRY_RUN" = false ]; then
        print_warning "Global installation already exists"
        if [ "$YES" = false ]; then
            read -p "Overwrite? (y/N): " -n 1 -r
        echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled"
                exit 0
            fi
        fi

        mv "$base_dir" "${base_dir}.backup-$(date +%Y%m%d-%H%M%S)"
        print_success "Existing global installation backed up"
    fi

    # Create structure
    create_directories "$base_dir"

    # Download components
    download_agents "$base_dir"
    download_personas "$base_dir" "$MAESTRO_LANG"
    download_self_enhancement "$base_dir"
    download_scripts "$base_dir"
    create_version_file "$base_dir"

    if [ "$DRY_RUN" = false ]; then
        print_success "Global installation complete!"
        print_success "Toolkit installed at ~/.claude-global/"

        # Setup shell aliases and PATH
        setup_shell_integration

        echo ""
        echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        echo -e "${CYAN}  Next: Initialize your first project${NC}"
        echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
        echo ""

        # Ask if they want to init current directory
        if [ "$YES" = false ]; then
            echo "Current directory: $(pwd)"
            echo ""
            read -p "Initialize this directory as a project? (Y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                echo ""
                if [ -f "$base_dir/scripts/init-project.sh" ]; then
                    bash "$base_dir/scripts/init-project.sh"
                fi
            else
                echo ""
                print_info "To initialize a project later, run:"
                echo -e "  ${CYAN}claude-init${NC}  (if you added shell integration)"
                echo -e "  ${CYAN}~/.claude-global/scripts/init-project.sh${NC}"
                echo ""
            fi
        else
            print_info "To initialize a project, run:"
            echo -e "  ${CYAN}claude-init${NC}  (if you added shell integration)"
            echo -e "  ${CYAN}~/.claude-global/scripts/init-project.sh${NC}"
            echo ""
        fi
    fi
}

# Show post-installation message
show_post_install() {
    if [ "$DRY_RUN" = true ]; then
        echo ""
        print_info "[DRY RUN] Installation simulation complete"
        return
    fi

    echo ""
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}   Installation Successful! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════${NC}"
    echo ""

    echo "Global installation: ${BLUE}~/.claude-global/${NC}"
    echo "  ├── agents/        ${BLUE}72 agents (10 core + 62 pool)${NC}"
    echo "  ├── commands/      ${BLUE}Maestro (en/es) + Coordinator + Supporting files${NC}"
    echo "  └── scripts/       ${BLUE}14 management tools${NC}"
    echo ""

    # Check if shell integration was added
    local shell_config=""
    if [ -f "$HOME/.zshrc" ]; then
        shell_config="$HOME/.zshrc"
    elif [ -f "$HOME/.bashrc" ]; then
        shell_config="$HOME/.bashrc"
    fi

    if [ -n "$shell_config" ] && grep -q "claude-code-agents-toolkit" "$shell_config" 2>/dev/null; then
        echo "Quick commands (${YELLOW}reload shell first${NC}):"
        echo -e "  ${CYAN}claude-init${NC}           - Initialize project (choose Maestro/Coordinator)"
        echo -e "  ${CYAN}claude-agents${NC}         - Manage active agents"
        echo -e "  ${CYAN}claude-test-agent${NC}     - Browse all 72 agents"
        echo -e "  ${CYAN}claude-health${NC}         - Check installation"
        echo -e "  ${CYAN}claude-update${NC}         - Update toolkit"
        echo ""
        echo "See all aliases: ${CYAN}alias | grep claude${NC}"
    else
        echo "To use in projects:"
        echo -e "  ${CYAN}~/.claude-global/scripts/init-project.sh${NC}"
        echo ""
        echo "Or use the alias (after adding shell integration):"
        echo -e "  ${CYAN}claude-init${NC}"
    fi

    echo ""
}

# Main installation flow
main() {
    # Parse arguments
    parse_args "$@"

    # Auto-detect if running in non-interactive mode (piped from curl)
    if [ ! -t 0 ] && [ "$YES" = false ]; then
        # stdin is not a terminal (piped), auto-enable non-interactive mode
        echo ""
        echo -e "${YELLOW}⚠${NC} Non-interactive mode detected (piped installation)"
        echo -e "${YELLOW}⚠${NC} Auto-confirming prompts. Use 'bash <(curl ...)' for interactive mode"
        echo ""
        YES=true
    fi

    print_header

    # Check prerequisites
    check_prerequisites

    # Show configuration
    echo ""
    print_info "Installation Configuration:"
    echo "  Mode: Global installation"
    echo "  Location: ~/.claude-global/"
    echo "  Maestro Language: $MAESTRO_LANG (both en/es will be installed)"
    echo "  Coordinator: Included"
    echo "  Self-Enhancement: $([ "$SELF_ENHANCEMENT" = true ] && echo "Enabled" || echo "Disabled")"
    echo "  Dry Run: $([ "$DRY_RUN" = true ] && echo "Yes" || echo "No")"
    echo ""

    # Confirm installation
    if [ "$DRY_RUN" = false ] && [ "$YES" = false ]; then
        read -p "Continue with installation? (Y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi

    # Install globally (only option now)
    install_global

    # Show post-installation message
    show_post_install
}

# Run main
main "$@"
