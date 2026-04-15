# Epics

## Active

```dataview
LIST
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "active"
SORT file.name ASC
```

## On Hold

```dataview
LIST
FROM "items/epics"
WHERE project = "<project-slug>"
  AND status = "on_hold"
SORT file.name ASC
```
