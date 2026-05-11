指定された 1 件以上の `task note path` を読み込み、実行可能な task note を `task_manager` に渡して開始してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `git-finalize` command
- `~/.config/opencode/obsidian-template/templates/task.md`
- `~/.config/opencode/commands/close-task-note.md`
- `~/.config/opencode/agents/task_manager.md`

## 役割

- 引数は 1 件以上の `task note path` を受け付ける
- vault 上の note は `obsidian-cli` で読む
- task ごとに独立して検証、状態更新、返却を行う
- 複数 task を 1 つの `task_manager` にまとめて渡してはならない
- `task_manager` が `done` を返し、`Human review required: false` の task は `close-task-note` 相当フローで auto-close する
- task pattern template を使った note でも、共通 task 契約を満たせば受け付ける

## 抽出する項目

- `Task`
- `Overview`
- `Description`
- `Success criteria`
- `Expected output`
- `Human review required`
- section があれば `Scope rules`、`Relations`、`References`
- `References` には元の `task note path` も含める

## 開始条件

- 入力 path は重複を除去して扱う
- 必須 section または frontmatter が不足していたら停止する
- 開始可能な `workflow_state` は `backlog` と `rework` だけとする
- `workflow_state` が `icebox`、`pending`、`in_progress`、`human_review`、`done`、`cancelled` のいずれかなら停止する
- `blocked_by` が空なら依存なしとして扱う
- `blocked_by` がある場合は依存 task note を解決し、依存先の `workflow_state` がすべて `done` の場合だけ開始する
- `blocked_by` に `done` 以外の task、または参照解決不能の task が 1 件でもあれば停止する
- `blocked_by` は依存メタデータなので、値が残っていること自体は停止理由にしない
- 依存 task 完了後も `blocked_by` を空にする必要はない
- ユーザーに `blocked_by` を空にしてから再実行するよう案内してはならない
- 複数 task が入力された場合、依存関係がある task は依存順に処理する
- 複数 task が相互に独立で、repo / worktree / 変更対象の衝突が見込まれない場合だけ並列に開始してよい
- 並列実行の安全性に自信がなければ直列に処理する

## 状態遷移

- 開始前に停止した場合は `workflow_state` を変更しない
- 開始直前に `workflow_state` を `in_progress` に更新する
- `continue` で待ち状態が明確なら `workflow_state` を `pending` にする
- `continue` で継続実装または継続調査なら `workflow_state` は `in_progress` のままにする
- `ready_for_human_review` なら `workflow_state` を `human_review` にする
- 開始後の `blocked` は `workflow_state` を `pending` にする
- `done` かつ `Human review required: false` なら `close-task-note` 相当の auto-close と git finalize を行い、成功時だけ `workflow_state` を `done` にする
- auto-close の git finalize に失敗した場合は `workflow_state` を `pending` にし、close 未完了として扱う
- この command は task を自動で `cancelled` にしない
- 状態更新時は `Results` を作業結果の正本として更新し、`Notes` は補足メモのまま維持する

## Auto Close

- `task_manager` の `Final recommendation` が `done` で、`Human review required: false` の task だけ auto-close 対象にする
- auto-close では `git-finalize`、`close-task-note` の `Git Context` / `Results` 更新、`NextAction` 判定のルールに従う
- `Results` は最低でも `Summary`、`Changes`、`Evidence`、`Verification`、必要なら `Commits` と `Follow-ups` を更新する
- finalize に失敗した task は完了扱いにせず、停止理由と finalize 失敗内容を返す

## 実行フロー

1. 入力された `task note path` を正規化し、重複を除去する。
2. 各 task note を読み、必須項目、`workflow_state`、`blocked_by` を task ごとに検証する。
3. `blocked_by` がある task は依存 task note を読み、`workflow_state` がすべて `done` か確認する。
4. 複数 task がある場合は、依存順と安全な並列性を判断する。
5. 開始不能な task は状態を変えずに停止理由を保持する。
6. 開始可能な task は task ごとに `workflow_state` を `in_progress` に更新する。
7. 開始可能な task ごとに、抽出した context を使って `task_manager` を 1 回だけ起動する。
8. 各 `task_manager` の `Final recommendation` に応じて task note の状態を task ごとに更新する。
9. `done` かつ `Human review required: false` の task は、`close-task-note` 相当の auto-close と `git-finalize` を行う。
10. auto-close が成功した task は `workflow_state` を `done` にし、`NextAction` を判定する。
11. task ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Started`、`Completed`、`Skipped` の順にまとめる
- `Summary` には `Processed`、`Started`、`Completed`、`Skipped` の件数を含める
- `Started` では task ごとに `Txxx title` を見出しにし、`New workflow_state`、`Task Manager Summary`、必要な場合だけ `Git Context` を返す
- `Task Manager Summary` は全文ではなく 1-3 行の要約にする
- 起動した結果として対象リポジトリに変更があれば、task ごとの `Git Context` として repository、branch 名、worktree、commit を返す
- 変更はあるがコミットがない場合は、task ごとの `Git Context` に branch 名と worktree を含め、commit は `none` または省略でよい
- `Completed` では task ごとに `Txxx title` を見出しにし、`New workflow_state: done`、`Task Manager Summary`、必要な場合だけ `Git Finalize Summary`、`Git Context`、`NextAction` を返す
- `Git Finalize Summary` の形式は `git-finalize` と同じにする
- `NextAction` の形式は `close-task-note` と同じにする
- `Skipped` では task ごとに `Txxx title` を見出しにし、`Reason` を主として返す
- auto-close の finalize に失敗した task は `Skipped` ではなく `Started` に含め、`New workflow_state: pending` と失敗理由を返す
- 一部 task が失敗しても、他の task は続行してよい

## ユーザー依頼

$ARGUMENTS
