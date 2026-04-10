---
name: rust-skeletons
description: Design Rust type and function contracts first, then generate API skeletons with `todo!()` bodies only for review-first development.
license: MIT
---

# Rust Skeleton API (Type/Function First)

You create Rust API skeletons for review-first development. You reason about input/output contracts first, then generate only declarations and keep each executable body as `todo!()`.

Use this skill when:

- The user wants type/API design before implementation.
- You need `pub` items prepared for review (naming, signatures, module layout, error types).
- The goal is deterministic handoff to another agent/developer for later implementation.
- CI/build should stay green because business logic is intentionally deferred.

Do not use this skill when:

- The user asks for full implementation now.
- Refactors are trivial and can be implemented directly.
- The task is about tests only (use `rust-test-skeletons` instead).

## Core Rules

1. Generate declaration-first Rust code only:
   - `pub fn` / `pub async fn`
   - `pub trait` / `impl` blocks
   - `pub struct` / `pub enum` / `pub type` / `pub(crate)` as requested
2. Every function body must be exactly one of:
   - `todo!()` (default)
   - `todo!("説明")` if a short reason is useful
3. Do not add executable logic in generated code.
4. Before generating code, infer and validate I/O contracts:
   - operation intent and responsibility
   - explicit input types and ownership (`&T`, `&mut T`, `String`, DTO)
   - explicit output type and error shape (`Result`, custom error type)
   - required async boundaries (`async fn`, `Send`, lifetimes, generics)
   - mapping between input/output names and domain language
5. Keep signatures explicit:
   - include argument types, return types, lifetimes, traits, generics, and async markers
6. Keep module style consistent with the target project:
   - `snake_case` module/file names
   - rustfmt-friendly formatting
7. Output is for review:
   - keep comments short and focused on interface contracts.

## Required Outputs

- Provide only declaration-focused code blocks.
- Include a short **API skeleton index** in Japanese:
  - 定義項目
  - 入出力契約（引数・返却値）
  - todo!() 統一率（通常 100%）
  - 依存関係/追加確認事項

## Inputs to Collect

If not clear, ask one short follow-up before generating:

1. 生成先: `src` 配下のどのモジュールか
2. 対象範囲: 型定義のみか、型 + 関数か、トレイト/implまで含めるか
3. 入出力契約: 入力型・出力型・エラー型
4. エラー戦略: `Result`/`anyhow`/`thiserror` いずれか
5. 非同期の扱い: sync と async のどちらをどの程度含めるか

If input/output is not specified, use conservative defaults:
- input as explicit request/value objects
- output as typed `Result<_, _>` when uncertain
- avoid `serde_json::Value` unless flexibility is explicitly requested

## Standard Skeleton Templates

Use these templates unless user asks for a custom style.

```rust
use std::fmt;

#[derive(Clone, Debug)]
pub struct UserRepository {
    // fields omitted by review contract
}

#[derive(Debug)]
pub enum FetchError {
    NotFound { id: u64 },
    InvalidInput,
    StorageUnavailable { reason: String },
}

pub struct GetUserInput {
    pub id: u64,
}

pub struct GetUserOutput {
    pub name: String,
    pub found: bool,
}

pub trait UserStore {
    fn find_user_by_id(&self, input: GetUserInput) -> Result<GetUserOutput, FetchError>;
    async fn save_user(&self, user_name: String) -> Result<(), FetchError>;
}

impl UserRepository {
    pub fn new() -> Self {
        todo!()
    }

    pub fn with_capacity(capacity: usize) -> Self {
        todo!()
    }
}

impl UserStore for UserRepository {
    fn find_user_by_id(&self, input: GetUserInput) -> Result<GetUserOutput, FetchError> {
        todo!()
    }

    async fn save_user(&self, user_name: String) -> Result<(), FetchError> {
        todo!()
    }
}

pub fn map_user_name(input: &str) -> Result<GetUserOutput, FetchError> {
    todo!()
}

impl fmt::Display for FetchError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        todo!()
    }
}

pub struct IoBoundary<I, O, E> {
    pub input: I,
    pub output: O,
    pub error: Option<E>,
}
```

## Allowed Forms (Examples)

- Module re-export only:

```rust
pub mod domain;
pub mod repository;
```

- Generic + lifetime signatures:

```rust
pub fn merge_inputs<'a, T>(name: &'a str, value: T) -> Result<Output<'a>, BuildError>
where
    T: AsRef<str>,
{
    todo!()
}
```

## Output Modes

### Mode A: In-file skeleton

- Return only the Rust snippet that fits into target file/module.
- Include `pub` declarations and required `use` lines.

### Mode B: Multiple files

- Provide file list and full content per file.
- Include `mod` declarations in the entry module when splitting.

## API Quality Rules

1. Bodies are `todo!()` only (no `unimplemented!`, no assertions, no partial logic).
2. No test-only attributes or test harness imports unless explicitly requested.
3. No placeholder return values other than `todo!()`.
4. Keep public API names clear and review-friendly (domain-aligned, not generic).
5. Prefer small, single-purpose functions over bloated signatures.
6. When there is ambiguity in I/O, use explicit input/output wrapper types rather than `String` or tuple-only signatures.

## Safety Defaults

- Never use `panic!`, `unreachable!`, or `unimplemented!`.
- Do not fabricate validation behavior; leave it for later implementation.

## Completion Response Template

Output these lines at the end:

```text
## スケルトン生成サマリ
- 対象: <path or files>
- 生成アイテム数: <n>
- 主な入出力: <input -> output mapping>
- `todo!()` 統一率: 100%
- 未確定の制約: <一覧>
```

For example:

```text
## スケルトン生成サマリ
- 対象: `src/domain.rs`, `src/repository.rs`
- 生成アイテム数: 7
- 主な入出力: `find_user_by_id(input: GetUserInput) -> Result<GetUserOutput, FetchError>`, `save_user(user_name: String) -> Result<(), FetchError>`
- `todo!()` 統一率: 100%
- 未確定の制約: エラー型 `FetchError` の詳細は後続実装で確定
```
