#!/bin/bash

# RULEBOOK Interactive Questionnaire
# Guides users through setting up their RULEBOOK step by step

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

# Storage for answers
PROJECT_TYPE=""
FRAMEWORK=""
LANGUAGE=""
DATABASE=""
STYLING=""
TESTING=""
INFRASTRUCTURE=""
ADDITIONAL_TOOLS=()

print_header() {
    echo ""
    echo -e "${MAGENTA}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${MAGENTA}║${NC}  📝 Interactive RULEBOOK Questionnaire          ${MAGENTA}║${NC}"
    echo -e "${MAGENTA}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_question() {
    echo ""
    echo -e "${CYAN}❓ $1${NC}"
    echo ""
}

print_options() {
    local i=1
    for option in "$@"; do
        echo -e "  ${BLUE}[$i]${NC} $option"
        ((i++))
    done
    echo ""
}

ask_choice() {
    local prompt="$1"
    shift
    local options=("$@")
    local choice
    
    while true; do
        read -p "$(echo -e ${GREEN}$prompt${NC}): " choice
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 1 ] && [ "$choice" -le "${#options[@]}" ]; then
            echo "${options[$((choice-1))]}"
            return
        else
            echo -e "${RED}Invalid choice. Please enter a number between 1 and ${#options[@]}${NC}"
        fi
    done
}

print_header

# Question 1: Project Type
print_question "What type of project are you working on?"
print_options "Web Application (Frontend + Backend)" "Frontend Only" "Backend API" "Mobile App" "CLI Tool" "Library/Package" "Other"
PROJECT_TYPE=$(ask_choice "Enter your choice [1-7]" \
    "fullstack" "frontend" "backend" "mobile" "cli" "library" "other")

# Question 2: Framework (conditional)
if [[ "$PROJECT_TYPE" == "frontend" || "$PROJECT_TYPE" == "fullstack" ]]; then
    print_question "What frontend framework/library are you using?"
    print_options "React" "Next.js" "Vue.js" "Nuxt.js" "Angular" "Svelte" "SvelteKit" "Solid.js" "Astro" "None/Vanilla JS"
    FRAMEWORK=$(ask_choice "Enter your choice [1-10]" \
        "React" "Next.js" "Vue.js" "Nuxt.js" "Angular" "Svelte" "SvelteKit" "Solid.js" "Astro" "Vanilla")
fi

if [[ "$PROJECT_TYPE" == "backend" || "$PROJECT_TYPE" == "fullstack" ]]; then
    if [ -z "$FRAMEWORK" ]; then
        print_question "What backend framework are you using?"
        print_options "Express.js" "NestJS" "Fastify" "Koa" "Django" "Flask" "FastAPI" "Spring Boot" "ASP.NET" "Ruby on Rails" "None"
        FRAMEWORK=$(ask_choice "Enter your choice [1-11]" \
            "Express.js" "NestJS" "Fastify" "Koa" "Django" "Flask" "FastAPI" "Spring Boot" "ASP.NET" "Rails" "None")
    fi
fi

# Question 3: Programming Language
print_question "What is your primary programming language?"
print_options "TypeScript" "JavaScript" "Python" "Java" "C#" "Go" "Rust" "PHP" "Ruby" "Other"
LANGUAGE=$(ask_choice "Enter your choice [1-10]" \
    "TypeScript" "JavaScript" "Python" "Java" "C#" "Go" "Rust" "PHP" "Ruby" "Other")

# Question 4: Database
print_question "What database are you using?"
print_options "PostgreSQL" "MySQL" "MongoDB" "Redis" "SQLite" "SQL Server" "None" "Multiple/Other"
DATABASE=$(ask_choice "Enter your choice [1-8]" \
    "PostgreSQL" "MySQL" "MongoDB" "Redis" "SQLite" "SQL Server" "None" "Multiple")

# Question 5: Styling
if [[ "$PROJECT_TYPE" == "frontend" || "$PROJECT_TYPE" == "fullstack" ]]; then
    print_question "What styling approach are you using?"
    print_options "Tailwind CSS" "CSS Modules" "Styled Components" "Emotion" "SASS/SCSS" "Plain CSS" "Other"
    STYLING=$(ask_choice "Enter your choice [1-7]" \
        "Tailwind CSS" "CSS Modules" "Styled Components" "Emotion" "SASS/SCSS" "CSS" "Other")
fi

# Question 6: Testing
print_question "What testing framework are you using?"
print_options "Jest" "Vitest" "Playwright" "Cypress" "Testing Library" "Mocha/Chai" "pytest" "JUnit" "None yet"
TESTING=$(ask_choice "Enter your choice [1-9]" \
    "Jest" "Vitest" "Playwright" "Cypress" "Testing Library" "Mocha" "pytest" "JUnit" "None")

# Question 7: Infrastructure/Deployment
print_question "Where are you deploying or planning to deploy?"
print_options "Vercel" "AWS" "Google Cloud" "Azure" "Docker/Kubernetes" "Cloudflare" "Netlify" "Not decided yet"
INFRASTRUCTURE=$(ask_choice "Enter your choice [1-8]" \
    "Vercel" "AWS" "GCP" "Azure" "Docker/K8s" "Cloudflare" "Netlify" "TBD")

# Generate RULEBOOK
echo ""
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${GREEN}✨ Generating your RULEBOOK...${NC}"
echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""

cat > RULEBOOK.md << RULEBOOK_END
# RULEBOOK - Project Configuration

> Auto-generated by Claude Code Agents Toolkit - Interactive Questionnaire

## Project Overview

**Type**: $PROJECT_TYPE
**Framework**: ${FRAMEWORK:-Not specified}
**Language**: ${LANGUAGE:-Not specified}
**Database**: ${DATABASE:-Not specified}
**Styling**: ${STYLING:-Not specified}
**Testing**: ${TESTING:-Not specified}
**Infrastructure**: ${INFRASTRUCTURE:-Not specified}

## Code Standards

### General Guidelines
- Write clean, maintainable, and well-documented code
- Follow language-specific best practices for $LANGUAGE
- Use meaningful variable and function names
- Keep functions small and focused on a single responsibility

### Formatting
- Use consistent indentation (2 or 4 spaces)
- Follow team coding conventions
- Use linting and formatting tools

## Tech Stack Agents

Based on your answers, consider activating these specialized agents:

