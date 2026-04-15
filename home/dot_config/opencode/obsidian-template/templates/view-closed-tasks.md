# Tasks

## Done

```dataview
LIST
FROM "items/tasks"
WHERE length(file.tasks) > 0
  AND file.tasks[0].completed
  AND project = "<project-slug>"
SORT file.name ASC
```

## Cancelled

```dataview
LIST
FROM "items/tasks"
WHERE length(file.tasks) > 0
  AND file.tasks[0].status = "-"
  AND project = "<project-slug>"
SORT file.name ASC
```
