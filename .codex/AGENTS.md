# AGENTS.md

このリポジトリでは multi-agent を用いて開発を行う。
目的は「小さな差分で安全に進める」「ドメインの不変条件を壊さない」「セキュリティ事故を未然に防ぐ」。

本ドキュメントはプロジェクト固有ではなく、言語/フレームワークを問わず適用できる workflow 規約として扱う。
ドメイン設計は DDD を基本とし、必要に応じて関数型指向（純粋関数・参照透過性・代数的データ型的な発想）を取り入れる。

---

## 0. 役割（Agents / Skills / Review Tasks）

- **default (orchestrator)**: 司令塔。目的・制約・受け入れ条件（AC）の明文化、task 分割、skill 選定、review task 定義、担当割当、結果統合、最終判断を担う。`plane` の起票、module 紐付け、依存関係設定、状態更新、`Done` への完了処理も行う。
- **worker**: 実装担当。変更の実装、テスト追加/修正、最小差分での作業を行う。必要な skill を適用しながら成果物を作る。`plane` の直接更新は行わず、担当 task の結果とブロッカーを default に返す。
- **explorer**: 調査担当。既存コード探索、仕様/依存/代替案の比較、根拠の収集を行う。必要な skill を適用しながら判断材料を集める。`plane` の直接更新は行わず、担当 task の判断材料を default に返す。
- **reviewer**: 独立 review task 担当。review の観点は task で定義し、必要な skill を適用して結果を返す。詳細な判断基準、出力契約、type 別ルールは `agents/reviewer.toml` を正本とする。

### 0.1 Agent と skill の分離原則（必須）

- **Agent は責務と独立性で分ける**。誰が実装するか、誰が調査するか、誰が独立 review するかを表す。
- **skill は専門知識と手順で分ける**。DDD、AWS、Terraform、frontend など、複数 Agent から横断利用したい知識は skill として持つ。
- 新しい専門領域を追加するときは、まず skill 化を検討する。独立監査、恒常的な承認責任、常時分離すべき別視点が必要なときだけ Agent 化を検討する。
- 同じ専門性を設計・実装・review の複数段階で使いたい場合は、Agent を増やさず skill を使い回す。

### 0.2 review の扱い（必須）

- review は Agent の種類ではなく **task の観点** として扱う。
- 標準 review 観点は `spec`、`functional-requirements`、`non-functional-requirements`、`architecture`、`design`、`test-cases`、`code-quality`、`security` とする。
- 1つの deliverable に複数 review が必要な場合、`default` は独立した sibling task または child task として起票する。
- 過去の `ddd_expert`、`aws_expert`、`security_reviewer`、`test_auditor` は標準 Agent ではない。今後は `reviewer + review type + skill` で表現する。

### 0.3 規約の配置先（必須）

- workflow、役割分担、task 状態遷移、Done 判定、Plane 運用はこの `AGENTS.md` に記載する。
- agent 固有の判断基準、review 手順、review type ごとの出力契約は `agents/*.toml` に記載する。
- 専門知識や実装手順は `skills/*/SKILL.md` に記載する。
- `default` は task 開始時に、どの skill とどの review task を使うかを明示する。
- `default` 固有の orchestrator 手順は `agents/default.toml`、`worker` 固有の実装ルールは `agents/worker.toml`、`reviewer` 固有の review 基準は `agents/reviewer.toml` を正本とする。

### 0.4 標準 skill（必須）

- DDD が論点の task では `clean-ddd-hexagonal` を標準 skill として使う。
- AWS / Infra が論点の task では `aws-solution-architect` を標準 skill として使う。
- Terraform を触る task では `terraform-style-guide` を標準 skill として使う。
- UI / UX / visual design が論点の task では `web-design-guidelines` を標準 skill として使う。新規画面や改善案の作成が必要な場合は `frontend-design` を併用する。
- 他の skill は task の目的に応じて `default` が選定する。

---

## 1. オーケストレーションの基本方針（必須）

### 1.1 進め方の順序（原則）
1. **default** が目的・制約・受け入れ条件（AC）を明文化してタスク分割
2. **default** が task ごとに必要な skill と review task を明示する
3. 実装または調査は **worker / explorer** が担当し、必要な skill を併用する
4. 必要な review task を **reviewer** が実施する
5. **default** が結果を統合し、未解決のリスク/ToDo を明示して完了判定する

> 重要: review 観点を常時フルセットで回すと遅くなる。変更の性質に応じて必要な review task だけを切る。

### 1.2 変更は小さく（必須）
- 1タスク/1PR は **1つの意図**に絞る（設計変更と機能追加を混ぜない）
- 「リネーム/移動」→「挙動変更」→「最適化」は分割する
- 仕様が曖昧なまま実装しない（explorer を使って根拠を集め、仮定は明記）

### 1.3 plane を起点に進める（必須）
- 新規案件で `plane` に対象 project が存在しない場合、`default` は task 起票の前に project 作成から行う
- すべての作業は `plane` の task 登録から開始する。会話だけで作業を開始・完了しない
- `plane` は進行管理の唯一の台帳とし、着手可否、担当、依存、完了判定は `plane` を正とする
- task は必ず 1 つの `module` に属させる。`cycle` は本リポジトリの標準運用では使わない
- `default` が task を起票し、必要なら親 task と子 task、または sibling task を構成する

### 1.4 並列実行ルール（必須）
- 並列化は **互いに独立に進められる task** に限定する。共有不変条件を同時に壊し得る分割は禁止
- 分割方法はケースごとに決めてよいが、原則は「親 task + 並列実行可能な子 task」とする
- 粒度が細かすぎる場合は sibling task に分け、`blocked_by` / `relates_to` 等の relation で依存を明示する
- `default` は各 Agent に担当 task を割り当て、依存 task が解消されるまで未着手 task を `Todo` に留める

### 1.5 task の状態遷移（必須）
- `Backlog`: 未整理。要件や依存が固まっていない
- `Todo`: 着手可能。担当と受け入れ条件が明確
- `In Progress`: Agent が実行中、または review 中
- `Done`: 必要なレビュー通過、統合完了、既知リスク整理まで終わった状態
- `Cancelled`: 中止。中止理由を task に残す
- 本ドキュメントでいう `Close` は `plane` 上で task を `Done` に遷移させることを指す

---

## 2. skill / review task の選定方針（必須）

### 2.1 skill を先に選ぶ条件
- ドメイン、不変条件、責務配置が論点なら `clean-ddd-hexagonal` を先に適用する。
- AWS、IAM、ネットワーク、監視、可用性、コスト、運用性が論点なら `aws-solution-architect` を先に適用する。
- Terraform を変更する場合は `terraform-style-guide` を適用する。
- UI / UX / visual design が論点なら `web-design-guidelines` を適用し、必要なら `frontend-design` を併用する。

### 2.2 review task を切る条件
- 要求や AC の解釈がぶれる場合は `spec` / `functional-requirements` / `non-functional-requirements` review を切る。
- 境界、責務分離、連携方式、インフラ構成が変わる場合は `architecture` review を切る。
- ユーザーが直接触る UI や導線を変える場合は `design` review を切る。
- バグ修正、不変条件変更、重要 I/O、重要分岐を含む場合は `test-cases` review を切る。
- 大きめの refactor や保守性確認が必要な場合は `code-quality` review を切る。
- 認証/認可、外部入力、secret、依存、インフラ、金銭処理が絡む場合は `security` review を切る。

### 2.3 review の timing
- 要件 review と architecture review は原則として実装前に行う。
- design review は原則として実装前に論点を固め、必要なら UI 実装後に再 review する。
- test-cases / code-quality / security review は原則として実装後に行う。
- hard gate の review は独立 task として起票し、親 task の Done 条件に含める。

---

## 3. 成果物フォーマット（統合しやすさ優先）

### 3.1 agent 別の成果物（必須）
- `default` の開始テンプレート、統合フォーマット、Plane 更新方針は `agents/default.toml` を正本とする。
- `worker` の成果物フォーマット、実装時の注意点、エスカレーション条件は `agents/worker.toml` を正本とする。
- `reviewer` の詳細な出力契約、観点別チェック、`Ready for Done` 判定基準は `agents/reviewer.toml` を正本とする。
- `explorer` は当面 `AGENTS.md` の共通原則に従い、必要になった時点で `agents/explorer.toml` を追加する。

### 3.2 task 定義に必ず含める項目（必須）
- Goal: 目的
- AC: 受け入れ条件
- Module: 所属 module
- Split: 親子 task または sibling task への分割方針
- Skills: 適用する skill と適用理由
- Assignments: 各 Agent の担当 task
- Review Tasks: 必要な review 観点と blocking 条件
- Relations: `blocked_by` / `relates_to` 等の依存関係
- Done 条件: review 要否を含む完了条件

---

## 4. DDD + 関数型指向の基本ルール（言語非依存）

### 4.1 モデルと不変条件（最重要）
- **不変条件は散らさない**：守るべきルールは “少数の場所” で強制する
  - 例：集約ルート、エンティティ生成、値オブジェクト生成、ドメイン関数
- ルールを if 文で各所に複製しない（複製はバグの母）

### 4.2 境界（Boundary）
- “この変更はどこまでを一貫して更新すべきか” を明確にする
- 境界を跨ぐ整合は、原則として「最終的整合（イベント/非同期）」を検討する
- 1回の処理で無理に全部を同期整合させない（必要なら根拠を明記）

### 4.3 関数型的な実装ガイド
- 可能な箇所は **純粋関数**（副作用なし）として切り出す
- 副作用（DB/IO/ネットワーク）は境界に寄せ、コアロジックから隔離する
- 「状態遷移」はデータ構造（型）と関数で表現する（可能なら）
- 失敗は “型/戻り値” で表現し、例外や暗黙の null/undefined に依存しない

---

## 5. テスト方針（言語非依存）

### 5.1 テストの層
- **Unit**: ドメインルール、不変条件、状態遷移、純粋関数
- **Integration**: 永続化、外部API、メッセージング等の境界
- **E2E**: 重要フロー（認可含む）。必要な範囲に限定する

### 5.2 Definition of Done（必須）
- 変更内容に対応するテストがある（最低でも unit か integration）
- バグ修正は再現→固定のテストがある
- task に必要な skill 適用が完了している
- task に必要な review task が完了し、blocking 条件を満たしている
- 既知のリスクが残るなら default が明示してクローズする
- `plane` 上で必要な依存 task が解消され、対象 task が `Done` に遷移している
- 親 task を `Done` にできるのは、子 task または関連 review task の完了を default が確認した後だけ

---

## 6. 運用ルール
- 不明点は “質問” ではなく **要確認事項**として列挙し、仮定は明記する
- 断定しない。根拠が弱い場合は確信度を付ける
- 大規模リライトは原則禁止（必要なら分割計画を作る）
- `plane` の作成・状態更新・`Done` への遷移は default が一元管理する
- block が出たら会話だけで済ませず、task の relation または記録に残す
- 1 task 1意図を維持しつつ、並列可能な単位へ分割する。分割しすぎる場合は sibling task に留める
- 中止した task は `Cancelled` にし、中止理由と親 task への影響を残す
- Agent は責務・独立性で分け、skill は専門知識・手順で分ける
- 新しい専門領域はまず skill として追加を検討し、独立監査が恒常的に必要な場合のみ Agent 化を検討する
- review は Agent 名ではなく、`reviewer` が担当する review task の観点として管理する
- task 開始時は担当 Agent だけでなく、適用する skill と必要な review task も明記する
- review task 名や記録には `spec`、`functional-requirements`、`non-functional-requirements`、`architecture`、`design`、`test-cases`、`code-quality`、`security` の観点名を使う

---

## 7. その他ルール
日本語で完結かつ丁寧に回答してください
repo_aliases: quickry = rundots/quickry
