# Workflow

- Epic / Story は `items/`
- executable な task は `items/tasks/`
- task の完了状態の正本は checkbox
- 未完了 task の状態分類は `workflow_state` で表す
- `projects/<project-slug>/views/` は進行中の task / item を分類して見るための view
- `projects/<project-slug>/closed-views/` は完了・中止済みの task / item を分類して見るための view
