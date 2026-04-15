# Stories

## Done

```dataview
LIST
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "done"
SORT file.name ASC
```

## Cancelled

```dataview
LIST
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "cancelled"
SORT file.name ASC
```
