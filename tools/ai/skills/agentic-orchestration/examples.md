# Invocation Examples

## Example 1: Linear Ticket (Bounded)

Most common workflow — feed a Linear ticket and let the orchestrator decompose it.

```
orchestrate CAL-123 10
```

**What happens:**
- Orchestrator fetches `CAL-123` via `linctl issue get CAL-123 --json` (or Linear MCP fallback), extracts title/description/labels
- Mandate produced from ticket content — if description is vague, Orchestrator asks user to clarify
- Branch created: `feature/CAL-123-add-batch-cancellation` (from default branch)
- Manager decomposes into task graph, Tech Lead reviews
- 10 iteration cycles execute (stops early if all tasks complete)
- Build + test validation runs
- PR submitted to GitHub/Azure DevOps with ticket linked in description
- Linear ticket updated with PR URL comment

## Example 2: Notion Page (Bounded)

Feed a Notion spec or plan page directly.

```
orchestrate https://notion.so/workspace/API-Migration-Plan-abc123def456 12
```

**What happens:**
- Orchestrator detects Notion URL, fetches page via `notion-fetch`
- Page title → mandate objective, page content parsed for scope/constraints/AC
- If the page is in a database, properties (status, priority, tags) add context
- Branch created: `feature/notion-api-migration-plan`
- Manager decomposes into task graph, Tech Lead reviews
- Up to 12 iteration cycles execute
- PR submitted with Notion page linked as source in description
- Optionally adds a comment on the Notion page with the PR URL

## Example 3: Inline Description (Fixed, Exploratory)

Good for seeing the approach before committing resources.

```
orchestrate "Build a REST API for user authentication with JWT tokens, PostgreSQL storage, and rate limiting." 4
```

**What happens:**
- Orchestrator parses inline description, infers scope, may ask clarifying questions
- Branch created: `feature/orchestrate-build-rest-api-jwt-auth`
- Manager decomposes into ~8-12 tasks (models, middleware, endpoints, tests, etc.)
- 4 iteration cycles run, likely completing 6-8 tasks
- System reports: what's done, what remains, quality assessment, partial branch state
- User decides: `orchestrate resume 6` for more iterations, adjust scope, or accept partial result

## Example 4: Markdown Plan File (Bounded)

When you have a detailed plan document ready.

```
orchestrate ./plans/container-migration.md 15
```

Where `plans/container-migration.md` contains:

```yaml
---
objective: "Migrate the CalcEngine service to containerized deployment"
scope:
  - Dockerize the .NET application
  - Configure Azure Service Bus connectivity from container
  - Set up health checks and monitoring
  - Create CI/CD pipeline for container builds
constraints:
  - Must maintain backward compatibility with existing clients
  - Zero downtime deployment
  - All configuration via environment variables
acceptance_criteria:
  - Docker image builds and runs locally
  - CI/CD pipeline deploys to staging
  - Health checks report correctly
  - All existing API tests pass against containerized service
context:
  - "Existing codebase uses Clean Architecture"
  - "Current deployment is Azure App Service"
---
```

**What happens:**
- Orchestrator reads the file, extracts structured plan from YAML frontmatter
- Branch created: `feature/orchestrate-container-migration`
- Manager creates task graph with dependency edges (Dockerfile before CI/CD, health checks before monitoring)
- Tech Lead reviews decomposition
- Up to 15 iterations execute, stopping early if all tasks complete
- PR submitted with full validation results and link to plan file

## Example 5: Continuous Execution

For complex work where you trust the system to run autonomously.

```
orchestrate CAL-456 n
```

**What happens:**
- Fetches Linear ticket, produces mandate
- Branch created from ticket ID
- Continuous execution with progress reports every 3 iterations
- Circuit breakers active — system auto-pauses if stuck or drifting
- Runs until complete, then submits PR
- If circuit breaker trips: reports checkpoint, user decides how to proceed

## Example 6: Resume from Checkpoint

After a previous run stopped (cap reached, breaker tripped, or user-stopped):

```
orchestrate resume 10
```

**What happens:**
- Manager loads checkpoint from previous run
- Rebuilds task graph state: completed tasks stay done, queued tasks ready for dispatch
- Checks out existing feature branch (already created in previous run)
- Runs 10 more iterations from where it left off
- No work is repeated
- On completion: validates, creates PR (or updates existing draft PR)

## Example 7: Inline Plan with Multiple Work Streams

```yaml
orchestrate:
  plan:
    objective: "Add batch cancellation support to CalcEngine"
    scope:
      - API endpoint for cancellation (PATCH /v1/api/batches/{id}/cancel)
      - Domain logic for batch state transition (Running → Cancelling → Cancelled)
      - Worker notification via health endpoint response
      - Service Bus event for cancellation
      - Integration tests
    constraints:
      - Workers must finish current job before honoring cancellation
      - Cancellation is idempotent
      - Must work with existing container health protocol
    context:
      - "Batch states: Submitted, Running, Completed, Failed"
      - "Workers poll health endpoint every 30s"
      - "Service Bus publishes BatchCompleted events"
  iterations: 10
```

**Task graph the Manager would produce:**

| ID | Title | Type | Depends On | Persona |
|----|-------|------|------------|---------|
| TASK-001 | Add Cancelling/Cancelled to BatchStatus enum | parallel | — | backend_engineer |
| TASK-002 | Implement batch cancellation domain logic | serial | TASK-001 | backend_engineer |
| TASK-003 | Add cancel endpoint to BatchController | serial | TASK-002 | backend_engineer |
| TASK-004 | Add ShouldCancel flag to health response | parallel | TASK-001 | backend_engineer |
| TASK-005 | Publish BatchCancelled event to Service Bus | serial | TASK-002 | backend_engineer |
| TASK-006 | Integration tests for cancellation flow | serial | TASK-003, TASK-004, TASK-005 | qa_engineer |

**Expected output:**
- Branch: `feature/orchestrate-add-batch-cancellation`
- 6 commits (one per task), each referencing task ID
- PR submitted with task completion table, build/test results
- Parallelism ceiling: 2 (TASK-001 blocks most, TASK-003/004/005 can partially overlap)
