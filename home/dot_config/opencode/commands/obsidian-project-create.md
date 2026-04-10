Obsidian CLI を使って、指定された `<project-slug>` の project workspace を Obsidian vault 内に作成してください。

## 参照

- `obsidian-task-management` skill
- `obsidian-cli` skill
- `obsidian-markdown` skill
- `obsidian-template/PROJECT_OPERATIONS.md`

テンプレート:

- `obsidian-template/templates/project.md`
- `obsidian-template/templates/knowledge.md`
- `obsidian-template/templates/labels.md`
- `obsidian-template/templates/view-tasks.md`
- `obsidian-template/templates/view-epics.md`
- `obsidian-template/templates/view-stories.md`
- `obsidian-template/templates/view-closed-tasks.md`
- `obsidian-template/templates/view-closed-epics.md`
- `obsidian-template/templates/view-closed-stories.md`

## この command の役割

- `<project-slug>` を受け取って project workspace 一式を作成する
- 対象は Obsidian vault 内の note と directory とする
- path は vault root からの相対 path とする
- `PROJECT_OPERATIONS.md` の新規 project 作成手順に従って初期化する

## 作成する path

- `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/README.md`
- `projects/<project-slug>/meta/labels.md`
- `projects/<project-slug>/views/tasks.md`
- `projects/<project-slug>/views/epics.md`
- `projects/<project-slug>/views/stories.md`
- `projects/<project-slug>/closed-views/tasks.md`
- `projects/<project-slug>/closed-views/epics.md`
- `projects/<project-slug>/closed-views/stories.md`

## 実行ルール

- 引数は `<project-slug>` だけを必須とする
- slug が曖昧な場合だけ短い確認質問を 1 つ行う
- vault への操作は `obsidian` CLI 経由で行う
- すでに対象 path が存在する場合は、無条件に上書きせず現状を読んで不足分だけ補う
- `overview.md` では `id: my-project` と `# my-project` を `<project-slug>` に置き換える
- `views/*.md` と `closed-views/*.md` では query 内の `<project-slug>` を実際の slug に置き換える
- example 値や placeholder を残さない
- `items/epics/`、`items/stories/`、`items/tasks/` の note はこの command では作らない

## 返却内容

- 作成または更新した path 一覧
- `<project-slug>` に置換した箇所の要約
- 既存 file がありスキップまたは追記した場合はその内容

## ユーザー依頼

$ARGUMENTS
