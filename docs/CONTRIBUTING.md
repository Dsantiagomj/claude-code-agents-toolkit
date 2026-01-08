# Contributing to Claude Code Agents Toolkit

Thank you for your interest in contributing to the Claude Code Agents Toolkit! This guide will help you get started.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [Project Structure](#project-structure)
- [Contributing Guidelines](#contributing-guidelines)
- [Pull Request Process](#pull-request-process)
- [Coding Standards](#coding-standards)
- [Testing](#testing)
- [Documentation](#documentation)
- [Release Process](#release-process)

---

## Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors, regardless of experience level, background, or identity.

### Expected Behavior

- Be respectful and professional
- Provide constructive feedback
- Focus on what is best for the community
- Show empathy towards other community members

### Unacceptable Behavior

- Harassment, trolling, or derogatory comments
- Personal or political attacks
- Public or private harassment
- Publishing others' private information

---

## Getting Started

### Prerequisites

- **Bash** 3.2+ (macOS, Linux, WSL on Windows)
- **Git** 2.x+
- **Claude Code CLI** (for testing)
- **GitHub Account** (for PRs)

### Fork & Clone

```bash
# 1. Fork the repository on GitHub

# 2. Clone your fork
git clone https://github.com/YOUR-USERNAME/claude-code-agents-toolkit.git
cd claude-code-agents-toolkit

# 3. Add upstream remote
git remote add upstream https://github.com/Dsantiagomj/claude-code-agents-toolkit.git

# 4. Verify remotes
git remote -v
```

---

## Development Setup

### Local Installation for Development

```bash
# 1. Install from your local repository
./install.sh

# 2. Or use the development installation
export CLAUDE_DEV_MODE=1
./scripts/dev-install.sh  # If available
```

### Testing Your Changes

```bash
# Test in a sample project
cd ~/test-project
~/.claude-global/scripts/init-project.sh

# Test specific scripts
~/.claude-global/scripts/test-agent.sh --list
~/.claude-global/scripts/agent-stats.sh --summary
~/.claude-global/scripts/healthcheck.sh
```

---

## Project Structure

```
claude-code-agents-toolkit/
├── commands/                 # Workflow mode definitions
│   ├── maestro.md           # English Maestro mode
│   ├── maestro.es.md        # Spanish Maestro mode
│   ├── coordinator.md       # Coordinator mode
│   ├── agent-router.md      # Routing logic
│   ├── agent-routing-rules.json  # Routing tables
│   └── ...
├── agents/                  # 72 specialized agents
│   ├── core/               # 10 core agents
│   └── specialized/        # 62 stack-specific agents
├── scripts/                # Management scripts
│   ├── lib/                # Shared library
│   │   ├── common.sh       # Common functions
│   │   └── README.md       # Library docs
│   ├── init-project.sh     # Project initialization
│   ├── select-agents.sh    # Agent management
│   └── ...
├── docs/                   # Documentation
│   ├── ARCHITECTURE.md     # Architecture guide
│   ├── CONTRIBUTING.md     # This file
│   ├── FAQ.md              # FAQ
│   └── TROUBLESHOOTING.md  # Troubleshooting
├── templates/              # Project templates
│   ├── projects/           # Stack-specific templates
│   └── RULEBOOK_TEMPLATE.md
├── install.sh              # Global installation script
└── README.md               # Main README
```

---

## Contributing Guidelines

### Types of Contributions

We welcome:

1. **Bug Fixes** - Fix broken functionality
2. **New Agents** - Add specialized agents for new stacks
3. **Documentation** - Improve guides, examples, FAQs
4. **Scripts** - Enhance management scripts
5. **Translations** - Add language support
6. **Templates** - Add project templates for new stacks
7. **Tests** - Add test coverage
8. **Performance** - Optimize existing code

### What We're Looking For

**High Priority:**
- Bug fixes with clear reproduction steps
- New agents for popular frameworks/tools
- Documentation improvements
- Performance optimizations
- Better error messages

**Medium Priority:**
- New language translations
- Additional project templates
- Script enhancements
- Test coverage improvements

**Low Priority:**
- Code style changes (use existing patterns)
- Minor refactoring without clear benefit

---

## Pull Request Process

### Before You Start

1. **Check existing issues** - Avoid duplicate work
2. **Open an issue first** - Discuss major changes
3. **One feature per PR** - Keep PRs focused
4. **Follow conventions** - Match existing code style

### Creating a Pull Request

```bash
# 1. Create a feature branch
git checkout -b feature/your-feature-name

# 2. Make your changes
# ... edit files ...

# 3. Test your changes
./scripts/healthcheck.sh
./scripts/test-agent.sh --list

# 4. Commit with conventional format
git commit -m "feat: add NextJS 15 agent

- Add agent definition for Next.js 15
- Include App Router patterns
- Add server component examples

Co-Authored-By: Your Name <your.email@example.com>"

# 5. Push to your fork
git push origin feature/your-feature-name

# 6. Create PR on GitHub
# Go to: https://github.com/Dsantiagomj/claude-code-agents-toolkit/pulls
```

### PR Title Format

Use [Conventional Commits](https://www.conventionalcommits.org/):

```
feat: add new agent for X
fix: correct routing logic in Y
docs: update installation guide
refactor: optimize script Z
test: add tests for feature A
chore: update dependencies
```

### PR Description Template

```markdown
## Description
Brief description of what this PR does.

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to change)
- [ ] Documentation update

## How Has This Been Tested?
Describe the tests you ran and how to reproduce.

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have tested my changes
- [ ] I have updated documentation (if needed)
- [ ] My commits follow conventional commit format
- [ ] I have added Co-Authored-By in my commits
```

---

## Coding Standards

### Bash Scripts

**Style Guide:**

```bash
#!/bin/bash
# Script description
# Compatible with bash 3.2+

set -e  # Exit on error

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

# Use existing functions from common.sh
print_success "Operation complete"
print_error "Something failed"

# Function naming: lowercase with underscores
check_something() {
    local param="$1"

    if [ -z "$param" ]; then
        print_error "Parameter required"
        return 1
    fi

    # Do something
    print_success "Check passed"
}

# Main function
main() {
    check_something "$1"
}

main "$@"
```

**Best Practices:**
- ✅ Use `common.sh` for shared functions
- ✅ Add error handling (`set -e`, check return codes)
- ✅ Use meaningful variable names
- ✅ Add comments for complex logic
- ✅ Test on bash 3.2+ (macOS default)
- ❌ Don't use bash 4+ features (not macOS compatible)
- ❌ Don't hardcode paths (use constants)

### Markdown Files (Agents, Commands)

**Structure:**

```markdown
# Agent/Command Name

> Brief description

## Core Identity / Purpose
Who/what this is

## Capabilities / Features
What it can do

## When to Use
Scenarios where this helps

## Best Practices
Guidelines for using this

## Examples
Concrete usage examples
```

**Style:**
- Use clear, concise language
- Include code examples where relevant
- Use bullet points for lists
- Use `##` for main sections
- Use `###` for subsections

### JSON Files

**Format:**

```json
{
  "key": "value",
  "nested": {
    "item": "value"
  },
  "array": [
    "item1",
    "item2"
  ]
}
```

**Validation:**
```bash
# Validate JSON syntax
python3 -m json.tool file.json > /dev/null
# or
jq . file.json > /dev/null
```

---

## Testing

### Manual Testing

**Test Checklist:**

```bash
# 1. Installation
./install.sh
# Verify: ~/.claude-global/ created with correct structure

# 2. Project initialization
cd ~/test-project
~/.claude-global/scripts/init-project.sh
# Verify: .claude/ created with symlinks

# 3. Health check
~/.claude-global/scripts/healthcheck.sh
# Verify: All checks pass

# 4. Agent management
~/.claude-global/scripts/select-agents.sh
# Verify: Interactive menu works

# 5. Agent stats
~/.claude-global/scripts/agent-stats.sh --summary
# Verify: Statistics display correctly

# 6. Update process
~/.claude-global/scripts/update.sh --check
# Verify: Version check works
```

### Testing New Agents

```bash
# 1. Add agent file to agents/ directory
# agents/specialized/your-agent.md

# 2. Test agent appears in list
~/.claude-global/scripts/test-agent.sh --list | grep your-agent

# 3. Test agent info
~/.claude-global/scripts/test-agent.sh --info your-agent

# 4. Test agent in category
~/.claude-global/scripts/test-agent.sh --category specialized

# 5. Activate and test in Claude Code
# Use /maestro or /coordinator and reference the agent
```

### Testing Script Changes

```bash
# 1. Syntax check
bash -n script.sh

# 2. ShellCheck (if available)
shellcheck script.sh

# 3. Run with test data
./script.sh --test-mode  # If supported

# 4. Test error handling
./script.sh --invalid-option
# Verify: Shows error and help message
```

---

## Documentation

### When to Update Documentation

**Required:**
- Adding new features
- Changing existing behavior
- Adding new agents
- Modifying installation process

**Recommended:**
- Fixing bugs (add to troubleshooting)
- Improving error messages
- Adding examples

### Documentation Files to Update

| Change Type | Files to Update |
|-------------|----------------|
| New agent | agents/README.md, templates/AGENT_SELECTION_GUIDE.md |
| New script | scripts/lib/README.md (if using common.sh) |
| Architecture change | docs/ARCHITECTURE.md |
| Installation change | README.md, install.sh comments |
| New workflow mode | commands/workflow-modes.md, commands/workflow-examples.md |

### Writing Good Documentation

**Do:**
- ✅ Use clear, simple language
- ✅ Include code examples
- ✅ Add screenshots/diagrams if helpful
- ✅ Keep it up to date
- ✅ Test examples before documenting

**Don't:**
- ❌ Use jargon without explanation
- ❌ Write wall of text (use headings, lists)
- ❌ Assume prior knowledge
- ❌ Leave broken examples

---

## Release Process

### Version Numbering

We use [Semantic Versioning](https://semver.org/):

```
MAJOR.MINOR.PATCH

MAJOR: Breaking changes
MINOR: New features (backward compatible)
PATCH: Bug fixes (backward compatible)

Example: 1.3.2
```

### Creating a Release

**For Maintainers:**

```bash
# 1. Update version
echo "1.4.0" > .toolkit-version
git add .toolkit-version
git commit -m "chore: bump version to 1.4.0"

# 2. Create tag
git tag -a v1.4.0 -m "Release v1.4.0

Changes:
- Feature 1
- Feature 2
- Bug fix 3

Co-Authored-By: Maintainer <email>"

# 3. Push tag
git push origin v1.4.0

# 4. Create GitHub release
# Go to: https://github.com/Dsantiagomj/claude-code-agents-toolkit/releases/new
# - Tag: v1.4.0
# - Title: v1.4.0 - Brief description
# - Body: Detailed changelog
```

### Changelog Format

```markdown
## [1.4.0] - 2026-01-15

### Added
- New agent for Next.js 15
- Spanish translation for coordinator mode

### Changed
- Improved routing logic performance
- Updated installation script

### Fixed
- Fixed bug in agent-stats.sh
- Corrected RULEBOOK generation for monorepos

### Removed
- Deprecated old routing system
```

---

## Areas Needing Contributions

### High Priority

1. **Agent Coverage**
   - Missing: Deno, Bun, Tauri agents
   - Needed: More database specialists (Supabase, PlanetScale)
   - Wanted: CI/CD platform agents (CircleCI, Travis, etc.)

2. **Documentation**
   - Video tutorials
   - More workflow examples
   - Translation to other languages

3. **Testing**
   - Automated tests for scripts
   - Agent validation tests
   - Installation tests

### Medium Priority

4. **Templates**
   - More project templates
   - Monorepo template
   - Micro-frontend template

5. **Scripts**
   - Better error messages
   - Progress indicators
   - Interactive wizards

### Future Ideas

6. **Advanced Features**
   - Agent versioning system
   - Agent marketplace
   - Performance metrics
   - Usage analytics (opt-in)

---

## Getting Help

### Where to Ask Questions

- **GitHub Issues** - Bug reports, feature requests
- **GitHub Discussions** - General questions, ideas
- **Pull Request Comments** - Code-specific questions

### Response Time

- Issues: Within 48 hours
- PRs: Within 72 hours
- Questions: Best effort (community-driven)

---

## Recognition

### Contributors

All contributors will be:
- Listed in CONTRIBUTORS.md
- Mentioned in release notes
- Added to Co-Authored-By in relevant commits

### Top Contributors

Special recognition for:
- 10+ merged PRs
- Major feature contributions
- Consistent code reviews
- Documentation improvements

---

## License

By contributing, you agree that your contributions will be licensed under the same license as the project (see LICENSE file).

---

## Thank You!

Your contributions make this project better for everyone. Whether it's a bug fix, new feature, or documentation improvement, we appreciate your time and effort.

**Happy Contributing!** 🚀

---

**Questions?** Open an issue or start a discussion on GitHub.

**Found a Bug?** Please report it with detailed steps to reproduce.

**Have an Idea?** We'd love to hear it! Open a feature request.

---

**Version:** 1.0.0
**Last Updated:** 2026-01-08
**Maintained By:** Claude Code Agents Toolkit Team
