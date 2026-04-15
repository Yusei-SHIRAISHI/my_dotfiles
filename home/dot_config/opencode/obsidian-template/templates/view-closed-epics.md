# Epics

## Done

```dataview
LIST
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "done"
SORT file.name ASC
```

## Cancelled

```dataview
LIST
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "cancelled"
SORT file.name ASC
```
