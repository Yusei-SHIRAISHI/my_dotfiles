指定された `task note path` の task note を 1 件だけ読み込み、Human Review 完了後の close 作業を行ってください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `~/.config/opencode/obsidian-template/templates/task.md`

## 役割

- 引数は `task note path` 1 件だけを必須とする
- ユーザーが補足を書いた場合は、human review の結果メモとして利用してよい
- vault 上の note は `obsidian-cli` で読む
- 対象は task note 1 件だけとし、複数 task をまとめて閉じない

## close 条件

- 必須 section または frontmatter が不足していたら停止する
- task checkbox が `- [x]` または `- [-]` なら停止する
- `Human review required` が `true` の task を対象とする
- `workflow_state` が `human_review` の task を優先対象とする
- `workflow_state` が `human_review` でない場合は、human review 完了済みと判断できる明示情報がなければ停止する
- human review 未完了、差し戻し中、または判断材料不足なら閉じない

## 状態更新

- close できる場合は task checkbox を `- [x]` に更新する
- 完了後は `workflow_state` を保持せず、残っていれば削除する
- `Git Context` section があり、対象リポジトリを解決できる場合は repository、branch、worktree を補完してよい
- `Results` section があれば、取得できる commit と verification を追記してよい
- ユーザーが human review の補足を書いた場合は `Results` または `Notes` に追記してよい
- close できない場合は note を変更しない

## 実行フロー

1. `obsidian-cli` で対象 task note を読む。
2. 必須項目、checkbox、`workflow_state`、`Human review required`、`Results` の有無を確認する。
3. human review 完了として閉じてよいかを判定する。
4. 閉じられない場合は、状態を変えず停止理由を返す。
5. 閉じられる場合は checkbox を `- [x]` に更新し、`workflow_state` を削除する。
6. 対象リポジトリが解決できる場合は、必要に応じて `Git Context` と `Results` を更新する。
7. 更新後の note 要約を返す。

## 返却内容

- close した場合は、更新した task note path と要約だけを返す
- 変更がある場合は、`Git Context` として repository、branch、worktree、commit を返してよい
- close できなかった場合は、停止理由を主として返す

## ユーザー依頼

$ARGUMENTS
