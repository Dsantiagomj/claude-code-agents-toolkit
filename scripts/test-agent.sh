#!/bin/bash
# test-agent.sh - Test and inspect individual agents
# Part of Claude Code Agents Global Toolkit
# Compatible with bash 3.2+

set -e

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Paths (override from common.sh for backward compatibility)
AGENTS_DIR="${HOME}/.claude-global/agents"
RULEBOOK="${RULEBOOK_LOCAL}"

# ============================================================================
# AGENT DESCRIPTIONS
# ============================================================================

get_agent_description() {
  local agent="$1"
  case "$agent" in
    # Core Agents
    code-reviewer)
      echo "Reviews code for bugs, security issues, best practices, and suggests improvements"
      ;;
    refactoring-specialist)
      echo "Refactors code to improve readability, maintainability, and follows SOLID principles"
      ;;
    documentation-engineer)
      echo "Creates comprehensive documentation, JSDoc comments, README files, and API docs"
      ;;
    test-strategist)
      echo "Designs test strategies, writes unit/integration tests, improves test coverage"
      ;;
    architecture-advisor)
      echo "Provides architectural guidance, design patterns, system design recommendations"
      ;;
    security-auditor)
      echo "Audits code for security vulnerabilities (OWASP Top 10), suggests fixes"
      ;;
    performance-optimizer)
      echo "Optimizes code performance, identifies bottlenecks, suggests caching strategies"
      ;;
    git-workflow-specialist)
      echo "Helps with git workflows, branch strategies, commit messages, PR reviews"
      ;;
    dependency-manager)
      echo "Manages dependencies, updates packages, resolves version conflicts"
      ;;
    project-analyzer)
      echo "Analyzes project structure, identifies technical debt, suggests improvements"
      ;;
    # Frontend
    nextjs-specialist)
      echo "Next.js expert: App Router, RSC, Server Actions, ISR, SSR, SSG, routing"
      ;;
    react-specialist)
      echo "React expert: Hooks, Context, performance, component patterns, state management"
      ;;
    vue-specialist)
      echo "Vue.js expert: Composition API, Pinia, Vue Router, reactivity system"
      ;;
    angular-specialist)
      echo "Angular expert: Components, services, RxJS, dependency injection"
      ;;
    svelte-specialist)
      echo "Svelte expert: Reactive programming, stores, SvelteKit"
      ;;
    solid-specialist)
      echo "Solid.js expert: Fine-grained reactivity, JSX, SolidStart"
      ;;
    qwik-specialist)
      echo "Qwik expert: Resumability, lazy loading, QwikCity"
      ;;
    astro-specialist)
      echo "Astro expert: Islands architecture, static sites, integrations"
      ;;
    # Backend
    express-specialist)
      echo "Express.js expert: Middleware, routing, error handling, REST APIs"
      ;;
    nestjs-specialist)
      echo "NestJS expert: Modules, dependency injection, decorators, guards, interceptors"
      ;;
    fastify-specialist)
      echo "Fastify expert: High-performance APIs, plugins, validation"
      ;;
    hono-specialist)
      echo "Hono expert: Edge computing, ultralight framework, middleware"
      ;;
    koa-specialist)
      echo "Koa.js expert: Async middleware, context, error handling"
      ;;
    adonis-specialist)
      echo "AdonisJS expert: MVC framework, ORM, authentication"
      ;;
    feathers-specialist)
      echo "FeathersJS expert: Real-time APIs, services, hooks"
      ;;
    sails-specialist)
      echo "Sails.js expert: MVC framework, WebSockets, Waterline ORM"
      ;;
    # Full-Stack
    remix-specialist)
      echo "Remix expert: Loader/action pattern, progressive enhancement, nested routes"
      ;;
    nuxt-specialist)
      echo "Nuxt.js expert: Vue SSR, auto-imports, file-based routing"
      ;;
    sveltekit-specialist)
      echo "SvelteKit expert: Full-stack Svelte, load functions, endpoints"
      ;;
    solidstart-specialist)
      echo "SolidStart expert: Solid SSR, routing, data loading"
      ;;
    analog-specialist)
      echo "Analog expert: Angular SSR, file-based routing, Vite"
      ;;
    fresh-specialist)
      echo "Fresh expert: Deno, islands architecture, no build step"
      ;;
    # Databases
    postgres-expert)
      echo "PostgreSQL expert: Schema design, queries, indexes, transactions, performance tuning"
      ;;
    mongodb-expert)
      echo "MongoDB expert: Document modeling, aggregation pipelines, indexes, sharding"
      ;;
    mysql-expert)
      echo "MySQL expert: Relational design, queries, optimization, replication"
      ;;
    redis-specialist)
      echo "Redis expert: Caching, pub/sub, data structures, sessions"
      ;;
    prisma-orm-specialist)
      echo "Prisma expert: Schema modeling, migrations, queries, relations, type safety"
      ;;
    drizzle-orm-specialist)
      echo "Drizzle ORM expert: Type-safe queries, schema-first design"
      ;;
    typeorm-specialist)
      echo "TypeORM expert: Entity modeling, migrations, relations"
      ;;
    sequelize-specialist)
      echo "Sequelize expert: ORM patterns, migrations, associations"
      ;;
    # Languages
    typescript-pro)
      echo "TypeScript expert: Advanced types, generics, type guards, utility types"
      ;;
    javascript-modernizer)
      echo "JavaScript expert: ES2024+, functional programming, async patterns"
      ;;
    python-specialist)
      echo "Python expert: Type hints, async/await, dataclasses, decorators, best practices"
      ;;
    go-specialist)
      echo "Go expert: Concurrency, goroutines, channels, interfaces"
      ;;
    rust-specialist)
      echo "Rust expert: Ownership, lifetimes, traits, async Rust"
      ;;
    java-specialist)
      echo "Java expert: Spring Boot, JVM, concurrency, design patterns"
      ;;
    csharp-specialist)
      echo "C# expert: .NET, LINQ, async/await, Entity Framework"
      ;;
    php-specialist)
      echo "PHP expert: Laravel, Symfony, modern PHP, PSR standards"
      ;;
    # Infrastructure
    docker-specialist)
      echo "Docker expert: Containerization, multi-stage builds, compose, optimization"
      ;;
    kubernetes-expert)
      echo "Kubernetes expert: Deployments, services, ingress, helm, best practices"
      ;;
    aws-cloud-specialist)
      echo "AWS expert: EC2, S3, Lambda, RDS, CloudFormation, best practices"
      ;;
    gcp-specialist)
      echo "GCP expert: Compute Engine, Cloud Run, GKE, Cloud Functions"
      ;;
    azure-specialist)
      echo "Azure expert: App Service, Functions, AKS, Cosmos DB"
      ;;
    terraform-specialist)
      echo "Terraform expert: IaC, modules, state management, providers"
      ;;
    ci-cd-specialist)
      echo "CI/CD expert: GitHub Actions, GitLab CI, Jenkins, deployment pipelines"
      ;;
    nginx-specialist)
      echo "Nginx expert: Reverse proxy, load balancing, caching, SSL"
      ;;
    monitoring-specialist)
      echo "Monitoring expert: Prometheus, Grafana, logging, alerting"
      ;;
    # Testing
    jest-testing-specialist)
      echo "Jest expert: Unit tests, mocks, snapshots, coverage, best practices"
      ;;
    vitest-specialist)
      echo "Vitest expert: Fast unit testing, Vite integration, UI mode"
      ;;
    playwright-specialist)
      echo "Playwright expert: E2E tests, browser automation, parallel execution"
      ;;
    cypress-specialist)
      echo "Cypress expert: E2E testing, component testing, visual testing"
      ;;
    testing-library-specialist)
      echo "Testing Library expert: User-centric tests, accessibility, best practices"
      ;;
    storybook-specialist)
      echo "Storybook expert: Component documentation, visual testing, addons"
      ;;
    msw-specialist)
      echo "MSW expert: API mocking, service workers, testing patterns"
      ;;
    # Specialized
    graphql-specialist)
      echo "GraphQL expert: Schema design, resolvers, Apollo, subscriptions, performance"
      ;;
    rest-api-architect)
      echo "REST API expert: Design, versioning, authentication, rate limiting, best practices"
      ;;
    websocket-specialist)
      echo "WebSocket expert: Real-time communication, Socket.io, scaling"
      ;;
    data-pipeline-specialist)
      echo "Data pipeline expert: ETL, streaming, batch processing, orchestration"
      ;;
    ml-specialist)
      echo "ML expert: Model training, deployment, MLOps, TensorFlow, PyTorch"
      ;;
    blockchain-specialist)
      echo "Blockchain expert: Smart contracts, Web3, Ethereum, Solidity"
      ;;
    mobile-specialist)
      echo "Mobile expert: React Native, Flutter, iOS, Android"
      ;;
    desktop-specialist)
      echo "Desktop expert: Electron, Tauri, cross-platform applications"
      ;;
    *)
      echo "Specialized AI agent"
      ;;
  esac
}

# ============================================================================
# AGENT EXAMPLES
# ============================================================================

get_agent_examples() {
  local agent="$1"
  case "$agent" in
    code-reviewer)
      echo "Review this React component for performance issues"
      echo "Check this API endpoint for security vulnerabilities"
      echo "Analyze this function for potential bugs"
      ;;
    refactoring-specialist)
      echo "Refactor this class to use dependency injection"
      echo "Split this large function into smaller ones"
      echo "Remove code duplication in these files"
      ;;
    documentation-engineer)
      echo "Add JSDoc comments to this module"
      echo "Create API documentation for these endpoints"
      echo "Write a README for this component library"
      ;;
    test-strategist)
      echo "Write unit tests for this service"
      echo "Create integration tests for the checkout flow"
      echo "Design a testing strategy for this microservice"
      ;;
    nextjs-specialist)
      echo "Implement server actions for this form"
      echo "Optimize this page with ISR"
      echo "Convert this to use App Router"
      ;;
    react-specialist)
      echo "Optimize this component with useMemo"
      echo "Create a custom hook for data fetching"
      echo "Fix this infinite render loop"
      ;;
    postgres-expert)
      echo "Design schema for e-commerce app"
      echo "Optimize this slow query"
      echo "Create indexes for better performance"
      ;;
    typescript-pro)
      echo "Add strict types to this module"
      echo "Create generic utility type"
      echo "Fix these type errors"
      ;;
    *)
      echo "Ask this agent for help with ${agent%-*} tasks"
      ;;
  esac
}

# ============================================================================
# DISPLAY FUNCTIONS
# ============================================================================

show_help() {
  echo -e "${BOLD}Agent Testing Mode - Test and inspect individual agents${NC}"
  echo ""
  echo "Usage: $0 [OPTIONS] [AGENT_NAME]"
  echo ""
  echo "Options:"
  echo "  ${CYAN}--list${NC}              List all available agents"
  echo "  ${CYAN}--category <cat>${NC}    List agents by category (core, frontend, backend, etc.)"
  echo "  ${CYAN}--search <keyword>${NC}  Search agents by keyword"
  echo "  ${CYAN}--info <agent>${NC}      Show detailed info about an agent"
  echo "  ${CYAN}--examples <agent>${NC}  Show example use cases for an agent"
  echo "  ${CYAN}--active${NC}            List currently active agents from RULEBOOK"
  echo "  ${CYAN}--help${NC}              Show this help message"
  echo ""
  echo "Examples:"
  echo "  $0 --list"
  echo "  $0 --category frontend"
  echo "  $0 --search react"
  echo "  $0 --info nextjs-specialist"
  echo "  $0 --examples code-reviewer"
  echo "  $0 --active"
  echo ""
  echo "Categories:"
  echo "  ${GREEN}core${NC}          - Core agents (always recommended)"
  echo "  ${BLUE}frontend${NC}      - Frontend framework specialists"
  echo "  ${YELLOW}backend${NC}       - Backend framework specialists"
  echo "  ${CYAN}fullstack${NC}     - Full-stack framework specialists"
  echo "  ${GRAY}language${NC}      - Programming language specialists"
  echo "  ${CYAN}database${NC}      - Database and ORM experts"
  echo "  ${YELLOW}infrastructure${NC} - DevOps and cloud specialists"
  echo "  ${GREEN}testing${NC}       - Testing framework specialists"
  echo "  ${BLUE}specialized${NC}   - Domain-specific specialists"
}

list_all_agents() {
  echo -e "${BOLD}All Available Agents ($TOTAL_AGENTS Total)${NC}"
  echo ""

  local current_category=""
  local count=0

  while IFS= read -r agent; do
    local category=$(get_agent_category "$agent")

    # Print category header if changed
    if [ "$category" != "$current_category" ]; then
      current_category="$category"
      echo ""
      case "$category" in
        core)
          echo -e "${GREEN}${BOLD}Core Agents (Always Recommended)${NC}"
          ;;
        frontend)
          echo -e "${BLUE}${BOLD}Frontend Frameworks${NC}"
          ;;
        backend)
          echo -e "${YELLOW}${BOLD}Backend Frameworks${NC}"
          ;;
        fullstack)
          echo -e "${CYAN}${BOLD}Full-Stack Frameworks${NC}"
          ;;
        language)
          echo -e "${GRAY}${BOLD}Programming Languages${NC}"
          ;;
        database)
          echo -e "${CYAN}${BOLD}Databases & ORMs${NC}"
          ;;
        infrastructure)
          echo -e "${YELLOW}${BOLD}Infrastructure & DevOps${NC}"
          ;;
        testing)
          echo -e "${GREEN}${BOLD}Testing Frameworks${NC}"
          ;;
        specialized)
          echo -e "${BLUE}${BOLD}Specialized Domains${NC}"
          ;;
      esac
      echo "----------------------------------------"
    fi

    # Check if agent is active
    local is_active=""
    if is_agent_active "$agent"; then
      is_active=" ${GREEN}[ACTIVE]${NC}"
    fi

    echo -e "  ${BOLD}$agent${NC}$is_active"
    local desc=$(get_agent_description "$agent")
    echo -e "    ${GRAY}$desc${NC}"

    ((count++))
  done < <(get_all_agents)

  echo ""
  echo -e "${BOLD}Total Agents:${NC} $count"
}

list_by_category() {
  local target_category="$1"

  echo -e "${BOLD}Agents in category: ${target_category}${NC}"
  echo ""

  local found=0
  while IFS= read -r agent; do
    local category=$(get_agent_category "$agent")

    if [ "$category" = "$target_category" ]; then
      found=1

      # Check if agent is active
      local is_active=""
      if is_agent_active "$agent"; then
        is_active=" ${GREEN}[ACTIVE]${NC}"
      fi

      echo -e "  ${BOLD}$agent${NC}$is_active"
      local desc=$(get_agent_description "$agent")
      echo -e "    ${GRAY}$desc${NC}"
      echo ""
    fi
  done < <(get_all_agents)

  if [ $found -eq 0 ]; then
    echo -e "${RED}No agents found in category: $target_category${NC}"
    echo ""
    echo "Available categories: core, frontend, backend, fullstack, language, database, infrastructure, testing, specialized"
  fi
}

search_agents() {
  local keyword="$1"

  echo -e "${BOLD}Searching for agents matching: ${keyword}${NC}"
  echo ""

  local found=0
  while IFS= read -r agent; do
    local desc=$(get_agent_description "$agent")

    # Search in agent name or description (case insensitive)
    if echo "$agent" | grep -qi "$keyword" || echo "$desc" | grep -qi "$keyword"; then
      found=1

      # Check if agent is active
      local is_active=""
      if is_agent_active "$agent"; then
        is_active=" ${GREEN}[ACTIVE]${NC}"
      fi

      local category=$(get_agent_category "$agent")
      echo -e "  ${BOLD}$agent${NC}$is_active"
      echo -e "    Category: ${category}"
      echo -e "    ${GRAY}$desc${NC}"
      echo ""
    fi
  done < <(get_all_agents)

  if [ $found -eq 0 ]; then
    echo -e "${YELLOW}No agents found matching: $keyword${NC}"
  fi
}

show_agent_info() {
  local agent="$1"

  # Check if agent exists
  local exists=0
  while IFS= read -r a; do
    if [ "$a" = "$agent" ]; then
      exists=1
      break
    fi
  done < <(get_all_agents)

  if [ $exists -eq 0 ]; then
    echo -e "${RED}Agent not found: $agent${NC}"
    echo ""
    echo "Use '$0 --list' to see all available agents"
    exit 1
  fi

  local category=$(get_agent_category "$agent")
  local desc=$(get_agent_description "$agent")

  echo -e "${BOLD}Agent: ${agent}${NC}"
  echo ""

  # Active status
  if is_agent_active "$agent"; then
    echo -e "Status: ${GREEN}ACTIVE${NC}"
  else
    echo -e "Status: ${GRAY}Inactive${NC}"
  fi

  echo -e "Category: ${category}"
  echo ""

  echo -e "${BOLD}Description:${NC}"
  echo -e "$desc"
  echo ""

  # Check if agent file exists
  if [ -f "$AGENTS_DIR/$agent.md" ]; then
    echo -e "${BOLD}Agent File:${NC} $AGENTS_DIR/$agent.md"
    echo ""
  fi

  echo -e "${BOLD}Example Use Cases:${NC}"
  get_agent_examples "$agent" | while IFS= read -r example; do
    echo -e "  • ${CYAN}$example${NC}"
  done
  echo ""

  # Activation instructions
  if ! is_agent_active "$agent"; then
    echo -e "${BOLD}To activate this agent:${NC}"
    echo -e "  1. Run: ${CYAN}scripts/select-agents.sh${NC}"
    echo -e "  2. Navigate to ${category} category"
    echo -e "  3. Toggle $agent"
    echo ""
    echo -e "  Or manually add to RULEBOOK.md Active Agents section:"
    echo -e "  ${GRAY}- $agent${NC}"
  fi
}

show_agent_examples() {
  local agent="$1"

  # Check if agent exists
  local exists=0
  while IFS= read -r a; do
    if [ "$a" = "$agent" ]; then
      exists=1
      break
    fi
  done < <(get_all_agents)

  if [ $exists -eq 0 ]; then
    echo -e "${RED}Agent not found: $agent${NC}"
    exit 1
  fi

  echo -e "${BOLD}Example use cases for: ${agent}${NC}"
  echo ""

  local i=1
  get_agent_examples "$agent" | while IFS= read -r example; do
    echo -e "${BOLD}Example $i:${NC}"
    echo -e "  Prompt: ${CYAN}\"$example\"${NC}"
    echo -e "  Agent: ${BOLD}$agent${NC}"
    echo ""
    ((i++))
  done

  echo -e "${BOLD}How to test:${NC}"
  echo -e "  1. Ensure agent is active in RULEBOOK.md"
  echo -e "  2. In Claude Code, use prompt: ${CYAN}\"[example prompt from above]\"${NC}"
  echo -e "  3. Claude will automatically use the $agent agent"
}

list_active_agents() {
  if ! check_rulebook_exists; then
    echo ""
    echo "Run the installation script first to set up the toolkit"
    exit 1
  fi

  echo -e "${BOLD}Currently Active Agents${NC}"
  echo ""

  # Extract active agents from RULEBOOK
  local active_agents=$(grep "^- " "$RULEBOOK" | sed 's/^- //' | sort)

  if [ -z "$active_agents" ]; then
    echo -e "${YELLOW}No active agents found in RULEBOOK.md${NC}"
    echo ""
    echo "Run 'scripts/select-agents.sh' to activate agents"
    exit 0
  fi

  local count=0
  local current_category=""

  while IFS= read -r agent; do
    ((count++))

    local category=$(get_agent_category "$agent")

    # Print category header if changed
    if [ "$category" != "$current_category" ]; then
      current_category="$category"
      echo ""
      case "$category" in
        core)
          echo -e "${GREEN}${BOLD}Core Agents${NC}"
          ;;
        frontend)
          echo -e "${BLUE}${BOLD}Frontend Frameworks${NC}"
          ;;
        backend)
          echo -e "${YELLOW}${BOLD}Backend Frameworks${NC}"
          ;;
        fullstack)
          echo -e "${CYAN}${BOLD}Full-Stack Frameworks${NC}"
          ;;
        language)
          echo -e "${GRAY}${BOLD}Programming Languages${NC}"
          ;;
        database)
          echo -e "${CYAN}${BOLD}Databases & ORMs${NC}"
          ;;
        infrastructure)
          echo -e "${YELLOW}${BOLD}Infrastructure & DevOps${NC}"
          ;;
        testing)
          echo -e "${GREEN}${BOLD}Testing Frameworks${NC}"
          ;;
        specialized)
          echo -e "${BLUE}${BOLD}Specialized Domains${NC}"
          ;;
        *)
          echo -e "${BOLD}Other${NC}"
          ;;
      esac
      echo "----------------------------------------"
    fi

    echo -e "  ${GREEN}✓${NC} ${BOLD}$agent${NC}"
    local desc=$(get_agent_description "$agent")
    echo -e "    ${GRAY}$desc${NC}"
  done <<< "$active_agents"

  echo ""
  echo -e "${BOLD}Total Active Agents:${NC} $count"
  echo ""
  echo -e "${GRAY}To modify active agents, run: ${CYAN}scripts/select-agents.sh${NC}"
}

# ============================================================================
# MAIN
# ============================================================================

main() {
  # Parse arguments
  case "${1:-}" in
    --help|-h)
      show_help
      ;;
    --list)
      list_all_agents
      ;;
    --category)
      if [ -z "$2" ]; then
        echo -e "${RED}Error: --category requires a category name${NC}"
        exit 1
      fi
      list_by_category "$2"
      ;;
    --search)
      if [ -z "$2" ]; then
        echo -e "${RED}Error: --search requires a keyword${NC}"
        exit 1
      fi
      search_agents "$2"
      ;;
    --info)
      if [ -z "$2" ]; then
        echo -e "${RED}Error: --info requires an agent name${NC}"
        exit 1
      fi
      show_agent_info "$2"
      ;;
    --examples)
      if [ -z "$2" ]; then
        echo -e "${RED}Error: --examples requires an agent name${NC}"
        exit 1
      fi
      show_agent_examples "$2"
      ;;
    --active)
      list_active_agents
      ;;
    "")
      show_help
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
