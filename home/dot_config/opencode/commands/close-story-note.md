指定された 1 件以上の `story note path` を読み込み、関連 task の完了状況と Story のゴール達成を確認したうえで close してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `~/.config/opencode/obsidian-template/templates/story.md`

## 役割

- 引数は 1 件以上の `story note path` を受け付ける
- vault 上の note は `obsidian-cli` で読む
- task の close 状況だけでなく、Story のゴール、スコープ、完了イメージが満たされているかも確認する
- story ごとに独立して close 判定、状態更新、返却を行う

## close 条件

- 入力 path は重複を除去して扱う
- 必須 section または frontmatter が不足していたら停止する
- `type: story` であること
- `status` が `done` または `cancelled` なら停止する
- 関連 executable task は `story: <story id>` と `project: <project-slug>` で特定する
- 関連 executable task が 1 件でも `done` / `cancelled` 以外なら close しない
- 関連 task がすべて close 済みでも、Story のゴール、スコープ、完了イメージを満たす根拠が読み取れなければ close しない
- ユーザー補足、`Notes`、task の `Results`、Story note の `完了確認` を goal verification の evidence として使ってよい
- 残りの executable task がなく、Story はまだ未達と判断される場合は close せず `Task Breakdown Needed` を返す
- close できなかった story には `NextAction` を返す

## 状態更新

- close できる場合は `status` を `done` に更新する
- 必要なら `完了確認` または `Notes` に goal verification の要約を追記してよい
- close できない場合は note を変更しない

## 実行フロー

1. 入力された `story note path` を正規化し、重複を除去する。
2. 各 Story note を読み、frontmatter、`ゴール`、`スコープ`、`完了イメージ`、`完了確認`、`Notes` を確認する。
3. `story` と `project` を使って関連 task note を集め、`workflow_state` を確認する。
4. 関連 task がすべて close 済みか、goal verification の evidence が十分かを story ごとに判定する。
5. close できない story は状態を変えず停止理由を保持し、`NextAction` を判定する。
6. close できる story は `status` を `done` に更新する。
7. story ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Closed`、`Skipped`、`NextAction` の順にまとめる
- `Summary` には `Processed`、`Closed`、`Skipped` の件数を含める
- `Closed` では story ごとに `Sxxx title` を見出しにし、`New status: done` と `Goal Verification Summary` を返す
- `Skipped` では story ごとに `Sxxx title` を見出しにし、`Reason` を主として返す
- `NextAction` は close できなかった story ごとに返す
- `Next Tasks`: 関連 executable task がまだ残っている場合。task の `workflow_state` を添えて列挙してよい
- `Goal Verification Needed`: task は close 済みだが、Story のゴール達成 evidence が不足している場合。`完了確認` または `Notes` の更新を促す
- `Task Breakdown Needed`: 残りの executable task がなく、Story はまだ `active` の場合。`Suggestion: /task-breakdown で follow-up task を再設計する` を返す

## ユーザー依頼

$ARGUMENTS
