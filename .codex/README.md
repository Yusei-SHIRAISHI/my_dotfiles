# Codex Workflow Dotfiles

このディレクトリは Codex の共有用ワークフロー定義を管理します。

## 含めるもの
- `AGENTS.md`
- `agents/`
- `skills/`
- `rules/`
- `policy/`
- `config.example.toml`

## 含めないもの
- `auth.json`
- `config.toml`
- sqlite / sessions / logs / cache などのローカル実行状態
- `skills/.system/` と `bin/` のようなローカル導入物

## セットアップ
1. `~/.my_dotfiles/.codex` を配置した状態で `install.sh` を実行する
2. `~/.codex` が `~/.my_dotfiles/.codex` を向く symlink になることを確認する
3. `config.example.toml` を参考に、各 PC の `~/.codex/config.toml` を作成する
4. `auth.json`、各種 API key、MCP server 用 secret はローカルで設定する

## 注意
- `~/.codex` を丸ごと git 管理すると、会話履歴・ログ・内部 state まで混ざるため `.gitignore` で除外しています
- 既存の `~/.codex` が実体ディレクトリの場合、`install.sh` は timestamp 付き backup を作ってから symlink を張ります
