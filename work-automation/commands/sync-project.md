# プロジェクト状態同期

## 使用方法
```
/sync [project-code]
```

## 処理フロー

### Step 1: プロジェクト検証
指定された `project-code` が `projects/` に存在するか確認

### Step 2: ソース定義読み込み
`projects/{project-code}/sources.yaml` を読み込み

### Step 3: 情報収集

#### カレンダー
- `meetings` セクションの `calendar_pattern` で今週のミーティングを検索
- 各ミーティングの `docs` から関連ドキュメントURLを取得

#### Slack
- `slack.channels` から監視対象チャンネルの直近メッセージを取得
- `slack.threads` の進行中スレッドの更新を確認
- 重要なメッセージ（メンション、決定事項、アクションアイテム）を抽出

#### ドキュメント
- `documents.confluence` の各ページの更新を確認
- `documents.google_drive` の各ファイルの更新を確認

### Step 4: 状態更新

#### state/decisions.md
新しい意思決定を追記:
```markdown
### [DEC-XXX] {決定事項タイトル}
- **日付**: {date}
- **決定事項**: {内容}
- **背景**: {なぜこの決定に至ったか}
- **影響**: {この決定の影響}
- **ソース**: {情報源}
```

#### state/actions.md
アクションアイテムを更新:
- 新規追加
- ステータス変更
- 期限変更
- 完了への移動

#### state/last_sync.json
同期状態を更新:
```json
{
  "last_sync": "ISO8601 timestamp",
  "sources_checked": {
    "calendar": true,
    "slack": true,
    "documents": true
  },
  "stats": {
    "new_decisions": 1,
    "updated_actions": 2,
    "new_actions": 1
  }
}
```

### Step 5: サマリー出力

```markdown
# Sync Complete - {project-code}

**同期時刻**: {timestamp}

## 更新内容
- 新規意思決定: 1件
- 新規アクション: 1件
- 更新アクション: 2件

## 新しい意思決定
- [DEC-002] {タイトル}

## アクションアイテム変更
- [AP-003] 新規追加: {タイトル}
- [AP-001] ステータス変更: not_started → in_progress

## 注意事項
- {重要なメッセージやフラグがあれば表示}
```

$ARGUMENTS
