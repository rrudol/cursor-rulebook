# Cursor Rules Categories 🗂️

This directory organizes cursor rules into logical categories for easy discovery and management. Each category focuses on a specific aspect of development workflow.

## Category Structure 📁

### 🤖 AI Behavior (`ai-behavior/`)

Rules that control how the AI assistant behaves, interacts, and performs tasks.

**Focus Areas**:

- Task automation and workflow
- Response patterns and communication
- Autonomous operation preferences
- Error handling and fallback behaviors

**Current Rules**:

- `no-lazy-ai.mdc` - Prevents lazy behavior, ensures autonomous task completion
- `self-improving-ai.mdc` - Enables AI learning and rule proposal mechanisms
- `task-tracking.mdc` - Enforces active task management during sessions

### 🌍 Project Standards (`project-standards/`)

Rules that enforce coding standards, conventions, and project-wide requirements.

**Focus Areas**:

- Language and naming conventions
- Code style and formatting
- Project structure requirements
- Quality and consistency standards

**Current Rules**:

- `language_en.mdc` - Enforces English language consistency
- `commit-after-task.mdc` - Requires git commits after task completion
- `cursor-rules.mdc` - Guidelines for cursor rule organization

### 🛠️ Tools (`tools/`)

Rules for configuring and managing development tools, package managers, and build systems.

**Focus Areas**:

- Package manager preferences
- Build tool configurations
- Development environment setup
- Tool-specific workflows

**Current Rules**:

- `pnpm.mdc` - Configuration for pnpm package manager
- `pip-requirements.mdc` - Python dependency management guidelines

## Finding the Right Category 🎯

### Decision Tree

```
Is this rule about...
├── How AI behaves? → ai-behavior/
├── Coding standards? → project-standards/
└── Tool configuration? → tools/
```

### Examples by Type

#### AI Behavior Examples

- Response tone and style
- Task prioritization logic
- Confirmation and permission patterns
- Learning and adaptation behaviors

#### Project Standards Examples

- Naming conventions
- Code formatting rules
- Documentation requirements
- Quality gates and checks

#### Tool Configuration Examples

- Package manager setup
- Linter configurations
- Build system preferences
- Deployment workflows

## Adding New Categories 📂

When the current categories don't fit your needs:

### 1. Assess Need

- Do you have 3+ related rules?
- Is the category distinct from existing ones?
- Will others benefit from this organization?

### 2. Create Structure

```bash
mkdir .cursor/rules/categories/new-category-name
```

### 3. Update Documentation

- Add category to this README
- Update main rules README
- Update installation script
- Add to templates if needed

### 4. Migration Path

If moving existing rules:

```bash
# Move rules to new category
mv .cursor/rules/categories/old-category/rule.mdc .cursor/rules/categories/new-category/

# Update cross-references in related rules
# Update installation scripts
```

## Category Guidelines 📋

### Naming Conventions

- Use kebab-case: `ai-behavior`, `project-standards`
- Be descriptive but concise
- Avoid abbreviations unless universally understood
- Use singular nouns when possible

### Size Management

- **Ideal**: 5-10 rules per category
- **Warning**: 15+ rules (consider subcategories)
- **Split when**: Categories become unwieldy or serve multiple distinct purposes

### Cross-Category Rules

Some rules might relate to multiple categories:

**Solutions**:

1. **Primary Category**: Place in most relevant category
2. **Cross-References**: Link from other relevant categories
3. **Shared Rules**: Create `shared/` category for truly universal rules

## Usage Patterns 🔄

### Installing by Category

```bash
# Install specific category
./scripts/install-rules.sh --ai-behavior

# Install multiple categories (separate commands)
./scripts/install-rules.sh --project-standards
./scripts/install-rules.sh --tools
```

### Browsing Categories

```bash
# List all categories
ls .cursor/rules/categories/

# See rules in category
ls .cursor/rules/categories/ai-behavior/

# Count rules per category
find .cursor/rules/categories/ -name "*.mdc" | cut -d'/' -f5 | sort | uniq -c
```

### Category-Specific Templates

Each category has corresponding templates in `/templates/`:

- `ai-behavior-rule-template.mdc`
- `project-standards-rule-template.mdc`
- `tool-rule-template.mdc`

## Maintenance 🔧

### Regular Reviews

- **Monthly**: Check for rules that should be moved
- **Quarterly**: Review category organization effectiveness
- **Annually**: Consider restructuring based on usage patterns

### Quality Checks

- Ensure rules in each category follow similar patterns
- Verify cross-references are accurate
- Check that category descriptions match contents
- Validate installation scripts include all categories

### Evolution Strategy

Categories should evolve based on:

- **Usage patterns** - which rules are most commonly used together
- **Community feedback** - what organization makes sense to users
- **Rule growth** - new domains requiring organization
- **Tool ecosystem changes** - new tools requiring configuration

---

_Well-organized rules make for productive development! 🚀_
