# Task Pattern Templates

このディレクトリは、繰り返し出現する task pattern 用の template を置く。

- 共通契約は `../task.md` を正本とする
- pattern template でも、共通の frontmatter と section を満たす
- pattern 固有の実行意図は `Description`、`Success criteria`、`Scope rules`、`Notes` で表現する
- 新しい pattern を追加するときは、共通 template を壊さず最小差分で拡張する

## Current Templates

- `type-function-io.md`
  - 型、関数シグネチャ、エラー契約を先に定義する task 用
  - declaration-first / skeleton-first の進め方を前提にする

## Usage

- 汎用 task は `../task.md` を使う
- 繰り返し出る task pattern だけ、この配下の template を使う
- `task-breakdown` で pattern が明確なら、対応する pattern template を優先してよい
