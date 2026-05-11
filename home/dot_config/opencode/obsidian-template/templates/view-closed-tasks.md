# Tasks

## Done

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "done"
SORT file.name ASC
```

## Cancelled

```dataview
LIST
FROM "items/tasks"
WHERE project = "<project-slug>"
  AND workflow_state = "cancelled"
SORT file.name ASC
```
