指定された 1 件以上の task / story / epic note path を読み込み、関連 task note の `Git Context` をもとに git finalize だけを行ってください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `using-git-worktrees` skill
- `~/.config/opencode/obsidian-template/templates/task.md`

## 役割

- 引数は 1 件以上の task / story / epic note path を受け付ける
- vault 上の note は `obsidian-cli` で読む
- task ごとに独立して git finalize 判定、実行、返却を行う
- story / epic が入力された場合は、関連 task note を解決して task 単位で finalize する
- task / story / epic の close や `workflow_state` / `status` 更新は行わない
- task note の `Results` は作業結果の正本として更新してよい

## 実行条件

- 入力 path は重複を除去して扱う
- 入力 note は `type: task | story | epic` のいずれかであること
- `type: task` の場合はその task を対象とする
- `type: story` の場合は `story: <story id>` と `project: <project-slug>` で関連 task を特定する
- `type: epic` の場合は `epic: <epic id>` と `project: <project-slug>` で関連 task を特定する
- code changes を伴う task を対象とする
- `Git Context` の repository、branch、worktree を解決できること
- merge target はユーザー依頼または `Git Context` の `Merge target` から解決できること
- merge target が曖昧な場合は main へ決め打ちせず停止する
- story / epic 入力で関連 task が 0 件なら停止理由を返す

## Git Finalize

- source branch に未コミット変更があれば、repo の commit message 慣例に従ってコミットする
- commit は source branch 上で行い、review 済み commit の amend や rewrite はしない
- merge は source branch から merge target branch へ行い、rebase や force push はしない
- merge target branch の checkout が必要な場合は、既存 worktree を使うか、安全な一時 worktree を用意する
- merge 成功後にのみ、source worktree を削除し、source branch を `git branch -d` 相当の非 force で削除してよい
- merge、commit、cleanup のいずれかに失敗した場合は停止理由を返す
- remote push は行わない
- finalize 成功時は `Results` の `Commits`、`Evidence`、`Verification`、必要なら `Follow-ups` を更新してよい
- `Notes` は補足メモのまま維持する

## 実行フロー

1. 入力された note path を正規化し、重複を除去する。
2. 各入力 note を読み、type に応じて finalize 対象 task を解決する。
3. 各 task の `Git Context` から repository、source branch、source worktree、merge target を解決する。
4. git finalize できない task、または関連 task を解決できない story / epic は状態を変えず停止理由を保持する。
5. git finalize 対象の task ごとに、未コミット変更の commit、merge、worktree 削除、branch 削除を順に行う。
6. task ごとの結果をまとめて返す。

## 返却内容

- 返却は `Summary`、`Finalized`、`Skipped` の順にまとめる
- `Summary` には `Processed`、`Resolved tasks`、`Finalized`、`Skipped` の件数を含める
- `Finalized` では task ごとに `Txxx title` を見出しにし、必要なら `Source note`、`Git Finalize Summary`、`Git Context` を返す
- `Git Finalize Summary` には commit 有無、merge target、worktree 削除、branch 削除の結果を含める
- `Skipped` では task または入力 note ごとに見出しを付け、`Reason` を主として返す

## ユーザー依頼

$ARGUMENTS
