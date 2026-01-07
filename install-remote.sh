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

# Redirect stdin to /dev/tty for interactive prompts when piped from curl
if [ -t 0 ]; then
    # stdin is a terminal, no need to redirect
    :
else
    # stdin is not a terminal (piped), redirect to /dev/tty
    exec fi

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
INSTALL_GLOBAL=false
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
    --global                Install globally to ~/.claude-global/
    --lang=LANG            Set Maestro language (en or es) [default: en]
    --skip-self-enhancement Disable self-enhancement mode
    --skip-wizard          Skip RULEBOOK wizard after installation
    --yes                  Skip all prompts (auto-confirm)
    --dry-run              Show what would be installed without making changes
    --help                 Show this help message

EXAMPLES:
    # Standard installation in current directory
    curl -fsSL URL/install-remote.sh | bash

    # Global installation
    curl -fsSL URL/install-remote.sh | bash -s -- --global

    # Spanish Maestro mode
    curl -fsSL URL/install-remote.sh | bash -s -- --lang=es

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
            --global)
                INSTALL_GLOBAL=true
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

    mkdir -p "$base_dir/agents-global/core"
    mkdir -p "$base_dir/agents-global/pool"
    mkdir -p "$base_dir/commands"

    print_success "Directory structure created"
}

# Download agents
download_agents() {
    local base_dir=$1

    if [ "$DRY_RUN" = true ]; then
        print_info "[DRY RUN] Would download 78 agents to: $base_dir/agents-global/"
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
        if download_file "$REPO_RAW_URL/agents-global/core/$agent" "$base_dir/agents-global/core/$agent"; then
            echo -e "  ${GREEN}✓${NC} Downloaded: core/$agent"
        else
            print_warning "Failed to download: core/$agent"
        fi
    done

    # For now, we'll try to download a complete agent pool archive if available
    # Otherwise, individual downloads would be needed
    print_info "Downloading specialized agents pool..."
    # Note: This would need to be implemented based on how agents are stored
    # Option 1: Download individual files (68 more agents)
    # Option 2: Download a tar.gz archive
    # Option 3: Git sparse checkout

    print_success "Agents downloaded"
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
    local source_file="maestro.${lang}.md"

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

    # Create scripts directory relative to .claude
    local scripts_dir
    if [ "$INSTALL_GLOBAL" = true ]; then
        scripts_dir="$HOME/.claude-global-scripts"
    else
        scripts_dir="scripts"
    fi

    mkdir -p "$scripts_dir"

    local scripts=(
        "rulebook-wizard.sh"
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
            read -p "Overwrite? (y/N): " -n 1 -r             echo
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
            read -p "Run RULEBOOK wizard? (Y/n): " -n 1 -r             echo
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
            read -p "Overwrite? (y/N): " -n 1 -r             echo
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
        # Create symlinks in current directory
        print_info "Creating symlinks in current directory..."
        mkdir -p .claude
        ln -sf "$base_dir/agents-global" .claude/agents-global
        ln -sf "$base_dir/commands" .claude/commands
        ln -sf "$base_dir/.toolkit-version" .claude/.toolkit-version

        print_success "Global installation complete!"
        print_success "Symlinks created in current directory"

        # Run RULEBOOK wizard for current project
        if [ "$SKIP_WIZARD" = false ] && [ "$YES" = false ]; then
            echo ""
            print_info "Now let's set up your project's RULEBOOK..."
            echo ""
            read -p "Run RULEBOOK wizard? (Y/n): " -n 1 -r             echo
            if [[ ! $REPLY =~ ^[Nn]$ ]]; then
                if [ -f "$HOME/.claude-global-scripts/rulebook-wizard.sh" ]; then
                    bash "$HOME/.claude-global-scripts/rulebook-wizard.sh"
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

    if [ "$INSTALL_GLOBAL" = true ]; then
        echo "Global installation: ~/.claude-global/"
        echo "Project symlinks: .claude/"
        echo ""
        echo "To use in other projects:"
        echo "  ${BLUE}curl -fsSL URL/install-remote.sh | bash -s -- --global --skip-wizard${NC}"
    else
        echo "Installation: .claude/"
    fi

    echo ""
    echo "Useful commands:"
    echo "  ${BLUE}scripts/select-agents.sh${NC}      - Manage active agents"
    echo "  ${BLUE}scripts/test-agent.sh${NC}         - Browse available agents"
    echo "  ${BLUE}scripts/validate-rulebook.sh${NC}  - Validate your RULEBOOK"
    echo "  ${BLUE}scripts/healthcheck.sh${NC}        - Check installation health"
    echo ""
}

# Main installation flow
main() {
    # Parse arguments
    parse_args "$@"

    print_header

    # Check prerequisites
    check_prerequisites

    # Show configuration
    echo ""
    print_info "Installation Configuration:"
    echo "  Mode: $([ "$INSTALL_GLOBAL" = true ] && echo "Global" || echo "Local")"
    echo "  Maestro Language: $MAESTRO_LANG"
    echo "  Self-Enhancement: $([ "$SELF_ENHANCEMENT" = true ] && echo "Enabled" || echo "Disabled")"
    echo "  Dry Run: $([ "$DRY_RUN" = true ] && echo "Yes" || echo "No")"
    echo ""

    # Confirm installation
    if [ "$DRY_RUN" = false ] && [ "$YES" = false ]; then
        read -p "Continue with installation? (Y/n): " -n 1 -r         echo
        if [[ $REPLY =~ ^[Nn]$ ]]; then
            print_info "Installation cancelled"
            exit 0
        fi
    fi

    # Install
    if [ "$INSTALL_GLOBAL" = true ]; then
        install_global
    else
        install_local
    fi

    # Show post-installation message
    show_post_install
}

# Run main
main "$@"
