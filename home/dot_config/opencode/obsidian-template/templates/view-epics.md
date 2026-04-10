# Epics

## Active

```dataview
TABLE id, status
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "active"
SORT id ASC
```

## On Hold

```dataview
TABLE id, status
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "on_hold"
SORT id ASC
```
