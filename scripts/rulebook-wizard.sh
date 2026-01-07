#!/bin/bash

# Claude Code Agents Toolkit - Smart RULEBOOK Wizard
# Version: 1.0.0
# Description: Intelligently generates RULEBOOK by scanning project or asking questions

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Project context storage
DETECTED_FRAMEWORK=""
DETECTED_LANGUAGE=""
DETECTED_DATABASE=""
DETECTED_STYLING=""
DETECTED_TESTING=""
DETECTED_TOOLS=()
SCAN_RESULTS=()
SCAN_HELPFUL=false

# Helper functions
print_header() {
    echo ""
    echo -e "${BLUE}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC}  🧙 RULEBOOK Wizard - Smart Project Setup       ${BLUE}║${NC}"
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

print_found() {
    echo -e "${GREEN}  ➜${NC} $1"
}

print_not_found() {
    echo -e "${YELLOW}  ○${NC} $1"
}

# Scan current directory for project files (NOT parent directories)
scan_project_context() {
    echo ""
    print_section "📂 Scanning Current Directory"
    print_info "Analyzing project files in: $(pwd)"
    echo ""

    # List all files in current directory first
    print_info "Files in current directory:"
    ls -1 | head -20 | while read -r file; do
        echo "  • $file"
    done

    local total_files=$(ls -1 | wc -l | tr -d ' ')
    if [ "$total_files" -gt 20 ]; then
        echo "  ... and $((total_files - 20)) more files"
    fi
    echo ""

    local files_scanned=0
    local files_helpful=0

    # Scan markdown files for project context
    if ls *.md &> /dev/null; then
        print_info "Reading markdown files for context..."
        for md_file in *.md; do
            if [ -f "$md_file" ]; then
                files_scanned=$((files_scanned + 1))
                print_found "Found: $md_file"

                # Try to extract useful info from markdown
                if [ "$md_file" = "README.md" ] || [ "$md_file" = "readme.md" ]; then
                    # Extract first few lines for project description
                    local description=$(head -10 "$md_file" | grep -v "^#" | grep -v "^$" | head -3)
                    if [ -n "$description" ]; then
                        files_helpful=$((files_helpful + 1))
                        SCAN_RESULTS+=("$md_file: Project documentation found")
                    fi
                fi
            fi
        done
        echo ""
    fi

    # Node.js / JavaScript / TypeScript projects
    if [ -f "package.json" ]; then
        files_scanned=$((files_scanned + 1))
        print_found "Found: package.json"
        SCAN_RESULTS+=("package.json: Node.js project detected")

        # Parse package.json
        if command -v jq &> /dev/null; then
            local deps=$(cat package.json | jq -r '.dependencies // {} | keys[]' 2>/dev/null || echo "")
            local devDeps=$(cat package.json | jq -r '.devDependencies // {} | keys[]' 2>/dev/null || echo "")

            # Detect framework
            if echo "$deps" | grep -q "next"; then
                DETECTED_FRAMEWORK="Next.js"
                files_helpful=$((files_helpful + 1))
                print_found "  Framework: Next.js"
            elif echo "$deps" | grep -q "^react$"; then
                DETECTED_FRAMEWORK="React"
                files_helpful=$((files_helpful + 1))
                print_found "  Framework: React"
            elif echo "$deps" | grep -q "vue"; then
                DETECTED_FRAMEWORK="Vue"
                files_helpful=$((files_helpful + 1))
                print_found "  Framework: Vue"
            elif echo "$deps" | grep -q "express"; then
                DETECTED_FRAMEWORK="Express"
                files_helpful=$((files_helpful + 1))
                print_found "  Framework: Express"
            fi

            # Detect database/ORM
            if echo "$deps" | grep -q "prisma"; then
                DETECTED_DATABASE="Prisma"
                files_helpful=$((files_helpful + 1))
                print_found "  Database/ORM: Prisma"
            elif echo "$deps" | grep -q "mongoose"; then
                DETECTED_DATABASE="MongoDB + Mongoose"
                files_helpful=$((files_helpful + 1))
                print_found "  Database/ORM: MongoDB + Mongoose"
            fi

            # Detect styling
            if echo "$deps $devDeps" | grep -q "tailwindcss"; then
                DETECTED_STYLING="Tailwind CSS"
                files_helpful=$((files_helpful + 1))
                print_found "  Styling: Tailwind CSS"
            fi

            # Detect testing
            if echo "$devDeps" | grep -q "vitest"; then
                DETECTED_TESTING="Vitest"
                files_helpful=$((files_helpful + 1))
                print_found "  Testing: Vitest"
            elif echo "$devDeps" | grep -q "jest"; then
                DETECTED_TESTING="Jest"
                files_helpful=$((files_helpful + 1))
                print_found "  Testing: Jest"
            fi
        else
            # Fallback without jq
            if grep -q "next" package.json 2>/dev/null; then
                DETECTED_FRAMEWORK="Next.js"
                files_helpful=$((files_helpful + 1))
            elif grep -q "\"react\"" package.json 2>/dev/null; then
                DETECTED_FRAMEWORK="React"
                files_helpful=$((files_helpful + 1))
            fi
        fi
    else
        print_not_found "package.json not found"
    fi

    # TypeScript
    if [ -f "tsconfig.json" ]; then
        files_scanned=$((files_scanned + 1))
        files_helpful=$((files_helpful + 1))
        print_found "Found: tsconfig.json"
        DETECTED_LANGUAGE="TypeScript"
        SCAN_RESULTS+=("tsconfig.json: TypeScript project")
    else
        print_not_found "tsconfig.json not found"
    fi

    # Python projects
    if [ -f "pyproject.toml" ] || [ -f "requirements.txt" ] || [ -f "setup.py" ]; then
        files_scanned=$((files_scanned + 1))
        files_helpful=$((files_helpful + 1))
        DETECTED_LANGUAGE="Python"

        if [ -f "pyproject.toml" ]; then
            print_found "Found: pyproject.toml"
            SCAN_RESULTS+=("pyproject.toml: Python project")
        fi
        if [ -f "requirements.txt" ]; then
            print_found "Found: requirements.txt"

            # Check for FastAPI
            if grep -q "fastapi" requirements.txt 2>/dev/null; then
                DETECTED_FRAMEWORK="FastAPI"
                print_found "  Framework: FastAPI"
            fi
        fi
    else
        print_not_found "Python project files not found"
    fi

    # Go projects
    if [ -f "go.mod" ]; then
        files_scanned=$((files_scanned + 1))
        files_helpful=$((files_helpful + 1))
        print_found "Found: go.mod"
        DETECTED_LANGUAGE="Go"
        SCAN_RESULTS+=("go.mod: Go project")
    else
        print_not_found "go.mod not found"
    fi

    # Rust projects
    if [ -f "Cargo.toml" ]; then
        files_scanned=$((files_scanned + 1))
        files_helpful=$((files_helpful + 1))
        print_found "Found: Cargo.toml"
        DETECTED_LANGUAGE="Rust"
        SCAN_RESULTS+=("Cargo.toml: Rust project")
    else
        print_not_found "Cargo.toml not found"
    fi

    # Docker
    if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ]; then
        files_scanned=$((files_scanned + 1))
        files_helpful=$((files_helpful + 1))
        print_found "Found: Docker configuration"
        DETECTED_TOOLS+=("Docker")
        SCAN_RESULTS+=("Dockerfile/docker-compose.yml: Docker in use")
    else
        print_not_found "Docker files not found"
    fi

    # Summary
    echo ""
    print_section "📊 Scan Summary"
    echo -e "  Files scanned: ${BLUE}$files_scanned${NC}"
    echo -e "  Files helpful: ${GREEN}$files_helpful${NC}"
    echo ""

    if [ $files_helpful -gt 0 ]; then
        SCAN_HELPFUL=true
        print_success "Project context detected successfully!"
        echo ""
        echo "Detected configuration:"
        [ -n "$DETECTED_FRAMEWORK" ] && echo -e "  ${GREEN}•${NC} Framework: ${BLUE}$DETECTED_FRAMEWORK${NC}"
        [ -n "$DETECTED_LANGUAGE" ] && echo -e "  ${GREEN}•${NC} Language: ${BLUE}$DETECTED_LANGUAGE${NC}"
        [ -n "$DETECTED_DATABASE" ] && echo -e "  ${GREEN}•${NC} Database/ORM: ${BLUE}$DETECTED_DATABASE${NC}"
        [ -n "$DETECTED_STYLING" ] && echo -e "  ${GREEN}•${NC} Styling: ${BLUE}$DETECTED_STYLING${NC}"
        [ -n "$DETECTED_TESTING" ] && echo -e "  ${GREEN}•${NC} Testing: ${BLUE}$DETECTED_TESTING${NC}"
        [ ${#DETECTED_TOOLS[@]} -gt 0 ] && echo -e "  ${GREEN}•${NC} Tools: ${BLUE}${DETECTED_TOOLS[*]}${NC}"
    else
        print_warning "No project context detected from scanned files"
        print_info "We'll use interactive mode to set up your RULEBOOK"
    fi
}

# Show wizard options
show_wizard_options() {
    echo ""
    print_section "🎯 How would you like to create your RULEBOOK?"
    echo ""

    echo -e "  ${BLUE}[1]${NC} Use detected configuration (auto-generate)"
    if [ "$SCAN_HELPFUL" = true ]; then
        echo -e "      ${GREEN}→ Recommended based on project scan${NC}"
    else
        echo -e "      ${YELLOW}→ Limited info detected, may need adjustments${NC}"
    fi

    echo ""
    echo -e "  ${BLUE}[2]${NC} Answer questions interactively"
    echo -e "      ${CYAN}→ Full guided setup with questionnaire${NC}"

    echo ""
    echo -e "  ${BLUE}[3]${NC} Start with minimal template"
    echo -e "      ${CYAN}→ I'll customize everything manually${NC}"

    echo ""
    echo -e "  ${BLUE}[4]${NC} Skip for now"
    echo -e "      ${CYAN}→ Exit without creating RULEBOOK${NC}"

    echo ""
}

# Generate RULEBOOK from detected context
generate_from_context() {
    print_section "🔨 Generating RULEBOOK from detected context"

    local rulebook_path=".claude/RULEBOOK.md"
    local project_name=$(basename "$(pwd)")

    # Read README.md if it exists for project description
    local readme_description=""
    if [ -f "README.md" ]; then
        # Extract first paragraph (skip title)
        readme_description=$(head -20 README.md | grep -v "^#" | grep -v "^$" | head -5 | tr '\n' ' ')
    fi

    # Create RULEBOOK
    cat > "$rulebook_path" << EOF
# RULEBOOK for $project_name

*Last Updated: $(date +%Y-%m-%d)*

## 📋 Project Overview

**Project Name:** $project_name
**Type:** $([ -n "$DETECTED_FRAMEWORK" ] && echo "$DETECTED_FRAMEWORK application" || echo "Software project")
**Primary Language:** $([ -n "$DETECTED_LANGUAGE" ] && echo "$DETECTED_LANGUAGE" || echo "Multiple/Unknown")

$(if [ -n "$readme_description" ]; then echo "**Description:** $readme_description"; fi)

## 🛠️ Tech Stack

### Core Technologies
$([ -n "$DETECTED_FRAMEWORK" ] && echo "- **Framework:** $DETECTED_FRAMEWORK" || echo "- **Framework:** Not detected")
$([ -n "$DETECTED_LANGUAGE" ] && echo "- **Language:** $DETECTED_LANGUAGE" || echo "- **Language:** Not detected")
$([ -n "$DETECTED_DATABASE" ] && echo "- **Database/ORM:** $DETECTED_DATABASE" || echo "")
$([ -n "$DETECTED_STYLING" ] && echo "- **Styling:** $DETECTED_STYLING" || echo "")
$([ -n "$DETECTED_TESTING" ] && echo "- **Testing:** $DETECTED_TESTING" || echo "")
$([ ${#DETECTED_TOOLS[@]} -gt 0 ] && echo "- **Tools:** ${DETECTED_TOOLS[*]}" || echo "")

### Detection Details
Files analyzed in current directory:
$(for result in "${SCAN_RESULTS[@]}"; do echo "- $result"; done)

## 📂 Project Structure

\`\`\`
$project_name/
$([ -f "package.json" ] && echo "├── package.json" || echo "")
$([ -f "tsconfig.json" ] && echo "├── tsconfig.json" || echo "")
$([ -d "src" ] && echo "├── src/" || echo "")
$([ -d "app" ] && echo "├── app/" || echo "")
$([ -d "pages" ] && echo "├── pages/" || echo "")
$([ -d "components" ] && echo "├── components/" || echo "")
└── .claude/
    ├── RULEBOOK.md (this file)
    └── agents-global/
\`\`\`

## 🤖 Active Agents

Based on your detected stack, the following agents are recommended:

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

### Stack-Specific Agents
$(generate_recommended_agents)

> **Note:** You can activate/deactivate agents using:
> - \`~/.claude-global/scripts/select-agents.sh\` - Interactive agent selector
> - \`~/.claude-global/scripts/test-agent.sh\` - Browse all 72 available agents

## 📝 Code Organization

### Naming Conventions
- Files: kebab-case (e.g., \`user-profile.tsx\`)
- Components: PascalCase (e.g., \`UserProfile\`)
- Functions: camelCase (e.g., \`getUserData\`)
- Constants: UPPER_SNAKE_CASE (e.g., \`MAX_RETRIES\`)

### File Structure
- Keep related files together
- Separate business logic from UI components
- Use index files for cleaner imports

## 🧪 Testing Strategy

- Write tests for critical business logic
- Aim for meaningful test coverage (not just 100%)
- Test user-facing features and edge cases
$([ -n "$DETECTED_TESTING" ] && echo "- Using: $DETECTED_TESTING" || echo "")

## 🔒 Security Guidelines

- Never commit secrets or API keys
- Validate all user inputs
- Use environment variables for configuration
- Follow OWASP security best practices
- Keep dependencies updated

## 🚀 Performance Targets

- Page load time: < 3 seconds
- Time to Interactive: < 5 seconds
- Lighthouse score: > 90
$([ "$DETECTED_FRAMEWORK" = "Next.js" ] && echo "- Core Web Vitals: Pass all metrics" || echo "")

## 📚 Additional Notes

This RULEBOOK was auto-generated by scanning your project.
Please customize it to match your specific requirements.

To update agents or configuration, run:
- \`scripts/select-agents.sh\` - Manage active agents
- \`scripts/validate-rulebook.sh\` - Validate this file
- Edit this file directly for custom rules

---
*Generated by Claude Code Agents Toolkit - RULEBOOK Wizard*
EOF

    print_success "RULEBOOK generated at: $rulebook_path"
}

# Generate recommended agents based on detected stack
generate_recommended_agents() {
    local agents=""

    # Framework-specific
    if [ "$DETECTED_FRAMEWORK" = "Next.js" ]; then
        agents+="- nextjs-specialist\n"
    elif [ "$DETECTED_FRAMEWORK" = "React" ]; then
        agents+="- react-specialist\n"
    elif [ "$DETECTED_FRAMEWORK" = "Vue" ]; then
        agents+="- vue-specialist\n"
    elif [ "$DETECTED_FRAMEWORK" = "Express" ]; then
        agents+="- express-specialist\n"
    elif [ "$DETECTED_FRAMEWORK" = "FastAPI" ]; then
        agents+="- fastapi-specialist\n"
    fi

    # Language-specific
    if [ "$DETECTED_LANGUAGE" = "TypeScript" ]; then
        agents+="- typescript-pro\n"
    elif [ "$DETECTED_LANGUAGE" = "Python" ]; then
        agents+="- python-specialist\n"
    elif [ "$DETECTED_LANGUAGE" = "Go" ]; then
        agents+="- go-specialist\n"
    elif [ "$DETECTED_LANGUAGE" = "Rust" ]; then
        agents+="- rust-specialist\n"
    fi

    # Database/ORM
    if [[ "$DETECTED_DATABASE" == *"Prisma"* ]]; then
        agents+="- prisma-orm-specialist\n"
    elif [[ "$DETECTED_DATABASE" == *"MongoDB"* ]]; then
        agents+="- mongodb-expert\n"
    fi

    # Styling
    if [[ "$DETECTED_STYLING" == *"Tailwind"* ]]; then
        agents+="- css-specialist\n"
    fi

    # Testing
    if [ "$DETECTED_TESTING" = "Vitest" ]; then
        agents+="- vitest-specialist\n"
    elif [ "$DETECTED_TESTING" = "Jest" ]; then
        agents+="- jest-testing-specialist\n"
    fi

    # Tools
    for tool in "${DETECTED_TOOLS[@]}"; do
        if [ "$tool" = "Docker" ]; then
            agents+="- docker-specialist\n"
        fi
    done

    echo -e "$agents"
}

# Launch interactive questionnaire
launch_questionnaire() {
    print_info "Launching interactive questionnaire..."

    # Try multiple locations
    local script_path=""

    if [ -f "$HOME/.claude-global/scripts/questionnaire.sh" ]; then
        script_path="$HOME/.claude-global/scripts/questionnaire.sh"
    elif [ -f "scripts/questionnaire.sh" ]; then
        script_path="scripts/questionnaire.sh"
    elif [ -f "../scripts/questionnaire.sh" ]; then
        script_path="../scripts/questionnaire.sh"
    else
        print_error "Questionnaire script not found"
        print_info "Searched locations:"
        echo "  - ~/.claude-global/scripts/questionnaire.sh"
        echo "  - scripts/questionnaire.sh"
        echo "  - ../scripts/questionnaire.sh"
        exit 1
    fi

    bash "$script_path"
}

# Create minimal template
create_minimal_template() {
    print_section "📄 Creating minimal RULEBOOK template"

    local rulebook_path=".claude/RULEBOOK.md"
    local project_name=$(basename "$(pwd)")

    cat > "$rulebook_path" << 'EOF'
# RULEBOOK for [Your Project Name]

*Last Updated: YYYY-MM-DD*

## 📋 Project Overview

**Project Name:** [Your Project Name]
**Type:** [Description]
**Primary Language:** [Language]

## 🛠️ Tech Stack

- **Framework:** [Framework]
- **Language:** [Language]
- **Database:** [Database]

## 🤖 Active Agents

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

### Add Your Stack-Specific Agents
[Add agents based on your tech stack]

> Run `scripts/select-agents.sh` to browse and activate agents

## 📝 Code Organization

[Customize based on your project]

## 🧪 Testing Strategy

[Customize based on your project]

## 🔒 Security Guidelines

- Never commit secrets or API keys
- Validate all user inputs
- Keep dependencies updated

---
*Customize this RULEBOOK to match your project's needs*
EOF

    print_success "Minimal RULEBOOK created at: $rulebook_path"
    print_warning "Please customize .claude/RULEBOOK.md for your project"
}

# Main wizard flow
main() {
    print_header

    # Ensure .claude directory exists
    if [ ! -d ".claude" ]; then
        print_error ".claude directory not found"
        print_info "Please run the installer first"
        exit 1
    fi

    # Check if RULEBOOK already exists
    if [ -f ".claude/RULEBOOK.md" ]; then
        echo ""
        print_warning "RULEBOOK.md already exists in .claude/"
        echo ""
        read -p "Overwrite existing RULEBOOK? (y/N): " -n 1 -r
        echo ""
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_info "Keeping existing RULEBOOK. Exiting wizard."
            exit 0
        fi

        # Backup existing RULEBOOK
        cp .claude/RULEBOOK.md ".claude/RULEBOOK.md.backup-$(date +%Y%m%d-%H%M%S)"
        print_success "Backed up existing RULEBOOK"
    fi

    # Scan project
    scan_project_context

    # Show options
    show_wizard_options

    # Get user choice
    read -p "Enter your choice [1-4]: " choice

    echo ""
    case $choice in
        1)
            generate_from_context
            ;;
        2)
            launch_questionnaire
            ;;
        3)
            create_minimal_template
            ;;
        4)
            print_info "Skipping RULEBOOK creation"
            print_warning "You can run this wizard later with: scripts/rulebook-wizard.sh"
            exit 0
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac

    echo ""
    print_success "RULEBOOK wizard complete!"
    echo ""
    print_info "Next steps:"
    echo "  ${BLUE}1.${NC} Review your RULEBOOK: .claude/RULEBOOK.md"
    echo "  ${BLUE}2.${NC} Customize as needed for your project"
    echo "  ${BLUE}3.${NC} Manage agents: scripts/select-agents.sh"
    echo "  ${BLUE}4.${NC} Validate RULEBOOK: scripts/validate-rulebook.sh"
    echo ""
}

# Run main
main "$@"
