# Tasks

## Icebox

```dataview
TASK
FROM "items/tasks"
WHERE !completed
  AND status != "-"
  AND project = "<project-slug>"
  AND workflow_state = "icebox"
SORT file.name ASC
```

## Backlog

```dataview
TASK
FROM "items/tasks"
WHERE !completed
  AND status != "-"
  AND project = "<project-slug>"
  AND workflow_state = "backlog"
SORT file.name ASC
```

## In Progress

```dataview
TASK
FROM "items/tasks"
WHERE !completed
  AND status != "-"
  AND project = "<project-slug>"
  AND workflow_state = "in_progress"
SORT file.name ASC
```

## Human Review

```dataview
TASK
FROM "items/tasks"
WHERE !completed
  AND status != "-"
  AND project = "<project-slug>"
  AND workflow_state = "human_review"
SORT file.name ASC
```

## Pending

```dataview
TASK
FROM "items/tasks"
WHERE !completed
  AND status != "-"
  AND project = "<project-slug>"
  AND workflow_state = "pending"
SORT file.name ASC
```
