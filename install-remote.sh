#!/bin/bash

# Claude Code Agents Toolkit - Remote Installer
# Version: 1.0.0
# Description: Lightweight installer - downloads and installs without cloning repo
#
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/YOUR_REPO/main/install-remote.sh | bash
#   wget -qO- https://raw.githubusercontent.com/YOUR_REPO/main/install-remote.sh | bash
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
INSTALL_LOCAL=false  # Changed: Now global is default, --local is the flag
MAESTRO_LANG="en"
SELF_ENHANCEMENT=true
DRY_RUN=false
SKIP_WIZARD=false
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
    curl -fsSL URL/install-remote.sh | bash
    curl -fsSL URL/install-remote.sh | bash -s -- [OPTIONS]

OPTIONS:
    --local                 Install locally (copy files to project) [not recommended]
    --lang=LANG            Set Maestro language (en or es) [default: en]
    --skip-self-enhancement Disable self-enhancement mode
    --skip-wizard          Skip RULEBOOK wizard after installation
    --yes                  Skip all prompts (auto-confirm)
    --dry-run              Show what would be installed without making changes
    --help                 Show this help message

NOTE: Global installation is now the default. The toolkit installs to
~/.claude-global/ and creates symlinks in your project. This keeps your
projects clean and allows sharing agents across multiple projects.

EXAMPLES:
    # Standard global installation (recommended)
    curl -fsSL URL/install-remote.sh | bash

    # Spanish Maestro mode
    curl -fsSL URL/install-remote.sh | bash -s -- --lang=es

    # Local installation (all files in project)
    curl -fsSL URL/install-remote.sh | bash -s -- --local

    # Skip RULEBOOK wizard
    curl -fsSL URL/install-remote.sh | bash -s -- --skip-wizard

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
            --local)
                INSTALL_LOCAL=true
                shift
                ;;
            --global)
                # Keep for backward compatibility, but it's now the default
                print_warning "--global is now the default, no need to specify it"
                shift
                ;;
            --lang=*)
                MAESTRO_LANG="${1#*=}"
                shift
                ;;
            --skip-self-enhancement)
                SELF_ENHANCEMENT=false
                shift
                ;;
            --skip-wizard)
                SKIP_WIZARD=true
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

# Download Maestro Mode
download_maestro() {
    local base_dir=$1
    local lang=$2

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download Maestro Mode ($lang)"
        return
    fi

    print_info "Downloading Maestro Mode ($lang)..."

    local maestro_file="maestro.md"
    local source_file

    # English uses maestro.md, others use maestro.{lang}.md
    if [ "$lang" = "en" ]; then
        source_file="maestro.md"
    else
        source_file="maestro.${lang}.md"
    fi

    if download_file "$REPO_RAW_URL/commands/$source_file" "$base_dir/commands/$maestro_file"; then
        print_success "Maestro Mode downloaded"
    else
        print_warning "Failed to download Maestro Mode"
    fi
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

    local scripts=(
        "rulebook-wizard.sh"
        "questionnaire.sh"
        "select-agents.sh"
        "validate-rulebook.sh"
        "test-agent.sh"
        "healthcheck.sh"
        "update.sh"
    )

    for script in "${scripts[@]}"; do
        if download_file "$REPO_RAW_URL/scripts/$script" "$scripts_dir/$script"; then
            chmod +x "$scripts_dir/$script"
            echo -e "  ${GREEN}✓${NC} Downloaded: $script"
        else
            print_warning "Failed to download: $script"
        fi
    done

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

# Install to current directory
install_local() {
    print_info "Installing to current directory: $(pwd)"

    local base_dir=".claude"

    # Check if already installed
    if [ -d "$base_dir" ] && [ "$DRY_RUN" = false ]; then
        print_warning ".claude directory already exists"
        if [ "$YES" = false ]; then
            read -p "Overwrite? (y/N): " -n 1 -r
        echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_info "Installation cancelled"
                exit 0
            fi
        fi

        # Backup existing installation
        mv "$base_dir" "${base_dir}.backup-$(date +%Y%m%d-%H%M%S)"
        print_success "Existing installation backed up"
    fi

    # Create structure
    create_directories "$base_dir"

    # Download components
    download_agents "$base_dir"
    download_maestro "$base_dir" "$MAESTRO_LANG"
    download_self_enhancement "$base_dir"
    download_scripts "$base_dir"
    create_version_file "$base_dir"

    if [ "$DRY_RUN" = false ]; then
        print_success "Installation complete!"

        # Run RULEBOOK wizard
        if [ "$SKIP_WIZARD" = false ] && [ "$YES" = false ]; then
            echo ""
            print_info "Now let's set up your RULEBOOK..."
            echo ""
            read -p "Run RULEBOOK wizard? (Y/n): " -n 1 -r
        echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                if [ -f "scripts/rulebook-wizard.sh" ]; then
                    bash scripts/rulebook-wizard.sh
                else
                    print_warning "RULEBOOK wizard not found, skipping"
                fi
            fi
        fi
    fi
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
    download_maestro "$base_dir" "$MAESTRO_LANG"
    download_self_enhancement "$base_dir"
    download_scripts "$base_dir"
    create_version_file "$base_dir"

    if [ "$DRY_RUN" = false ]; then
        # Create minimal per-project setup
        print_info "Setting up project directory..."
        mkdir -p .claude

        # Create symlinks to global installation
        ln -sf "$base_dir/agents" .claude/agents
        ln -sf "$base_dir/commands" .claude/commands
        ln -sf "$base_dir/.toolkit-version" .claude/.toolkit-version

        # Create empty agents-active.txt (project-specific)
        touch .claude/agents-active.txt

        print_success "Global installation complete!"
        print_success "Project setup created (symlinks + local config)"

        # Run RULEBOOK wizard for current project
        if [ "$SKIP_WIZARD" = false ] && [ "$YES" = false ]; then
            echo ""
            print_info "Now let's set up your project's RULEBOOK..."
            echo ""
            read -p "Run RULEBOOK wizard? (Y/n): " -n 1 -r
        echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                if [ -f "$base_dir/scripts/rulebook-wizard.sh" ]; then
                    bash "$base_dir/scripts/rulebook-wizard.sh"
                else
                    print_warning "RULEBOOK wizard not found, skipping"
                fi
            fi
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

    if [ "$INSTALL_LOCAL" = false ]; then
        echo "Global installation: ${BLUE}~/.claude-global/${NC}"
        echo "Project directory: ${BLUE}.claude/${NC} (symlinks)"
        echo "Project config: ${BLUE}RULEBOOK.md${NC}"
        echo ""
        echo "To use in other projects:"
        echo "  ${BLUE}bash <(curl -fsSL URL/install-remote.sh)${NC}"
    else
        echo "Local installation: ${BLUE}.claude/${NC}"
        echo "Project config: ${BLUE}RULEBOOK.md${NC}"
    fi

    echo ""
    echo "Useful commands:"
    echo "  ${BLUE}~/.claude-global/scripts/select-agents.sh${NC}      - Manage active agents"
    echo "  ${BLUE}~/.claude-global/scripts/test-agent.sh${NC}         - Browse available agents"
    echo "  ${BLUE}~/.claude-global/scripts/validate-rulebook.sh${NC}  - Validate your RULEBOOK"
    echo "  ${BLUE}~/.claude-global/scripts/healthcheck.sh${NC}        - Check installation health"
    echo ""
    echo "Or add ~/.claude-global/scripts to your PATH for easier access!"
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
        SKIP_WIZARD=true
    fi

    print_header

    # Check prerequisites
    check_prerequisites

    # Show configuration
    echo ""
    print_info "Installation Configuration:"
    echo "  Mode: $([ "$INSTALL_LOCAL" = true ] && echo "Local (project-only)" || echo "Global (recommended)")"
    echo "  Location: $([ "$INSTALL_LOCAL" = true ] && echo ".claude/" || echo "~/.claude-global/")"
    echo "  Maestro Language: $MAESTRO_LANG"
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

    # Install (global is now the default)
    if [ "$INSTALL_LOCAL" = true ]; then
        install_local
    else
        install_global
    fi

    # Show post-installation message
    show_post_install
}

# Run main
main "$@"
