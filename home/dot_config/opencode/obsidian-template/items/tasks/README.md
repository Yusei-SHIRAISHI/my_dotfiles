# tasks

実行単位の task note を置くディレクトリです。

- 1 ファイル = 1 task
- task の状態正本は `workflow_state` で持つ
- human review feedback 後に同一 task 内で再作業できる場合は `rework` にする
- 完了時は `done`、キャンセル時は `cancelled` にする
- 完了済みと cancelled は history view で確認する
- AI が主に編集する対象
