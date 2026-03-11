# Command Registry
## Complete Registry of Claude Commands

*This file provides the authoritative registry of all Claude commands with their locations and purposes.*

---

## Directory Structure

```
.claude/commands/
├── 01-analysis/          # Code analysis and architecture
├── 02-development/       # Development assistance
├── 03-testing/          # Testing and linting
├── 04-refactoring/      # Code refactoring
├── 05-documentation/    # Documentation generation
├── 06-security/         # Security testing and auditing
├── 07-memory-bank/      # Memory bank management
├── 08-prompt-engineering/ # Prompt optimization
├── 09-utilities/        # Utility commands
└── 10-maintenance/      # Maintenance and cleanup
```

---

## Complete Command List (25 Commands)

### 01-analysis: Analysis Commands (2)
| Command | Purpose |
|---------|---------|
| analyze-codebase | Comprehensive codebase analysis |
| explain-architecture-pattern | Explain architectural patterns |

### 02-development: Development Commands (1)
| Command | Purpose |
|---------|---------|
| apply-thinking-to | Apply systematic thinking to development |

### 03-testing: Testing Commands (2)
| Command | Purpose |
|---------|---------|
| test | Run tests and validate code |
| lint | Code linting and formatting |

### 04-refactoring: Refactoring Commands (1)
| Command | Purpose |
|---------|---------|
| refactor-code | Systematic code refactoring |

### 05-documentation: Documentation Commands (2)
| Command | Purpose |
|---------|---------|
| create-readme-section | Generate README sections |
| update-claudemd | Update CLAUDE.md documentation |

### 06-security: Security Commands (9)
| Command | Purpose |
|---------|---------|
| check-best-practices | Security best practices audit |
| secure-prompts | Secure prompt engineering |
| security-audit | Comprehensive security audit |
| test-advanced-injection | Test advanced injection attacks |
| test-authority-claims | Test authority claim vulnerabilities |
| test-basic-role-override | Test role override attempts |
| test-css-hiding | Test CSS hiding attacks |
| test-encoding-attacks | Test encoding-based attacks |
| test-invisible-chars | Test invisible character attacks |

### 07-memory-bank: Memory Bank Commands (3)
| Command | Purpose |
|---------|---------|
| update-memory-bank | Update memory bank files |
| compound-from-history | Extract compound learnings from git history |
| extract-git-lessons | Extract lessons from git commits |

### 08-prompt-engineering: Prompt Engineering Commands (3)
| Command | Purpose |
|---------|---------|
| batch-operations-prompt | Optimize batch operations |
| convert-to-test-driven-prompt | Convert to TDD approach |
| convert-to-todowrite-tasklist-prompt | Convert to TodoWrite format |

### 09-utilities: Utility Commands (1)
| Command | Purpose |
|---------|---------|
| ccusage-daily | Daily code usage analytics |

### 10-maintenance: Maintenance Commands (1)
| Command | Purpose |
|---------|---------|
| cleanup-context | Clean up context and temporary files |

---

## Command Categories

### 🔍 Analysis & Understanding
- `analyze-codebase` - Deep dive into code structure
- `explain-architecture-pattern` - Understand design patterns

### 🛠️ Development & Refactoring
- `apply-thinking-to` - Systematic development approach
- `refactor-code` - Improve code quality

### ✅ Testing & Quality
- `test` - Comprehensive testing
- `lint` - Code quality checks
- `check-best-practices` - Best practices validation

### 📚 Documentation
- `create-readme-section` - Generate documentation
- `update-claudemd` - Maintain AI instructions

### 🔒 Security
- `security-audit` - Full security review
- `secure-prompts` - Prompt injection prevention
- Test suite for various attack vectors

### 🧠 Memory & Learning
- `update-memory-bank` - Keep knowledge current
- `compound-from-history` - Learn from git history
- `extract-git-lessons` - Capture historical insights

### 🎯 Optimization
- `batch-operations-prompt` - Optimize batch work
- `convert-to-test-driven-prompt` - TDD transformation
- `convert-to-todowrite-tasklist-prompt` - Task management

### 🧹 Maintenance
- `cleanup-context` - Keep workspace clean
- `ccusage-daily` - Monitor usage patterns

---

## Usage Guidelines

### Invoking Commands
Commands are typically invoked via slash commands in Claude:
```
/analyze-codebase
/security-audit
/update-memory-bank
```

### Command Locations
All commands are markdown files located in:
```
.claude/commands/[category]/[command-name].md
```

### Adding New Commands
1. Choose appropriate category (01-10)
2. Create markdown file with clear instructions
3. Update this registry
4. Test the command

### Command Naming Conventions
- Use kebab-case (lowercase with hyphens)
- Be descriptive but concise
- Use verbs for actions (analyze, update, test)
- Group related commands with common prefixes

---

## Maintenance Notes

1. **Regular Review**: Review command usage monthly
2. **Deprecation**: Mark unused commands for removal
3. **Updates**: Keep commands current with best practices
4. **Documentation**: Ensure each command has clear docs

---

*Last Updated: 2025-01-21*
*Total Commands: 25*
*Categories: 10*
*Structure: Numbered for clarity*
