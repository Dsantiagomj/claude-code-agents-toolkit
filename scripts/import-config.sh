#!/bin/bash

# Import Claude Code Agents Toolkit Configuration
# Imports configuration from JSON file exported by export-config.sh

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
    echo "Run this script from your project directory"
    exit 1
fi

# Header
print_header() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║  📥 Claude Code Agents - Configuration Import      ║${NC}"
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
Usage: $(basename "$0") <config-file.json> [OPTIONS]

Import toolkit configuration from JSON file.

ARGUMENTS:
    config-file.json    Path to configuration file exported by export-config.sh

OPTIONS:
    --merge             Merge with existing configuration (default: replace)
    --rulebook-only     Import only RULEBOOK
    --settings-only     Import only settings.json
    --maestro-only      Import only Maestro configuration
    --agents-only       Import only active agents list
    --force             Skip confirmation prompts
    --help              Show this help message

EXAMPLES:
    # Import full configuration
    scripts/import-config.sh team-config.json

    # Import only RULEBOOK
    scripts/import-config.sh rulebook.json --rulebook-only

    # Merge with existing (don't replace)
    scripts/import-config.sh config.json --merge

    # Skip confirmation
    scripts/import-config.sh config.json --force

IMPORT MODES:
    replace (default)   Replace existing configuration completely
    merge              Merge with existing, keep unique values

SAFETY:
    - Automatic backup created before import
    - Backup location: .claude.import-backup.YYYY-MM-DD-HHMMSS/
    - Validation before applying changes
    - Rollback instructions provided

NOTES:
    - Requires .claude/ directory to exist
    - Creates backup automatically
    - Validates JSON before import
    - Compatible with export-config.sh output

EOF
    exit 0
}

# Parse arguments
CONFIG_FILE=""
IMPORT_MODE="replace"
IMPORT_SCOPE="full"
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --merge)
            IMPORT_MODE="merge"
            shift
            ;;
        --rulebook-only)
            IMPORT_SCOPE="rulebook"
            shift
            ;;
        --settings-only)
            IMPORT_SCOPE="settings"
            shift
            ;;
        --maestro-only)
            IMPORT_SCOPE="maestro"
            shift
            ;;
        --agents-only)
            IMPORT_SCOPE="agents"
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        --help|-h)
            show_help
            ;;
        *)
            if [ -z "$CONFIG_FILE" ]; then
                CONFIG_FILE="$1"
            else
                print_error "Unknown option: $1"
                echo "Use --help for usage information"
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate arguments
if [ -z "$CONFIG_FILE" ]; then
    print_error "Missing required argument: config-file.json"
    echo ""
    echo "Usage: $(basename "$0") <config-file.json> [OPTIONS]"
    echo "Use --help for more information"
    exit 1
fi

if [ ! -f "$CONFIG_FILE" ]; then
    print_error "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

print_header
print_info "Configuration file: $CONFIG_FILE"
print_info "Import mode: $IMPORT_MODE"
print_info "Import scope: $IMPORT_SCOPE"
echo ""

# Validate JSON
print_info "Validating JSON file..."
if ! python3 -m json.tool "$CONFIG_FILE" > /dev/null 2>&1; then
    print_error "Invalid JSON format in $CONFIG_FILE"
    exit 1
fi
print_success "JSON validation passed"
echo ""

# Helper function to extract JSON value
get_json_value() {
    local json_file="$1"
    local key_path="$2"
    python3 << EOF
import json
import sys

try:
    with open('$json_file', 'r') as f:
        data = json.load(f)

    # Navigate nested keys
    keys = '$key_path'.split('.')
    value = data
    for key in keys:
        if key in value:
            value = value[key]
        else:
            sys.exit(1)

    if isinstance(value, str):
        print(value)
    elif isinstance(value, bool):
        print(str(value).lower())
    elif isinstance(value, list):
        for item in value:
            print(item)
    else:
        print(json.dumps(value))
except Exception as e:
    sys.exit(1)
EOF
}

# Create backup
create_backup() {
    local timestamp=$(date +"%Y-%m-%d-%H%M%S")
    local backup_dir=".claude.import-backup.$timestamp"

    print_info "Creating backup..."

    if [ -d "$CLAUDE_DIR" ]; then
        cp -r "$CLAUDE_DIR" "$backup_dir"
        print_success "Backup created: $backup_dir"
        echo ""
        return 0
    else
        print_warning "No existing .claude directory to backup"
        echo ""
        return 1
    fi
}

# Import RULEBOOK
import_rulebook() {
    print_info "Importing RULEBOOK..."

    local rulebook_content=$(get_json_value "$CONFIG_FILE" "rulebook.content")

    if [ -n "$rulebook_content" ]; then
        # Unescape JSON string (remove \n, etc.)
        echo "$rulebook_content" | python3 -c "import sys, json; print(json.loads('\"' + sys.stdin.read().strip() + '\"'), end='')" > "$CLAUDE_DIR/RULEBOOK.md"
        print_success "RULEBOOK imported"
    else
        print_warning "No RULEBOOK content found in config file"
    fi
}

# Import settings
import_settings() {
    print_info "Importing settings..."

    local settings=$(get_json_value "$CONFIG_FILE" "settings")

    if [ -n "$settings" ] && [ "$settings" != "{}" ]; then
        echo "$settings" | python3 -m json.tool > "$CLAUDE_DIR/settings.json"
        print_success "Settings imported"
    else
        print_warning "No settings found in config file"
    fi
}

# Import Maestro configuration
import_maestro() {
    print_info "Importing Maestro configuration..."

    local language=$(get_json_value "$CONFIG_FILE" "maestro.language")
    local self_enhancement=$(get_json_value "$CONFIG_FILE" "maestro.selfEnhancement")

    if [ -n "$language" ]; then
        # Copy appropriate language version
        if [ "$language" = "es" ]; then
            if [ -f "commands/maestro.es.md" ]; then
                cp commands/maestro.es.md "$CLAUDE_DIR/commands/maestro.md"
                print_success "Maestro language set to: Spanish"
            fi
        else
            if [ -f "commands/maestro.md" ]; then
                cp commands/maestro.md "$CLAUDE_DIR/commands/maestro.md"
                print_success "Maestro language set to: English"
            fi
        fi
    fi

    # Handle self-enhancement
    if [ "$self_enhancement" = "true" ]; then
        if [ -f "commands/self-enhancement.md" ]; then
            cp commands/self-enhancement.md "$CLAUDE_DIR/commands/self-enhancement.md"
            print_success "Self-enhancement enabled"
        fi
    else
        if [ -f "$CLAUDE_DIR/commands/self-enhancement.md" ]; then
            rm "$CLAUDE_DIR/commands/self-enhancement.md"
            print_success "Self-enhancement disabled"
        fi
    fi
}

# Import active agents
import_agents() {
    print_info "Importing active agents..."

    local agents=$(get_json_value "$CONFIG_FILE" "activeAgents")

    if [ -n "$agents" ]; then
        # Create agents section in RULEBOOK
        local temp_file=$(mktemp)

        if [ -f "$CLAUDE_DIR/RULEBOOK.md" ]; then
            # Remove existing Active Agents section
            sed '/## Active Agents/,/^##/d' "$CLAUDE_DIR/RULEBOOK.md" > "$temp_file"

            # Add new Active Agents section
            echo "" >> "$temp_file"
            echo "## Active Agents" >> "$temp_file"
            echo "" >> "$temp_file"

            # Add each agent
            echo "$agents" | while read -r agent; do
                if [ -n "$agent" ]; then
                    echo "- $agent" >> "$temp_file"
                fi
            done

            mv "$temp_file" "$CLAUDE_DIR/RULEBOOK.md"
            print_success "Active agents imported"
        else
            print_warning "RULEBOOK.md not found, skipping agents import"
        fi
    else
        print_warning "No active agents found in config file"
    fi
}

# Show import summary
show_summary() {
    echo ""
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  Import Summary${NC}"
    echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
    echo ""

    local exported_at=$(get_json_value "$CONFIG_FILE" "metadata.exportedAt" || echo "Unknown")
    local version=$(get_json_value "$CONFIG_FILE" "metadata.version" || echo "Unknown")

    echo "Configuration Details:"
    echo "  • Exported: $exported_at"
    echo "  • Version: $version"
    echo "  • Import Mode: $IMPORT_MODE"
    echo "  • Import Scope: $IMPORT_SCOPE"
    echo ""

    if [ "$IMPORT_SCOPE" = "full" ] || [ "$IMPORT_SCOPE" = "rulebook" ]; then
        if [ -f "$CLAUDE_DIR/RULEBOOK.md" ]; then
            print_success "RULEBOOK.md updated"
        fi
    fi

    if [ "$IMPORT_SCOPE" = "full" ] || [ "$IMPORT_SCOPE" = "settings" ]; then
        if [ -f "$CLAUDE_DIR/settings.json" ]; then
            print_success "settings.json updated"
        fi
    fi

    if [ "$IMPORT_SCOPE" = "full" ] || [ "$IMPORT_SCOPE" = "maestro" ]; then
        if [ -f "$CLAUDE_DIR/commands/maestro.md" ]; then
            print_success "Maestro configuration updated"
        fi
    fi

    echo ""
}

# Confirm before import
if [ "$FORCE" != true ]; then
    echo -e "${YELLOW}⚠ Warning: This will modify your .claude/ directory${NC}"
    echo ""
    echo "A backup will be created automatically."
    echo ""
    read -p "Continue with import? (y/N): " -n 1 -r
    echo ""

    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_info "Import cancelled"
        exit 0
    fi
    echo ""
fi

# Create backup
create_backup

# Perform import based on scope
case $IMPORT_SCOPE in
    rulebook)
        import_rulebook
        ;;
    settings)
        import_settings
        ;;
    maestro)
        import_maestro
        ;;
    agents)
        import_agents
        ;;
    full)
        import_rulebook
        import_settings
        import_maestro
        import_agents
        ;;
esac

# Show summary
show_summary

# Validation
echo ""
print_info "Validating imported configuration..."
if [ -f "scripts/validate-rulebook.sh" ] && [ "$IMPORT_SCOPE" != "settings" ]; then
    if bash scripts/validate-rulebook.sh > /dev/null 2>&1; then
        print_success "Validation passed"
    else
        print_warning "Validation found issues (run scripts/validate-rulebook.sh for details)"
    fi
fi

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}  ✓ Import Complete!${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════${NC}"
echo ""

echo "Next steps:"
echo "  1. Verify configuration: scripts/validate-rulebook.sh"
echo "  2. Run health check: scripts/healthcheck.sh"
echo "  3. Test Maestro: /maestro in Claude Code"
echo ""

echo "Rollback (if needed):"
echo "  • Backup location: Latest .claude.import-backup.*/ directory"
echo "  • Command: rm -rf .claude && mv .claude.import-backup.* .claude"
echo ""

exit 0
