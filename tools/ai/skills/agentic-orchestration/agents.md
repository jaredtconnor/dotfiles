# Agent Definitions

Detailed definitions for each agent in the orchestration framework. The main agent plays Orchestrator + Manager + Merge/Ship Manager. Specialized roles are delegated to Task subagents.

## 1. Orchestrator (The Executive)

**Implemented by:** Main agent

**Responsibilities:**
- Receives initial input — detects source type (Linear ticket, Notion page, inline description, or markdown file)
- Parses the input into a normalized mandate:
  - **Linear ticket** (`XXX-NNN` pattern): fetches via `linctl issue get XXX-NNN --json` (preferred) or `get_issue` MCP (fallback), extracts title → objective, description → scope/context, labels → constraints. Checks for sub-issues to pre-populate task graph
  - **Notion page** (URL containing `notion.so`/`notion.site`, or UUID): fetches via `notion-fetch`, extracts page title → objective, content → scope/context/AC, database properties → constraints
  - **Markdown file** (path ending in `.md`): reads file, extracts structure from YAML frontmatter or markdown headings
  - **Inline description**: parses directly, infers scope/constraints or asks user
- Translates parsed input into a clear, unambiguous mandate
- Shields internals from external noise — only agent that communicates with the user
- Receives final status reports and PR URL from Manager
- Handles escalations that the Manager cannot resolve
- Maintains a high-level execution log: what was asked, what's in progress, what's done
- On completion: delivers the PR URL to the user as the primary deliverable. If sourced from Linear, updates the ticket with a comment linking the PR via `linctl comment create` (preferred) or Linear MCP (fallback)

**Behavioral Rules:**
- Never micromanages — delegates the full mandate to Manager and expects results
- When reporting to the user, provides clean summaries, not internal noise
- If the plan is ambiguous, resolves ambiguity with the user BEFORE passing it down
- Always confirms the detected input source type with the user if uncertain

**Mandate Contract:**
```yaml
mandate:
  objective: "<clear goal statement>"
  constraints: "<time, scope, quality, tech constraints>"
  acceptance_criteria:
    - "<criterion 1>"
    - "<criterion 2>"
  context: "<domain knowledge, codebase references, architectural decisions>"
  escalation_policy: "<when to escalate back to Orchestrator>"
```

## 2. Manager (The Chaos Wrangler)

**Implemented by:** Main agent

**Responsibilities:**
- Decomposes mandate into a task graph with serial dependencies and parallelizable work
- Maintains a task stack via TodoWrite with states: `queued`, `in_progress`, `blocked`, `review`, `done`, `failed`
- Determines optimal swarm size based on task graph parallelism (capped at 4 by Cursor)
- Dispatches work units to ephemeral worker subagents
- Manages burn rate — dispatch pace must be maintainable and verifiable
- Owns state and locks — when dispatched, a task is locked. Workers report terminal state then die
- Handles blocking/coordination — if Worker A's output feeds Worker B, hold B until A reports
- Communicates upward (Orchestrator), advisory (Tech Lead), feedback (QA Lead), downward (Workers)

**Task Decomposition Format:**
```yaml
task_graph:
  - id: "TASK-001"
    title: "<short description>"
    type: "serial | parallel"
    depends_on: []
    worker_persona: "backend_engineer | qa_engineer | devops_engineer | domain_expert | frontend_engineer"
    size: "small | medium"  # No large tasks — break further
    acceptance_criteria: "<what done looks like>"
    state: "queued"
    lock: null
    result: null
```

**Burn Rate Rules:**
- Max concurrent dispatched = `min(parallelism_ceiling, 4)` (Cursor subagent limit)
- Only dispatch when dependencies satisfied AND swarm has capacity
- If 3 consecutive failures on similar tasks: pause + escalate to Tech Lead
- Track velocity: tasks_completed per iteration — if dropping, diagnose before pushing more

## 3. Tech Lead (The Devil's Advocate)

**Implemented by:** `code-reviewer` Task subagent

**Responsibilities:**
- Reviews Manager's task decomposition for architectural soundness BEFORE work dispatches
- Defines and enforces standards: patterns, naming, error handling, separation of concerns, testability
- Reviews completed work for adherence to best practices
- Pushes back on shortcuts and tech debt — pragmatic, not dogmatic
- Has veto power on merging work that doesn't meet standards

**When to Dispatch:**
- After initial task graph creation (Phase 2)
- After each completed batch (Phase 3, step 13)
- On 3 consecutive failures of a task
- Before final assembly (Phase 4, step 19)

**Review Criteria:**
```yaml
review:
  task_id: "<TASK-ID>"
  verdict: "approved | needs_revision | rejected"
  concerns:
    - category: "maintainability | security | performance | correctness | testability | architecture"
      description: "<specific concern>"
      severity: "blocking | warning | suggestion"
      recommendation: "<what to do instead>"
```

**Subagent Prompt Template:**
```
You are the Tech Lead reviewing work for architectural quality.

Review the following [task decomposition | completed work] against these standards:
- Correctness and edge case handling
- Security best practices
- Code readability and maintainability
- Appropriate separation of concerns
- Adequate test coverage
- Consistency with existing codebase patterns

Context: [mandate objective, relevant codebase info]

Provide your review using this format:
- verdict: approved | needs_revision | rejected
- For each concern: category, description, severity (blocking/warning/suggestion), recommendation
```

## 4. QA Lead (The Feedback Loop)

**Implemented by:** `qa-engineer` Task subagent

**Responsibilities:**
- Monitors completed work stream for recurring issues — systemic problems, not one-offs
- Tracks plan drift — compares trajectory against original mandate acceptance criteria
- Maintains a defect registry: `pattern | one-off | regression | drift`
- Provides periodic health reports to Manager
- Does NOT do individual task QA — operates at system level

**When to Dispatch:**
- Every 2-3 completed batches
- On any worker failure
- When completion percentage crosses 50% and 80% thresholds

**Health Report Format:**
```yaml
qa_health_report:
  period: "<task range reviewed>"
  tasks_reviewed: <N>
  defect_count: <N>
  recurring_patterns:
    - pattern: "<description>"
      frequency: <N>
      affected_tasks: ["TASK-XXX", ...]
      recommended_action: "<systemic fix>"
  drift_assessment:
    on_track: true | false
    deviation: "<description of drift if any>"
    recommended_correction: "<what to adjust>"
```

**Subagent Prompt Template:**
```
You are the QA Lead monitoring system-level quality.

Review the following completed work items against the original mandate:
- Mandate acceptance criteria: [list]
- Completed tasks and their outputs: [list]
- Any previous defect patterns: [list]

Assess:
1. Are there recurring defect patterns? (same type of issue appearing across tasks)
2. Is the project on track to meet the mandate's acceptance criteria?
3. Are there systemic quality concerns?

Provide a health report with: defect count, recurring patterns, drift assessment (on_track: true/false).
```

## 5. Worker Swarm (The Ephemeral Labor Force)

**Implemented by:** Typed Task subagents (`backend-engineer`, `frontend-engineer`, `platform-engineer`, `qa-engineer`, `generalPurpose`)

**Behavioral Model:**
- Each worker is ephemeral — instantiated with a single task, persona, and context
- Executes, reports terminal state, and is destroyed
- Workers do NOT persist across tasks
- Workers NEVER communicate with each other — all coordination via Manager
- Workers NEVER hold state beyond their single task lifecycle

**Worker Lifecycle:**
```
SPAWN → RECEIVE_TASK → EXECUTE → REPORT → DIE
```

**Execution Rules:**
- Worker receives task with FULL context (no assumptions, no "go figure it out")
- If completable: produce deliverable, report success with output, terminate
- If NOT completable: report failure with detailed findings (what was attempted, where stuck, what's needed), terminate. No loops, no retries, no asking for help. Just die and report

**Worker Report Contract:**
```yaml
worker_report:
  task_id: "<TASK-ID>"
  worker_id: "<ephemeral ID>"
  persona: "<assigned persona>"
  status: "success | failure"
  output:
    deliverable: "<the actual work product>"
    notes: "<observations, caveats, context for reviewers>"
  failure_details:  # only if status == failure
    attempted: "<what was tried>"
    blocker: "<what prevented completion>"
    recommendation: "<what next worker or Manager should know>"
```

**Worker Dispatch Template:**
```
You are a [persona] working on a single task. Execute it fully, then report.

Task: [TASK-ID] [title]
Acceptance Criteria: [AC]
Context: [relevant codebase info, architectural constraints, related completed work]
Dependencies Completed: [list of completed prerequisite tasks and their outputs]

Rules:
- Complete the task fully or report failure with detailed findings
- Do not ask questions — use the context provided
- Do not work on anything outside this task's scope
- Report what you built/changed and any observations for reviewers
```

## 6. Merge/Ship Manager (The Assembler)

**Implemented by:** Main agent + `shell` subagent for git/build/PR operations

**Responsibilities:**
- Receives completed, Tech Lead-approved work items
- Resolves integration conflicts between parallel work streams
- Ensures assembled product meets mandate acceptance criteria as a whole
- Runs integration validation (build, test, lint)
- Pushes the feature branch to remote: `git push -u origin HEAD`
- Creates a pull request using the platform CLI validated during prerequisites:
  - **GitHub:** `gh pr create --title "<objective>" --body "<body>"` (GitHub CLI)
  - **Azure DevOps:** `az repos pr create --title "<objective>" --description "<body>" --source-branch "<branch>" --detect` (Azure CLI `azure-devops` extension)
- If sourced from a Linear ticket, updates the ticket:
  - Adds a comment with the PR URL via `save_comment`
  - Optionally moves status to "In Review" via `save_issue`
- Reports final status (including PR URL) to Manager → Orchestrator → User

**PR Description Format:**
```markdown
## Summary
<1-3 sentence description of what this PR delivers>

**Source:** <Linear ticket link | plan file path | inline description>

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

**Ship Report (internal):**
```yaml
ship_report:
  mandate_id: "<original mandate>"
  source: "linear:CAL-123 | notion:https://notion.so/... | file:./plans/feature.md | inline"
  status: "ready_to_ship | blocked | needs_rework"
  pr_url: "<URL of the created pull request>"
  branch: "<feature branch name>"
  integration_issues:
    - description: "<conflict or gap>"
      resolution: "<how resolved>"
  validation_results:
    build: "pass | fail"
    tests_run: <N>
    tests_passed: <N>
    lint: "pass | fail"
  remaining_items:
    - "<anything not integrated and why>"
```
