Obsidian CLI を使って、ユーザーの依頼に応じて Epic / Story / task note を新規作成または整理してください。

## 参照

ルール:

@rules/task-breakdown.md

skills:

- `obsidian-task-management`
- `obsidian-cli`
- `obsidian-markdown`

テンプレート:

- `obsidian-template/templates/epic.md`
- `obsidian-template/templates/story.md`
- `obsidian-template/templates/task.md`
- `obsidian-template/templates/task-patterns/type-function-io.md`

実行契約:

@agents/task_manager.md

## この command の役割

- 新規依頼では最低 1 つの Story note と必要な task note を作成する
- 依頼が広ければ Epic note も作成する
- 既存 Epic / Story / task が指定されている場合は、差分更新として整理する
- 追加、更新、削除、`- [-]`、`blocked_by` 更新を使って breakdown を保守する
- task note は後で `task_manager` が実行できる状態にする

## 実行ルール

- `obsidian-task-management` skill を使って vault layout、metadata、status semantics を揃える
- vault への操作は `obsidian-cli` skill に従って `obsidian` CLI 経由で行う
- note の本文と frontmatter は `obsidian-markdown` skill に従って整える
- 詳細な task breakdown と dependency のルールは `rules/task-breakdown.md` を正本とする
- note 本文は template に従う
- `型・関数IO作成` task では、可能なら `obsidian-template/templates/task-patterns/type-function-io.md` を優先する
- 対象の vault path、project、Epic / Story の切り方、または要求整理が曖昧な場合は、作成前に短い確認質問を 1 つだけ行う

## 返却内容

- 作成または更新した Epic note と Story note
- 作成した task note
- 更新した task note
- 削除または `- [-]` にした tasks
- 作成または更新した `blocked_by` 情報
- すぐに並列開始できる tasks
- 依存解決待ちの直列 chain
- 省略した task type とその理由

## ユーザー依頼

$ARGUMENTS
