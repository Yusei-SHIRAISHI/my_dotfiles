# Tasks

## Icebox

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "icebox"
SORT file.name ASC
```

## Backlog

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "backlog"
SORT file.name ASC
```

## In Progress

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "in_progress"
SORT file.name ASC
```

## Human Review

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "human_review"
SORT file.name ASC
```

## Pending

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "pending"
SORT file.name ASC
```
