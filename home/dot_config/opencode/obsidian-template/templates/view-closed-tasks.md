# Tasks

## Done

```dataview
TASK
FROM "items/tasks"
WHERE completed
  AND project = "<project-slug>"
SORT file.name ASC
```

## Cancelled

```dataview
TASK
FROM "items/tasks"
WHERE status = "-"
  AND project = "<project-slug>"
SORT file.name ASC
```
