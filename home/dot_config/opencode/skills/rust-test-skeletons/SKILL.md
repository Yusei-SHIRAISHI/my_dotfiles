---
name: rust-test-skeletons
description: Generate Rust test-case skeletons only, using `#[ignore]` and `unimplemented!()` so implementation can be filled in later by review-driven development.
license: MIT
---

# Rust Test Skeletons

You create only test skeletons for Rust projects. This skill is used when the user wants:

- test cases first before implementation, especially for complex behavior
- test scaffolding for review-oriented planning
- a safe path to add many cases without breaking CI immediately
- consistent Rust test naming and structure for future implementation

Always use `#[ignore]`-first and keep each test as a skeleton using `unimplemented!()`. Do not write full assertions unless the user explicitly asks for production-ready tests.

This skill should be triggered for all requests about Rust test-case generation, planning test coverage, or converting requirements to test scaffolding.

## Core Constraints

- All generated test functions **must be in Japanese** (including function names and section headings inside generated skeleton comments).
- All generated test functions **must include `#[ignore]`** by default.
- All generated test functions **must contain `unimplemented!(...)`** in the body.
- Use `mod tests {}` conventions and keep one file focused on one unit target unless user requests a suite split.
- Do not emit executable assertions or fully implemented test logic unless explicitly requested.
- Preserve existing project style (module layout, helper functions, fixtures, and lint settings) when possible.
- Default output location:
  - unit tests: `#[cfg(test)] mod tests` in source file
  - integration tests: `tests/<feature>_test.rs`
- If an output path already exists, avoid duplicating test names.

## Inputs to Collect

1. **Target**
   - module / file path
   - function name(s) or type names to exercise
   - trait behavior or scenario description
2. **Scope**
   - unit | integration | both
   - priority (critical / important / medium / low)
   - expected number of cases (min, target)
3. **Output format**
   - same-file unit test module vs dedicated `tests/` file
   - naming prefix for ignored skeletons

If any required input is missing, ask one concise follow-up before generating output.

## Workflow

### Step 1: Interpret the target and test layers

From the requested function/feature, extract:

- normal behavior (happy path)
- exceptional behavior (error, validation failure, unauthorized, etc.)
- boundary values (0, 1, min/max, empty/non-empty, nil/None, off-by-one)
- edge combinations or state transitions

Classify each case by:

- `正常系` (expected path)
- `異常系` (error path)
- `境界値` (boundary)
- `回帰` (known issue/regression)
- `将来実装` (not yet implemented but needed soon)

### Step 2: Choose test function granularity

- 1 test function per behavior, keep tests single-purpose.
- For async behavior, generate `#[tokio::test]` and keep it `#[ignore]`.
- For panic behavior, use `#[should_panic]` only if the user explicitly requested it; otherwise keep comments only.

### Step 3: Generate Japanese-named skeletons

For each case, generate:

- descriptive Japanese test name in snake_case-like form
- concise purpose comment block with Arrange / Act / Assert placeholders
- `#[ignore = "...review by QA or design first..."]`
- `unimplemented!("TODO: ...")`

Example naming patterns:

- `fn 正常系_有効な入力で_結果が成功する()`
- `fn 異常系_空入力時に_エラーを返す()`
- `fn 境界値_配列が空のとき_失敗しないこと()`

### Step 4: Output by destination

- **Unit tests**: provide one complete Rust snippet for embedding in target file.
- **Integration tests**: provide one `tests/<feature>_test.rs` skeleton file and optional helper notes.
- Attach a short Japanese test-case index in markdown after the code block.

### Step 5: Confirm and summarize

End with:

1. 出力先
2. 生成したケース数
3. `ignore` 率（デフォルト 100%）
4. 実装優先度リスト（高→低）

## Required Test Skeleton Template

Use this exact style unless user asks for another structure.

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    #[ignore = "skeleton only: review-driven implementation required"]
    fn 正常系_有効な入力で_期待どおり成功する() {
        // Arrange
        // Act
        // Assert
        unimplemented!("TODO: 初期データ、実行処理、期待値を実装する");
    }

    #[test]
    #[ignore = "skeleton only: behavior is unimplemented"]
    fn 異常系_空文字列のとき_エラーを返す() {
        // Arrange
        // Act
        // Assert
        unimplemented!("TODO: 空文字列時のエラーケースを実装する");
    }

    #[test]
    #[ignore = "skeleton only: boundary case"]
    fn 境界値_上限超過時に_エラーを返す() {
        // Arrange
        // Act
        // Assert
        unimplemented!("TODO: 上限超過入力の境界テストを実装する");
    }

    #[test]
    #[ignore = "skeleton only: regression case"]
    fn 回帰_既知の不具合再発防止のため_再現テストを用意する() {
        // Arrange
        // Act
        // Assert
        unimplemented!("TODO: 再発防止向けのケースを実装する");
    }
}
```

For async targets:

```rust
#[tokio::test]
#[ignore = "skeleton only: async path"]
async fn 異常系_タイムアウト時に_再試行せず失敗する() {
    // Arrange
    // Act
    // Assert
    unimplemented!("TODO: async を使った再試行ロジックを実装する");
}
```

## Output format

Respond in one of two modes:

### Mode A: In-place unit skeleton
- Provide a single Rust code block for `#[cfg(test)] mod tests`.
- Do not overwrite existing file content; provide minimal diff-style guidance if requested.

### Mode B: New integration test file skeleton
- Provide markdown with target file path and full file contents.
- Include only skeleton tests and helper setup comments.

Always add a short index block in Japanese:

```text
## テストケース一覧（スケルトン）
- 正常系: N 件
- 異常系: N 件
- 境界値: N 件
- 回帰: N 件
- 将来実装: N 件
```

## Quality Rules

1. **Never generate executable assertions by default** (`assert_eq!`, `panic!`, etc. are optional only if requested).
2. **Never generate all-English test names**.
3. Keep generated tests as `#[ignore]` first by default (100% ignored unless the user explicitly requests implementation-ready tests).
4. If the user requests implementation tests, remove `unimplemented!()` only after collecting concrete expected behavior.
5. Keep generated names descriptive enough for git review and bug reproduction.
6. Prefer small focused tests over broad combined assertions.

## Common Test Case Categories for Rust

- `正常系`: success path, main API/logic flow
- `異常系`: invalid input, missing context, permission error, timeout paths
- `境界値`: empty, zero, one, max, min, boundary transitions
- `並行系`: lock, race, duplicate access, idempotence
- `状態遷移`: start -> in progress -> success/failure
- `将来実装`: expensive, unknown, and feature-flagged paths

## Notes

- If comments include symbols, keep them short and avoid emoji.
- Use markdown headings and fenced code blocks to keep output copy-friendly.
