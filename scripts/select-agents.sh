#!/bin/bash

# Claude Code Agents Global Toolkit - Agent Selector
# Version: 1.0.0
# Description: Interactive menu to activate/deactivate specific agents

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Helper functions
print_header() {
    clear
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🎯 Claude Code Agents Selector                  ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# Note: check_rulebook_exists is now in common.sh

# Get list of currently active agents from RULEBOOK
get_active_agents() {
    if grep -q "## Active Agents" $RULEBOOK_LOCAL 2>/dev/null; then
        # Extract agents from RULEBOOK (between ## Active Agents and next ##)
        sed -n '/## Active Agents/,/^##/p' $RULEBOOK_LOCAL | grep '^-' | sed 's/^- //' | sed 's/ .*//' > /tmp/active_agents.txt
    else
        # No active agents section
        touch /tmp/active_agents.txt
    fi
}

# Check if agent is active
is_agent_active() {
    local agent=$1
    grep -q "^$agent$" /tmp/active_agents.txt 2>/dev/null
}

# Show main menu
show_main_menu() {
    print_header

    echo -e "${CYAN}Select agent category to configure:${NC}"
    echo ""
    echo "  [1] Core Agents (10 agents)"
    echo "  [2] Frontend Frameworks (8 agents)"
    echo "  [3] Backend Frameworks (8 agents)"
    echo "  [4] Full-Stack Frameworks (6 agents)"
    echo "  [5] Languages (8 agents)"
    echo "  [6] Databases & ORMs (8 agents)"
    echo "  [7] Infrastructure & DevOps (9 agents)"
    echo "  [8] Testing Frameworks (7 agents)"
    echo "  [9] Specialized Domains (8 agents)"
    echo ""
    echo "  [A] Activate All Agents"
    echo "  [D] Deactivate All Agents (keep core)"
    echo "  [S] Show Current Selection"
    echo "  [Q] Save & Quit"
    echo ""
    read -p "Select option: " -n 1 -r MENU_CHOICE
    echo
}

# Show category agents
show_category_agents() {
    local category=$1
    local title=$2
    shift 2
    local agents=("$@")

    print_header
    echo -e "${CYAN}${title}${NC}"
    echo -e "${YELLOW}Toggle agents with their number. Press 'B' to go back.${NC}"
    echo ""

    local i=1
    for agent in "${agents[@]}"; do
        local status="${RED}[ ]${NC}"
        if is_agent_active "$agent"; then
            status="${GREEN}[✓]${NC}"
        fi
        echo -e "  [$i] $status $agent"
        ((i++))
    done

    echo ""
    echo "  [A] Activate All in Category"
    echo "  [D] Deactivate All in Category"
    echo "  [B] Back to Main Menu"
    echo ""
    read -p "Select option: " -n 1 -r AGENT_CHOICE
    echo

    # Handle choice
    if [[ $AGENT_CHOICE =~ ^[0-9]+$ ]] && [ $AGENT_CHOICE -ge 1 ] && [ $AGENT_CHOICE -le ${#agents[@]} ]; then
        local selected_agent="${agents[$((AGENT_CHOICE-1))]}"
        toggle_agent "$selected_agent"
        show_category_agents "$category" "$title" "${agents[@]}"
    elif [[ $AGENT_CHOICE =~ ^[Aa]$ ]]; then
        for agent in "${agents[@]}"; do
            activate_agent "$agent"
        done
        show_category_agents "$category" "$title" "${agents[@]}"
    elif [[ $AGENT_CHOICE =~ ^[Dd]$ ]]; then
        for agent in "${agents[@]}"; do
            deactivate_agent "$agent"
        done
        show_category_agents "$category" "$title" "${agents[@]}"
    elif [[ $AGENT_CHOICE =~ ^[Bb]$ ]]; then
        return
    else
        show_category_agents "$category" "$title" "${agents[@]}"
    fi
}

# Toggle agent activation
toggle_agent() {
    local agent=$1
    if is_agent_active "$agent"; then
        deactivate_agent "$agent"
    else
        activate_agent "$agent"
    fi
}

# Activate agent
activate_agent() {
    local agent=$1
    if ! is_agent_active "$agent"; then
        echo "$agent" >> /tmp/active_agents.txt
    fi
}

# Deactivate agent
deactivate_agent() {
    local agent=$1
    grep -v "^$agent$" /tmp/active_agents.txt > /tmp/active_agents_tmp.txt 2>/dev/null || true
    mv /tmp/active_agents_tmp.txt /tmp/active_agents.txt
}

# Activate all agents
activate_all() {
    # Get all available agents
    find .claude/agents-global -name "*.md" -type f | while read -r file; do
        basename "$file" .md >> /tmp/active_agents.txt
    done
    # Remove duplicates
    sort -u /tmp/active_agents.txt > /tmp/active_agents_tmp.txt
    mv /tmp/active_agents_tmp.txt /tmp/active_agents.txt
}

# Deactivate all except core
deactivate_all_except_core() {
    local core_agents=(
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

    rm -f /tmp/active_agents.txt
    for agent in "${core_agents[@]}"; do
        echo "$agent" >> /tmp/active_agents.txt
    done
}

# Show current selection
show_current_selection() {
    print_header
    echo -e "${CYAN}Currently Active Agents:${NC}"
    echo ""

    local count=$(wc -l < /tmp/active_agents.txt)
    echo -e "${GREEN}Total: $count agents${NC}"
    echo ""

    cat /tmp/active_agents.txt | sort

    echo ""
    read -p "Press any key to continue..." -n 1 -r
    echo
}

# Save changes to RULEBOOK
save_to_rulebook() {
    print_header
    echo -e "${YELLOW}Saving changes to RULEBOOK.md...${NC}"
    echo ""

    # Backup RULEBOOK
    cp $RULEBOOK_LOCAL $RULEBOOK_LOCAL.backup

    # Get current active agents
    local active_agents=$(cat /tmp/active_agents.txt | sort | tr '\n' ' ')

    # Update RULEBOOK - replace the Active Agents section
    if grep -q "## Active Agents" $RULEBOOK_LOCAL; then
        # Section exists, replace it
        awk -v agents="$active_agents" '
        /^## Active Agents/ {
            print "## Active Agents"
            print ""
            split(agents, arr, " ")
            for (i in arr) {
                if (arr[i] != "") print "- " arr[i]
            }
            in_section=1
            next
        }
        /^##/ && in_section {
            in_section=0
        }
        !in_section {
            print
        }
        ' $RULEBOOK_LOCAL > $RULEBOOK_LOCAL.tmp
        mv $RULEBOOK_LOCAL.tmp $RULEBOOK_LOCAL
    else
        # Section doesn't exist, add it
        echo "" >> $RULEBOOK_LOCAL
        echo "## Active Agents" >> $RULEBOOK_LOCAL
        echo "" >> $RULEBOOK_LOCAL
        cat /tmp/active_agents.txt | sort | while read -r agent; do
            echo "- $agent" >> $RULEBOOK_LOCAL
        done
    fi

    print_success "Changes saved to RULEBOOK.md"
    print_info "Backup created: $RULEBOOK_LOCAL.backup"
    echo ""

    local count=$(wc -l < /tmp/active_agents.txt)
    echo -e "${GREEN}Active agents: $count${NC}"
    echo ""
}

# Main loop
main() {
    # Parse arguments
    if [ "$1" = "--help" ]; then
        echo "Usage: ./select-agents.sh"
        echo ""
        echo "Interactive menu to activate/deactivate Claude Code agents."
        echo "Changes are saved to $RULEBOOK_LOCAL"
        echo ""
        echo "Features:"
        echo "  • Browse agents by category (Frontend, Backend, etc.)"
        echo "  • Toggle individual agents on/off"
        echo "  • Activate/deactivate entire categories"
        echo "  • View currently active agents"
        echo "  • Auto-saves to RULEBOOK.md"
        echo "  • Creates backup before saving"
        echo ""
        echo "Categories:"
        echo "  [1] Core Agents (10) - Always recommended"
        echo "  [2] Frontend Frameworks (8)"
        echo "  [3] Backend Frameworks (8)"
        echo "  [4] Full-Stack Frameworks (6)"
        echo "  [5] Programming Languages (8)"
        echo "  [6] Databases & ORMs (8)"
        echo "  [7] Infrastructure & DevOps (9)"
        echo "  [8] Testing Frameworks (7)"
        echo "  [9] Specialized Domains (8)"
        echo ""
        echo "Quick Actions:"
        echo "  [A] Activate All Agents (72)"
        echo "  [D] Deactivate All (keep core 10)"
        echo "  [S] Show Current Selection"
        echo "  [Q] Save & Quit"
        echo ""
        echo "Example workflow:"
        echo "  1. Run: ./select-agents.sh"
        echo "  2. Select category (e.g., press '2' for Frontend)"
        echo "  3. Toggle agents (press agent number)"
        echo "  4. Press 'B' to go back"
        echo "  5. Press 'Q' to save changes"
        echo ""
        exit 0
    fi

    # Validate environment
    check_global_installation || exit 1
    check_project_initialization || exit 1

    # Check RULEBOOK exists (required for this script)
    if ! check_rulebook_exists; then
        print_error "RULEBOOK.md is required for agent selection"
        echo "Please initialize Maestro mode first or run this from a Maestro project."
        exit 1
    fi

    # Load currently active agents
    get_active_agents

    while true; do
        show_main_menu

        case $MENU_CHOICE in
            1)
                local core_agents=(
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
                show_category_agents "core" "Core Agents (Always Recommended)" "${core_agents[@]}"
                ;;
            2)
                local frontend_agents=(
                    "react-specialist"
                    "vue-specialist"
                    "angular-specialist"
                    "svelte-specialist"
                    "tailwind-expert"
                    "css-architect"
                    "ui-accessibility"
                    "animation-specialist"
                )
                show_category_agents "frontend" "Frontend Frameworks" "${frontend_agents[@]}"
                ;;
            3)
                local backend_agents=(
                    "express-specialist"
                    "fastify-expert"
                    "nest-specialist"
                    "koa-expert"
                    "rest-api-architect"
                    "graphql-specialist"
                    "websocket-expert"
                    "microservices-architect"
                )
                show_category_agents "backend" "Backend Frameworks" "${backend_agents[@]}"
                ;;
            4)
                local fullstack_agents=(
                    "nextjs-specialist"
                    "nuxt-specialist"
                    "remix-specialist"
                    "astro-specialist"
                    "sveltekit-specialist"
                    "solidstart-specialist"
                )
                show_category_agents "fullstack" "Full-Stack Frameworks" "${fullstack_agents[@]}"
                ;;
            5)
                local language_agents=(
                    "typescript-pro"
                    "javascript-modernizer"
                    "python-specialist"
                    "go-specialist"
                    "rust-expert"
                    "java-specialist"
                    "csharp-specialist"
                    "php-modernizer"
                )
                show_category_agents "languages" "Programming Languages" "${language_agents[@]}"
                ;;
            6)
                local database_agents=(
                    "postgres-expert"
                    "mysql-specialist"
                    "mongodb-expert"
                    "redis-specialist"
                    "prisma-specialist"
                    "typeorm-expert"
                    "drizzle-specialist"
                    "sequelize-expert"
                )
                show_category_agents "databases" "Databases & ORMs" "${database_agents[@]}"
                ;;
            7)
                local infra_agents=(
                    "docker-specialist"
                    "kubernetes-expert"
                    "cicd-automation-specialist"
                    "aws-cloud-specialist"
                    "vercel-deployment-specialist"
                    "terraform-iac-specialist"
                    "cloudflare-edge-specialist"
                    "monitoring-observability-specialist"
                    "nginx-load-balancer-specialist"
                )
                show_category_agents "infrastructure" "Infrastructure & DevOps" "${infra_agents[@]}"
                ;;
            8)
                local testing_agents=(
                    "jest-testing-specialist"
                    "playwright-e2e-specialist"
                    "vitest-specialist"
                    "cypress-specialist"
                    "testing-library-specialist"
                    "storybook-testing-specialist"
                    "test-automation-strategist"
                )
                show_category_agents "testing" "Testing Frameworks" "${testing_agents[@]}"
                ;;
            9)
                local specialized_agents=(
                    "react-native-mobile-specialist"
                    "electron-desktop-specialist"
                    "cli-tools-specialist"
                    "browser-extension-specialist"
                    "ai-ml-integration-specialist"
                    "blockchain-web3-specialist"
                    "game-development-specialist"
                    "data-pipeline-specialist"
                )
                show_category_agents "specialized" "Specialized Domains" "${specialized_agents[@]}"
                ;;
            [Aa])
                activate_all
                ;;
            [Dd])
                deactivate_all_except_core
                ;;
            [Ss])
                show_current_selection
                ;;
            [Qq])
                save_to_rulebook
                echo "Goodbye!"
                echo ""
                exit 0
                ;;
            *)
                ;;
        esac
    done
}

# Run main
main "$@"
