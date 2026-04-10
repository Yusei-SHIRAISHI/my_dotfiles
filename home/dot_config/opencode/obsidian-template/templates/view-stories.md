# Stories

## Active

```dataview
TABLE id, epic, phase, status
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "active"
SORT id ASC
```

## On Hold

```dataview
TABLE id, epic, phase, status
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "on_hold"
SORT id ASC
```
