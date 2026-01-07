#!/bin/bash

# Claude Code Agents Global Toolkit - RULEBOOK Questionnaire
# Version: 1.0.0
# Description: Interactive questionnaire to generate customized RULEBOOK

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Answers storage (using regular variables for compatibility)
PROJECT_NAME=""
FRAMEWORK=""
LANGUAGE=""
STATE_MGMT=""
STYLING=""
TESTING=""
DATABASE=""
ORM=""
API_TYPE=""
DEPLOYMENT=""
FILE_NAMING=""
COMPONENT_STRUCTURE=""

# Helper functions
print_header() {
    clear
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  📋 RULEBOOK Generator - Interactive Setup      ${BLUE}║${NC}"
    echo -e "${BLUE}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_section() {
    echo ""
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

print_question() {
    echo -e "${YELLOW}$1${NC}"
}

print_option() {
    echo -e "  ${BLUE}[$1]${NC} $2"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

# Ask question with options
ask_question() {
    local question=$1
    local var_name=$2
    shift 2
    local options=("$@")

    echo ""
    print_question "$question"
    echo ""

    for i in "${!options[@]}"; do
        print_option "$((i+1))" "${options[$i]}"
    done

    echo ""
    read -p "Enter choice [1-${#options[@]}]: " choice

    # Validate choice
    while [[ ! "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#options[@]}" ]; do
        echo -e "${RED}Invalid choice. Please enter 1-${#options[@]}${NC}"
        read -p "Enter choice [1-${#options[@]}]: " choice
    done

    # Set the variable value using eval
    eval "$var_name='${options[$((choice-1))]}'"
}

# Ask free text question
ask_text() {
    local question=$1
    local var_name=$2
    local default=$3

    echo ""
    print_question "$question"
    if [ ! -z "$default" ]; then
        echo -e "${BLUE}(Press Enter for default: $default)${NC}"
    fi
    read -p "> " answer

    if [ -z "$answer" ] && [ ! -z "$default" ]; then
        answer=$default
    fi

    eval "$var_name='$answer'"
}

# Ask yes/no question
ask_yes_no() {
    local question=$1
    local var_name=$2
    local default=$3

    echo ""
    print_question "$question"

    if [ "$default" = "y" ]; then
        read -p "[Y/n]: " answer
        answer=${answer:-y}
    else
        read -p "[y/N]: " answer
        answer=${answer:-n}
    fi

    eval "$var_name='$answer'"
}

# Generate RULEBOOK content
generate_rulebook() {
    # Use the global variables directly
    local project_name="$PROJECT_NAME"
    local framework="$FRAMEWORK"
    local language="$LANGUAGE"
    local state_mgmt="$STATE_MGMT"
    local styling="$STYLING"
    local testing="$TESTING"
    local database="$DATABASE"
    local orm="$ORM"
    local api_type="$API_TYPE"
    local deployment="$DEPLOYMENT"
    local file_naming="$FILE_NAMING"
    local component_structure="$COMPONENT_STRUCTURE"

    cat > .claude/RULEBOOK.md << EOF
# $project_name - RULEBOOK

**Generated:** $(date +%Y-%m-%d)
**Last Updated:** $(date +%Y-%m-%d)

This RULEBOOK defines the patterns, conventions, and standards for the $project_name project.

---

## 📋 Table of Contents

1. [Tech Stack](#tech-stack)
2. [Architecture](#architecture)
3. [Code Organization](#code-organization)
4. [State Management](#state-management)
5. [Styling](#styling)
6. [Testing](#testing)
7. [Database](#database)
8. [API Design](#api-design)
9. [Naming Conventions](#naming-conventions)
10. [Code Patterns](#code-patterns)
11. [Security](#security)
12. [Performance](#performance)
13. [Accessibility](#accessibility)
14. [Deployment](#deployment)
15. [Active Agents](#active-agents)

---

## Tech Stack

### Frontend
- **Framework:** $framework
- **Language:** $language
- **Styling:** $styling
EOF

    # Add backend if applicable
    if [[ "$framework" == "Express"* ]] || [[ "$framework" == "Fastify"* ]] || [[ "$framework" == "NestJS"* ]]; then
        cat >> .claude/RULEBOOK.md << EOF
- **Runtime:** Node.js

### Backend
- **Framework:** $framework
- **API Type:** $api_type
EOF
    fi

    # Add database section
    if [ "$database" != "None" ]; then
        cat >> .claude/RULEBOOK.md << EOF

### Database
- **Database:** $database
EOF
        if [ "$orm" != "None" ]; then
            cat >> .claude/RULEBOOK.md << EOF
- **ORM/Query Builder:** $orm
EOF
        fi
    fi

    # Add testing section
    cat >> .claude/RULEBOOK.md << EOF

### Testing
- **Framework:** $testing
- **Coverage Target:** 80%+ for critical paths
- **Test Types:** Unit, Integration, E2E

### Deployment
- **Platform:** $deployment

---

## Architecture

### System Architecture
- **Pattern:** Component-Based Architecture
- **Separation:** Clear separation between business logic and UI
- **Data Flow:** Unidirectional data flow

### Folder Structure

\`\`\`
src/
├── components/          # Reusable UI components
├── pages/              # Page components / routes
EOF

    if [ "$state_mgmt" != "None" ] && [ "$state_mgmt" != "React Context" ]; then
        cat >> .claude/RULEBOOK.md << EOF
├── store/              # State management ($state_mgmt)
EOF
    fi

    cat >> .claude/RULEBOOK.md << EOF
├── hooks/              # Custom React hooks
├── utils/              # Utility functions
├── lib/                # External library configurations
├── types/              # TypeScript type definitions
└── styles/             # Global styles
\`\`\`

---

## Code Organization

### Component Structure
- **Pattern:** $component_structure
- **File Naming:** $file_naming

EOF

    if [ "$component_structure" = "Folder per component" ]; then
        cat >> .claude/RULEBOOK.md << EOF
**Example:**
\`\`\`
components/
└── Button/
    ├── Button.tsx
    ├── Button.test.tsx
    ├── Button.module.css
    └── index.ts
\`\`\`
EOF
    else
        cat >> .claude/RULEBOOK.md << EOF
**Example:**
\`\`\`
components/
├── Button.tsx
├── Button.test.tsx
└── Button.module.css
\`\`\`
EOF
    fi

    cat >> .claude/RULEBOOK.md << EOF

### Import Order
1. React/Framework imports
2. External library imports
3. Internal imports (components, hooks, utils)
4. Type imports
5. Styles

**Example:**
\`\`\`typescript
import React from 'react';
import { useState } from 'react';

import { format } from 'date-fns';
import axios from 'axios';

import Button from '@/components/Button';
import { useAuth } from '@/hooks/useAuth';
import { formatDate } from '@/utils/date';

import type { User } from '@/types/user';

import styles from './Component.module.css';
\`\`\`

---

## State Management

### Approach: $state_mgmt

EOF

    case "$state_mgmt" in
        "Redux Toolkit")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** Redux Toolkit with slices
**Location:** \`src/store/\`

**Rules:**
- Use \`createSlice\` for all state slices
- Use \`createAsyncThunk\` for async operations
- Keep slices focused and single-responsibility
- Use \`createSelector\` for computed values

**Example:**
\`\`\`typescript
// src/store/slices/userSlice.ts
import { createSlice, createAsyncThunk } from '@reduxjs/toolkit';

export const fetchUser = createAsyncThunk('user/fetch', async (id: string) => {
  const response = await api.getUser(id);
  return response.data;
});

const userSlice = createSlice({
  name: 'user',
  initialState: { data: null, loading: false },
  reducers: {},
  extraReducers: (builder) => {
    builder.addCase(fetchUser.fulfilled, (state, action) => {
      state.data = action.payload;
    });
  },
});
\`\`\`
EOF
            ;;
        "Zustand")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** Zustand stores
**Location:** \`src/store/\`

**Rules:**
- One store per domain
- Use middleware (persist, devtools) where needed
- Keep stores flat and normalized

**Example:**
\`\`\`typescript
// src/store/useUserStore.ts
import { create } from 'zustand';

export const useUserStore = create((set) => ({
  user: null,
  setUser: (user) => set({ user }),
  clearUser: () => set({ user: null }),
}));
\`\`\`
EOF
            ;;
        "React Context")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** React Context API
**Location:** \`src/context/\`

**Rules:**
- Split contexts by domain
- Use \`useReducer\` for complex state
- Memoize context values

**Example:**
\`\`\`typescript
// src/context/UserContext.tsx
const UserContext = createContext<UserContextType | null>(null);

export const UserProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const value = useMemo(() => ({ user, setUser }), [user]);

  return <UserContext.Provider value={value}>{children}</UserContext.Provider>;
};
\`\`\`
EOF
            ;;
    esac

    cat >> .claude/RULEBOOK.md << EOF

---

## Styling

### Approach: $styling

EOF

    case "$styling" in
        "Tailwind CSS")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** Utility-first CSS with Tailwind

**Rules:**
- Use Tailwind classes directly in JSX
- Extract repeated patterns to components
- Use \`@apply\` sparingly (only for complex reusable patterns)
- Follow mobile-first responsive design

**Example:**
\`\`\`tsx
<button className="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600 transition-colors">
  Click Me
</button>
\`\`\`
EOF
            ;;
        "CSS Modules")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** Scoped CSS with CSS Modules

**Rules:**
- One CSS module per component
- Use camelCase for class names
- Avoid global styles unless necessary

**Example:**
\`\`\`tsx
// Button.module.css
.button {
  padding: 0.5rem 1rem;
  background: blue;
}

// Button.tsx
import styles from './Button.module.css';

<button className={styles.button}>Click</button>
\`\`\`
EOF
            ;;
        "Styled Components")
            cat >> .claude/RULEBOOK.md << EOF
**Pattern:** CSS-in-JS with styled-components

**Rules:**
- Colocate styled components with their usage
- Use theme for colors, spacing, etc.
- Extract common styles to shared styled components

**Example:**
\`\`\`tsx
const Button = styled.button\`
  padding: 0.5rem 1rem;
  background: \${props => props.theme.colors.primary};
\`;
\`\`\`
EOF
            ;;
    esac

    cat >> .claude/RULEBOOK.md << EOF

---

## Testing

### Framework: $testing

**Coverage Requirements:**
- Critical paths: 80%+ coverage
- Utilities: 90%+ coverage
- Components: 70%+ coverage

**Test Structure:**
\`\`\`typescript
describe('ComponentName', () => {
  it('should render correctly', () => {
    // Arrange
    const props = { ... };

    // Act
    render(<Component {...props} />);

    // Assert
    expect(screen.getByText('...')).toBeInTheDocument();
  });
});
\`\`\`

**What to Test:**
- ✅ User interactions
- ✅ Edge cases
- ✅ Error states
- ✅ API integrations (mocked)
- ❌ Implementation details
- ❌ Third-party library internals

---

## Database

EOF

    if [ "$database" != "None" ]; then
        cat >> .claude/RULEBOOK.md << EOF
### Database: $database
EOF
        if [ "$orm" != "None" ]; then
            cat >> .claude/RULEBOOK.md << EOF
### ORM: $orm

**Patterns:**
- Define schemas/models in \`src/models/\`
- Use migrations for all schema changes
- Never use raw queries unless absolutely necessary
- Always use parameterized queries
EOF
        fi
    else
        cat >> .claude/RULEBOOK.md << EOF
### Database: None

This project does not use a database.
EOF
    fi

    cat >> .claude/RULEBOOK.md << EOF

---

## API Design

### Type: $api_type

EOF

    case "$api_type" in
        "REST")
            cat >> .claude/RULEBOOK.md << EOF
**Patterns:**
- RESTful resource naming (\`/users\`, \`/posts\`)
- Proper HTTP methods (GET, POST, PUT, DELETE)
- Consistent error responses
- Versioning: \`/api/v1/...\`

**Response Format:**
\`\`\`json
{
  "data": { ... },
  "error": null,
  "metadata": { ... }
}
\`\`\`
EOF
            ;;
        "GraphQL")
            cat >> .claude/RULEBOOK.md << EOF
**Patterns:**
- Schema-first design
- Resolvers in \`src/resolvers/\`
- Use DataLoader for batching
- Proper error handling with error codes

**Schema Organization:**
\`\`\`
schema/
├── types/
├── queries/
├── mutations/
└── index.ts
\`\`\`
EOF
            ;;
        "tRPC")
            cat >> .claude/RULEBOOK.md << EOF
**Patterns:**
- Type-safe procedures
- Routers in \`src/server/routers/\`
- Input validation with Zod
- Proper error handling with TRPCError

**Example:**
\`\`\`typescript
export const userRouter = router({
  getById: publicProcedure
    .input(z.object({ id: z.string() }))
    .query(({ input }) => {
      return db.user.findUnique({ where: { id: input.id } });
    }),
});
\`\`\`
EOF
            ;;
    esac

    cat >> .claude/RULEBOOK.md << EOF

---

## Naming Conventions

### Files
- **Components:** $file_naming
- **Utilities:** camelCase (\`formatDate.ts\`)
- **Types:** PascalCase (\`UserType.ts\`)
- **Constants:** UPPER_SNAKE_CASE (\`API_BASE_URL.ts\`)

### Variables & Functions
- **Variables:** camelCase (\`userName\`)
- **Functions:** camelCase (\`getUserData\`)
- **Classes:** PascalCase (\`UserService\`)
- **Constants:** UPPER_SNAKE_CASE (\`MAX_RETRY_COUNT\`)
- **Private fields:** prefix with \`_\` (\`_internalState\`)

### React Specific
- **Components:** PascalCase (\`UserProfile\`)
- **Hooks:** prefix with \`use\` (\`useAuth\`)
- **Props Types:** suffix with \`Props\` (\`ButtonProps\`)

---

## Code Patterns

### Error Handling
\`\`\`typescript
try {
  const result = await fetchData();
  return result;
} catch (error) {
  console.error('Failed to fetch data:', error);
  throw new Error('Data fetch failed');
}
\`\`\`

### Async/Await
- ✅ Always use async/await (not .then())
- ✅ Always handle errors
- ✅ Use try/catch for async operations

### Code Quality
- ✅ Single Responsibility Principle
- ✅ DRY (Don't Repeat Yourself)
- ✅ Meaningful variable names
- ✅ Keep functions small (<50 lines)
- ❌ No magic numbers/strings
- ❌ No deeply nested code (max 3 levels)

---

## Security

### Required Practices
- ✅ Input validation on all user inputs
- ✅ Parameterized queries (prevent SQL injection)
- ✅ HTTPS only in production
- ✅ Environment variables for secrets
- ✅ Rate limiting on API endpoints
- ❌ Never commit secrets to git
- ❌ Never expose sensitive data in responses

### Authentication
- Use secure authentication methods
- Store tokens securely
- Implement proper session management

---

## Performance

### Targets
- **First Contentful Paint:** < 1.5s
- **Time to Interactive:** < 3.5s
- **Lighthouse Score:** > 90

### Optimization Patterns
- Code splitting for routes
- Lazy loading for heavy components
- Image optimization (WebP, lazy loading)
- Memoization for expensive computations
- Virtual scrolling for long lists

---

## Accessibility

### Standards
- **Target:** WCAG 2.1 AA compliance
- **Tools:** axe DevTools, Lighthouse

### Required
- ✅ Semantic HTML
- ✅ ARIA labels where needed
- ✅ Keyboard navigation support
- ✅ Focus indicators
- ✅ Alt text for images
- ✅ Color contrast ratio > 4.5:1

---

## Deployment

### Platform: $deployment

### Process
1. Run tests (\`npm test\`)
2. Run linter (\`npm run lint\`)
3. Build production bundle (\`npm run build\`)
4. Deploy to $deployment

### Environment Variables
- Development: \`.env.development\`
- Production: \`.env.production\`
- Never commit \`.env\` files

---

## Active Agents

Based on this tech stack, the following agents will be active:

### Core Agents (Always Active)
- code-reviewer
- refactoring-specialist
- documentation-engineer
- test-strategist
- architecture-advisor
- security-auditor
- performance-optimizer
- git-workflow-specialist
- dependency-manager
- project-analyzer

### Specialized Agents (Auto-Activated)
EOF

    # Add specialized agents based on tech stack
    case "$framework" in
        *"Next.js"*)
            echo "- nextjs-specialist" >> .claude/RULEBOOK.md
            echo "- react-specialist" >> .claude/RULEBOOK.md
            ;;
        *"React"*)
            echo "- react-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Vue"*)
            echo "- vue-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Angular"*)
            echo "- angular-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Express"*)
            echo "- express-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Fastify"*)
            echo "- fastify-expert" >> .claude/RULEBOOK.md
            ;;
        *"NestJS"*)
            echo "- nest-specialist" >> .claude/RULEBOOK.md
            ;;
    esac

    if [ "$language" = "TypeScript" ]; then
        echo "- typescript-pro" >> .claude/RULEBOOK.md
    fi

    if [ "$styling" = "Tailwind CSS" ]; then
        echo "- tailwind-expert" >> .claude/RULEBOOK.md
    fi

    case "$testing" in
        *"Vitest"*)
            echo "- vitest-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Jest"*)
            echo "- jest-testing-specialist" >> .claude/RULEBOOK.md
            ;;
        *"Playwright"*)
            echo "- playwright-e2e-specialist" >> .claude/RULEBOOK.md
            ;;
    esac

    case "$database" in
        *"PostgreSQL"*)
            echo "- postgres-expert" >> .claude/RULEBOOK.md
            ;;
        *"MongoDB"*)
            echo "- mongodb-expert" >> .claude/RULEBOOK.md
            ;;
        *"MySQL"*)
            echo "- mysql-specialist" >> .claude/RULEBOOK.md
            ;;
    esac

    if [ "$orm" = "Prisma" ]; then
        echo "- prisma-specialist" >> .claude/RULEBOOK.md
    elif [ "$orm" = "Drizzle" ]; then
        echo "- drizzle-specialist" >> .claude/RULEBOOK.md
    fi

    cat >> .claude/RULEBOOK.md << EOF

---

## Notes

This RULEBOOK was generated on $(date +%Y-%m-%d) and should be updated as the project evolves.

**Remember:**
- The RULEBOOK is a living document
- Update it when patterns change
- Review it with the team regularly
- Use it to onboard new developers

**Maestro will enforce these patterns strictly. Update this file when you want to change project standards.**
EOF

    print_success "RULEBOOK generated successfully!"
}

# Main questionnaire flow
main() {
    print_header

    echo -e "${GREEN}Welcome to the RULEBOOK Generator!${NC}"
    echo ""
    echo "This interactive questionnaire will help you create a customized"
    echo "RULEBOOK.md for your project. Answer the questions below to define"
    echo "your project's patterns, conventions, and standards."
    echo ""
    echo -e "${YELLOW}Press Enter to continue...${NC}"
    read

    # Check if RULEBOOK already exists
    if [ -f ".claude/RULEBOOK.md" ]; then
        print_header
        print_warning "RULEBOOK.md already exists!"
        echo ""
        read -p "Overwrite existing RULEBOOK? [y/N]: " overwrite
        if [[ ! $overwrite =~ ^[Yy]$ ]]; then
            echo "Questionnaire cancelled."
            exit 0
        fi
        # Backup existing RULEBOOK
        cp .claude/RULEBOOK.md .claude/RULEBOOK.md.backup
        print_success "Existing RULEBOOK backed up to .claude/RULEBOOK.md.backup"
        echo ""
        echo -e "${YELLOW}Press Enter to continue...${NC}"
        read
    fi

    # Project basics
    print_header
    print_section "Project Information"

    ask_text "What is your project name?" "PROJECT_NAME" "$(basename "$PWD")"

    # Framework selection
    print_header
    print_section "Framework & Language"

    ask_question "What is your primary framework?" "FRAMEWORK" \
        "Next.js" \
        "React (CRA/Vite)" \
        "Vue.js" \
        "Angular" \
        "Svelte/SvelteKit" \
        "Express.js" \
        "Fastify" \
        "NestJS" \
        "Other"

    ask_question "What language are you using?" "LANGUAGE" \
        "TypeScript" \
        "JavaScript" \
        "Python" \
        "Go" \
        "Other"

    # State management
    print_header
    print_section "State Management"

    ask_question "How do you manage state?" "STATE_MGMT" \
        "Redux Toolkit" \
        "Zustand" \
        "React Context" \
        "Jotai" \
        "Recoil" \
        "None"

    # Styling
    print_header
    print_section "Styling Approach"

    ask_question "What is your styling approach?" "STYLING" \
        "Tailwind CSS" \
        "CSS Modules" \
        "Styled Components" \
        "Emotion" \
        "Sass/SCSS" \
        "Plain CSS"

    # Testing
    print_header
    print_section "Testing Framework"

    ask_question "What testing framework do you use?" "TESTING" \
        "Vitest" \
        "Jest" \
        "Playwright" \
        "Cypress" \
        "Testing Library" \
        "None"

    # Database
    print_header
    print_section "Database & ORM"

    ask_question "What database are you using?" "DATABASE" \
        "PostgreSQL" \
        "MongoDB" \
        "MySQL" \
        "Redis" \
        "SQLite" \
        "None"

    if [ "$DATABASE" != "None" ]; then
        ask_question "What ORM/Query builder?" "ORM" \
            "Prisma" \
            "Drizzle" \
            "TypeORM" \
            "Sequelize" \
            "Mongoose" \
            "Raw SQL" \
            "None"
    else
        ORM="None"
    fi

    # API
    print_header
    print_section "API Design"

    ask_question "What API type are you using?" "API_TYPE" \
        "REST" \
        "GraphQL" \
        "tRPC" \
        "gRPC" \
        "None"

    # Deployment
    print_header
    print_section "Deployment"

    ask_question "Where do you deploy?" "DEPLOYMENT" \
        "Vercel" \
        "AWS" \
        "Docker/Kubernetes" \
        "Netlify" \
        "Heroku" \
        "Self-hosted" \
        "Other"

    # Code organization
    print_header
    print_section "Code Organization"

    ask_question "File naming convention for components?" "FILE_NAMING" \
        "PascalCase (Button.tsx)" \
        "kebab-case (button.tsx)" \
        "camelCase (button.tsx)"

    ask_question "Component structure preference?" "COMPONENT_STRUCTURE" \
        "Folder per component (Button/Button.tsx)" \
        "Flat structure (Button.tsx)"

    # Generate RULEBOOK
    print_header
    print_section "Generating RULEBOOK"

    echo ""
    print_info "Generating your customized RULEBOOK.md..."
    echo ""

    # Ensure .claude directory exists
    mkdir -p .claude

    # Generate the RULEBOOK
    generate_rulebook

    # Show summary
    echo ""
    print_success "════════════════════════════════════════════════════════"
    print_success "  RULEBOOK Generated Successfully!"
    print_success "════════════════════════════════════════════════════════"
    echo ""

    echo -e "${GREEN}Your customized RULEBOOK has been created:${NC}"
    echo "  → .claude/RULEBOOK.md"
    echo ""

    echo -e "${BLUE}What's included:${NC}"
    echo "  • Tech stack documentation"
    echo "  • Architecture patterns"
    echo "  • Code organization rules"
    echo "  • Naming conventions"
    echo "  • Testing requirements"
    echo "  • Security guidelines"
    echo "  • Active agents list"
    echo ""

    echo -e "${YELLOW}Next steps:${NC}"
    echo "  1. Review .claude/RULEBOOK.md"
    echo "  2. Customize any sections as needed"
    echo "  3. Activate Maestro: /maestro in Claude Code"
    echo "  4. Maestro will enforce these patterns"
    echo ""

    echo -e "${CYAN}Tip: The RULEBOOK is a living document. Update it as your project evolves!${NC}"
    echo ""
}

# Run main
main "$@"
