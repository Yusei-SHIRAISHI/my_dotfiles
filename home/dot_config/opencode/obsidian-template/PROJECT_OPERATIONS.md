# Project 作成・削除手順

この文書は project ごとの workspace を新規作成・削除する手順を定義する。

## Scope

- この手順の対象は Obsidian vault 内の note と directory
- 文中の path はすべて vault root からの相対 path
- `projects/`、`templates/`、`meta/` は vault 側の path を指す
- ここでの `project 作成` は vault 内の note 作成であり、software repo の編集手順ではない
- vault 自体が git 管理されている場合だけ、結果として git diff に現れることがある

## 新規 project 作成

### 1. project slug を決める

- 例: `mobile-app`, `billing-api`, `internal-tools`
- frontmatter の `project` 値、directory 名、meta path は同じ slug を使う

### 2. project workspace を作る

以下の vault path を作成する。

- `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/README.md`
- `projects/<project-slug>/meta/labels.md`
- `projects/<project-slug>/views/tasks.md`
- `projects/<project-slug>/views/epics.md`
- `projects/<project-slug>/views/stories.md`
- `projects/<project-slug>/closed-views/tasks.md`
- `projects/<project-slug>/closed-views/epics.md`
- `projects/<project-slug>/closed-views/stories.md`

### 3. template から初期化する

- ここで参照する `templates/` も vault 内の template note を指す
- `projects/<project-slug>/overview.md` は `templates/project.md` を使う
- `projects/<project-slug>/knowledge/README.md` は `templates/knowledge.md` を使う
- `projects/<project-slug>/meta/labels.md` は `templates/labels.md` を使う
- `projects/<project-slug>/views/tasks.md` は `templates/view-tasks.md` を使う
- `projects/<project-slug>/views/epics.md` は `templates/view-epics.md` を使う
- `projects/<project-slug>/views/stories.md` は `templates/view-stories.md` を使う
- `projects/<project-slug>/closed-views/tasks.md` は `templates/view-closed-tasks.md` を使う
- `projects/<project-slug>/closed-views/epics.md` は `templates/view-closed-epics.md` を使う
- `projects/<project-slug>/closed-views/stories.md` は `templates/view-closed-stories.md` を使う

### 4. overview と view を初期化する

- `projects/<project-slug>/overview.md` では、template 由来の `my-project` を対象 slug に置き換える
- 具体的には `id: my-project` を `id: <project-slug>` に変える
- 同じく `# my-project` を `# <project-slug>` に変える
- `projects/<project-slug>/views/*.md` と `projects/<project-slug>/closed-views/*.md` では、query 内の `<project-slug>` を対象 slug に置き換える
- 例: project slug が `billing-api` なら `project = "<project-slug>"` を `project = "billing-api"` に変える
- 必要なら `projects/<project-slug>/meta/labels.md` の初期値を project 用に調整する

### 5. 動作確認する

- `overview.md` から `knowledge/` と `views/` に辿れることを確認する
- `overview.md` から `closed-views/` にも辿れることを確認する
- `views/tasks.md` が対象 project の未完了 task を workflow_state ごとに分類していることを確認する
- `views/epics.md` / `views/stories.md` が `active/on_hold` を分類していることを確認する
- `closed-views/tasks.md` が `Done` と `Cancelled` を分けて表示していることを確認する
- `closed-views/epics.md` / `closed-views/stories.md` が `done/cancelled` を分けて表示していることを確認する
- `projects/<project-slug>/meta/labels.md` の link が解決することを確認する

### 6. 正本を作り始める

- `items/epics/` と `items/stories/` に必要な note を作る
- `items/tasks/` に task note を作る
- task note では `project: <project-slug>` を必ず設定する
- 未完了 task の状態分類は `workflow_state` で管理する

## project 削除

project 削除は 2 段階で考える。

- まず human-facing workspace を消す
- 正本である `items/` を消すかは別判断にする

### 1. 対象 project の task を整理する

- `project: <project-slug>` の task を確認する
- 未完了 task は完了するか `- [-]` にして cancelled にする
- `- [/]` または `- [x]` の task は原則として履歴として残す

### 2. project workspace を削除する

以下の vault path を削除する。

- `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/`
- `projects/<project-slug>/meta/labels.md`
- `projects/<project-slug>/views/`
- `projects/<project-slug>/closed-views/`

`projects/<project-slug>/` が空になったら directory ごと削除してよい。

### 3. 正本を残すか purge するか決める

通常は history を残すため、以下は削除しない。

- `items/epics/` の note
- `items/stories/` の note
- `items/tasks/` の note

完全に purge したい場合だけ、`project: <project-slug>` を持つ note を別途削除する。

### 4. purge の判断基準

以下に当てはまる場合だけ purge を検討する。

- 履歴を残す必要がない
- 他 note から参照されていない
- 完了済みまたは cancelled 済みである

迷う場合は purge せず、workspace だけ削除する。

## 推奨運用

- 新規作成や削除は、まずこの手順を正本にする
- OpenCode からは `/obsidian-project-create <project-slug>` と `/obsidian-project-remove <project-slug>` を使ってよい
- command を更新する場合も、この文書を更新してから追従させる
