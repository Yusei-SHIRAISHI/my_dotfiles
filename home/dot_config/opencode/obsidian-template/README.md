# Obsidian Template

このディレクトリは、AI と人間が共同で Obsidian 上の task 管理を行うための vault 構成テンプレートです。

- この repository 内の `obsidian-template/` は template の配布元
- 実運用では、これをコピーした先の Obsidian vault 側の file / directory を操作する
- 実運用で想定する vault 名は `task-manage` とする
- AI 側の共通運用ルールは `obsidian-task-management` skill を正本とする
- 実運用での vault 操作は `obsidian-cli` と `obsidian-skills` を前提とする

## Directory Layout

```text
obsidian-template/
  items/
    epics/
    stories/
    tasks/
  projects/
    <project-slug>/
      overview.md
      knowledge/
        README.md
      meta/
        labels.md
      views/
        tasks.md
        epics.md
        stories.md
      closed-views/
        tasks.md
        epics.md
        stories.md
  templates/
    task-patterns/
  meta/
    phases.md
    statuses.md
    workflow.md
  .obsidian/
```

## Source of Truth

- Epic / Story の要約は `items/`
- 実行単位は `items/tasks/`
- project overview は `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/` は project 固有の知識メモ
- `projects/<project-slug>/views/` は進行中の task / item を確認する人間向け view
- `projects/<project-slug>/closed-views/` は完了・中止済みの task / item を確認する view
- 共通の phase / statuses / workflow は `meta/`
- project 固有の labels は `projects/<project-slug>/meta/labels.md`
- view template は `templates/view-*.md`
- labels template は `templates/labels.md`
- task template は `templates/task.md` を基本とし、必要なら `templates/task-patterns/` 配下の pattern template を使う
- pattern template の一覧と用途は `templates/task-patterns/README.md` を参照する
- task の完了状態の正本は task note の checkbox
- task の未完了状態分類は task note の `workflow_state`

## Next Step

- `INSTALL.md` を読んで vault へ導入してください
- project の追加・削除は `PROJECT_OPERATIONS.md` を参照してください
