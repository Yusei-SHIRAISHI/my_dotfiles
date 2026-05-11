指定された 1 件以上の `epic note path` を読み込み、関連 Story の完了状況と Epic のゴール達成を確認したうえで close してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `~/.config/opencode/obsidian-template/templates/epic.md`

## 役割

- 引数は 1 件以上の `epic note path` を受け付ける
- vault 上の note は `obsidian-cli` で読む
- Story の close 状況だけでなく、Epic のゴールとスコープが満たされているかも確認する
- epic ごとに独立して close 判定、状態更新、返却を行う

## close 条件

- 入力 path は重複を除去して扱う
- 必須 section または frontmatter が不足していたら停止する
- `type: epic` であること
- `status` が `done` または `cancelled` なら停止する
- 関連 Story は `epic: <epic id>` と `project: <project-slug>` で特定する
- 関連 Story が 1 件でも `done` / `cancelled` 以外なら close しない
- 関連 Story がすべて close 済みでも、Epic のゴールとスコープを満たす根拠が読み取れなければ close しない
- ユーザー補足、Story / task の結果、Epic note の `完了確認` または `Notes` を goal verification の evidence として使ってよい
- 残り Story がなく、Epic はまだ未達と判断される場合は close しない
- close できなかった epic には `NextAction` を返す

## 状態更新

- close できる場合は `status` を `done` に更新する
- 必要なら `完了確認` または `Notes` に goal verification の要約を追記してよい
- close できない場合は note を変更しない

## 実行フロー

1. 入力された `epic note path` を正規化し、重複を除去する。
2. 各 Epic note を読み、frontmatter、`ゴール`、`スコープ`、`完了確認`、`Notes` を確認する。
3. `epic` と `project` を使って関連 Story を集め、`status` を確認する。
4. 関連 Story がすべて close 済みか、goal verification の evidence が十分かを epic ごとに判定する。
5. close できない epic は状態を変えず停止理由を保持し、`NextAction` を判定する。
6. close できる epic は `status` を `done` に更新する。
7. epic ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Closed`、`Skipped`、`NextAction` の順にまとめる
- `Summary` には `Processed`、`Closed`、`Skipped` の件数を含める
- `Closed` では epic ごとに `Exxx title` を見出しにし、`New status: done` と `Goal Verification Summary` を返す
- `Skipped` では epic ごとに `Exxx title` を見出しにし、`Reason` を主として返す
- `NextAction` は close できなかった epic ごとに返す
- `Next Stories`: 関連 Story がまだ残っている場合。Story の `status` を添えて列挙してよい
- `Goal Verification Needed`: Story は close 済みだが、Epic のゴール達成 evidence が不足している場合。`完了確認` または `Notes` の更新を促す
- `Task Breakdown Needed`: 残り Story がなく、Epic はまだ `active` の場合。`Suggestion: /task-breakdown で follow-up Story / task を再設計する` を返す

## ユーザー依頼

$ARGUMENTS
