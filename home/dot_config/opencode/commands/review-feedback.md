指定された 1 件以上の `task note path` に human review のフィードバックを反映してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `~/.config/opencode/obsidian-template/templates/task.md`

## 役割

- 引数は 1 件以上の `task note path` と、human review のフィードバック本文を受け付ける
- task 未指定のフィードバックは受けず、短く確認する
- vault 上の note は `obsidian-cli` で読む
- code は変更せず、task note の更新だけを行う
- task ごとに独立して feedback 反映、状態更新、返却を行う

## 適用条件

- 入力 path は重複を除去して扱う
- `type: task` であること
- 必須 section または frontmatter が不足していたら停止する
- フィードバック本文が空なら停止する
- `workflow_state` が `done` または `cancelled` の task には原則適用しない
- `workflow_state` が `human_review` でない task にも適用してよいが、その理由を返す

## 状態更新

- `Results` は作業結果の正本として更新する
- フィードバック要約は `Results` の `Evidence` に追記する
- 修正要求や残件は `Results` の `Follow-ups` に追記する
- raw に近い補足が必要なら `Notes` に追記してよい
- すぐ再実装できる差し戻しなら `workflow_state` を `rework` に更新する
- 追加判断、追加入力、追加設計、分解見直しが必要なら `workflow_state` を `pending` に更新する
- 既存 task では吸収できない規模の差し戻しなら `Task Breakdown Needed` を返してよい

## 実行フロー

1. 入力された `task note path` を正規化し、重複を除去する。
2. 各 task note を読み、frontmatter、`Results`、`Notes`、`workflow_state` を確認する。
3. フィードバック本文から task ごとの要点、修正要求、追加判断の有無を整理する。
4. task ごとに `rework` へ戻すか `pending` にするかを判定する。
5. `Results` の `Evidence` と `Follow-ups` を更新し、必要なら `Notes` に補足を追記する。
6. task ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Updated`、`Skipped` の順にまとめる
- `Summary` には `Processed`、`Updated`、`Skipped` の件数を含める
- `Updated` では task ごとに `Txxx title` を見出しにし、`New workflow_state`、`Feedback Summary`、必要なら `NextAction` を返す
- `Feedback Summary` には reviewer 指摘の要点を 1-3 行で要約する
- `NextAction` は `Resume Implementation`、`Pending Input`、`Task Breakdown Needed` のいずれかを返してよい
- `Resume Implementation` では `/start-task-note` で `rework` の task を再開するよう案内してよい
- `Skipped` では task ごとに `Txxx title` を見出しにし、`Reason` を主として返す

## ユーザー依頼

$ARGUMENTS
