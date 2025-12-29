# joyan-claude-code

Claude Code のユーザーグローバル設定（commands, skills, agents）を Git で管理するためのリポジトリ。

## セットアップ

### 1. リポジトリをクローン

```bash
cd ~/Development
git clone git@github.com:joyan/joyan-claude-code.git
```

### 2. シンボリックリンクを作成

`~/.claude` ディレクトリに各設定フォルダへのシンボリックリンクを作成します。

```bash
# 既存のディレクトリがある場合は先にバックアップ
# mv ~/.claude/commands ~/.claude/commands.bak
# mv ~/.claude/skills ~/.claude/skills.bak
# mv ~/.claude/agents ~/.claude/agents.bak

# シンボリックリンクを作成
ln -s ~/Development/joyan-claude-code/commands ~/.claude/commands
ln -s ~/Development/joyan-claude-code/skills ~/.claude/skills
ln -s ~/Development/joyan-claude-code/agents ~/.claude/agents
```

### 3. 確認

```bash
ls -la ~/.claude
```

以下のようにシンボリックリンクが作成されていれば成功です：

```
commands -> /Users/shinichiro.joya/Development/joyan-claude-code/commands
skills -> /Users/shinichiro.joya/Development/joyan-claude-code/skills
agents -> /Users/shinichiro.joya/Development/joyan-claude-code/agents
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
