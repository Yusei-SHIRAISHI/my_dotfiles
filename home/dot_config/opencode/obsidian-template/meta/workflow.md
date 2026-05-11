# Workflow

- Epic / Story は `items/`
- executable な task は `items/tasks/`
- task の状態正本は `workflow_state` とする
- task の `workflow_state` は `icebox`、`backlog`、`rework`、`in_progress`、`human_review`、`pending`、`done`、`cancelled` を使う
- `rework` は human review feedback を受け、同一 task 内で再作業可能な状態を表す
- `projects/<project-slug>/views/` は進行中の task / item を分類して見るための view
- `projects/<project-slug>/closed-views/` は完了・中止済みの task / item を分類して見るための view
