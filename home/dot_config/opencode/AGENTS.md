# Global Agent Rules

このファイルはグローバル既定の作業ルールを定義する。リポジトリ固有の `AGENTS.md` がある場合はそちらを優先してよいが、安全性を下げる方向には解釈しない。

## Git Worktree Requirement

- git 管理されたリポジトリでソースコードを変更する場合は、必ず専用の git worktree を使う
- 既存のメイン checkout では実装・編集しない
- 既に task 専用の worktree にいる場合は、そのまま作業してよい
- 読み取りだけの調査、レビュー、仕様確認では worktree は必須ではない
- ドキュメントだけの軽微な更新であっても、git 管理リポジトリ内でファイルを編集するなら worktree を使う

## Worktree Setup Rules

- worktree 作成時は `using-git-worktrees` skill の手順に従う
- worktree の作成場所は、各リポジトリ直下の `.worktrees/` を既定とする
- `.worktrees/` を使う前に、親リポジトリの ignore 設定に `.worktrees/` が含まれていることを確認する
- リポジトリ固有の `AGENTS.md` に別の明示ルールがある場合のみ、その指定を優先してよい

## Execution Rules

- worktree が必要な条件を満たすのに worktree が未作成なら、先に worktree を準備してから実装を始める
- task_manager や general などの実行系 agent は、このルールを満たさない状態でソース変更を進めない
- 例外が必要なら、理由を明示して人間の承認を得る
