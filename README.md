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
