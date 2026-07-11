# joyan-claude-code

Claude Code のユーザーグローバル設定（commands, skills, agents）を Git で管理するためのリポジトリ。

## セットアップ

### 1. リポジトリをクローン

```bash
git clone git@github.com:joyan/joyan-claude-code.git
cd joyan-claude-code
```

### 2. シンボリックリンクを作成

`~/.claude` ディレクトリに各設定フォルダへのシンボリックリンクを作成します。

```bash
# 既存のディレクトリがある場合は先にバックアップ
# mv ~/.claude/commands ~/.claude/commands.bak
# mv ~/.claude/skills ~/.claude/skills.bak
# mv ~/.claude/agents ~/.claude/agents.bak

# シンボリックリンクを作成（リポジトリのルートで実行）
ln -s "$(pwd)/commands" ~/.claude/commands
ln -s "$(pwd)/skills" ~/.claude/skills
ln -s "$(pwd)/agents" ~/.claude/agents
```

### 3. 確認

```bash
ls -la ~/.claude
```

以下のようにシンボリックリンクが作成されていれば成功です：

```
commands -> /path/to/joyan-claude-code/commands
skills -> /path/to/joyan-claude-code/skills
agents -> /path/to/joyan-claude-code/agents
```

## ディレクトリ構成

```
joyan-claude-code/
├── commands/   # カスタムコマンド
├── skills/     # カスタムスキル
├── agents/     # カスタムエージェント
└── README.md
```

## 使い方

このリポジトリ内のファイルを編集すると、Claude Code に即座に反映されます。
変更を Git で管理し、複数マシン間で設定を同期できます。

## Advisor-Executor パターン

高コストモデル（Fable/Opus 高effort）を思考・計画・監査に限定し、実行を安価なモデルに
委譲するコスト最適化構成。参考: [Anthropic Advisor tool](https://platform.claude.com/docs/en/agents-and-tools/tool-use/advisor-tool)

### エージェント

| エージェント | モデル / effort | 役割 |
|-------------|----------------|------|
| `executor-lite` | Haiku / low | 機械的タスク（検索・リネーム・fmt・ボイラープレート） |
| `executor` | Sonnet / medium | 標準実装タスク（デフォルト実行役） |
| `executor-pro` | Opus / low | 複雑だが計画確定済みの実行（複数ファイル横断等） |
| `advisor` | Fable / xhigh | 行き詰まり・設計判断の相談役（読み取り専用） |
| `auditor` | Opus / high | 完了前の品質監査（読み取り専用） |

### スキル

| スキル | 用途 |
|--------|------|
| `/advisor-mode` | オーケストレーションモード起動。計画→委譲→相談→監査のループを規律化 |
| `/consult` | `advisor` への相談（2回失敗・設計分岐・高リスク操作時） |
| `/audit` | `auditor` による完了前監査（コミット・PR・完了報告の前に） |

### 運用ルール（要点）

- オーケストレーターは自分で実装しない（1〜2行の自明な修正を除く）
- Executor は同じエラーで2回失敗したら HELP_NEEDED で停止 → Advisor に相談
- 非自明な変更は Auditor の PASS を得てから完了報告
