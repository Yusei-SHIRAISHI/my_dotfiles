---
name: obsidian-task-management
description: Common workflow for managing Obsidian Epic, Story, and task notes with Obsidian Tasks and Dataview. Use this whenever the user asks to create or update an Obsidian task-management vault, organize items/epics/items/stories/items/tasks, maintain projects/<slug>/views or closed-views, set workflow_state or blocked_by, or manage Epic/Story/task frontmatter. Also trigger on Japanese requests mentioning Obsidian, タスク管理, Epic, Story, task note, workflow_state, blocked_by, views, closed-views, frontmatter, Dataview, or Obsidian Tasks.
---

# Obsidian Task Management

## Purpose

- 人間は Obsidian Tasks と Dataview で一覧・更新する
- AI は `obsidian-cli` と Markdown 編集で task 管理を保守する
- AI 管理の task 情報は vault 内の決まったディレクトリ構造に集約する

## Preconditions

- 対象は Obsidian vault 内の note と directory とする
- 対象 vault 名は `task-manage` を既定とする
- path は vault root からの相対 path として扱う
- Obsidian desktop app が起動している
- `obsidian-cli` が PATH から実行できる
- OpenCode 側で `obsidian-cli` と `obsidian-markdown` skill を利用できる

## Tooling

- vault の read、search、create、append、property 更新は `obsidian-cli` skill に従って `obsidian-cli` を使う
- note の本文や frontmatter の整形は `obsidian-markdown` skill に従う
- この skill は vault layout、metadata、status semantics の正本として使う
- vault 指定が曖昧な場合は `task-manage` を対象 vault として扱う

## Directory Layout

- `items/epics/`: Epic note
- `items/stories/`: User Story note
- `items/tasks/`: executable な task note
- `projects/<project-slug>/overview.md`: project overview note
- `projects/<project-slug>/knowledge/`: project 固有の知識メモ
- `projects/<project-slug>/meta/labels.md`: project 固有 label の辞書
- `projects/<project-slug>/views/`: 進行中の Tasks query や Dataview note
- `projects/<project-slug>/closed-views/`: 完了・中止済みの Tasks query や Dataview note
- `templates/`: Obsidian 側で使う note template
- `meta/`: phases、workflow、statuses などの共通辞書

標準構造:

- `items/epics/E001-<slug>.md`
- `items/stories/S001-<slug>.md`
- `items/tasks/T001-<slug>.md`
- `projects/<project-slug>/overview.md`
- `projects/<project-slug>/knowledge/README.md`
- `projects/<project-slug>/meta/labels.md`
- `projects/<project-slug>/views/tasks.md`
- `projects/<project-slug>/views/epics.md`
- `projects/<project-slug>/views/stories.md`
- `projects/<project-slug>/closed-views/tasks.md`
- `projects/<project-slug>/closed-views/epics.md`
- `projects/<project-slug>/closed-views/stories.md`
- `meta/phases.md`
- `meta/statuses.md`
- `meta/workflow.md`

## Source Of Truth

- Epic と Story の要約は `items/` 配下の note を正本とする
- 実行単位の詳細と依存は `items/tasks/` 配下の task note を正本とする
- project 全体の概要は `projects/<project-slug>/overview.md` に置く
- project 固有の長期的な知識メモは `projects/<project-slug>/knowledge/` に置く
- Epic と Story の lifecycle status は各 note の frontmatter `status` を正本とする
- view は metadata、`workflow_state`、checkbox から再構築できる一覧であり、正本にしない
- task の完了状態は task note 内の Obsidian Tasks checkbox を正本とする
- task の未完了状態分類は task note の `workflow_state` を正本とする

## Frontmatter Rules

- YAML frontmatter は必ずファイル先頭に置く
- frontmatter より前に見出し、説明文、空行以外の内容を置かない
- Dataview で読む metadata は frontmatter に置く

## Metadata Rules

- Project note は少なくとも `type: project`、`id` を持つ
- Epic note は少なくとも `type: epic`、`id`、`project`、`status` を持つ
- Story note は少なくとも `type: story`、`id`、`project`、`status` を持ち、必要なら `epic` を持つ
- Task note は少なくとも `type: task`、`id`、`project`、`workflow_state` を持ち、必要なら `story`、`epic`、`blocked_by`、`labels` を持つ
- Epic / Story の `status` は `active`、`on_hold`、`done`、`cancelled` を使う
- `workflow_state` は `icebox`、`backlog`、`in_progress`、`human_review`、`pending` を使う
- `workflow_state` は未完了 task の状態分類を表し、完了状態は表さない
- `labels` は `projects/<project-slug>/meta/labels.md` で project ごとに定義してよい

## View Semantics

- `projects/<project-slug>/views/tasks.md` では `workflow_state` ごとに未完了 task を分類する
- `projects/<project-slug>/views/epics.md` では `active` と `on_hold` を分類する
- `projects/<project-slug>/views/stories.md` では `active` と `on_hold` を分類する
- `projects/<project-slug>/closed-views/tasks.md` では `Done` と `Cancelled` を表示する
- `projects/<project-slug>/closed-views/epics.md` では `done` と `cancelled` を表示する
- `projects/<project-slug>/closed-views/stories.md` では `done` と `cancelled` を表示する

## Status Rules

- `- [ ]` を未着手に使う
- `- [/]` を着手中に使う
- `- [x]` を完了に使う
- `- [-]` を不要化または cancelled に使う
- task note に別の status field を重複して持たせない
- `done` と `cancelled` は `workflow_state` に持たせない
- cancelled task は `- [-]` を正本とし、標準の state view からは通常除外してよい

## Working Style

- 人間向けの補足や作業ログは note 本文に追記する
- 依存、review 条件、実行契約は task note に残す
- template から note を作る場合は、template 由来の example 値や placeholder を実データへ置換する
- `overview.md` は入口 note として保ち、詳細一覧は `views/` と `closed-views/` に寄せる

## When Acting On A User Request

- project 作成依頼では `overview.md`、`knowledge/README.md`、`meta/labels.md`、`views/*.md`、`closed-views/*.md` を揃える
- task 作成・更新依頼では `items/tasks/` 配下を正本として扱う
- Epic / Story の追加や変更では `status` と `project` の整合を保つ
- query や link を更新するときは、`items/tasks/`、`views/`、`closed-views/` の path を崩さない
