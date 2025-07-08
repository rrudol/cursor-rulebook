# Cursor Rules Collection 📋

This directory contains a collection of Cursor rules designed to improve development workflow, code quality, and AI assistant behavior.

## 📁 Rule Categories

### 🤖 AI Behavior Rules

- **`no-lazy-ai.mdc`** - Prevents AI from being lazy, ensures autonomous task completion
- **`self-improving-ai.mdc`** - Enables AI to learn and propose new rules based on patterns
- **`task-tracking.mdc`** - Enforces active task management during coding sessions

### 🛠️ Tool & Package Management

- **`pnpm.mdc`** - Configuration for using pnpm as Node.js package manager
- **`pip-requirements.mdc`** - Guidelines for Python dependency management
- **`no-blocking-scripts.mdc`** - Prevents running blocking dev scripts that halt AI workflow

### 🎨 Project Standards & Design

- **`collaboration-guidelines.mdc`** - Git conventions and development philosophy
- **`react-typescript-frontend.mdc`** - Frontend development standards for React TypeScript projects
- **`tailwind-design-system-compatibility.mdc`** - Ensures proper Tailwind CSS setup for external design systems
- **`language_en.mdc`** - Enforces English language consistency across codebase
- **`commit-after-task.mdc`** - Requires git commit and push after completing tasks
- **`cursor-rules.mdc`** - Guidelines for proper cursor rule file placement and structure

## 🚀 How to Use

### Apply to Single Project

```bash
# Copy specific rules
cp .cursor/rules/categories/ai-behavior/no-lazy-ai.mdc /path/to/your/project/.cursor/rules/

# Copy category
cp -r .cursor/rules/categories/ai-behavior/ /path/to/your/project/.cursor/rules/

# Copy all rules
cp -r .cursor/rules/ /path/to/your/project/.cursor/
```

### Apply Globally

```bash
# Link to your global cursor config
ln -s $(pwd)/.cursor/rules ~/.cursor/rules
```

### Selective Application

Each rule has frontmatter configuration:

- `alwaysApply: true` - Always enforced
- `alwaysApply: false` - Applied based on file patterns in `globs`

## 📝 Rule Status

| Rule                                 | Status    | Purpose                           |
| ------------------------------------ | --------- | --------------------------------- |
| no-lazy-ai                           | ✅ Active | Autonomous AI behavior            |
| self-improving-ai                    | ✅ Active | AI learning & improvement         |
| task-tracking                        | ✅ Active | Project task management           |
| no-blocking-scripts                  | ✅ Active | Prevents blocking dev commands    |
| pnpm                                 | ✅ Active | Node.js package management        |
| pip-requirements                     | ✅ Active | Python dependencies               |
| collaboration-guidelines             | ✅ Active | Git conventions & philosophy      |
| react-typescript-frontend            | ✅ Active | React TypeScript standards        |
| tailwind-design-system-compatibility | ✅ Active | Tailwind CSS external integration |
| language_en                          | ✅ Active | English consistency               |
| commit-after-task                    | ✅ Active | Git workflow                      |
| cursor-rules                         | ✅ Active | Rule organization                 |

## 🔧 Rule Development

See the main repository README for guidelines on:

- Writing new rules
- Contributing to the collection
- Testing and validation

---

_Keep your cursor sharp with these rules! ✨_
