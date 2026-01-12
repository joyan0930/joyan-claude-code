# Jo's Work Automation - Orchestrator

## 目的
複数プロジェクトの情報を統合し、毎朝のブリーフィングと
アクションアイテム管理で認知負荷を最小化する。

## プロジェクト構造
各プロジェクトは `projects/{project-code}/` に格納:
- `context.md`: 戦略・背景・前提知識
- `sources.yaml`: インプットソース定義
- `state/`: 自動更新される状態ファイル

## サブエージェント実行
プロジェクト固有の処理はサブエージェントに委譲:

```bash
claude --cwd projects/{project-code} -p "..."
```

## MCP サーバー

- google-workspace: Calendar, Docs, Drive
- slack: チャンネル、スレッド、ユーザー
- confluence: ページ取得
- bigquery: 状態永続化

## 日次ワークフロー

1. 全プロジェクトの sources.yaml を読み込み
2. 今日のカレンダーからミーティング抽出
3. 各プロジェクトのサブエージェントで:
   - 関連 Docs の更新差分取得
   - Slack の重要メッセージ抽出
   - アクションアイテム更新
4. 統合ブリーフィング生成

## コマンド一覧

- `/morning` - 朝のブリーフィング生成
- `/sync [project]` - 特定プロジェクトの状態同期
- `/actions` - 全プロジェクトのアクションアイテム一覧

## プロジェクトステータス

| プロジェクト | コード | ステータス | 優先度 |
|-------------|--------|-----------|--------|
| データプラットフォーム刷新 | data-platform | active | high |
| 組織ブランディング | org-branding | active | medium |
| Looker Analytics Agent | looker-analytics-agent | active | medium |
