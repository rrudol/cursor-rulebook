# Contributing to Cursor Rulebook 🤝

Thank you for your interest in contributing to the Cursor Rulebook! This guide will help you create high-quality cursor rules that benefit the entire community.

## 🚀 Quick Start

1. **Fork the repository** and clone your fork
2. **Choose a template** from `/templates/` that matches your rule type
3. **Follow our guidelines** below for writing effective rules
4. **Test your rule** using our validation script
5. **Submit a pull request** with a clear description

## 📋 Contribution Types

### New Rules 📝

- AI behavior improvements
- Project standards and conventions
- Tool configurations and workflows
- Language-specific best practices

### Rule Improvements 🔧

- Fix existing rule issues
- Add missing examples or documentation
- Improve clarity and usability
- Update deprecated practices

### Documentation 📚

- Improve writing guides
- Add new templates
- Fix typos and formatting
- Enhance examples

### Tooling 🛠️

- Improve validation scripts
- Add new installation options
- Fix bugs in automation

## ✨ Quality Standards

### Rule Requirements

#### ✅ Must Have

- **Valid frontmatter** with description, globs, and alwaysApply
- **Clear title** with appropriate category emoji (🤖🌍🛠️)
- **Motivation section** explaining why the rule exists
- **Examples section** showing good and bad patterns
- **English language** throughout (see Language Consistency Rule)
- **Kebab-case filename** ending in `.mdc`

#### 🎯 Should Have

- Specific, actionable guidelines
- Code examples with proper syntax highlighting
- Cross-references to related rules
- Performance or quality benefits clearly stated

#### 💡 Nice to Have

- Troubleshooting section for common issues
- Tool configuration examples
- Version compatibility notes
- Migration guidelines

### Writing Style Guide

#### Voice and Tone

- **Clear and Direct**: Use simple, unambiguous language
- **Helpful and Supportive**: Explain the "why" behind requirements
- **Professional but Approachable**: Use emojis sparingly for clarity

#### Structure

```markdown
---
description: Brief, clear description
globs: ["**/*.relevant"]
alwaysApply: true/false
---

# Rule Title 🎯

Brief overview explaining the rule's purpose.

## Core Principles

[Key requirements and guidelines]

## Examples

[Good vs bad examples with code]

## Motivation

[Benefits and reasoning]
```

#### Language Requirements

- **English Only**: All content must be in English
- **Active Voice**: "Use X" not "X should be used"
- **Present Tense**: "This rule enforces" not "This rule will enforce"
- **Clear Requirements**: Use "MUST", "SHOULD", "MAY" for different levels

## 🔧 Development Process

### 1. Planning

Before writing a new rule:

- Check if a similar rule already exists
- Determine the appropriate category (ai-behavior, project-standards, tools)
- Consider how it relates to existing rules
- Think about edge cases and exceptions

### 2. Writing

1. **Copy the appropriate template**:

   ```bash
   cp templates/ai-behavior-rule-template.mdc .cursor/rules/categories/ai-behavior/my-rule.mdc
   ```

2. **Replace all placeholders** (marked with `[brackets]`)

3. **Follow the category guidelines**:
   - **AI Behavior**: Focus on assistant behavior and workflow
   - **Project Standards**: Emphasize consistency and quality
   - **Tools**: Provide configuration and usage patterns

### 3. Testing

Run our validation script to check your rule:

```bash
./scripts/validate-rules.sh
```

Fix any errors or warnings before submitting.

### 4. Documentation

- Update relevant README files if adding new categories
- Add your rule to the appropriate category documentation
- Include examples in your rule that others can easily follow

## 📂 File Organization

### Directory Structure

```
.cursor/rules/categories/
├── ai-behavior/          # AI assistant behavior rules
├── project-standards/    # Coding standards and conventions
└── tools/               # Tool configurations and workflows
```

### Naming Conventions

- **Files**: Use kebab-case: `my-awesome-rule.mdc`
- **Titles**: Use title case: `My Awesome Rule 🎯`
- **IDs**: Use kebab-case: `my-awesome-rule-001`

## 🔍 Review Process

### Self-Review Checklist

Before submitting, ensure your contribution:

- [ ] Passes validation script without errors
- [ ] Follows the appropriate template structure
- [ ] Has clear, actionable guidelines
- [ ] Includes both good and bad examples
- [ ] Explains motivation and benefits
- [ ] Uses proper English and formatting
- [ ] Fits the target category appropriately

### Community Review

Pull requests will be reviewed for:

- **Accuracy**: Technical correctness of guidelines
- **Clarity**: Easy to understand and follow
- **Completeness**: All required sections present
- **Consistency**: Matches existing style and structure
- **Value**: Provides genuine benefit to users

## 🎯 Types of Rules by Category

### 🤖 AI Behavior Rules

**Purpose**: Control how AI assistants behave and interact

**Common Patterns**:

- Response formatting and tone
- Task management and workflow
- Error handling and recovery
- Learning and adaptation

**Example Topics**:

- Code review automation
- Testing strategy enforcement
- Documentation generation
- Debugging workflows

### 🌍 Project Standards Rules

**Purpose**: Enforce coding standards and project conventions

**Common Patterns**:

- Language and syntax requirements
- File organization and naming
- Code quality metrics
- Team collaboration practices

**Example Topics**:

- TypeScript strict mode
- Import organization
- Commit message formatting
- Code review requirements

### 🛠️ Tool Configuration Rules

**Purpose**: Configure development tools and workflows

**Common Patterns**:

- Package manager preferences
- Build system configuration
- Linting and formatting setup
- Development environment standardization

**Example Topics**:

- ESLint configuration
- Docker setup
- CI/CD pipeline requirements
- Database migration practices

## 🚀 Getting Started Examples

### Contributing a Simple Rule

```bash
# 1. Copy template
cp templates/project-standards-rule-template.mdc .cursor/rules/categories/project-standards/no-console-log.mdc

# 2. Edit the file to create a rule about avoiding console.log in production

# 3. Validate
./scripts/validate-rules.sh

# 4. Test in a project
cp .cursor/rules/categories/project-standards/no-console-log.mdc ~/my-project/.cursor/rules/

# 5. Submit PR
git add .
git commit -m "feat: add no-console-log rule for production code"
git push origin my-feature-branch
```

### Contributing Documentation

```bash
# 1. Identify improvement area
# 2. Make changes to docs/
# 3. Test with validation script
# 4. Submit PR with clear description
```

## 💬 Getting Help

### Before Contributing

- Read through existing rules for inspiration
- Check the [writing guide](docs/writing-effective-rules.md)
- Look at our [templates](templates/README.md)

### While Contributing

- Use our validation script frequently
- Test rules in real projects
- Ask questions in GitHub issues
- Follow existing patterns and conventions

### After Contributing

- Respond to review feedback promptly
- Update documentation as needed
- Help others understand your rule

## 🎉 Recognition

Contributors will be:

- Listed in our contributors section
- Credited in rule documentation
- Invited to help review future contributions
- Recognized for significant improvements

---

**Ready to contribute?** Start by exploring our [templates](templates/) and [writing guide](docs/writing-effective-rules.md), then dive in! We're excited to see what you create. ✨

_Questions? Open an issue or start a discussion!_
