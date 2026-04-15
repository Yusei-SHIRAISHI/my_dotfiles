指定された `task note path` の task note を 1 件だけ読み込み、実行可能なら `task_manager` に渡して開始してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `~/.config/opencode/obsidian-template/templates/task.md`
- `~/.config/opencode/agents/task_manager.md`

## 役割

- 引数は `task note path` 1 件だけ受け付ける
- vault 上の note は `obsidian-cli` で読む
- 実行単位は task note 1 件だけとし、複数 task をまとめて開始しない
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

- 必須 section または frontmatter が不足していたら停止する
- `workflow_state: in_progress` なら停止する
- task checkbox が `- [/]`、`- [x]`、`- [-]` なら停止する
- `blocked_by` が空なら依存なしとして扱う
- `blocked_by` がある場合は依存 task note を解決し、checkbox がすべて `- [x]` の場合だけ開始する
- `blocked_by` に未完了、着手中、中止、または参照解決不能の task が 1 件でもあれば停止する
- `blocked_by` は依存メタデータなので、値が残っていること自体は停止理由にしない
- 依存 task 完了後も `blocked_by` を空にする必要はない
- ユーザーに `blocked_by` を空にしてから再実行するよう案内してはならない

## 状態遷移

- 開始前に停止した場合は checkbox と `workflow_state` を変更しない
- 開始直前に checkbox を `- [/]`、`workflow_state` を `in_progress` に更新する
- `task_manager` の返却が `continue` なら checkbox は `- [/]` のままにする
- `continue` で待ち状態が明確なら `workflow_state` を `pending` にする
- `continue` で継続実装または継続調査なら `workflow_state` は `in_progress` のままにする
- `ready_for_human_review` なら checkbox は `- [/]` のまま、`workflow_state` を `human_review` にする
- 開始後の `blocked` は checkbox を `- [/]` のまま、`workflow_state` を `pending` にする
- `done` なら checkbox を `- [x]` にする
- `done` と `cancelled` は `workflow_state` に持たせない
- この command は task を自動で `- [-]` にしない
- 必要なら `Notes` に待ち要因や引き継ぎ事項を追記する

## 実行フロー

1. `obsidian-cli` で対象 task note を読む。
2. 必須項目、checkbox、`workflow_state`、`blocked_by` を検証する。
3. `blocked_by` がある場合は依存 task note を読み、すべて `- [x]` か確認する。
4. 開始不能なら状態を変えずに停止理由を返す。
5. 開始可能なら checkbox を `- [/]`、`workflow_state` を `in_progress` に更新する。
6. 抽出した context を使って `task_manager` を 1 回だけ起動する。
7. `Final recommendation` に応じて task note の状態を更新する。
8. 更新後の状態と必要最小限の結果を返す。

## 返却内容

- 起動した場合は、不要な中間判定を並べず `task_manager` の結果全文を返す
- 起動した場合にコミットが作成されたなら、そのコミットを作成したブランチ名を返す
- 起動したがコミットがない場合は、ブランチ名は省略してよい
- 起動しなかった場合は、停止理由を主として返す
- 起動しなかった場合は、依存未解決、不足項目、着手済み、完了済みなどの内訳を理由として含めてよい

## ユーザー依頼

$ARGUMENTS
