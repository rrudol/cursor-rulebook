# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is the **Cursor Rulebook** - a repository for creating, organizing, and sharing Cursor editor rules. The project contains templates, documentation, and utilities for developing effective cursor rules (.mdc files) that enhance AI-powered development workflows.

## Common Commands

### Rule Validation
```bash
# Validate all cursor rules for syntax, structure, and best practices
./scripts/validate-rules.sh

# Validate with strict mode (treat warnings as errors)
./scripts/validate-rules.sh --strict
```

### Rule Copying and Distribution
```bash
# Copy all rules to current directory or auto-detect .cursor folder
./scripts/copy-cursor-rules.sh

# Copy rules with flattened structure (no subdirectories)
./scripts/copy-cursor-rules.sh --flatten

# Preview what would be copied without actually copying
./scripts/copy-cursor-rules.sh --dry-run

# Copy to specific target directory
./scripts/copy-cursor-rules.sh ~/my-project/.cursor/rules
```

### CLI Tool Installation
```bash
# Install the copy-cursor-rules CLI tool system-wide
./scripts/install-cursor-rules-cli.sh

# Uninstall the CLI tool
./scripts/install-cursor-rules-cli.sh --uninstall
```

## Architecture and Structure

### Repository Organization
- **`docs/`** - Comprehensive documentation including rule writing guides
- **`templates/`** - Standardized templates for different rule types (AI behavior, project standards, tools)
- **`scripts/`** - Shell utilities for validation, copying, and CLI installation
- **`.cursor/rules/categories/`** - Organized collection of example cursor rules

### Rule Categories
The project organizes cursor rules into three main categories:

1. **AI Behavior Rules** (`ai-behavior/`) - Control how AI assistants behave and interact
2. **Project Standards Rules** (`project-standards/`) - Enforce coding conventions and project requirements  
3. **Tool Configuration Rules** (`tools/`) - Configure development tools and workflows

### Key Components

#### Rule Structure
All `.mdc` files follow a standardized format:
- **YAML frontmatter** with `description`, `globs`, and `alwaysApply` fields
- **Markdown content** with title, principles, examples, and motivation sections
- **Kebab-case naming** convention for file names

#### Validation System
The `validate-rules.sh` script performs comprehensive checks:
- YAML frontmatter syntax validation
- Markdown structure verification
- Content quality analysis (placeholders, line length, typos)
- File naming convention enforcement

#### Distribution System
The `copy-cursor-rules.sh` script enables:
- Auto-detection of local `.cursor` directories
- Preservation of directory structure or flattened copying
- Exclusion of documentation files (only copies `.mdc` rule files)
- Conflict resolution for duplicate filenames

## Development Workflow

When working with cursor rules:

1. **Use templates** from `templates/` directory for consistency
2. **Follow naming conventions** (kebab-case, .mdc extension)
3. **Validate rules** with `./scripts/validate-rules.sh` before committing
4. **Test rule behavior** by copying to a test project
5. **Update documentation** if adding new rule categories or patterns

## Rule Writing Guidelines

Based on `docs/writing-effective-rules.md`:

- Use clear, actionable language with specific requirements
- Include both good and bad examples with proper syntax highlighting
- Provide motivation explaining the "why" behind each rule
- Configure appropriate `globs` patterns for file targeting
- Set `alwaysApply: true` for AI behavior rules, `false` for file-specific rules
- Keep rules focused on single concepts (atomic rules)
- Link related rules together for comprehensive coverage