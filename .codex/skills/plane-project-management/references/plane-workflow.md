# Plane Workflow

This reference captures the local Plane operating model used by the `default` orchestrator.

## Core Assumptions

- Plane is the only execution ledger.
- The orchestrator updates Plane; other agents return results in chat.
- Standard hierarchy is `project -> module -> work item`.
- `cycle` is not used.
- `Close` means moving a work item to `Done`.
- New work items are not created blindly. Existing open items must be checked first for reuse or extension.

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
2. Search existing open work items in that module and nearby related modules.
3. Read comments on any related work item before deciding whether it is still active, partially superseded, or suitable for reuse.
4. Reuse or extend an existing work item when it still represents the same intent and can keep a clean `Done` decision.
5. Create a new work item only when reuse would mix separate intents, owners, or review gates.
6. Create a new module only if the work introduces a new responsibility boundary.

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
- `In Progress`: an agent is actively executing, investigating, or preparing an artifact.
- `In Review`: the artifact has reached a human review gate. The next state decision is human-owned.
- `Done`: acceptance criteria and required reviews are complete.
- `Cancelled`: the work is intentionally stopped.

Use `In Review` for review-required checkpoints inside a work item when further agent work should pause until a person approves or redirects it. Typical examples:

- `test-cases`
- function I/O design
- type definition design

Do not move items out of `In Review` automatically. The human reviewer decides whether the item should:

- move to `Done`
- return to `Todo`
- return to `In Progress`
- be split into follow-up implementation or review items

Recommended default after design review:

- If approval leads to a separate implementation artifact, keep the design item as the review checkpoint and create or activate a separate implementation item.
- Do not routinely send the same design item back to `In Progress` for a broader implementation phase.
- Reuse the same item after review only when the remaining implementation is small and the item still preserves one intent and one `Done` condition.

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

### Use `In Review` instead of a separate review item when

- the work item's primary output is the design or review artifact itself
- the implementation should not continue until a human makes a decision
- keeping the review inside the same item preserves one clear intent

### Use a separate review item when

- the review is a hard gate for a broader parent item
- the implementation and the review have different outputs or different owners
- the implementation will continue as a separate task after the design is approved
- the review should be tracked independently for auditability or coordination

### Split design and implementation into separate items by default when

- the design artifact must be approved before implementation starts
- approval leads to a different primary artifact, such as code, tests, or schema updates
- resuming the same item after review would mix design and implementation in one `Done` decision

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
