# Stories

## Active

```dataview
LIST
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "active"
SORT file.name ASC
```

## On Hold

```dataview
LIST
FROM "items/stories"
WHERE project = "<project-slug>"
  AND status = "on_hold"
SORT file.name ASC
```
