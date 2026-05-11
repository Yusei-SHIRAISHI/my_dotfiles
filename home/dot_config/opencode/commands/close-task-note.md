指定された 1 件以上の `task note path` を読み込み、Human Review 完了後の close 作業と git finalize を行ってください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `git-finalize` command
- `~/.config/opencode/obsidian-template/templates/task.md`

## 役割

- 引数は 1 件以上の `task note path` を受け付ける
- ユーザーが補足を書いた場合は、human review の結果メモとして利用してよい
- vault 上の note は `obsidian-cli` で読む
- task ごとに独立して close 判定、状態更新、返却を行う
- code changes を伴う task では、close 前に `git-finalize` を成功させる

## close 条件

- 入力 path は重複を除去して扱う
- 必須 section または frontmatter が不足していたら停止する
- `Human review required` が `true` の task を対象とする
- `workflow_state` が `human_review` の task を優先対象とする
- `workflow_state` が `done` または `cancelled` なら停止する
- `workflow_state` が `human_review` でない場合は、human review 完了済みと判断できる明示情報がなければ停止する
- human review 未完了、差し戻し中、または判断材料不足なら閉じない
- 複数 task が相互に独立している場合は、並列に close してよい
- code changes を伴う task は、`Git Context` の repository、branch、worktree を解決できなければ閉じない
- code changes を伴う task は、merge target をユーザー依頼または `Git Context` の `Merge target` から解決できなければ閉じない
- merge target が曖昧な場合は main へ決め打ちせず停止する

## 状態更新

- close できる場合は `workflow_state` を `done` に更新する
- `Git Context` section があり、対象リポジトリを解決できる場合は repository、branch、worktree、merge target を補完してよい
- `Results` section は作業結果の正本として更新する
- close 成功時は `Results` の `Summary`、`Changes`、`Evidence`、`Verification` を更新し、必要なら `Commits` と `Follow-ups` を追記する
- `git-finalize` が成功した場合は、`Results` に merge 完了と cleanup 完了を追記してよい
- ユーザーが human review の補足を書いた場合は `Results` の `Evidence` または `Follow-ups` に反映してよい
- `Notes` は補足メモのまま維持する
- close できない場合は note を変更しない

## 実行フロー

1. 入力された `task note path` を正規化し、重複を除去する。
2. 各 task note を読み、必須項目、`workflow_state`、`Human review required`、`Results` の有無を task ごとに確認する。
3. task ごとに human review 完了として閉じてよいかを判定する。
4. code changes を伴う task は、`git-finalize` の条件を満たすかを確認する。
5. 閉じられない task は状態を変えず停止理由を保持する。
6. git finalize が必要な task は、`git-finalize` を呼び出して成功を確認する。
7. `git-finalize` が成功した task だけ `workflow_state` を `done` に更新する。
8. 対象リポジトリが解決できる場合は、task ごとに必要に応じて `Git Context` と `Results` を更新する。
9. close 済み task の `story` と `epic` を見て、`NextAction` を判定する。
10. `NextAction` は `Next Tasks`、`Task Breakdown Needed`、`Story Completed`、`Epic Completed` の優先順で 1 つだけ返す。
11. task ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Closed`、`Skipped`、`NextAction` の順にまとめる
- `Summary` には `Processed`、`Closed`、`Skipped` の件数を含める
- `Closed` では task ごとに `Txxx title` を見出しにし、`New workflow_state`、`Git Finalize Summary`、必要な場合だけ `Git Context` を返す
- `Git Finalize Summary` の形式は `git-finalize` と同じにする
- 変更がある場合は、task ごとの `Git Context` として repository、source branch、merge target、worktree、commit を返してよい
- `Skipped` では task ごとに `Txxx title` を見出しにし、`Reason` を主として返す
- `NextAction` は次の優先順で 1 つだけ返す
- `Next Tasks`: 今回の close によって新たに着手可能になった task がある場合
- `Task Breakdown Needed`: 残りの executable task がなく、対象 Story がまだ `active` の場合
- `Story Completed`: 対象 Story 配下の executable task がすべて `done` または `cancelled` の場合
- `Epic Completed`: 対象 Epic 配下の Story と task がすべて完了条件を満たす場合
- `Next Tasks` では task ごとに `Txxx title` を列挙し、必要なら `Ready reason` を添えてよい
- `Task Breakdown Needed` では `Reason` と `Suggestion: /task-breakdown で follow-up task を再設計する` を返す
- `Story Completed` と `Epic Completed` では完了候補の note を簡潔に報告する
- 一部 task が失敗しても、他の task は続行してよい

## ユーザー依頼

$ARGUMENTS
