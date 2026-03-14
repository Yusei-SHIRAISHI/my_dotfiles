# Task Templates

Use these templates when the `default` orchestrator is shaping work in Plane.

## Parent Work Item Template

- Goal: user-visible outcome or milestone
- AC: explicit acceptance criteria
- Module: target Plane module
- Split: why this is parent/child rather than sibling-only
- Granularity Rationale: why this parent has meaningful completion logic
- Child Items: short list of independent work streams
- Review Gates: required review items and why they block completion
- Done Condition: what must be true before the parent moves to `Done`

## Child Work Item Template

- Goal: one concrete intent
- Parent: linked parent item, if any
- Inputs: dependencies or assumptions
- Output: one primary artifact or result
- Agent: `worker`, `explorer`, or reviewer role
- Granularity Rationale: why this is a standalone child item
- Done Condition: the evidence needed for the orchestrator to mark it complete

## Sibling Work Item Template

- Goal: one concrete intent
- Related Items: sibling links with `relates_to` or `blocked_by`
- Agent: assigned role
- Output: one primary artifact or result
- Granularity Rationale: why this is sibling-only rather than parent/child
- Done Condition: standalone completion criteria

## Review Work Item Template

- Goal: review objective
- Review Type: one of `spec`, `functional-requirements`, `non-functional-requirements`, `architecture`, `design`, `test-cases`, `code-quality`, `security`
- Trigger: why this review is required
- Scope: files, systems, or decisions under review
- Skills: required supporting skills
- Output Format: expected review structure
- Blocking Rule: whether the target implementation item can move to `Done` before this review completes

## Feasibility Work Item Template

- Goal: prove that a technical path is viable
- Scope: the minimum environment / CI-CD / connectivity check
- Trigger: what uncertainty blocks the implementation
- Output: one proof of viability
- Agent: assigned role
- Follow-up: which implementation items can start after this completes
- Done Condition: the evidence needed to prove the path is viable

## Default Start Template

- Goal:
- AC:
- Module:
- Split: why this structure and sequence were chosen
- Skills:
- Assignments:
- Review Tasks:
- Relations:
- Done Condition:

## Final Orchestrator Report Template

- Decision:
- Rationale:
- Changes:
- Plane Updates:
- Risks:
- Next Actions:
