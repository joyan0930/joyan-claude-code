# Work Automation - Morning Orchestrator

複数プロジェクトの情報を統合し、毎朝のブリーフィングとアクションアイテム管理で認知負荷を最小化するシステム。

## アーキテクチャ

```
┌─────────────────────────────────────────────────────────────┐
│                   Morning Orchestrator                       │
│            (Claude Code メインエージェント)                    │
└─────────────────────────────────────────────────────────────┘
                              │
         ┌────────────────────┼────────────────────┐
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ Project Agent   │  │ Project Agent   │  │ Project Agent   │
│ data-platform   │  │ org-branding    │  │ looker-agent    │
├─────────────────┤  ├─────────────────┤  ├─────────────────┤
│ context.md      │  │ context.md      │  │ context.md      │
│ sources.yaml    │  │ sources.yaml    │  │ sources.yaml    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

## セットアップ手順

### Step 1: MCP サーバーの設定

`~/.claude/settings.json` または プロジェクトの `.mcp.json` に以下のMCPサーバーを追加:

```json
{
  "mcpServers": {
    "google-workspace": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-google-workspace"],
      "env": {
        "GOOGLE_CLIENT_ID": "your-client-id",
        "GOOGLE_CLIENT_SECRET": "your-client-secret"
      }
    },
    "slack": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-slack"],
      "env": {
        "SLACK_BOT_TOKEN": "xoxb-your-token"
      }
    },
    "confluence": {
      "command": "npx",
      "args": ["-y", "@anthropic/mcp-confluence"],
      "env": {
        "CONFLUENCE_URL": "https://your-domain.atlassian.net",
        "CONFLUENCE_API_TOKEN": "your-api-token"
      }
    }
  }
}
```

### Step 2: プロジェクトの設定

#### 2-1. テンプレートをコピー

```bash
cp -r projects/_template projects/your-project-name
```

#### 2-2. context.md を編集

プロジェクトの背景・戦略・技術コンテキストを記述:

```markdown
# プロジェクト名

## 戦略的位置づけ
このプロジェクトの組織における位置づけ

## ビジネス目標
- 目標1
- 目標2

## 技術コンテキスト
現在の技術スタックや制約事項

## 意思決定の原則
- コスト効率 > 機能網羅性
- 自動化 > 手動運用
```

#### 2-3. sources.yaml を編集

情報ソースを定義:

```yaml
project:
  name: プロジェクト名
  code: project-code
  status: active
  priority: high

meetings:
  - name: 定例ミーティング名
    calendar_pattern: "カレンダー検索パターン"
    frequency: weekly
    day: tuesday
    docs:
      - type: agenda
        url: https://docs.google.com/document/d/xxx

slack:
  channels:
    - id: C_CHANNEL_ID
      name: "#channel-name"
      watch: true

documents:
  confluence:
    - title: ドキュメント名
      url: https://example.atlassian.net/wiki/xxx
      type: architecture

stakeholders:
  owner: owner@example.com
  members:
    - name: 田中
      slack: "@tanaka"
      role: Tech Lead
```

### Step 3: CLAUDE.md にプロジェクトを追加

`work-automation/CLAUDE.md` のプロジェクト一覧テーブルに追加:

```markdown
| プロジェクト名 | project-code | active | high |
```

## 使い方

### 朝のブリーフィング生成

```bash
cd ~/path-to/work-automation
claude "/morning"
```

**出力例:**
```markdown
# Daily Briefing - 2025-01-13

## 今日のスケジュール
| 時間 | ミーティング | プロジェクト | 準備事項 |
|------|-------------|-------------|---------|
| 10:00 | データ基盤定例 | data-platform | アジェンダ要確認 |

## プロジェクト別サマリー
### data-platform: データプラットフォーム刷新
**直近の意思決定:**
- 2025-01-10: Redshift 移行を Q3 に延期

**アクションアイテム:**
- 今週期限: コスト削減施策の優先順位付け (@jo, 1/15)
```

### 特定プロジェクトの同期

```bash
claude "/sync data-platform"
```

プロジェクトの最新情報を取得し、`state/` ディレクトリを更新:
- `decisions.md`: 新しい意思決定を追記
- `actions.md`: アクションアイテムを更新
- `last_sync.json`: 同期状態を記録

### アクションアイテム一覧

```bash
# 全アクション
claude "/actions"

# 期限切れのみ
claude "/actions overdue"

# 今週期限のみ
claude "/actions this-week"

# 自分担当のみ
claude "/actions mine"

# 特定担当者
claude "/actions @tanaka"
```

## ディレクトリ構造

```
work-automation/
├── CLAUDE.md                    # オーケストレーター指示
├── README.md                    # このファイル
├── projects/
│   ├── _template/               # 新規プロジェクト用テンプレート
│   │   ├── context.md
│   │   └── sources.yaml
│   ├── {project-code}/
│   │   ├── CLAUDE.md            # プロジェクト固有指示
│   │   ├── context.md           # 戦略・背景・前提
│   │   ├── sources.yaml         # インプットソース定義
│   │   └── state/
│   │       ├── decisions.md     # 意思決定ログ (自動更新)
│   │       ├── actions.md       # アクションアイテム (自動更新)
│   │       └── last_sync.json   # 最終同期状態
├── outputs/
│   └── daily/                   # 日次ブリーフィング出力
└── commands/
    ├── morning.md               # /morning コマンド定義
    ├── sync-project.md          # /sync [project] コマンド定義
    └── actions.md               # /actions コマンド定義
```

## ファイルフォーマット

### state/actions.md

```markdown
# Actions - project-code

## Open

### [AP-001] アクションタイトル
- **担当**: @username
- **期限**: 2025-01-15
- **ステータス**: in_progress  # not_started | in_progress
- **ソース**: 2025-01-08 定例ミーティング
- **コンテキスト**: 背景情報
- **更新履歴**:
  - 2025-01-08: 作成
  - 2025-01-10: ステータス変更

## Completed

### [AP-000] 完了したアクション
- **担当**: @username
- **完了**: 2025-01-10
- **結果**: 完了時の結果や成果物
```

### state/decisions.md

```markdown
# Decisions - project-code

## 2025-01

### [DEC-001] 決定事項タイトル
- **日付**: 2025-01-10
- **決定事項**: 何を決定したか
- **背景**: なぜこの決定に至ったか
- **影響**: この決定の影響範囲
- **承認**: 誰が承認したか
- **ソース**: 情報源 (ミーティング名など)
```

## Tips

### 新しいプロジェクトを追加する

```bash
# 1. テンプレートをコピー
cp -r projects/_template projects/new-project

# 2. ファイルを編集
# - projects/new-project/context.md
# - projects/new-project/sources.yaml

# 3. CLAUDE.md のテーブルに追加
```

### 手動でアクションを追加する

`state/actions.md` を直接編集してアクションを追加可能。
次回の `/sync` 時に自動検出されたアクションとマージされる。

### サブエージェントとして実行

特定プロジェクトのコンテキストでClaude Codeを実行:

```bash
claude --cwd projects/data-platform -p "BigQueryのコスト削減について調べて"
```

プロジェクト固有の `CLAUDE.md` と `context.md` がコンテキストとして読み込まれる。
