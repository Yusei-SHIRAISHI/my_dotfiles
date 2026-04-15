Obsidian CLI を使って、ユーザーの依頼に応じて Epic / Story / task note を新規作成または整理してください。
ただし plan mode では task note 案の提示までに留め、vault への書き込みは行わないでください。

## 参照

ローカル参照元:

- `~/.config/opencode/rules/task-breakdown.md`
- `~/.config/opencode/agents/task_manager.md`
- `~/.config/opencode/obsidian-template/templates/epic.md`
- `~/.config/opencode/obsidian-template/templates/story.md`
- `~/.config/opencode/obsidian-template/templates/task.md`
- `~/.config/opencode/obsidian-template/templates/task-patterns/type-function-io.md`

この command 自体が依存する要点:

- 実行単位は `items/tasks/` 配下の executable な task note とする
- task note は後で `task_manager` に渡せる入力を持つ
- `blocked_by` で依存を表現し、不要な直列化を避ける
- `型・関数IO作成` は既定で skeleton-first とし、可能なら pattern template を使う
- human review の既定値は task type に応じて設定する

skills:

- `obsidian-task-management`
- `obsidian-cli`
- `obsidian-markdown`

テンプレート:

- `~/.config/opencode/obsidian-template/templates/epic.md`
- `~/.config/opencode/obsidian-template/templates/story.md`
- `~/.config/opencode/obsidian-template/templates/task.md`
- `~/.config/opencode/obsidian-template/templates/task-patterns/type-function-io.md`

task_manager 契約の要点:

- task note は `Task`、`Overview`、`Description`、`Success criteria`、`Expected output`、`Human review required` を持つ
- task 分解時点で、後続の `task_manager` が推測なしに実行判断できる粒度にする

## この command の役割

- build mode では新規依頼に対して最低 1 つの Story note と必要な task note を作成または更新する
- plan mode では作成や更新を行わず、Epic / Story / task note の案だけを返す
- 依頼が広ければ Epic note も扱う
- 既存 Epic / Story / task が指定されている場合は、差分更新案として整理する
- task note は後で `task_manager` が実行できる状態で設計する

## 実行ルール

- `obsidian-task-management` skill を使って vault layout、metadata、status semantics を揃える
- vault への操作は `obsidian-cli` skill に従って `obsidian-cli` 経由で行う
- note の本文と frontmatter は `obsidian-markdown` skill に従って整える
- 詳細な task breakdown と dependency のルールは `~/.config/opencode/rules/task-breakdown.md` を正本とする
- note 本文は template に従う
- `型・関数IO作成` task では、可能なら `~/.config/opencode/obsidian-template/templates/task-patterns/type-function-io.md` を優先する
- 対象の vault path、project、Epic / Story の切り方、または要求整理が曖昧な場合は、作成前に短い確認質問を 1 つだけ行う
- current operational mode が plan または read-only の場合は、vault note の作成、更新、削除、`blocked_by` 更新を行わない
- plan mode では既存 note の read/search は行ってよいが、返却は path、title、frontmatter、主要 section、`blocked_by` を含む draft proposal に留める
- current operational mode が build の場合だけ、実際の note 作成・更新・整理を行う

## 返却内容

- build mode では、作成または更新した Epic note と Story note
- build mode では、作成した task note
- build mode では、更新した task note
- build mode では、削除または `- [-]` にした tasks
- plan mode では、作成候補または更新候補の Epic / Story / task note 案
- 作成または更新した `blocked_by` 情報
- すぐに並列開始できる tasks
- 依存解決待ちの直列 chain
- 省略した task type とその理由

## ユーザー依頼

$ARGUMENTS
