# Execution Routing

## 目的

- small task は `Build` が直接処理する
- large task は `Task Manager` を経由する
- 逸脱時は理由を明示する

## Routing Rules

### Small Task

以下に当てはまる場合は `Build` が直接進めてよい。

- 修正範囲が局所的である
- 影響範囲が限定的である
- 実行系 subagent を複数組み合わせる必要がない
- human review checkpoint を挟まない
- DB schema、migration、複数モジュール横断変更、外部仕様調査が不要である

### Large Task

以下のいずれかに当てはまる場合は `Task Manager` を必ず経由する。

- 変更対象が複数モジュール、または 3 か所以上に広がる
- ローカルコード調査または外部仕様調査が必要である
- 設計、実装、検証を分離して進める必要がある
- 工程途中に review を挟む必要がある
- human review checkpoint が必要である
- DB schema、migration、セキュリティ影響、互換性影響を伴う

起票済みの executable task note がある場合は、実行単位は Epic や Story ではなく task note とする。
境界が曖昧な場合は、`Build` で無理に進めず `Task Manager` を優先する。

### Large Task With Existing Task Notes

以下に当てはまる場合、`Build` は 1 つの `Task Manager` に複数 task をまとめて渡さず、
実行可能な task note ごとに `Task Manager` を起動する。

- Obsidian 上に executable な task note が複数ある
- `blocked_by` により並列開始可能 task が判定できる
- 各 task を独立した review / human review の単位として扱いたい

この場合のルール:

- `blocked_by` が空の task ごとに `Task Manager` を 1 つ起動する
- sibling task は可能なら並列に進める
- `blocked_by` がある task は依存解消まで起動しない
- 1 つの `Task Manager` に複数 task の進行管理をさせない
- Epic や Story は実行単位ではなく、task note を実行単位とする
- 各 `Task Manager` は自分に割り当てられた 1 task の中でのみ `general`、`reviewer` を使う

## Notes

- この文書は実行経路の分岐ルールを定義する
- review、human review、completion の定義は `rules/development-flow.md` を正本とする
- `Task Manager` の担当単位は 1 task note とし、複数 task の束ね役にはしない
- large task で `Task Manager` を使わない、といった routing 逸脱は認めない
