# Development Flow

## Purpose

- 要求整理から完了までの全体フローを定義する
- routing、Obsidian task 整理、large task の実行詳細は各専用文書に委譲する
- agent review と human review は別物として扱う

## Flow

### 要求整理

- 依頼内容を整理し、goal、`Success criteria`、scope、out of scope を明確にする
- 要求整理が不足している場合は、起票や実装に進む前に補う

### 起票

- 必要に応じて Obsidian vault に Epic / Story / task note を作成または更新する
- 配置構造と note 管理のルールは `obsidian-task-management` skill に従う
- task 分解と `blocked_by` の扱いは `rules/task-breakdown.md` に従う

### Routing

- 実行前に small task / large task を判断する
- routing ルールは `rules/execution-routing.md` を正本とする

### 実行

- small task は `Build` が直接進める
- large task は `Task Manager` が進行管理する
- large task の実行ルールは `agents/task_manager.md` に従う

### テスト・検証

- 必要なテスト、lint、型チェック、E2E、手動確認を実施する
- 実施した内容と未実施の内容を区別して記録する
- 検証結果は completion 判断に使える形で残す

### Agent Review

- 必要な agent review を実施する
- blocking な finding があれば差し戻し、修正後に再 review する
- review は Story の phase ではなく、各 task に対する gate として扱う

### Human Review

- human review が必要な task は、人間の承認を通過してから先へ進む
- `Reviewer` は human review の代替ではない
- human review も Story の phase ではなく、対象 task ごとの gate として扱う
- human review に渡す差分は 1 つの review unit ごとに 1 commit にまとめる
- 1 commit に複数の独立した human review unit を混ぜない
- review しづらい差分量になる場合は、human review に渡す前に unit を分割する
- human review 後は review 済み commit を書き換えず、差し戻し対応は同一 review unit の追い commit で行う
- 差し戻し対応 commit に別 review unit の変更を混ぜない

### Completion

- `Success criteria` に整合している
- 必須 review が完了している
- 必須 human review が完了している
- テスト・検証結果が報告されている
- blocking な issue が残っていない

## Notes

- この文書は全体ライフサイクルの案内であり、各工程の詳細ルールは専用文書を正本とする
- 逸脱が必要な場合は、理由を明示する
