# Epics

## Done

```dataview
TABLE id, status
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "done"
SORT id ASC
```

## Cancelled

```dataview
TABLE id, status
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "cancelled"
SORT id ASC
```
