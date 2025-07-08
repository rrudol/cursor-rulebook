# Cursor Rule Templates 📝

This directory contains templates for creating new cursor rules. Each template provides a standardized structure and comprehensive examples to help you write effective rules.

## Available Templates

### 🤖 AI Behavior Templates

- **`ai-behavior-rule-template.mdc`** - For rules that control AI assistant behavior, workflow automation, and interaction patterns

### 🌍 Project Standards Templates

- **`project-standards-rule-template.mdc`** - For coding standards, conventions, style guides, and project requirements

### 🛠️ Tool Configuration Templates

- **`tool-rule-template.mdc`** - For package managers, build tools, development tools, and their configurations

## How to Use Templates

### 1. Choose the Right Template

Select the template that best matches your rule's purpose:

- **AI Behavior**: Controls how the AI assistant behaves or works
- **Project Standards**: Enforces coding standards or project conventions
- **Tool Configuration**: Configures tools, dependencies, or workflows

### 2. Copy and Customize

```bash
# Copy template to your rules directory
cp templates/ai-behavior-rule-template.mdc .cursor/rules/categories/ai-behavior/my-new-rule.mdc

# Edit the file and replace all placeholders
# Placeholders are marked with [brackets] and need to be customized
```

### 3. Replace All Placeholders

Each template contains placeholders you need to replace:

| Placeholder              | Description            | Example                            |
| ------------------------ | ---------------------- | ---------------------------------- |
| `[Rule Name]`            | Name of your rule      | `Code Review Required`             |
| `[Brief description...]` | Short explanation      | `Requires code review for all PRs` |
| `[rule-id-kebab-case]`   | Unique rule identifier | `code-review-required`             |
| `[Tool Name]`            | Tool being configured  | `ESLint`                           |
| `[language]`             | Programming language   | `typescript`                       |

### 4. Configure Frontmatter

Each rule needs proper frontmatter configuration:

```yaml
---
description: Brief description of what this rule does
globs: ["**/*"] # File patterns this rule applies to
alwaysApply: true # Whether this rule is always active
---
```

#### Frontmatter Options

- **`description`**: Brief explanation of the rule's purpose
- **`globs`**: Array of file patterns where this rule applies (e.g., `["**/*.ts", "**/*.js"]`)
- **`alwaysApply`**:
  - `true` - Rule applies everywhere
  - `false` - Rule only applies to files matching `globs` patterns

## Template Structure Guide

### Standard Sections

All templates include these standard sections:

1. **Frontmatter** - Configuration metadata
2. **Title & Description** - Clear explanation of purpose
3. **Core Principles/Guidelines** - Main requirements
4. **Examples** - Good vs bad patterns
5. **Motivation** - Benefits and reasoning
6. **Related Rules** - Links to connected rules

### Template-Specific Sections

#### AI Behavior Rules Include:

- Implementation Guidelines
- Specific behavioral scenarios
- Exception handling

#### Project Standards Include:

- Violation examples table
- Enforcement methods
- Tool configurations

#### Tool Rules Include:

- Installation instructions
- Command reference
- Troubleshooting guide
- Version requirements

## Writing Tips

### ✅ Best Practices

- **Be Specific**: Use clear, actionable language
- **Provide Examples**: Show both good and bad patterns
- **Explain Why**: Include motivation and benefits
- **Keep Updated**: Review and update rules as projects evolve

### 📝 Writing Style

- Use emojis sparingly but effectively
- Write in present tense and active voice
- Use "MUST", "SHOULD", "MAY" for clarity levels
- Include code examples with proper syntax highlighting

### 🔗 Cross-References

- Link to related rules in your project
- Reference external standards or documentation
- Include tool documentation links

## Validation Checklist

Before finalizing a new rule, ensure:

- [ ] All placeholders are replaced with actual content
- [ ] Frontmatter is properly configured
- [ ] Examples are relevant and correct
- [ ] Motivation section explains the "why"
- [ ] File is saved in the correct category directory
- [ ] Rule name follows kebab-case convention

## Examples

### Simple AI Behavior Rule

```yaml
---
description: Prevents AI from asking unnecessary confirmation questions
globs: ["**/*"]
alwaysApply: true
---
# No Confirmation Spam Rule 🤖
[rest of rule content...]
```

### Language-Specific Standard

```yaml
---
description: Enforces TypeScript strict mode configuration
globs: ["**/*.ts", "**/*.tsx", "tsconfig.json"]
alwaysApply: false
---
# TypeScript Strict Mode Rule 🌍
[rest of rule content...]
```

---

_Use these templates to create consistent, comprehensive cursor rules! ✨_
