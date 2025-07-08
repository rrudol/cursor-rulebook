# Writing Effective Cursor Rules 📚

This guide covers best practices, patterns, and techniques for creating powerful and maintainable cursor rules that improve your development workflow.

## Table of Contents

- [Rule Anatomy](#rule-anatomy)
- [Writing Principles](#writing-principles)
- [Rule Types & Patterns](#rule-types--patterns)
- [Advanced Techniques](#advanced-techniques)
- [Testing & Validation](#testing--validation)
- [Common Pitfalls](#common-pitfalls)
- [Performance Considerations](#performance-considerations)

## Rule Anatomy

### Frontmatter Configuration

Every rule starts with YAML frontmatter that configures its behavior:

```yaml
---
description: Brief, clear description of what this rule does
globs: ["**/*.ts", "**/*.js"] # File patterns where rule applies
alwaysApply: false # Whether to apply regardless of file type
---
```

#### Frontmatter Options

| Option        | Type    | Purpose                | Examples                                          |
| ------------- | ------- | ---------------------- | ------------------------------------------------- |
| `description` | string  | Brief rule explanation | `"Enforces TypeScript strict mode"`               |
| `globs`       | array   | File patterns          | `["**/*.ts"]`, `["package.json"]`                 |
| `alwaysApply` | boolean | Global application     | `true` for AI behavior, `false` for file-specific |

### Content Structure

```markdown
# Rule Title 🎯

Brief overview paragraph explaining the rule's purpose.

## Core Principles

1. **Principle 1**: Description
2. **Principle 2**: Description

## Implementation

[Detailed guidelines]

## Examples

[Good vs bad examples]

## Motivation

[Why this rule exists]
```

## Writing Principles

### 1. Clarity First 🎯

- **Use active voice**: "The AI must validate" not "Validation should be done"
- **Be specific**: "Use `pnpm install`" not "install dependencies"
- **Avoid ambiguity**: Define exactly what you want

### 2. Actionable Guidelines ⚡

```markdown
✅ Good: "Always add TypeScript strict mode to tsconfig.json"
❌ Bad: "TypeScript should be configured properly"
```

### 3. Provide Context 🧠

Explain the "why" behind each rule:

```markdown
## Motivation

- 🔒 **Type Safety**: Strict mode catches more errors at compile time
- 📈 **Code Quality**: Enforces better coding practices
- 🤝 **Team Consistency**: Everyone follows the same standards
```

### 4. Include Examples 📝

Always show both good and bad patterns:

````markdown
### ✅ Good Example

```typescript
// Clear, typed interface
interface User {
  id: number;
  name: string;
}
```
````

### ❌ Bad Example

```typescript
// Unclear, untyped object
let user: any = {};
```

## Rule Types & Patterns

### AI Behavior Rules 🤖

**Purpose**: Control how the AI assistant behaves and interacts

**Key Sections**:

- Implementation Guidelines
- Behavioral scenarios
- Exception handling

**Example Pattern**:

```markdown
## Implementation Guidelines

### ✅ Good Behavior
```

AI: _Analyzes requirements_
AI: _Immediately starts implementation_
AI: "Implementing user authentication..."

```

### ❌ Lazy Behavior to Avoid
```

AI: "Would you like me to implement this?"
AI: "Should I proceed with the next step?"

```

```

### Project Standards Rules 🌍

**Purpose**: Enforce coding standards, conventions, and project requirements

**Key Sections**:

- Enforcement methods
- Tool configurations
- Violation examples

**Example Pattern**:

````markdown
## Enforcement 🛡️

- **Linting**: ESLint rule `@typescript-eslint/no-any`
- **CI/CD**: Pre-commit hooks validate types
- **Code Review**: Reviewers check for strict mode usage

## Tool Configuration

```json
{
  "compilerOptions": {
    "strict": true,
    "noImplicitAny": true
  }
}
```
````

````

### Tool Configuration Rules 🛠️

**Purpose**: Configure tools, package managers, and development workflows

**Key Sections**:
- Installation instructions
- Command reference
- Troubleshooting
- Version requirements

**Example Pattern**:
```markdown
## Installation
```bash
npm install -g pnpm
````

## Command Reference

```bash
# Install dependencies
pnpm install

# Add new package
pnpm add package-name
```

## Troubleshooting

**Issue**: `pnpm: command not found`
**Solution**: Ensure pnpm is in your PATH

````

## Advanced Techniques

### 1. Conditional Logic 🔀
Use glob patterns for conditional application:
```yaml
# Apply only to React components
globs: ["**/*.jsx", "**/*.tsx"]

# Apply to config files
globs: ["*.config.js", "*.config.ts", "package.json"]

# Apply to test files
globs: ["**/*.test.*", "**/*.spec.*"]
````

### 2. Rule Hierarchies 📊

Create related rules that work together:

```markdown
## Related Rules

- [`base-typescript.mdc`](./base-typescript.mdc) - Basic TypeScript setup
- [`strict-typescript.mdc`](./strict-typescript.mdc) - Strict mode (this rule)
- [`typescript-testing.mdc`](./typescript-testing.mdc) - Testing with TypeScript
```

### 3. Progressive Enhancement 📈

Start with basic rules, then add advanced ones:

```markdown
## Beginner Level

- Enable TypeScript
- Basic type annotations

## Intermediate Level

- Strict mode
- No implicit any

## Advanced Level

- Custom utility types
- Advanced generic patterns
```

### 4. Context-Aware Rules 🎯

Make rules specific to situations:

```yaml
# Frontend-specific
globs: ["src/components/**/*", "src/pages/**/*"]

# Backend-specific
globs: ["server/**/*", "api/**/*"]

# Configuration files
globs: ["*.config.*", ".*rc.*"]
```

## Testing & Validation

### Rule Testing Checklist ✅

- [ ] Frontmatter syntax is valid YAML
- [ ] Glob patterns match intended files
- [ ] Examples use correct syntax highlighting
- [ ] All placeholders are replaced
- [ ] Links to related rules work
- [ ] Rule follows naming conventions

### Validation Tools

```bash
# Test YAML frontmatter
python -c "import yaml; yaml.safe_load(open('rule.mdc').read().split('---')[1])"

# Test glob patterns
find . -name "*.ts" -o -name "*.js" | head -5

# Lint markdown
markdownlint rule.mdc
```

### Manual Testing

1. **Copy rule to test project**
2. **Restart Cursor**
3. **Verify rule appears in settings**
4. **Test rule behavior**
5. **Check for conflicts with other rules**

## Common Pitfalls

### ❌ Anti-Patterns to Avoid

#### 1. Vague Requirements

```markdown
Bad: "Code should be clean"
Good: "Functions must not exceed 50 lines and have descriptive names"
```

#### 2. Missing Context

```markdown
Bad: "Use strict mode"
Good: "Enable TypeScript strict mode to catch type errors early and improve code reliability"
```

#### 3. No Examples

```markdown
Bad: Just explaining what to do
Good: Showing both correct and incorrect implementations
```

#### 4. Overly Broad Globs

```yaml
# Too broad - affects everything
globs: ["**/*"]

# Better - specific file types
globs: ["**/*.ts", "**/*.tsx"]
```

#### 5. Contradictory Rules

Ensure rules don't conflict:

```markdown
Rule A: "Always use single quotes"
Rule B: "Always use double quotes" # ❌ Conflicts!
```

### 🛠️ Debugging Rules

#### Rule Not Applying

1. Check frontmatter syntax
2. Verify glob patterns match your files
3. Restart Cursor
4. Check for conflicting rules

#### Unexpected Behavior

1. Review rule precedence
2. Check `alwaysApply` setting
3. Verify file patterns
4. Test in isolation

## Performance Considerations

### Efficient Glob Patterns ⚡

```yaml
# Efficient - specific patterns
globs: ["src/**/*.ts", "test/**/*.test.ts"]

# Inefficient - too many wildcards
globs: ["**/**/**/*.ts"]
```

### Rule Size Optimization 📏

- Keep rules focused on single concepts
- Split large rules into smaller, related ones
- Use templates for consistency
- Remove unused sections

### Loading Performance 🚀

```yaml
# Good - specific application
alwaysApply: false
globs: ["package.json"]

# Less efficient - always active
alwaysApply: true
globs: ["**/*"]
```

## Best Practices Summary

### ✅ Do This

- Write clear, actionable guidelines
- Include concrete examples
- Explain motivation and benefits
- Use specific glob patterns
- Test rules thoroughly
- Keep rules focused and atomic
- Link related rules together
- Update rules as projects evolve

### ❌ Avoid This

- Vague or ambiguous language
- Missing examples or context
- Overly broad application patterns
- Conflicting requirements
- Untested rule behavior
- Monolithic mega-rules
- Broken internal links
- Stale, outdated content

---

Remember: Great rules are **clear**, **specific**, **tested**, and **helpful**. They should make development faster and more consistent, not add confusion or overhead! 🚀

_Happy rule writing!_ ✨
