Obsidian CLI を使って、指定された `<project-slug>` の project workspace を Obsidian vault から削除してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `obsidian-template/PROJECT_OPERATIONS.md`

## この command の役割

- `<project-slug>` を受け取って project workspace を vault から削除する
- 対象は Obsidian vault 内の note と directory とする
- path は vault root からの相対 path とする
- デフォルトでは workspace だけを削除し、`items/` 配下の正本は削除しない

## 削除する path

- `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/`
- `projects/<project-slug>/meta/labels.md`
- `projects/<project-slug>/views/`
- `projects/<project-slug>/closed-views/`

## 実行ルール

- 引数は `<project-slug>` だけを必須とする
- slug が曖昧な場合だけ短い確認質問を 1 つ行う
- vault への操作は `obsidian` CLI 経由で行う
- 削除前に `project: <project-slug>` の task の存在を確認し、未完了 task があれば報告する
- それでもデフォルト動作は workspace-only とし、`items/epics/`、`items/stories/`、`items/tasks/` は削除しない
- `items/` 配下の purge は、この command では行わない
- path が存在しない場合は失敗にせず、存在したものだけ削除して報告する

## 返却内容

- 削除した path 一覧
- 存在しなかった path 一覧
- 見つかった未完了 task の有無
- `items/` 配下を保持したことの明示

## ユーザー依頼

$ARGUMENTS
