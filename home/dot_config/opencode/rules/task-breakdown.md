# Task Breakdown

## Purpose

- 依頼内容を Obsidian 上の Epic / Story / task note に分解する
- 要求定義・要件定義は通常 Story note に整理して記載し、別 task としては作成しない
- 実行対象の task note は、後で `agents/task_manager.md` に渡せる executable な task として作る
- Story と `blocked_by` を使い、並列可能な task と直列 task を明確にする
- 実行中に発見された追加作業や不要作業にも追従し、既存の breakdown を更新できるようにする

## Tracking

- Story には薄い `phase` を持たせる
- `phase` は `requirements`、`design`、`implementation`、`test` のいずれかにする
- `requirements` phase は Story note 上の要求・要件整理期間を表す
- review は Story の phase には含めず、各 task ごとの gate として扱う
- 実際の進行判断は Story の phase、task note の checkbox、`workflow_state`、`blocked_by` を正本とする

## Item Rules

- 新規依頼では最低 1 つの Story note を作る
- 依頼が複数の Story に分かれる大きな単位なら Epic note を作る
- project 概要が未作成なら `projects/<project-slug>/overview.md` を作るか更新する
- 実行単位はすべて `items/tasks/` 配下の task note として作る

## Candidate Tasks

- ファイル・ディレクトリ構成案作成
- API エンドポイント設計
- デザイン要件定義
- デザインワイヤーフレーム作成
- 型・関数IO作成
- DB Schema作成
- テストケース作成
- デザイン作成
- コード実装
- E2Eモンキーテスト実行

## Creation Rules

- Story note には目的、背景、要求整理、要件整理、scope、out of scope、完了イメージ、現在 phase を記載する
- Epic note には広い目的、背景、関連 Story のリンクを記載する
- task note は executable な task として作成し、必要な項目は template に従う
- 要求定義・要件定義は通常 Story note に集約し、別 task は明示的に求められた場合だけ作る
- task title は短く具体的にする
- task 本文には推測を避け、未確定事項は明示する

## Reconciliation Rules

- 既存 Epic / Story / task が指定されている場合は、現状を読んだうえで追加・更新・削除候補を判断する
- scope 変更や着手後の発見事項があれば、必要な task note を追加する
- task の責務や依存が変わった場合は、本文、Story との対応、`blocked_by` を更新する
- 未着手で不要になった task は note 削除または `- [-]` を検討する
- 既に `- [/]` または `- [x]` の task は原則として削除しない。不要化した場合は `- [-]` を優先する
- 重複 task がある場合は、残す task を決めたうえで他方を削除または `- [-]` にする
- breakdown を更新したら、並列開始可能 task と直列 chain を再計算する

## Dependency Rules

- 実行順の制約は `blocked_by` で表す
- 依存がある場合は task note 本文にも `Relations` として書く
- 真に必要な依存だけ張り、不要な直列化を避ける
- `blocked_by` が空の sibling task は並列候補として扱う
- 依存先 task が完了した後も、`blocked_by` は履歴と依存メタデータとして残してよい

## Default Dependency Hints

- `ファイル・ディレクトリ構成案作成`、`API エンドポイント設計`、`デザイン要件定義`、`DB Schema作成`、`テストケース作成` は要求・要件整理が十分なら並列候補として扱う
- `デザインワイヤーフレーム作成` は `デザイン要件定義` に `blocked_by`
- `型・関数IO作成` は `ファイル・ディレクトリ構成案作成` に `blocked_by`
- API を持つ `型・関数IO作成` や `コード実装` は `API エンドポイント設計` にも `blocked_by`
- `型・関数IO作成` は既定で skeleton-first とし、可能なら task pattern template を使う
- `デザイン作成` は `デザインワイヤーフレーム作成` に `blocked_by`
- `コード実装` は `型・関数IO作成` に `blocked_by`
- UI 変更がある `コード実装` は `デザイン作成` にも `blocked_by`
- DB 変更がある `コード実装` は `DB Schema作成` にも `blocked_by`
- テスト観点が先に必要な `コード実装` は `テストケース作成` にも `blocked_by`
- `E2Eモンキーテスト実行` は `コード実装` に `blocked_by`

## Human Review Defaults

- `ファイル・ディレクトリ構成案作成`: true
- `API エンドポイント設計`: true
- `デザイン要件定義`: true
- `デザインワイヤーフレーム作成`: true
- `型・関数IO作成`: true
- `DB Schema作成`: true
- `テストケース作成`: true
- `デザイン作成`: false を初期値にし、必要なら true にする
- `コード実装`: false を初期値にし、必要なら true にする
- `E2Eモンキーテスト実行`: false を初期値にし、必要なら true にする

## Notes

- この文書は Obsidian 上の task 分解と依存のルールを定義する
- command の返却形式は `commands/task-breakdown.md` を正本とする
- task note の具体的な本文項目は template と `agents/task_manager.md` を参照する
