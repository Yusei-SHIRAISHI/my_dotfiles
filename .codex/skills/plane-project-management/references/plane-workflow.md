# Plane Workflow

This reference captures the local Plane operating model used by the `default` orchestrator.

## Core Assumptions

- Plane is the only execution ledger.
- The orchestrator updates Plane; other agents return results in chat.
- Standard hierarchy is `project -> module -> work item`.
- `cycle` is not used.
- `Close` means moving a work item to `Done`.

## Start States

### New Project

Use this path when the user starts a new product area or repository and there is no matching Plane project.

1. Create the Plane `project`.
2. Create or identify the first `module` by responsibility boundary.
3. Create the strategy parent work item or the first major sibling items.
4. Add an environment / CI-CD / connectivity work item when feasibility is uncertain.
5. Split the actual implementation into domain/core work first, then adapter/UI/operational work.
6. Define relations and assign agent responsibilities.

### Existing Project

Use this path when a matching Plane project already exists.

1. Locate the correct `module`.
2. Reuse it if the work belongs there.
3. Create a new module only if the work introduces a new responsibility boundary.

## Work Item Structuring

### Granularity Rules

- One work item should represent one intent.
- One work item should produce one primary artifact.
- One work item should have one primary owner agent.
- One work item should have a `Done` condition that can be judged with a single yes/no decision.

Treat a work item as too large when:

- It mixes domain, UI, infra, and review concerns.
- Multiple agents need to progress it in parallel.
- Its `Done` condition splits into multiple unrelated success paths.

Treat a work item as too small when:

- It has no meaningful standalone tracking value.
- It could be absorbed into a parent or sibling item without making `Done` ambiguous.
- It represents only a tiny edit without an independent result.

### Parent + Child

Use parent/child when:

- There is one user-visible deliverable with multiple independent implementation tracks.
- The parent should not reach `Done` until several work streams finish.
- Reviews should block the overall deliverable, not just one implementation item.

Avoid parent/child when:

- The child items are too tiny to be managed independently.
- The parent has no meaning beyond being a bucket.
- The work could be represented more clearly as standalone sibling outcomes.

### Sibling Items

Use sibling items when:

- The work streams are independent enough to complete on their own.
- Parent/child would create noise without adding coordination value.
- The dependency can be captured by relations alone.
- Each sibling has its own meaningful artifact and `Done` decision.

### Feasibility Items

Use a standalone feasibility item when:

- A new external dependency, auth flow, DB, queue, or provider may block the whole plan.
- CI/CD, deployment, IAM, networking, or secret wiring may fail independently of the domain design.
- A lightweight connectivity check is needed before the real implementation can safely proceed.

Do not use a feasibility item as a bucket for the full implementation. Its outcome should be proof of viability only.

## Relation Rules

- Use `blocked_by` when an item cannot proceed without another item finishing.
- Use `relates_to` when the connection is informational or coordination-oriented.
- Do not leave dependencies implicit in chat. Record them in Plane.

## State Usage

- `Backlog`: the work exists but is not shaped enough to start.
- `Todo`: the work is defined and can be picked up.
- `In Progress`: an agent is actively executing or reviewing it.
- `Done`: acceptance criteria and required reviews are complete.
- `Cancelled`: the work is intentionally stopped.

## Review Routing

Create independent `reviewer` items and choose the review type explicitly.

### Add `spec` / `functional-requirements` / `non-functional-requirements`

- Requirements or acceptance criteria are still ambiguous
- Scope or non-functional expectations need to be fixed before implementation

### Add `architecture`

- New use cases
- Business rules or invariants change
- Responsibility boundaries are unclear
- AWS, Terraform, IAM, network, monitoring, cost, or operational simplicity are key concerns

### Add `design`

- User-facing UI, navigation, or information hierarchy changes

### Add `test-cases`

- Bug fix
- Invariants or state transitions change
- Important I/O or retry/timeout behavior changes

### Add `code-quality`

- Refactor risk or maintainability concerns need independent confirmation

### Add `security`

- Auth or authorization changes
- External input is persisted or interpreted
- Secrets, dependencies, infra, or money flows change

## Done Decision

Before moving an item to `Done`, the orchestrator should verify:

- Acceptance criteria are satisfied.
- Required child items and blocking review items are complete.
- Known risks are written down.
- The final report includes the Plane state changes and next actions.
