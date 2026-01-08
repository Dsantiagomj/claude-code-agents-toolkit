#!/bin/bash

# Claude Code Agents Toolkit - Common Library
# Version: 1.0.0
# Description: Shared functions and variables for all scripts

# ============================================================================
# COLORS
# ============================================================================

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
MAGENTA='\033[0;35m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# ============================================================================
# PATHS
# ============================================================================
# NOTE: Installation is ALWAYS global at ~/.claude-global/
# Project .claude/ directories contain symlinks + project-specific config only

# Global installation paths (always here)
GLOBAL_DIR="${HOME}/.claude-global"
AGENTS_DIR_GLOBAL="${GLOBAL_DIR}/agents"
COMMANDS_DIR_GLOBAL="${GLOBAL_DIR}/commands"
SCRIPTS_DIR="${GLOBAL_DIR}/scripts"
TOOLKIT_VERSION_FILE="${GLOBAL_DIR}/.toolkit-version"

# Local project paths (project-specific config + symlinks to global)
CLAUDE_LOCAL_DIR=".claude"
RULEBOOK_LOCAL="${CLAUDE_LOCAL_DIR}/RULEBOOK.md"
COMMANDS_LOCAL_SYMLINK="${CLAUDE_LOCAL_DIR}/commands"  # Symlink to COMMANDS_DIR_GLOBAL
AGENTS_LOCAL_SYMLINK="${CLAUDE_LOCAL_DIR}/agents"      # Symlink to AGENTS_DIR_GLOBAL
SETTINGS_LOCAL_FILE="${CLAUDE_LOCAL_DIR}/settings.local.json"
AGENTS_ACTIVE_FILE="${CLAUDE_LOCAL_DIR}/agents-active.txt"
VERSION_LOCAL_FILE="${CLAUDE_LOCAL_DIR}/.toolkit-version"

# ============================================================================
# PRINT FUNCTIONS
# ============================================================================

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

# Aliases for test-agent.sh and healthcheck.sh
print_pass() {
    echo -e "${GREEN}✓ PASS${NC}"
}

print_fail() {
    echo -e "${RED}✗ FAIL${NC}"
    if [ ! -z "$1" ]; then
        echo -e "    ${RED}→${NC} $1"
    fi
}

print_warn() {
    echo -e "${YELLOW}⚠ WARNING${NC}"
    if [ ! -z "$1" ]; then
        echo -e "    ${YELLOW}→${NC} $1"
    fi
}

print_check() {
    echo -n "  $1... "
}

# ============================================================================
# AGENT CATEGORIES
# ============================================================================

# Core agents list (10 agents)
CORE_AGENTS=(
    "code-reviewer"
    "refactoring-specialist"
    "documentation-engineer"
    "test-strategist"
    "architecture-advisor"
    "security-auditor"
    "performance-optimizer"
    "git-workflow-specialist"
    "dependency-manager"
    "project-analyzer"
)

# Frontend frameworks (8 agents)
FRONTEND_AGENTS=(
    "angular-specialist"
    "animation-specialist"
    "css-architect"
    "react-specialist"
    "svelte-specialist"
    "tailwind-expert"
    "ui-accessibility"
    "vue-specialist"
)

# Backend frameworks (8 agents)
BACKEND_AGENTS=(
    "express-specialist"
    "fastify-expert"
    "graphql-specialist"
    "koa-expert"
    "microservices-architect"
    "nest-specialist"
    "rest-api-architect"
    "websocket-expert"
)

# Full-stack frameworks (6 agents)
FULLSTACK_AGENTS=(
    "astro-specialist"
    "nextjs-specialist"
    "nuxt-specialist"
    "remix-specialist"
    "solidstart-specialist"
    "sveltekit-specialist"
)

# Programming languages (8 agents)
LANGUAGE_AGENTS=(
    "csharp-specialist"
    "go-specialist"
    "java-specialist"
    "javascript-modernizer"
    "php-modernizer"
    "python-specialist"
    "rust-expert"
    "typescript-pro"
)

# Databases & ORMs (8 agents)
DATABASE_AGENTS=(
    "drizzle-specialist"
    "mongodb-expert"
    "mysql-specialist"
    "postgres-expert"
    "prisma-specialist"
    "redis-specialist"
    "sequelize-expert"
    "typeorm-expert"
)

# Infrastructure & DevOps (9 agents)
INFRASTRUCTURE_AGENTS=(
    "aws-cloud-specialist"
    "cicd-automation-specialist"
    "cloudflare-edge-specialist"
    "docker-specialist"
    "kubernetes-expert"
    "monitoring-observability-specialist"
    "nginx-load-balancer-specialist"
    "terraform-iac-specialist"
    "vercel-deployment-specialist"
)

# Testing frameworks (7 agents)
TESTING_AGENTS=(
    "cypress-specialist"
    "jest-testing-specialist"
    "playwright-e2e-specialist"
    "storybook-testing-specialist"
    "test-automation-strategist"
    "testing-library-specialist"
    "vitest-specialist"
)

# Specialized domains (8 agents)
SPECIALIZED_AGENTS=(
    "ai-ml-integration-specialist"
    "blockchain-web3-specialist"
    "browser-extension-specialist"
    "cli-tools-specialist"
    "data-pipeline-specialist"
    "electron-desktop-specialist"
    "game-development-specialist"
    "react-native-mobile-specialist"
)

# Agent counts
CORE_TOTAL=10
FRONTEND_TOTAL=8
BACKEND_TOTAL=8
FULLSTACK_TOTAL=6
LANGUAGE_TOTAL=8
DATABASE_TOTAL=8
INFRASTRUCTURE_TOTAL=9
TESTING_TOTAL=7
SPECIALIZED_TOTAL=8
TOTAL_AGENTS=72

# ============================================================================
# AGENT UTILITY FUNCTIONS
# ============================================================================

# Get agent category
get_agent_category() {
    local agent="$1"

    # Check core agents
    for a in "${CORE_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "core"
            return 0
        fi
    done

    # Check frontend agents
    for a in "${FRONTEND_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "frontend"
            return 0
        fi
    done

    # Check backend agents
    for a in "${BACKEND_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "backend"
            return 0
        fi
    done

    # Check fullstack agents
    for a in "${FULLSTACK_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "fullstack"
            return 0
        fi
    done

    # Check language agents
    for a in "${LANGUAGE_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "language"
            return 0
        fi
    done

    # Check database agents
    for a in "${DATABASE_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "database"
            return 0
        fi
    done

    # Check infrastructure agents
    for a in "${INFRASTRUCTURE_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "infrastructure"
            return 0
        fi
    done

    # Check testing agents
    for a in "${TESTING_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "testing"
            return 0
        fi
    done

    # Check specialized agents
    for a in "${SPECIALIZED_AGENTS[@]}"; do
        if [ "$a" = "$agent" ]; then
            echo "specialized"
            return 0
        fi
    done

    echo "unknown"
    return 1
}

# Get all agents (returns newline-separated list)
get_all_agents() {
    # Combine all agent arrays
    for agent in "${CORE_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${FRONTEND_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${BACKEND_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${FULLSTACK_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${LANGUAGE_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${DATABASE_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${INFRASTRUCTURE_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${TESTING_AGENTS[@]}"; do
        echo "$agent"
    done
    for agent in "${SPECIALIZED_AGENTS[@]}"; do
        echo "$agent"
    done
}

# Count active agents in a category
count_active_in_category() {
    local category="$1"
    local rulebook="${2:-$RULEBOOK_LOCAL}"
    local count=0

    if [ ! -f "$rulebook" ]; then
        echo 0
        return 0
    fi

    # Get agents for category
    local agents=()
    case "$category" in
        core)
            agents=("${CORE_AGENTS[@]}")
            ;;
        frontend)
            agents=("${FRONTEND_AGENTS[@]}")
            ;;
        backend)
            agents=("${BACKEND_AGENTS[@]}")
            ;;
        fullstack)
            agents=("${FULLSTACK_AGENTS[@]}")
            ;;
        language)
            agents=("${LANGUAGE_AGENTS[@]}")
            ;;
        database)
            agents=("${DATABASE_AGENTS[@]}")
            ;;
        infrastructure)
            agents=("${INFRASTRUCTURE_AGENTS[@]}")
            ;;
        testing)
            agents=("${TESTING_AGENTS[@]}")
            ;;
        specialized)
            agents=("${SPECIALIZED_AGENTS[@]}")
            ;;
        *)
            echo 0
            return 1
            ;;
    esac

    # Count active agents
    for agent in "${agents[@]}"; do
        if grep -q "^- $agent$" "$rulebook" 2>/dev/null; then
            ((count++))
        fi
    done

    echo $count
}

# Check if agent is active in RULEBOOK
is_agent_active() {
    local agent="$1"
    local rulebook="${2:-$RULEBOOK_LOCAL}"

    if [ ! -f "$rulebook" ]; then
        return 1
    fi

    grep -q "^- $agent$" "$rulebook" 2>/dev/null
}

# ============================================================================
# VALIDATION FUNCTIONS
# ============================================================================

# Check if RULEBOOK exists
check_rulebook_exists() {
    local rulebook="${1:-$RULEBOOK_LOCAL}"

    if [ ! -f "$rulebook" ]; then
        print_error "RULEBOOK not found at: $rulebook"
        return 1
    fi

    return 0
}

# Check if global installation exists
check_global_installation() {
    if [ ! -d "$GLOBAL_DIR" ]; then
        print_error "Global installation not found at: $GLOBAL_DIR"
        echo ""
        echo "Please install the toolkit first:"
        echo -e "${CYAN}bash <(curl -fsSL https://raw.githubusercontent.com/Dsantiagomj/claude-code-agents-toolkit/main/install.sh)${NC}"
        echo ""
        return 1
    fi

    return 0
}

# Get toolkit version
get_toolkit_version() {
    if [ -f "$TOOLKIT_VERSION_FILE" ]; then
        cat "$TOOLKIT_VERSION_FILE"
    else
        echo "unknown"
    fi
}

# ============================================================================
# PROGRESS BAR FUNCTION
# ============================================================================

draw_progress_bar() {
    local current=$1
    local total=$2
    local width=40

    # Avoid division by zero
    if [ $total -eq 0 ]; then
        total=1
    fi

    local percentage=$((current * 100 / total))
    local filled=$((current * width / total))
    local empty=$((width - filled))

    # Choose color based on percentage
    local color=$GREEN
    if [ $percentage -lt 30 ]; then
        color=$RED
    elif [ $percentage -lt 60 ]; then
        color=$YELLOW
    fi

    # Draw bar
    echo -ne "${color}"
    printf '█%.0s' $(seq 1 $filled 2>/dev/null)
    echo -ne "${GRAY}"
    printf '░%.0s' $(seq 1 $empty 2>/dev/null)
    echo -ne "${NC}"

    # Show percentage
    printf " %3d%% (%d/%d)" $percentage $current $total
}

# ============================================================================
# HELPER FUNCTIONS
# ============================================================================

# Print header with box
print_box_header() {
    local title="$1"
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    printf "${BLUE}║${NC}  %-50s  ${BLUE}║${NC}\n" "$title"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Confirm action (returns 0 for yes, 1 for no)
confirm_action() {
    local prompt="$1"
    read -p "$prompt (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# ============================================================================
# END OF COMMON LIBRARY
# ============================================================================
