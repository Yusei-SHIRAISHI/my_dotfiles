指定された `task note path` の task note を 1 件だけ読み込み、実行可能なら `task_manager` に渡して開始してください。

## 参照

ルール:

- @rules/development-flow.md
- @rules/execution-routing.md

skills:

- `obsidian-task-management`
- `obsidian-cli`

実行契約:

- @agents/task_manager.md
- `obsidian-template/templates/task.md`

## この command の役割

- 引数として受け取った `task note path` の task note を 1 件だけ扱う
- task note から `task_manager` の必須入力を抽出する
- 実行可能な task であれば、その 1 task だけを `task_manager` に渡す
- 開始時と返却時に、task note の checkbox と `workflow_state` を一貫したルールで更新する
- 実行不能な task であれば、不足項目または未解決依存を明示して停止する

## 実行ルール

- 引数は `task note path` だけを受け付ける
- path は 1 件だけ扱い、複数 task をまとめて開始しない
- vault 上の note の読み取りは `obsidian-task-management` と `obsidian-cli` の流儀に従い、`obsidian` CLI 経由で行う
- `task note path` は vault root からの相対 path として扱う
- まず対象 note を `obsidian` CLI で読み、`obsidian-template/templates/task.md` の共通契約を基準に内容を抽出する
- task pattern template を使った note でも、共通契約の section と frontmatter が満たされていれば受け付ける
- 少なくとも次を抽出する:
  - `Task`
  - `Overview`
  - `Description`
  - `Success criteria`
  - `Expected output`
  - `Human review required`
- `blocked_by` が空でない場合は開始せず、依存未解決として停止する
- `workflow_state` が `in_progress` の場合は開始せず、すでに着手中として停止する
- task checkbox が `- [/]`、`- [x]`、または `- [-]` の場合は開始せず、その状態を報告して停止する
- 必須項目が不足している場合は、足りない項目を列挙して停止する
- 対象が executable な task note なら、routing の再判断で迂回せず `task_manager` を起動する
- `task_manager` には対象 task を進めるのに必要な context だけを渡す
- 1 回の実行で起動する `task_manager` は 1 つだけとする

## task_manager への入力

- task note から抽出した必須項目をそのまま渡す
- section が存在する場合だけ次も渡す:
  - `Scope rules`
  - `Relations`
  - `References`
- note path を `References` に含め、元 task note を特定できるようにする

## Task Note Status Transition Rules

- 開始前の検証で停止した場合は、task note の checkbox と `workflow_state` を変更しない
- 実行開始直前に、task の checkbox を `- [/]` に更新し、`workflow_state` を `in_progress` に更新する
- `task_manager` の返却が `continue` の場合は、task を継続中として扱い、checkbox は `- [/]` のままにする
- `continue` で外部入力待ち、依存解消待ち、または再実行待ちが明確な場合は、`workflow_state` を `pending` に更新する
- `continue` で継続実装または継続調査が必要な場合は、`workflow_state` を `in_progress` のままにする
- `ready_for_human_review` の場合は、checkbox は `- [/]` のままにし、`workflow_state` を `human_review` に更新する
- `blocked` が開始後に返った場合は、checkbox は `- [/]` のままにし、`workflow_state` を `pending` に更新する
- `done` の場合は、task の checkbox を `- [x]` に更新する
- `done` や `cancelled` は `workflow_state` に持たせない
- この command は task を自動で `- [-]` にしない。不要化や中止は人間の明示判断がある場合だけ行う
- 状態更新時は、必要なら `Notes` に判断理由、待ち要因、human review 引き継ぎ事項を追記する

## 実行フロー

1. `obsidian` CLI で対象 task note を読む
2. 必須項目、`blocked_by`、checkbox、`workflow_state` を検証する
3. 開始不能なら状態を変えずに停止理由を返す
4. 開始可能なら checkbox を `- [/]`、`workflow_state` を `in_progress` に更新する
5. 抽出した context を使って `task_manager` を 1 回起動する
6. `task_manager` の `Final recommendation` に応じて task note の状態を更新する
7. 必要なら `Notes` や `References` に引き継ぎ情報を追記する
8. 更新後の状態と `task_manager` の結果を返す

## 停止条件

- `task note path` が存在しない
- task note ではない、または共通 task 契約を満たす note として読めない
- 必須 section または frontmatter が不足している
- `blocked_by` に未解決依存がある
- `workflow_state` が `in_progress` である
- task checkbox が `- [/]`、`- [x]`、または `- [-]` である

## 返却内容

- 読み込んだ task note path
- 抽出した task 要約
- 開始可否の判定理由
- `task_manager` を起動した場合は、その結果全文
- 起動しなかった場合は、不足項目または依存未解決の内容

## ユーザー依頼

$ARGUMENTS
