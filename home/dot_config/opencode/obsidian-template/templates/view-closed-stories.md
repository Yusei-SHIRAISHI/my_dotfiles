# Stories

## Done

```dataview
TABLE id, epic, phase, status
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "done"
SORT id ASC
```

## Cancelled

```dataview
TABLE id, epic, phase, status
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "cancelled"
SORT id ASC
```
