# Vault への導入手順

## 必須 plugin

- `Tasks`: task の一覧、絞り込み、進捗確認に使う
- `Dataview`: Epic / Story / Task の一覧 view を作るために使う

## 前提

- Obsidian desktop app をインストールし、対象 vault を開ける状態にする
- 対象 vault 名は `task-manage` とする
- `obsidian-cli` が PATH から実行できるようにする
- OpenCode 側には `obsidian-cli` と `obsidian-markdown` skill を `~/.config/opencode/skills/` 配下に配置する

## 1. テンプレートを vault にコピーする

- `obsidian-template/` 配下の内容を `task-manage` vault のルートにコピーする
- 既存構成がある場合は、必要なディレクトリだけマージする
- 以後この文書に出てくる path は、コピー先の Obsidian vault 側の path を指す

## 2. Obsidian plugin を有効化する

- Community Plugins で `Tasks` を有効化する
- `Dataview` を有効化する

このテンプレートでは上記 2 つを必須とする。

## 3. OpenCode の skill と CLI を確認する

- `kepano/obsidian-skills` を参照し、必要な `SKILL.md` を `~/.config/opencode/skills/<name>/SKILL.md` に配置する
- OpenCode を再起動して skill を再読込する
- `which obsidian-cli` を実行して CLI の場所を確認する
- Obsidian app を起動した状態で `obsidian-cli help` を実行する
- AI 側の共通運用ルールは `obsidian-task-management` skill を使う

## 4. 初期 note を整える

- `projects/<project-slug>/overview.md` を `templates/project.md` から作る
- `projects/<project-slug>/knowledge/README.md` を `templates/knowledge.md` から作る
- `projects/<project-slug>/views/` に `tasks.md` / `epics.md` / `stories.md` を作る
- `projects/<project-slug>/closed-views/` に `tasks.md` / `epics.md` / `stories.md` を作る
- `projects/<project-slug>/meta/labels.md` を `templates/labels.md` から作る
- `items/epics/` と `items/stories/` は必要になった時点で作る
- `items/tasks/` に executable な task note を作る
- task pattern が繰り返し出る場合は `templates/task.md` だけでなく `templates/task-patterns/` 配下の専用 template を使ってよい
- pattern template を追加した場合は `templates/task-patterns/README.md` も更新する

## 5. AI で task を作成・更新する

- OpenCode の `/task-breakdown` command を使う
- 生成された note を人間が Obsidian 上で確認する

## 6. 人間の運用

- task の進行状態は checkbox で更新する
- 補足メモや判断理由は note 本文に追記する
- `projects/<project-slug>/views/` を進行中の主画面として使う
- `projects/<project-slug>/closed-views/` を完了・中止済みの確認に使う

## 7. project の追加・削除

- `PROJECT_OPERATIONS.md` を参照する
- OpenCode では `/obsidian-project-create <project-slug>` と `/obsidian-project-remove <project-slug>` を使ってよい
