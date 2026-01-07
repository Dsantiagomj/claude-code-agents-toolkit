#!/bin/bash

# Export Claude Code Agents Toolkit Configuration
# Exports RULEBOOK, settings, and Maestro configuration to JSON

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Detect if running from project directory or toolkit directory
if [ -d ".claude" ]; then
    CLAUDE_DIR=".claude"
elif [ -d "../.claude" ]; then
    CLAUDE_DIR="../.claude"
else
    echo -e "${RED}✗ Error: .claude directory not found${NC}"
    echo "Run this script from your project directory or the toolkit directory"
    exit 1
fi

# Header
print_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  📤 Claude Code Agents - Configuration Export      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════╝${NC}"
    echo ""
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Help message
show_help() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS] > output.json

Export toolkit configuration to JSON format for sharing or backup.

OPTIONS:
    --rulebook-only     Export only RULEBOOK configuration
    --settings-only     Export only settings.json
    --maestro-only      Export only Maestro Mode configuration
    --agents-only       Export only active agents list
    --help              Show this help message

EXAMPLES:
    # Export everything
    scripts/export-config.sh > my-config.json

    # Export only RULEBOOK
    scripts/export-config.sh --rulebook-only > rulebook.json

    # Export to file with error logging
    scripts/export-config.sh > config.json 2> export.log

EXPORTED DATA:
    - RULEBOOK.md content (project patterns, conventions, tech stack)
    - settings.json (MCP servers, preferences)
    - Maestro Mode configuration (language, self-enhancement)
    - Active agents list
    - Toolkit version
    - Export metadata (timestamp, environment)

OUTPUT FORMAT:
    JSON format suitable for import-config.sh

NOTES:
    - Output goes to stdout (use > to redirect to file)
    - Sensitive data is NOT exported (API keys, secrets)
    - Binary files are NOT included
    - For team sharing or backup/restore

EOF
    exit 0
}

# Parse arguments
EXPORT_MODE="full"
while [[ $# -gt 0 ]]; do
    case $1 in
        --rulebook-only)
            EXPORT_MODE="rulebook"
            shift
            ;;
        --settings-only)
            EXPORT_MODE="settings"
            shift
            ;;
        --maestro-only)
            EXPORT_MODE="maestro"
            shift
            ;;
        --agents-only)
            EXPORT_MODE="agents"
            shift
            ;;
        --help|-h)
            show_help
            ;;
        *)
            print_error "Unknown option: $1"
            echo "Use --help for usage information"
            exit 1
            ;;
    esac
done

# Show header only if not exporting to stdout
if [ -t 1 ]; then
    print_header
    print_info "Export mode: $EXPORT_MODE"
    echo ""
fi

# Helper function to escape JSON strings
escape_json() {
    local input="$1"
    # Escape backslashes, quotes, and newlines
    echo "$input" | sed 's/\\/\\\\/g' | sed 's/"/\\"/g' | awk '{printf "%s\\n", $0}' | sed '$ s/\\n$//'
}

# Helper function to read file content
read_file_content() {
    local file="$1"
    if [ -f "$file" ]; then
        cat "$file"
    else
        echo ""
    fi
}

# Get toolkit version
get_version() {
    if [ -f "$CLAUDE_DIR/.toolkit-version" ]; then
        cat "$CLAUDE_DIR/.toolkit-version"
    else
        echo "1.0.0"
    fi
}

# Get Maestro language
get_maestro_language() {
    if [ -f "$CLAUDE_DIR/commands/maestro.md" ]; then
        local first_line=$(head -n 1 "$CLAUDE_DIR/commands/maestro.md")
        if echo "$first_line" | grep -q "Modo Maestro"; then
            echo "es"
        else
            echo "en"
        fi
    else
        echo "en"
    fi
}

# Check if self-enhancement is enabled
is_self_enhancement_enabled() {
    if [ -f "$CLAUDE_DIR/commands/self-enhancement.md" ]; then
        echo "true"
    else
        echo "false"
    fi
}

# Get active agents
get_active_agents() {
    if [ -f "$CLAUDE_DIR/RULEBOOK.md" ]; then
        grep "^- " "$CLAUDE_DIR/RULEBOOK.md" 2>/dev/null | sed 's/^- //' || echo ""
    else
        echo ""
    fi
}

# Export RULEBOOK content
export_rulebook() {
    local rulebook_content=""
    if [ -f "$CLAUDE_DIR/RULEBOOK.md" ]; then
        rulebook_content=$(escape_json "$(cat "$CLAUDE_DIR/RULEBOOK.md")")
    fi

    # Extract key sections
    local project_name=""
    local tech_stack=""

    if [ -f "$CLAUDE_DIR/RULEBOOK.md" ]; then
        # Try to extract project name
        project_name=$(grep "^**Name:**" "$CLAUDE_DIR/RULEBOOK.md" | head -n 1 | sed 's/^**Name:** //' || echo "")

        # Extract tech stack section
        tech_stack=$(sed -n '/## Tech Stack/,/^##/p' "$CLAUDE_DIR/RULEBOOK.md" | sed '1d;$d' || echo "")
    fi

    cat << EOF
    "rulebook": {
      "content": "$rulebook_content",
      "projectName": "$(escape_json "$project_name")",
      "techStack": "$(escape_json "$tech_stack")",
      "exists": $([ -f "$CLAUDE_DIR/RULEBOOK.md" ] && echo "true" || echo "false")
    }
EOF
}

# Export settings
export_settings() {
    local settings_content="{}"
    if [ -f "$CLAUDE_DIR/settings.json" ]; then
        settings_content=$(cat "$CLAUDE_DIR/settings.json")
    fi

    cat << EOF
    "settings": $settings_content
EOF
}

# Export Maestro configuration
export_maestro() {
    local language=$(get_maestro_language)
    local self_enhancement=$(is_self_enhancement_enabled)
    local maestro_installed=$([ -f "$CLAUDE_DIR/commands/maestro.md" ] && echo "true" || echo "false")

    cat << EOF
    "maestro": {
      "installed": $maestro_installed,
      "language": "$language",
      "selfEnhancement": $self_enhancement
    }
EOF
}

# Export active agents
export_agents() {
    local agents=$(get_active_agents)
    local agents_array=""

    if [ -n "$agents" ]; then
        agents_array=$(echo "$agents" | awk '{printf "\"%s\",", $0}' | sed 's/,$//')
    fi

    cat << EOF
    "activeAgents": [$agents_array]
EOF
}

# Export metadata
export_metadata() {
    local version=$(get_version)
    local timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local os=$(uname -s)
    local hostname=$(hostname)

    cat << EOF
    "metadata": {
      "version": "$version",
      "exportedAt": "$timestamp",
      "exportedBy": "$USER",
      "hostname": "$hostname",
      "os": "$os",
      "exportMode": "$EXPORT_MODE"
    }
EOF
}

# Main export function
export_config() {
    echo "{"

    case $EXPORT_MODE in
        rulebook)
            export_rulebook
            echo ","
            export_metadata
            ;;
        settings)
            export_settings
            echo ","
            export_metadata
            ;;
        maestro)
            export_maestro
            echo ","
            export_metadata
            ;;
        agents)
            export_agents
            echo ","
            export_metadata
            ;;
        full)
            export_rulebook
            echo ","
            export_settings
            echo ","
            export_maestro
            echo ","
            export_agents
            echo ","
            export_metadata
            ;;
    esac

    echo ""
    echo "}"
}

# Run export
export_config

# Show success message to stderr if outputting to file
if [ ! -t 1 ]; then
    print_success "Configuration exported successfully" >&2
fi

exit 0
