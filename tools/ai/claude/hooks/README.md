# Claude Code Automated Best Practices Hooks

This directory contains hooks that automatically enforce best practices without manual prompting.

## Configured Hooks

### 1. Tech-Lead Orchestrator (UserPromptSubmit)
**File**: `tech-lead-check.sh`
**Triggers**: When user submits prompts containing multi-step task keywords
**Action**: Automatically suggests using tech-lead-orchestrator for proper agent coordination

Keywords that trigger orchestration:
- implement, build, create feature
- refactor, fix...and...
- multiple, several
- architecture, design
- optimize, migrate, integrate

### 2. TDD Guard (PreToolUse)
**Command**: `tdd-guard`
**Triggers**: Before Write, Edit, MultiEdit, TodoWrite tools
**Action**: Enforces Test-Driven Development principles

### 3. Compound Engineering (PostToolUse)
**File**: `compound-engineering.sh`
**Triggers**: After Write, Edit, MultiEdit operations
**Action**: Automatically captures lessons learned (max once per 5 minutes)

### 4. Memory Bank Sync (PostToolUse)
**File**: `memory-sync.sh`
**Triggers**: After Task operations
**Action**: Monitors memory bank file sizes and suggests synchronization when needed

## How It Works

1. **No Manual Intervention Required**: Hooks run automatically based on your actions
2. **Smart Detection**: Scripts analyze context to determine when best practices apply
3. **Non-Intrusive**: Suggestions and actions happen in background
4. **Configurable**: Edit scripts to adjust thresholds and behaviors

## File Size Thresholds

Memory bank sync triggers when:
- Any single file > 50KB
- Total of all memory files > 150KB

## Testing Hooks

Test individual hooks:
```bash
# Test tech-lead detection
./.claude/hooks/tech-lead-check.sh "implement a new feature"

# Test memory sync check
./.claude/hooks/memory-sync.sh

# Test compound engineering
./.claude/hooks/compound-engineering.sh "Write"
```

## Disabling Hooks

To temporarily disable hooks, you can:
1. Remove from `.claude/settings.json`
2. Or add to settings.json: `"disableAllHooks": true`

## Hook Output Format

Hooks return JSON responses:
```json
{
    "action": "suggest|continue|notify|queue_agent",
    "message": "Human-readable message",
    "agent": "agent-name",
    "priority": "high|medium|low"
}
```

## Maintenance

- Hook scripts are located in: `/home/jlange/AI-AUTOMATION/.claude/hooks/`
- Configuration in: `/home/jlange/AI-AUTOMATION/.claude/settings.json`
- Last run tracking: `.claude/hooks/.last-compound-run`

## Benefits

✅ **Automatic tech-lead-orchestrator** for multi-step tasks
✅ **TDD enforcement** via tdd-guard
✅ **Continuous learning** via compound engineering
✅ **Memory optimization** via automatic sync detection
✅ **No manual prompting required**
