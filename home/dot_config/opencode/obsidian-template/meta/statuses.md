# Statuses

Epic と Story の lifecycle status を定義する。

## Values

- `active`: 現在進行対象
- `on_hold`: 一時停止中
- `done`: 完了済み
- `cancelled`: 不要化または中止

## Notes

- `project` には `status` を持たせない
- 標準の `epics.md` と `stories.md` は `done` / `cancelled` を除外してよい
- `task` には `status` を持たせず、checkbox と `workflow_state` を使う
