---
name: agentic-orchestration
description: "Multi-agent orchestration framework for complex software engineering tasks. Accepts work via Linear tickets, Notion pages, inline descriptions, or markdown plan files. Decomposes into parallel/serial task graphs, dispatches specialized worker agents, enforces quality gates, manages git branching, and delivers a pull request to GitHub or Azure DevOps. Use when the user says 'orchestrate', provides a multi-step plan, a Linear ticket ID, a Notion link, or a path to a plan file."
---

# Agentic Orchestration Framework

Instantiate a hierarchy of specialized agents to decompose complex tasks, execute them in parallel/serial work streams, enforce quality, and deliver a pull request.

**Core principle: work flows down, state flows up, chaos is contained.**

```
                        ┌─────────────┐
           User ◄──────►│ Orchestrator │
                        └──────┬──────┘
                               │
                        ┌──────┴──────┐
                        │   Manager    │◄──── QA Lead (feedback loop)
                        └──┬───────┬──┘
                           │       │
                    ┌──────┴──┐ ┌──┴────────┐
                    │Tech Lead│ │Merge/Ship │
                    └─────────┘ └───────────┘
                           │
                  ┌────────┼────────┐
                  ▼        ▼        ▼
              [Worker] [Worker] [Worker]  ← Ephemeral Swarm (N agents)
```

## Agent Roles

| Agent | Role | Implemented By |
|-------|------|----------------|
| **Orchestrator** | User-facing executive. Parses input, produces mandate, delivers PR | Main agent (you) |
| **Manager** | Decomposes mandate into task graph, dispatches workers, tracks state | Main agent (you) |
| **Tech Lead** | Reviews architecture and code quality. Has veto power on merges | `code-reviewer` subagent |
| **QA Lead** | Monitors patterns, drift, systemic quality at system level | `qa-engineer` subagent |
| **Workers** | Ephemeral execution units. One task, report, die | Typed subagents (see mapping below) |
| **Merge/Ship** | Assembles work, validates build, creates PR | Main agent + `shell` subagent |

The main agent plays **Orchestrator + Manager + Merge/Ship Manager** simultaneously. Specialized review and execution roles are delegated to Task subagents.

For full agent definitions and output contracts, see [agents.md](agents.md).

## Input Sources

The orchestrator accepts work from four input types. The Orchestrator parses the input during Phase 1 (Intake) and normalizes it into a mandate regardless of source.

| Source | Syntax | Parsing |
|--------|--------|---------|
| **Linear ticket** | `orchestrate CAL-123 <iterations>` | Fetch via `linctl issue get --json` (preferred) or `get_issue` Linear MCP. Title → objective, description → scope + context, labels → constraints |
| **Notion page** | `orchestrate https://notion.so/... <iterations>` | Fetch via Notion MCP `fetch` tool. Extract page title → objective, content → scope/context/AC |
| **Inline description** | `orchestrate "Build X with Y" <iterations>` | Parse directly as mandate objective. Orchestrator infers scope/constraints or asks user |
| **Markdown file** | `orchestrate ./plans/feature.md <iterations>` | Read file. Extract objective, scope, constraints, acceptance criteria from structure |

### Linear Ticket Parsing

When given a ticket identifier (e.g., `CAL-123`, `ENG-456`):

**Preferred: `linctl` CLI** (significantly faster than MCP):
1. Check availability: `linctl --version`
2. Fetch the issue: `linctl issue get CAL-123 --json`
3. Extract: **title** → objective, **description** → scope + context + acceptance criteria, **labels** → constraints/categorization
4. If the ticket has sub-issues, list them: `linctl issue list --json` and filter by parent
5. To create sub-issues: `linctl issue create --title "..." --team TEAM --parent CAL-123`
6. To update status: `linctl issue update CAL-123 --state "In Progress"`
7. To add comments: `linctl comment create CAL-123 --body "..."`
8. To find a project: `linctl project list --json` and match by name

**Fallback: Linear MCP** (if `linctl` is not installed):
1. Fetch the issue using `get_issue` from the Linear MCP tools
2. If the ticket has sub-issues, use `list_issues` with `parentId` to fetch them

Store the ticket ID for: branch naming, commit references, PR linking, and status updates on completion

### Notion Page Parsing

When given a Notion URL (contains `notion.so` or `notion.site`) or a Notion page ID (UUID format):

1. Fetch the page using `notion-fetch` with the URL or ID
2. Extract: **page title** → objective, **page content** → scope, context, acceptance criteria
3. Parse the page's markdown content looking for structured sections: headings like "Goal", "Scope", "Requirements", "Constraints", "Acceptance Criteria"
4. If the page is in a database, extract relevant properties (status, priority, assignee, tags) as additional mandate context
5. If the page contains child pages or linked databases, note them as potential sub-task references
6. Store the Notion page URL for: PR description linking and completion comments

### Markdown Plan File

When given a file path, read it and extract structure. The file can be either:

**Structured YAML frontmatter:**
```yaml
---
objective: "Clear goal statement"
scope:
  - "Deliverable 1"
  - "Deliverable 2"
constraints:
  - "Must maintain backward compatibility"
acceptance_criteria:
  - "All tests pass"
  - "PR approved"
context:
  - "Relevant codebase info"
---
Additional details in markdown body...
```

**Free-form markdown** — the Orchestrator extracts structure from headings, lists, and content. Look for headings like "Goal", "Scope", "Requirements", "Constraints", "Acceptance Criteria".

## Cursor Implementation Mapping

### Worker Persona → Subagent Type

| Worker Persona | Subagent Type |
|----------------|---------------|
| `backend_engineer` | `backend-engineer` |
| `frontend_engineer` | `frontend-engineer` |
| `devops_engineer` | `platform-engineer` |
| `qa_engineer` | `qa-engineer` |
| `domain_expert` | `generalPurpose` |
| `database_engineer` | `backend-engineer` |
| `security_engineer` | `code-reviewer` |

### Concurrency Rules

- **Maximum 4 parallel Task subagents** per dispatch batch (Cursor limit)
- Use `run_in_background: true` for parallel workers when dispatching multiple
- Poll background agents by reading their output files with exponential backoff
- Use `TodoWrite` as the task graph state store (see State Management below)

### Task State → Todo State

| Task Graph State | TodoWrite Status |
|------------------|------------------|
| `queued` | `pending` |
| `in_progress` | `in_progress` |
| `done` | `completed` |
| `blocked` | `pending` (with blocker noted in content) |
| `failed` / `dead` | `cancelled` (with failure details in content) |

## Prerequisites

Before dispatching any work, the Orchestrator validates that required tooling is installed and authenticated. These checks run at the start of Phase 1 and **block execution if any fail**. Report failures to the user with install/auth instructions.

### Validation Checks

Run these commands and verify non-error output:

| Check | Command | What to verify |
|-------|---------|----------------|
| **Git** | `git --version` | Git is installed |
| **Git remote** | `git remote get-url origin` | Repo has a remote configured |
| **Platform CLI** | *(depends on detected platform — see below)* | CLI installed and authenticated |
| **Linear CLI** | `linctl --version` | *(Optional but preferred)* If available, use `linctl` for all Linear operations instead of MCP. Install: `brew install dorkitude/linctl/linctl` or from [source](https://github.com/dorkitude/linctl). Auth: `linctl auth` |

### Platform-Specific CLI Validation

After detecting the platform from `git remote get-url origin`:

**GitHub** (remote contains `github.com`):
1. `gh --version` — verify GitHub CLI is installed
2. `gh auth status` — verify authenticated. If not, tell user: `gh auth login`

**Azure DevOps** (remote contains `dev.azure.com` or `visualstudio.com`):
1. `az --version` — verify Azure CLI is installed
2. `az devops project show --detect` — verify Azure DevOps extension is installed and authenticated against the correct org/project. If not, tell user:
   - Install extension: `az extension add --name azure-devops`
   - Login: `az login`
   - Set defaults: `az devops configure --defaults organization=https://dev.azure.com/ORG project=PROJECT`

**If validation fails:** Stop immediately. Report which tool is missing or not authenticated, provide the install/auth commands above, and ask the user to fix it before re-invoking.

## Execution Protocol

### Phase 1: Intake (Orchestrator Hat)

1. **Validate prerequisites** (see Prerequisites section above). Stop if any check fails.
2. **Parse the input source:**
   - If it matches a ticket pattern (`XXX-NNN`): fetch from Linear via `linctl issue get XXX-NNN --json` (preferred) or `get_issue` MCP (fallback)
   - If it contains `notion.so` or `notion.site`, or is a UUID: fetch from Notion via `notion-fetch`
   - If it's a file path (contains `/` or `\`, ends in `.md`): read via Read tool
   - Otherwise: treat as inline description
3. Normalize into a mandate. If ambiguous, resolve with the user BEFORE proceeding — do not guess
4. Produce the mandate:

```yaml
mandate:
  source: "linear:CAL-123 | notion:https://notion.so/... | file:./plans/feature.md | inline"
  objective: "<clear goal statement>"
  constraints: "<time, scope, quality, tech constraints>"
  acceptance_criteria:
    - "<criterion 1>"
    - "<criterion 2>"
  context: "<domain knowledge, codebase references, architectural decisions>"
  escalation_policy: "<when to escalate back to user>"
```

### Phase 2: Planning & Branching (Manager Hat)

5. **Platform already detected** during prerequisite validation (step 1). Cached result:
   - `github` → use `gh` CLI for all GitHub operations (PRs, status, etc.)
   - `azure-devops` → use `az repos` for PR operations, `az devops` for project queries

6. **Create a feature branch** from the repo's default branch:
   - Run `git symbolic-ref refs/remotes/origin/HEAD` or `git rev-parse --abbrev-ref origin/HEAD` to find the default branch
   - Branch naming convention:
     - From Linear ticket: `feature/<TICKET-ID>-<slugified-title>` (e.g., `feature/CAL-123-add-batch-cancellation`)
     - From Notion page: `feature/notion-<slugified-page-title>`
     - From description/file: `feature/orchestrate-<slugified-objective>`
   - Run `git checkout -b <branch-name>`

7. Explore the codebase to understand current state (use `explore` subagents for large codebases)

8. Decompose the mandate into a task graph:

```yaml
task_graph:
  - id: "TASK-001"
    title: "<short description>"
    type: "serial | parallel"
    depends_on: []
    worker_persona: "<persona from mapping table>"
    size: "small | medium"  # No large tasks — break them down
    acceptance_criteria: "<what done looks like>"
    state: "queued"
```

9. Write the task graph to `TodoWrite` with all tasks
10. Dispatch the task graph to a `code-reviewer` subagent (Tech Lead) for architectural review
11. Adjust based on Tech Lead feedback
12. Determine dispatch order from dependency graph

### Phase 3: Execution (Manager Hat)

13. Dispatch tasks to worker subagents respecting:
    - Dependency order (all `depends_on` tasks must be `done`)
    - Burn rate (max 4 concurrent, only dispatch when capacity exists)
    - Swarm capacity (don't flood — verify completion before next batch)

14. For each dispatch batch:
    - Spawn worker subagents with full context (task description, acceptance criteria, relevant code paths, architectural constraints)
    - Workers NEVER get vague instructions. Include everything they need
    - Mark dispatched tasks as `in_progress` in TodoWrite

15. Process worker reports:
    - On success: mark `completed`, unlock dependent tasks, queue next dispatch
    - On failure: evaluate — re-queue with more context, break into sub-tasks, or escalate to Tech Lead
    - **3 failures on same task = mandatory Tech Lead review before retry**

16. **Commit completed work** after each approved batch:
    - Stage changes with `git add`
    - Commit with a descriptive message referencing the task(s): `feat(TASK-001): <description>`
    - If sourced from Linear ticket, include ticket ID: `feat(CAL-123/TASK-001): <description>`
    - Keep commits logically grouped — one commit per task or per related batch, not one giant commit

17. After each batch completes, dispatch `code-reviewer` subagent (Tech Lead) to review completed work

18. Periodically (every 2-3 batches or on any failure), dispatch `qa-engineer` subagent (QA Lead) to check for:
    - Recurring defect patterns
    - Drift from original mandate acceptance criteria
    - Systemic quality issues

19. Loop steps 13-18 until task graph is complete or escalation needed

**Failure cascade rule:** If failure rate exceeds 50% for 2 consecutive batches, pause dispatch and escalate to Tech Lead for mandatory review before continuing.

### Phase 4: Assembly & PR (Merge/Ship Hat)

20. Run integration validation:
    - `dotnet build` / `npm run build` / language-appropriate build command
    - `dotnet test` / `npm test` / language-appropriate test command
    - Fix any integration issues between parallel work streams
21. Dispatch final `code-reviewer` review on the assembled whole
22. Push the branch: `git push -u origin HEAD`
23. Create the pull request using the platform CLI validated in step 1:
    - **GitHub:** `gh pr create --title "<objective>" --body "<PR body>"`
    - **Azure DevOps:** `az repos pr create --title "<objective>" --description "<PR body>" --source-branch "<branch>" --detect`
    - PR body format (see Git Workflow section below)
24. If sourced from a Linear ticket, update the ticket and add a comment with the PR URL:
    - **linctl (preferred):** `linctl issue update CAL-123 --state "Done"` and `linctl comment create CAL-123 --body "PR: <url>"`
    - **MCP (fallback):** use `update_issue` and `create_comment` Linear MCP tools

### Phase 5: Delivery (Orchestrator Hat)

25. Report to user with a clean summary:
    - PR URL (the primary deliverable)
    - What was accomplished (task completion summary)
    - Validation results (build, test, lint)
    - Any remaining items or known issues
    - Link to Linear ticket if applicable
26. The PR is the deliverable. The user reviews and merges.

## State Management

### TodoWrite as Task Graph

The task graph is maintained via `TodoWrite`. Each task is a todo item:

```
id: "TASK-001"
content: "[backend_engineer] Implement JWT auth middleware | depends: none | AC: middleware validates tokens"
status: "pending" | "in_progress" | "completed" | "cancelled"
```

**Rules:**
- Use `merge: true` when updating individual task states
- Use `merge: false` only when creating the initial task graph
- Include worker persona, dependencies, and acceptance criteria in the content field
- On failure, update content to include failure details before setting `cancelled`

### Locking

When a task is dispatched to a worker, it is `in_progress`. No other worker gets it. Lock is released on worker report.

### No Polling Workers

Workers push their reports on completion. The system is event-driven: dispatch → wait for subagent result → process. Background subagents are polled via output file reads, but workers themselves never need prodding.

## Git Workflow

### Branching

Every orchestration run operates on an isolated feature branch. The branch is created in Phase 2 and the PR is submitted in Phase 4.

**Branch naming:**
| Source | Branch Name |
|--------|-------------|
| Linear ticket `CAL-123` with title "Add batch cancellation" | `feature/CAL-123-add-batch-cancellation` |
| Notion page titled "API Migration Plan" | `feature/notion-api-migration-plan` |
| Inline description "Build JWT auth" | `feature/orchestrate-build-jwt-auth` |
| Markdown file `plans/api-migration.md` | `feature/orchestrate-api-migration` |

**Rules:**
- Always branch from the repo's default branch (auto-detected)
- Slugify: lowercase, replace spaces with hyphens, remove special characters, truncate to 60 chars
- Never commit directly to `main` or `master`

### Commit Strategy

- Workers make file changes. The **Manager commits** after Tech Lead approves each batch
- One logical commit per task or per tightly-related batch — not one giant commit at the end
- Commit message format: `<type>(<scope>): <description>`
  - Types: `feat`, `fix`, `refactor`, `test`, `docs`, `chore`
  - Scope: task ID, and optionally ticket ID (e.g., `feat(CAL-123/TASK-003): add cancel endpoint`)
- Run `git status` before each commit to verify only intended files are staged

### PR Description Template

The PR body uses this structure:

```markdown
## Summary
<1-3 sentence description of what this PR delivers>

**Source:** <Linear ticket link | plan file | inline description>

## Changes
<Bulleted list of what was built/changed, grouped by area>

## Task Completion
| Task | Status | Description |
|------|--------|-------------|
| TASK-001 | Done | <title> |
| TASK-002 | Done | <title> |

## Validation
- Build: PASS/FAIL
- Tests: X/Y passed
- Lint: PASS/FAIL

## Notes
<Any caveats, known issues, or follow-up items>
```

### Platform Detection & CLI Tools

Detected and validated during Prerequisites (step 1). Cached for the entire run.

```
git remote get-url origin
```

| Remote contains | Platform | CLI tool | PR command | Auth check |
|-----------------|----------|----------|------------|------------|
| `github.com` | GitHub | `gh` (GitHub CLI) | `gh pr create` | `gh auth status` |
| `dev.azure.com` or `visualstudio.com` | Azure DevOps | `az devops` / `az repos` | `az repos pr create --detect` | `az devops project show --detect` |
| Neither | Unknown | — | Ask user which platform | — |

**Azure DevOps specifics:**
- Use `az repos pr create` for PR creation (part of `azure-devops` extension)
- Use `az devops configure --defaults` to set org/project if not auto-detected
- The `--detect` flag auto-discovers org/project from the git remote

**GitHub specifics:**
- Use `gh pr create` for PR creation
- Use `gh pr view` to retrieve the PR URL after creation

## Iteration Control

The framework supports three iteration modes controlling how many execution cycles run before pausing:

| Mode | Syntax | Behavior |
|------|--------|----------|
| **Fixed** | `iterations: 4` | Run exactly 4 cycles, then stop and report |
| **Bounded** | `iterations: 15` | Run up to 15 cycles, stop early if complete |
| **Continuous** | `iterations: n` | Run until done, user-stopped, or circuit breaker trips |

Each iteration = one full dispatch-execute-review cycle (Phase 3 steps 13-18).

At each iteration boundary, produce an iteration summary and evaluate whether to continue.

For full iteration control details, circuit breakers, and resumption protocol, see [iteration-control.md](iteration-control.md).

## Invocation

```
orchestrate <source> <iterations>
```

**From a Linear ticket:**
```
orchestrate CAL-123 8
```

**From a Notion page:**
```
orchestrate https://notion.so/workspace/API-Migration-Plan-abc123 10
```

**From an inline description:**
```
orchestrate "Add rate limiting middleware to all API endpoints" 6
```

**From a markdown plan file:**
```
orchestrate ./plans/container-migration.md 15
```

**Continuous (run until done):**
```
orchestrate CAL-456 n
```

**Resume from checkpoint:**
```
orchestrate resume 10
```

For detailed examples with expected behavior, see [examples.md](examples.md).

## Guardrails Summary

Circuit breakers that auto-pause execution:

| Breaker | Trigger | Action |
|---------|---------|--------|
| Stall | 3 iterations with 0 completions | Pause + escalate to user |
| Failure Cascade | >50% failure rate for 2 iterations | Pause + Tech Lead review |
| Drift | QA reports off-track for 2 iterations | Pause + escalate to user |
| Infinite Loop | Same task fails 3+ times | Mark dead, continue or escalate |

## Reference Files

- [agents.md](agents.md) — Full agent definitions, responsibilities, communication rules, and output contracts
- [iteration-control.md](iteration-control.md) — Iteration modes, lifecycle, circuit breakers, resumption protocol, checkpoint format
- [examples.md](examples.md) — Detailed invocation examples with structured plans
