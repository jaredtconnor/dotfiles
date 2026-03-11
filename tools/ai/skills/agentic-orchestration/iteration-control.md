# Iteration Control & Guardrails

The framework operates in iteration cycles. Each iteration is one full dispatch-execute-review pass through Phase 3. This prevents runaway execution, gives the user control over cost/time budgets, and provides natural checkpoints.

## Iteration Modes

| Mode | Syntax | Behavior |
|------|--------|----------|
| **Fixed** | `iterations: 4` | Run exactly 4 cycles, then hard-stop and report |
| **Bounded** | `iterations: 15` | Run up to 15 cycles, stop early if complete |
| **Continuous** | `iterations: n` | Run until done, user-stopped, or circuit breaker trips |

**Fixed mode** — Use for exploratory work, cost-sensitive runs, or "let me see how far you get in N cycles."

**Bounded mode** — Use for well-scoped plans where you estimate effort but want a safety cap.

**Continuous mode** — Use for complex work where you trust the system to run autonomously. Orchestrator surfaces progress summaries every 3 iterations or on any `red` health status.

## Iteration Lifecycle

Each cycle follows this loop:

```
ITERATION START
  ├── Manager dispatches next batch (respecting burn rate + dependency graph)
  ├── Workers execute and report
  ├── Manager processes reports (unlock deps, handle failures, update task graph)
  ├── Tech Lead reviews completed work (if any completions this cycle)
  ├── QA Lead evaluates patterns + drift (every 2-3 cycles)
  ├── Manager computes iteration summary
  └── Evaluate: continue, pause, or stop?
ITERATION END → increment counter → evaluate guardrails
```

## Iteration Summary

Produced every cycle. Flows up to Orchestrator for user reporting.

```yaml
iteration_summary:
  iteration: <current number>
  max_iterations: <N | "continuous">
  tasks_dispatched_this_cycle: <N>
  tasks_completed_this_cycle: <N>
  tasks_failed_this_cycle: <N>
  total_tasks_remaining: <N>
  total_tasks_completed: <N>
  total_tasks_in_graph: <N>
  completion_percentage: <0-100>
  burn_rate: "<tasks/iteration average>"
  velocity_trend: "accelerating | steady | decelerating | stalled"
  blockers:
    - task_id: "<TASK-ID>"
      reason: "<why stuck>"
  health: "green | yellow | red"
  recommendation: "continue | needs_user_input | escalate | stop"
```

**Health thresholds:**
- `green` — completion progressing, no recurring failures, on track
- `yellow` — minor issues (isolated failures, slight drift, velocity dip)
- `red` — systemic problems (failure cascade, stall, significant drift)

## Circuit Breakers

Automatic guardrails that prevent the system from spinning uselessly. When tripped, execution pauses and Orchestrator escalates to user.

### Stall Detection
- **Trigger:** 3 consecutive iterations with 0 tasks completed
- **Action:** Pause and escalate — the system is stuck

### Failure Cascade
- **Trigger:** Failure rate exceeds 50% for 2 consecutive iterations
- **Action:** Pause, mandatory Tech Lead review, escalate to user

### Drift Alarm
- **Trigger:** QA Lead reports `on_track: false` for 2 consecutive iterations
- **Action:** Pause and escalate — building the wrong thing

### Resource Runaway
- **Trigger:** Manager requests additional capacity 3+ times without completion progress
- **Action:** Pause and escalate — scope may be unbounded

### Infinite Loop Detection
- **Trigger:** Same task has failed and been re-queued more than 3 times
- **Action:** Mark task as `dead`, notify Manager, continue if non-blocking; escalate if blocking

### Token Budget
- **Trigger:** Cumulative effort feels disproportionate to remaining work
- **Action:** Pause and report — let user decide whether to continue

## Resumption Protocol

When the system stops (cap reached, breaker tripped, user-stopped), it produces a checkpoint:

```yaml
checkpoint:
  mandate_id: "<original mandate>"
  iteration_reached: <N>
  stop_reason: "iteration_cap | circuit_breaker:<which> | user_stop | completed"
  task_graph_snapshot:
    completed: ["TASK-001", "TASK-003", ...]
    in_progress: []  # should be empty — workers are ephemeral
    queued: ["TASK-005", "TASK-007", ...]
    failed: ["TASK-004"]
    dead: []
  deliverables_so_far:
    - task_id: "<TASK-ID>"
      output: "<reference to deliverable>"
  blockers: [...]
  qa_health_at_stop:
    # latest QA health report
  resumption_options:
    - "resume <N> — continue for N more iterations"
    - "resume n — continue until done"
    - "adjust — modify plan/tasks before resuming"
    - "ship — accept current state, send to Merge/Ship"
    - "abort — discard and stop"
```

**To resume:** User provides checkpoint context and resumption command. Manager rebuilds state from checkpoint and continues dispatching. No work is repeated.

## Mode Selection Guidance

| Situation | Recommended Mode |
|-----------|-----------------|
| First time using this framework | `iterations: 3` (fixed, see the approach) |
| Well-defined plan, ~10 tasks | `iterations: 8` (bounded) |
| Large refactor, 20+ tasks | `iterations: 20` (bounded) |
| Trusted plan, want hands-off | `iterations: n` (continuous) |
| Debugging a specific issue | `iterations: 2` (fixed, quick cycle) |
