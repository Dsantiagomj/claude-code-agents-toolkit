#!/bin/bash
# agent-stats.sh - Show statistics and analytics for active agents
# Part of Claude Code Agents Global Toolkit
# Compatible with bash 3.2+

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GRAY='\033[0;90m'
BOLD='\033[1m'
NC='\033[0m' # No Color

# Paths
RULEBOOK="${HOME}/.claude/RULEBOOK.md"
AGENTS_DIR="${HOME}/.claude/agents-global"

# Agent counts by category
CORE_TOTAL=10
FRONTEND_TOTAL=8
BACKEND_TOTAL=8
FULLSTACK_TOTAL=6
LANGUAGE_TOTAL=8
DATABASE_TOTAL=8
INFRASTRUCTURE_TOTAL=9
TESTING_TOTAL=7
SPECIALIZED_TOTAL=8

TOTAL_AGENTS=78

# Category lists
CORE_AGENTS="code-reviewer refactoring-specialist documentation-engineer test-strategist architecture-advisor security-auditor performance-optimizer git-workflow-specialist dependency-manager project-analyzer"

FRONTEND_AGENTS="nextjs-specialist react-specialist vue-specialist angular-specialist svelte-specialist solid-specialist qwik-specialist astro-specialist"

BACKEND_AGENTS="express-specialist nestjs-specialist fastify-specialist hono-specialist koa-specialist adonis-specialist feathers-specialist sails-specialist"

FULLSTACK_AGENTS="remix-specialist nuxt-specialist sveltekit-specialist solidstart-specialist analog-specialist fresh-specialist"

LANGUAGE_AGENTS="typescript-pro javascript-modernizer python-specialist go-specialist rust-specialist java-specialist csharp-specialist php-specialist"

DATABASE_AGENTS="postgres-expert mongodb-expert mysql-expert redis-specialist prisma-orm-specialist drizzle-orm-specialist typeorm-specialist sequelize-specialist"

INFRASTRUCTURE_AGENTS="docker-specialist kubernetes-expert aws-cloud-specialist gcp-specialist azure-specialist terraform-specialist ci-cd-specialist nginx-specialist monitoring-specialist"

TESTING_AGENTS="jest-testing-specialist vitest-specialist playwright-specialist cypress-specialist testing-library-specialist storybook-specialist msw-specialist"

SPECIALIZED_AGENTS="graphql-specialist rest-api-architect websocket-specialist data-pipeline-specialist ml-specialist blockchain-specialist mobile-specialist desktop-specialist"

# Helper functions
count_active_in_category() {
  local category_agents="$1"
  local count=0

  for agent in $category_agents; do
    if grep -q "^- $agent$" "$RULEBOOK" 2>/dev/null; then
      ((count++))
    fi
  done

  echo $count
}

draw_progress_bar() {
  local current=$1
  local total=$2
  local width=40

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
  printf '█%.0s' $(seq 1 $filled)
  echo -ne "${GRAY}"
  printf '░%.0s' $(seq 1 $empty)
  echo -ne "${NC}"

  # Show percentage
  printf " %3d%% (%d/%d)" $percentage $current $total
}

get_recommendation() {
  local active=$1
  local total=$2
  local category=$3

  local percentage=$((active * 100 / total))

  if [ "$category" = "Core" ]; then
    if [ $active -lt 10 ]; then
      echo "${RED}⚠ Activate all core agents (essential)${NC}"
    else
      echo "${GREEN}✓ Core agents properly configured${NC}"
    fi
  else
    if [ $percentage -eq 0 ]; then
      echo "${GRAY}ℹ No agents active (add if using this stack)${NC}"
    elif [ $percentage -lt 40 ]; then
      echo "${YELLOW}💡 Consider adding more ${category,,} agents${NC}"
    elif [ $percentage -ge 80 ]; then
      echo "${CYAN}✓ Well configured for ${category,,}${NC}"
    else
      echo "${GREEN}✓ Good balance${NC}"
    fi
  fi
}

show_help() {
  echo -e "${BOLD}Agent Statistics - Analytics for active agents${NC}"
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  ${CYAN}--summary${NC}         Quick overview (default)"
  echo "  ${CYAN}--detailed${NC}        Detailed breakdown by category"
  echo "  ${CYAN}--recommendations${NC} Show optimization recommendations"
  echo "  ${CYAN}--performance${NC}     Show performance impact analysis"
  echo "  ${CYAN}--help${NC}            Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0                    # Show summary"
  echo "  $0 --detailed         # Detailed statistics"
  echo "  $0 --recommendations  # Get recommendations"
  echo "  $0 --performance      # Performance analysis"
}

show_summary() {
  if [ ! -f "$RULEBOOK" ]; then
    echo -e "${RED}RULEBOOK.md not found at: $RULEBOOK${NC}"
    echo ""
    echo "Run './install.sh' first to set up the toolkit"
    exit 1
  fi

  echo -e "${BOLD}📊 Agent Statistics Summary${NC}"
  echo ""

  # Count total active agents
  local total_active=$(grep -c "^- " "$RULEBOOK" 2>/dev/null || echo 0)

  # Overall stats
  echo -e "${BOLD}Overall:${NC}"
  echo -e "  Total Agents Available: ${CYAN}$TOTAL_AGENTS${NC}"
  echo -e "  Total Agents Active:    ${GREEN}$total_active${NC}"
  echo -e "  Activation Rate:        $(draw_progress_bar $total_active $TOTAL_AGENTS)"
  echo ""

  # Count by category
  local core_active=$(count_active_in_category "$CORE_AGENTS")
  local frontend_active=$(count_active_in_category "$FRONTEND_AGENTS")
  local backend_active=$(count_active_in_category "$BACKEND_AGENTS")
  local fullstack_active=$(count_active_in_category "$FULLSTACK_AGENTS")
  local language_active=$(count_active_in_category "$LANGUAGE_AGENTS")
  local database_active=$(count_active_in_category "$DATABASE_AGENTS")
  local infrastructure_active=$(count_active_in_category "$INFRASTRUCTURE_AGENTS")
  local testing_active=$(count_active_in_category "$TESTING_AGENTS")
  local specialized_active=$(count_active_in_category "$SPECIALIZED_AGENTS")

  # Category breakdown
  echo -e "${BOLD}By Category:${NC}"
  echo ""
  echo -e "  ${GREEN}Core${NC}             $(draw_progress_bar $core_active $CORE_TOTAL)"
  echo -e "  ${BLUE}Frontend${NC}         $(draw_progress_bar $frontend_active $FRONTEND_TOTAL)"
  echo -e "  ${YELLOW}Backend${NC}          $(draw_progress_bar $backend_active $BACKEND_TOTAL)"
  echo -e "  ${CYAN}Full-Stack${NC}       $(draw_progress_bar $fullstack_active $FULLSTACK_TOTAL)"
  echo -e "  ${GRAY}Languages${NC}        $(draw_progress_bar $language_active $LANGUAGE_TOTAL)"
  echo -e "  ${CYAN}Databases${NC}        $(draw_progress_bar $database_active $DATABASE_TOTAL)"
  echo -e "  ${YELLOW}Infrastructure${NC}   $(draw_progress_bar $infrastructure_active $INFRASTRUCTURE_TOTAL)"
  echo -e "  ${GREEN}Testing${NC}          $(draw_progress_bar $testing_active $TESTING_TOTAL)"
  echo -e "  ${BLUE}Specialized${NC}      $(draw_progress_bar $specialized_active $SPECIALIZED_TOTAL)"
  echo ""

  # Quick recommendations
  echo -e "${BOLD}Quick Check:${NC}"

  if [ $core_active -lt 10 ]; then
    echo -e "  ${RED}⚠${NC}  Missing core agents (${core_active}/10 active)"
    echo -e "     ${GRAY}Run: ${CYAN}scripts/select-agents.sh${NC}"
  else
    echo -e "  ${GREEN}✓${NC}  All core agents active"
  fi

  local percentage=$((total_active * 100 / TOTAL_AGENTS))
  if [ $percentage -lt 20 ]; then
    echo -e "  ${YELLOW}💡${NC} Low activation (${percentage}%) - consider adding stack-specific agents"
  elif [ $percentage -gt 60 ]; then
    echo -e "  ${CYAN}ℹ${NC}  High activation (${percentage}%) - ensure all agents are needed"
  else
    echo -e "  ${GREEN}✓${NC}  Balanced activation (${percentage}%)"
  fi

  echo ""
  echo -e "${GRAY}For detailed analysis: ${CYAN}$0 --detailed${NC}"
  echo -e "${GRAY}For recommendations: ${CYAN}$0 --recommendations${NC}"
}

show_detailed() {
  if [ ! -f "$RULEBOOK" ]; then
    echo -e "${RED}RULEBOOK.md not found${NC}"
    exit 1
  fi

  echo -e "${BOLD}📊 Detailed Agent Statistics${NC}"
  echo ""

  # Count total active
  local total_active=$(grep -c "^- " "$RULEBOOK" 2>/dev/null || echo 0)

  echo -e "${BOLD}═══════════════════════════════════════════════════════${NC}"
  echo -e "${BOLD}Overall Statistics${NC}"
  echo -e "${BOLD}═══════════════════════════════════════════════════════${NC}"
  echo ""
  echo -e "  Total Agents:    ${CYAN}$TOTAL_AGENTS${NC}"
  echo -e "  Active:          ${GREEN}$total_active${NC}"
  echo -e "  Inactive:        ${GRAY}$((TOTAL_AGENTS - total_active))${NC}"
  echo -e "  Activation Rate: ${GREEN}$((total_active * 100 / TOTAL_AGENTS))%${NC}"
  echo ""

  # Detailed category breakdown
  echo -e "${BOLD}═══════════════════════════════════════════════════════${NC}"
  echo -e "${BOLD}Category Breakdown${NC}"
  echo -e "${BOLD}═══════════════════════════════════════════════════════${NC}"
  echo ""

  # Core Agents
  local core_active=$(count_active_in_category "$CORE_AGENTS")
  echo -e "${GREEN}${BOLD}Core Agents (Essential)${NC}"
  echo -e "  Active: $(draw_progress_bar $core_active $CORE_TOTAL)"
  echo -e "  $(get_recommendation $core_active $CORE_TOTAL "Core")"
  echo ""

  # Frontend
  local frontend_active=$(count_active_in_category "$FRONTEND_AGENTS")
  echo -e "${BLUE}${BOLD}Frontend Frameworks${NC}"
  echo -e "  Active: $(draw_progress_bar $frontend_active $FRONTEND_TOTAL)"
  echo -e "  $(get_recommendation $frontend_active $FRONTEND_TOTAL "Frontend")"
  echo ""

  # Backend
  local backend_active=$(count_active_in_category "$BACKEND_AGENTS")
  echo -e "${YELLOW}${BOLD}Backend Frameworks${NC}"
  echo -e "  Active: $(draw_progress_bar $backend_active $BACKEND_TOTAL)"
  echo -e "  $(get_recommendation $backend_active $BACKEND_TOTAL "Backend")"
  echo ""

  # Full-Stack
  local fullstack_active=$(count_active_in_category "$FULLSTACK_AGENTS")
  echo -e "${CYAN}${BOLD}Full-Stack Frameworks${NC}"
  echo -e "  Active: $(draw_progress_bar $fullstack_active $FULLSTACK_TOTAL)"
  echo -e "  $(get_recommendation $fullstack_active $FULLSTACK_TOTAL "Full-Stack")"
  echo ""

  # Languages
  local language_active=$(count_active_in_category "$LANGUAGE_AGENTS")
  echo -e "${GRAY}${BOLD}Programming Languages${NC}"
  echo -e "  Active: $(draw_progress_bar $language_active $LANGUAGE_TOTAL)"
  echo -e "  $(get_recommendation $language_active $LANGUAGE_TOTAL "Language")"
  echo ""

  # Databases
  local database_active=$(count_active_in_category "$DATABASE_AGENTS")
  echo -e "${CYAN}${BOLD}Databases & ORMs${NC}"
  echo -e "  Active: $(draw_progress_bar $database_active $DATABASE_TOTAL)"
  echo -e "  $(get_recommendation $database_active $DATABASE_TOTAL "Database")"
  echo ""

  # Infrastructure
  local infrastructure_active=$(count_active_in_category "$INFRASTRUCTURE_AGENTS")
  echo -e "${YELLOW}${BOLD}Infrastructure & DevOps${NC}"
  echo -e "  Active: $(draw_progress_bar $infrastructure_active $INFRASTRUCTURE_TOTAL)"
  echo -e "  $(get_recommendation $infrastructure_active $INFRASTRUCTURE_TOTAL "Infrastructure")"
  echo ""

  # Testing
  local testing_active=$(count_active_in_category "$TESTING_AGENTS")
  echo -e "${GREEN}${BOLD}Testing Frameworks${NC}"
  echo -e "  Active: $(draw_progress_bar $testing_active $TESTING_TOTAL)"
  echo -e "  $(get_recommendation $testing_active $TESTING_TOTAL "Testing")"
  echo ""

  # Specialized
  local specialized_active=$(count_active_in_category "$SPECIALIZED_AGENTS")
  echo -e "${BLUE}${BOLD}Specialized Domains${NC}"
  echo -e "  Active: $(draw_progress_bar $specialized_active $SPECIALIZED_TOTAL)"
  echo -e "  $(get_recommendation $specialized_active $SPECIALIZED_TOTAL "Specialized")"
  echo ""
}

show_recommendations() {
  if [ ! -f "$RULEBOOK" ]; then
    echo -e "${RED}RULEBOOK.md not found${NC}"
    exit 1
  fi

  echo -e "${BOLD}💡 Agent Optimization Recommendations${NC}"
  echo ""

  local total_active=$(grep -c "^- " "$RULEBOOK" 2>/dev/null || echo 0)
  local core_active=$(count_active_in_category "$CORE_AGENTS")
  local percentage=$((total_active * 100 / TOTAL_AGENTS))

  echo -e "${BOLD}Current Configuration:${NC}"
  echo -e "  Active Agents: ${GREEN}$total_active${NC} / $TOTAL_AGENTS (${percentage}%)"
  echo ""

  # Core agents check
  echo -e "${BOLD}1. Core Agents (Essential)${NC}"
  if [ $core_active -lt 10 ]; then
    echo -e "   ${RED}⚠ Missing ${BOLD}$((10 - core_active))${NC}${RED} core agents${NC}"
    echo ""
    echo -e "   ${BOLD}Missing agents:${NC}"
    for agent in $CORE_AGENTS; do
      if ! grep -q "^- $agent$" "$RULEBOOK" 2>/dev/null; then
        echo -e "     • ${GRAY}$agent${NC}"
      fi
    done
    echo ""
    echo -e "   ${BOLD}Action:${NC} ${CYAN}scripts/select-agents.sh${NC} → Core Agents → Activate missing agents"
    echo ""
  else
    echo -e "   ${GREEN}✓ All core agents active${NC}"
    echo ""
  fi

  # Stack-specific recommendations
  echo -e "${BOLD}2. Stack-Specific Agents${NC}"

  # Check for framework patterns in RULEBOOK
  local has_nextjs=0
  local has_react=0
  local has_express=0
  local has_postgres=0

  if grep -qi "next\.js\|nextjs" "$RULEBOOK" 2>/dev/null; then
    has_nextjs=1
  fi
  if grep -qi "react" "$RULEBOOK" 2>/dev/null; then
    has_react=1
  fi
  if grep -qi "express" "$RULEBOOK" 2>/dev/null; then
    has_express=1
  fi
  if grep -qi "postgres\|postgresql" "$RULEBOOK" 2>/dev/null; then
    has_postgres=1
  fi

  # Give recommendations based on detected stack
  if [ $has_nextjs -eq 1 ]; then
    if ! grep -q "^- nextjs-specialist$" "$RULEBOOK" 2>/dev/null; then
      echo -e "   ${YELLOW}💡 Detected Next.js - consider activating:${NC}"
      echo -e "      • nextjs-specialist"
      if ! grep -q "^- react-specialist$" "$RULEBOOK" 2>/dev/null; then
        echo -e "      • react-specialist"
      fi
      echo ""
    fi
  fi

  if [ $has_react -eq 1 ] && ! grep -q "^- react-specialist$" "$RULEBOOK" 2>/dev/null; then
    echo -e "   ${YELLOW}💡 Detected React - consider activating:${NC}"
    echo -e "      • react-specialist"
    echo ""
  fi

  if [ $has_express -eq 1 ] && ! grep -q "^- express-specialist$" "$RULEBOOK" 2>/dev/null; then
    echo -e "   ${YELLOW}💡 Detected Express - consider activating:${NC}"
    echo -e "      • express-specialist"
    echo ""
  fi

  if [ $has_postgres -eq 1 ] && ! grep -q "^- postgres-expert$" "$RULEBOOK" 2>/dev/null; then
    echo -e "   ${YELLOW}💡 Detected PostgreSQL - consider activating:${NC}"
    echo -e "      • postgres-expert"
    if grep -qi "prisma" "$RULEBOOK" 2>/dev/null && ! grep -q "^- prisma-orm-specialist$" "$RULEBOOK" 2>/dev/null; then
        echo -e "      • prisma-orm-specialist"
      fi
      echo ""
  fi

  # Activation density recommendations
  echo -e "${BOLD}3. Activation Density${NC}"
  if [ $percentage -lt 15 ]; then
    echo -e "   ${YELLOW}⚠ Very low activation (${percentage}%)${NC}"
    echo -e "   Consider adding agents for your specific stack."
    echo -e "   Run: ${CYAN}scripts/test-agent.sh --category <category>${NC}"
  elif [ $percentage -gt 75 ]; then
    echo -e "   ${CYAN}ℹ High activation (${percentage}%)${NC}"
    echo -e "   Ensure all active agents are needed for your project."
    echo -e "   Review: ${CYAN}scripts/test-agent.sh --active${NC}"
  else
    echo -e "   ${GREEN}✓ Good balance (${percentage}%)${NC}"
  fi
  echo ""

  # General tips
  echo -e "${BOLD}4. General Tips${NC}"
  echo -e "   • ${GRAY}Start with core + your main framework/language${NC}"
  echo -e "   • ${GRAY}Add database/ORM agents as needed${NC}"
  echo -e "   • ${GRAY}Add testing agents when writing tests${NC}"
  echo -e "   • ${GRAY}Infrastructure agents for deployment work${NC}"
  echo ""

  echo -e "${BOLD}Tools to help:${NC}"
  echo -e "  ${CYAN}scripts/select-agents.sh${NC}     - Activate/deactivate agents"
  echo -e "  ${CYAN}scripts/test-agent.sh --list${NC} - Explore available agents"
  echo -e "  ${CYAN}scripts/test-agent.sh --search${NC} <keyword> - Find specific agents"
}

show_performance() {
  if [ ! -f "$RULEBOOK" ]; then
    echo -e "${RED}RULEBOOK.md not found${NC}"
    exit 1
  fi

  echo -e "${BOLD}⚡ Performance Impact Analysis${NC}"
  echo ""

  local total_active=$(grep -c "^- " "$RULEBOOK" 2>/dev/null || echo 0)
  local percentage=$((total_active * 100 / TOTAL_AGENTS))

  # Estimated context usage
  local base_context=5000
  local per_agent_context=200
  local total_context=$((base_context + (total_active * per_agent_context)))

  echo -e "${BOLD}Context Usage:${NC}"
  echo -e "  Base System:        ${CYAN}~${base_context} tokens${NC}"
  echo -e "  Agents ($total_active active):  ${CYAN}~$((total_active * per_agent_context)) tokens${NC} (${per_agent_context} per agent)"
  echo -e "  ${BOLD}Total Estimated:    ${GREEN}~${total_context} tokens${NC}"
  echo ""

  # Performance recommendations
  echo -e "${BOLD}Performance Impact:${NC}"
  if [ $total_active -le 15 ]; then
    echo -e "  ${GREEN}✓ Minimal${NC} - Optimal for all project sizes"
  elif [ $total_active -le 30 ]; then
    echo -e "  ${GREEN}✓ Low${NC} - Good for most projects"
  elif [ $total_active -le 50 ]; then
    echo -e "  ${YELLOW}⚠ Moderate${NC} - Consider deactivating unused agents"
  else
    echo -e "  ${RED}⚠ High${NC} - Review active agents, deactivate unused ones"
  fi
  echo ""

  # Project size recommendations
  echo -e "${BOLD}Recommendations by Project Size:${NC}"
  echo ""
  echo -e "  ${BOLD}Small Projects${NC} (< 1000 lines):"
  echo -e "    Suggested: ${CYAN}10-15 agents${NC} (Core + main stack)"
  if [ $total_active -ge 10 ] && [ $total_active -le 15 ]; then
    echo -e "    Your setup: ${GREEN}✓ Optimal ($total_active agents)${NC}"
  elif [ $total_active -lt 10 ]; then
    echo -e "    Your setup: ${YELLOW}Could add ${BOLD}$((15 - total_active))${NC}${YELLOW} more${NC}"
  else
    echo -e "    Your setup: ${YELLOW}Consider reducing by ${BOLD}$((total_active - 15))${NC}${YELLOW} agents${NC}"
  fi
  echo ""

  echo -e "  ${BOLD}Medium Projects${NC} (1K-10K lines):"
  echo -e "    Suggested: ${CYAN}15-25 agents${NC} (Core + stack + domain)"
  if [ $total_active -ge 15 ] && [ $total_active -le 25 ]; then
    echo -e "    Your setup: ${GREEN}✓ Optimal ($total_active agents)${NC}"
  elif [ $total_active -lt 15 ]; then
    echo -e "    Your setup: ${YELLOW}Could add ${BOLD}$((20 - total_active))${NC}${YELLOW} more${NC}"
  else
    echo -e "    Your setup: ${YELLOW}Consider if all $total_active agents are needed${NC}"
  fi
  echo ""

  echo -e "  ${BOLD}Large Projects${NC} (10K+ lines):"
  echo -e "    Suggested: ${CYAN}25-40 agents${NC} (Core + full stack + specialized)"
  if [ $total_active -ge 25 ] && [ $total_active -le 40 ]; then
    echo -e "    Your setup: ${GREEN}✓ Optimal ($total_active agents)${NC}"
  elif [ $total_active -lt 25 ]; then
    echo -e "    Your setup: ${CYAN}Room for ${BOLD}$((30 - total_active))${NC}${CYAN} more specialized agents${NC}"
  else
    echo -e "    Your setup: ${CYAN}Review if all $total_active agents provide value${NC}"
  fi
  echo ""

  # Optimization tips
  echo -e "${BOLD}Optimization Tips:${NC}"
  echo -e "  1. ${GRAY}Keep core agents always active (10 agents)${NC}"
  echo -e "  2. ${GRAY}Add framework agents only for frameworks you use${NC}"
  echo -e "  3. ${GRAY}Database agents: 1-2 based on your databases${NC}"
  echo -e "  4. ${GRAY}Testing agents: activate when writing tests${NC}"
  echo -e "  5. ${GRAY}Infrastructure: only if doing DevOps work${NC}"
  echo ""

  echo -e "${BOLD}Quick Actions:${NC}"
  echo -e "  Review active: ${CYAN}scripts/test-agent.sh --active${NC}"
  echo -e "  Modify agents: ${CYAN}scripts/select-agents.sh${NC}"
}

# Main
main() {
  case "${1:-}" in
    --help|-h)
      show_help
      ;;
    --detailed)
      show_detailed
      ;;
    --recommendations)
      show_recommendations
      ;;
    --performance)
      show_performance
      ;;
    --summary|"")
      show_summary
      ;;
    *)
      echo -e "${RED}Unknown option: $1${NC}"
      echo ""
      show_help
      exit 1
      ;;
  esac
}

main "$@"
