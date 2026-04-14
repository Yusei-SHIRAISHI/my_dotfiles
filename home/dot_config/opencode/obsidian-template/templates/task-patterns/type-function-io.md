---
type: task
id: T001
project: <project-slug>
epic: <E001-or-empty>
story: <S001>
workflow_state: backlog
blocked_by: []
labels: []
human_review_required: true
---

- [ ] <T001 型・関数IO作成>

## Task

<対象モジュールの型・関数IO作成>

## Overview

<対象モジュールの入出力契約、型、関数シグネチャを先に確定し、後続のコード実装と review の土台を作る>

## Description

<対象モジュールについて、型定義、関数シグネチャ、必要なエラー型、interface / trait / protocol 境界を先に定義する。>
<この task では business logic を完成させず、review 可能な declaration-first の skeleton を作る。>

## Success criteria

- <必要な public / internal の型が定義されている>
- <必要な関数または method の引数と返り値が明示されている>
- <エラー型または失敗契約が明示されている>
- <skeleton code または declaration 群が後続実装に渡せる>

## Expected output

- <対象ファイルまたは module の skeleton code>
- <型一覧と主要関数の入出力契約>
- <未確定事項のメモ>

## Human review required

true

## Scope rules

- 型、関数IO、interface / trait / protocol、エラー契約の定義は行ってよい
- module 構成を整えるための最小限の file 追加は行ってよい
- business logic の実装、暫定 return、仮データ埋め込みは行わない
- skeleton は対象言語の慣習に沿った最小表現に留める
- declaration-first または未実装 stub だけを置き、実行ロジックは入れない

## Relations

- Blocked by:
  - <ファイル・ディレクトリ構成案作成 or API エンドポイント設計>
- Blocks:
  - <コード実装>

## References

- <関連 Story / API 設計 / 既存 module>
- [[../stories/S001-example-story]]

## Notes

- <対象言語での未実装表現や declaration-only 方針があればここに補足してよい>
