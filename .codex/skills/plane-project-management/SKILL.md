---
name: plane-project-management
description: "Use this skill when the default orchestrator needs to manage work in Plane: creating a new Plane project, choosing or creating modules, splitting work into parent/child or sibling items, setting relations for parallel execution, assigning agent responsibilities, and deciding when items are ready for Done. This skill is tailored to the local workflow where Plane is the single source of truth, cycles are not used, and Close means moving a work item to Done."
---

# Plane Project Management

## Overview

This skill guides the `default` orchestrator through the local Plane-based workflow from project and existing-item discovery to final `Done` judgement. It assumes the current `/home/shira/.codex/AGENTS.md` rules: Plane is the only execution ledger, `module + work item + relation` is the standard structure, and the `default` agent is the only agent that updates Plane.

## When To Use

Use this skill when a request involves any of the following:

- A new effort needs a Plane `project` before any task can be tracked.
- Existing work must be organized into `modules`, parent/child work items, or sibling work items.
- Parallel work needs explicit `relates_to` or `blocked_by` relations.
- The `default` agent needs to decide which `reviewer` work items and skills should be attached to the plan.
- A task is ready to move to `Done`, and the orchestrator must verify dependencies, review status, and residual risks.

Do not use this skill for implementation details inside a single task. Once the Plane structure and execution plan are clear, switch to the domain-specific skill or the normal coding workflow.

## Core Workflow

### 1. Establish the Plane context

- Check whether the target Plane `project` already exists.
- If it does not exist, create the Plane project before creating any work item.
- Before creating any new work item, check whether an existing open item already captures the same intent, review gate, or deliverable.
- When an existing item looks related, read its comments before deciding whether to reuse, extend, or replace it.
- Reuse and update an existing item when the goal, artifact, and ownership still fit. Create a new item only when reuse would blur the `Done` decision or mix separate intents.
- Choose the target `module`. Decide modules by responsibility boundary first, not by file or screen.
- Confirm the state model is the local standard: `Backlog`, `Todo`, `In Progress`, `In Review`, `Done`, `Cancelled`.
- In this workflow, `Close` means moving a work item to `Done`.

For a new project, prefer this startup order:

1. Create the Plane `project`.
2. Decide the first `module` or modules by responsibility boundary.
3. Create a strategy parent item or the first major sibling items to capture the overall direction.
4. Add an environment / CI-CD / connectivity item when technical feasibility is still uncertain.
5. Split domain/core implementation work before adapter, UI, or operational polish work.

### 2. Define the execution unit

- Keep one intent per work item.
- Keep one primary artifact per work item.
- Keep one primary owner agent per work item.
- A work item should have a `Done` condition that can be judged with a single yes/no decision.
- For larger work, use a parent item plus child items when the parent represents a deliverable that depends on multiple independent outcomes.
- Use sibling items when parent/child would be too granular or artificial.
- Only split work in parallel when the items can proceed independently without violating shared invariants.
- Keep review work explicit. Reviews are separate `reviewer` items by default.
- If a work item mixes domain, UI, infra, and review concerns, it is too large.
- If a work item is so small that it has no meaningful standalone `Done` decision, it is too small.

### 3. Set relations and ownership

- The `default` agent owns Plane updates.
- Worker and reviewer agents do not change Plane directly; they return outcomes, evidence, blockers, and readiness for `Done`.
- Use `blocked_by` when one item cannot start or finish until another item completes.
- Use `relates_to` when the work is connected but not strictly blocked.
- Leave blocked work in `Todo` until the dependency clears. Move actively worked items to `In Progress`.
- Use `In Review` when a work item has reached a human review gate and the next transition must be decided by a person.
- Typical `In Review` checkpoints include `test-cases`, function I/O design, and type definition design.
- When an item moves to `In Review`, the AI agent should stop changing its status. Transitions out of `In Review` are human-owned.

### 4. Attach the right reviews

- Add `spec`, `functional-requirements`, or `non-functional-requirements` review items when the request or acceptance criteria are still ambiguous.
- Add `architecture` review items when business rules, invariants, boundaries, or infrastructure structure are changing.
- Add `design` review items when user-facing UI, navigation, or information hierarchy changes.
- Add `test-cases` review items when bug fixes, invariants, important branching, or important I/O are involved.
- Treat `test-cases`, function I/O design, and type definition design as review-required checkpoints even when they are embedded in a broader implementation plan.
- Add `code-quality` review items when the refactor risk or maintenance cost needs independent judgement.
- Add `security` review items when auth, external input, secrets, dependencies, infra, or money flows are involved.
- Attach the right skill to the plan: `clean-ddd-hexagonal`, `aws-solution-architect`, `terraform-style-guide`, `web-design-guidelines`, or others as needed.
- If the review is a hard gate, create a dedicated review item and make the implementation item or parent item depend on it.
- Prefer a dedicated review item when the review result can independently pass or fail while the implementation work continues as a separate artifact.
- Prefer moving the current item to `In Review` when that item's primary output is the design decision itself and further agent work should pause until a human approves or redirects it.
- When a design artifact must be approved before a separate implementation artifact can begin, split the work into a design item and an implementation item by default.
- Do not treat `In Review` as the standard way to pause a design item and then resume the same item for a larger implementation phase.
- Returning a design item from `In Review` to `In Progress` for continued implementation is an exception path only.
- Allow that exception only when the implementation delta is small and the same item can still keep one clear intent and one clear `Done` decision.

### 5. Decide when an item is ready for Done

- Confirm the acceptance criteria are met.
- Confirm all required child items or related review items are complete.
- Confirm remaining blockers and known risks are documented.
- Move the item to `Done` only after the `default` agent has integrated the outcomes.
- Move abandoned work to `Cancelled`, with the reason and parent impact recorded.

## Working Rules

- Plane is the single source of truth for execution status.
- Do not manage active work purely in chat.
- Do not use `cycle` in this local workflow.
- Prefer the smallest structure that preserves safety and clarity.
- Do not create duplicate items by default. Search existing project, module, and open work items first.
- Keep task titles and acceptance criteria concrete enough that another agent can act without inventing missing decisions.
- Use `Split` to explain why the chosen structure is parent/child, sibling-only, or includes a standalone feasibility item.
- Treat connectivity checks as feasibility work, not as a bucket for the real implementation.

## References

- Read [references/plane-workflow.md](references/plane-workflow.md) when you need the local Plane workflow, state usage, or project/module decisions.
- Read [references/task-templates.md](references/task-templates.md) when you need reusable templates for parent items, child items, review items, or final orchestration reports.

When the user asks for a new Plane setup or a reorganization of parallel work, start by establishing the project/module context, then choose the work-item structure, then define reviews and `Done` conditions before any execution begins.
