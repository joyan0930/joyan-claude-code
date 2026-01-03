---
name: create-git-worktree
description: |
  Git worktreeを使用して、ブランチごとの独立した作業ディレクトリを作成。
  「worktree作成」「ブランチを分離」「並行開発環境を作成」などのリクエストで使用。
  .git-worktrees/ ディレクトリ配下にworktreeを作成し、環境設定ファイルも自動コピー。
version: 1.0.0
---

# Create Git Worktree Skill

Git worktreeを使用して、ブランチごとの独立した作業環境を自動セットアップする。

## 使用方法

```bash
bash ${CLAUDE_SKILL_ROOT}/scripts/create-worktree.sh <branch-name>
```

## 使用シーン

- 「feature/xxx ブランチのworktreeを作成して」
- 「並行開発用の環境を作って」
- 「このブランチを別ディレクトリで作業したい」

## 機能

- デフォルトブランチから最新コードを取得
- `.git-worktrees/<branch-name>` にworktreeを作成
- ブランチ名のスラッシュはハイフンに変換
- 既存worktreeがあれば再利用
- `.env` ファイルを自動コピー
- `.env.keys` (dotenvx) ファイルを自動コピー
- Docker Compose設定があれば自動ビルド

## 出力

作成されたworktreeのパスと次のステップの案内

## 前提条件

- Git 2.5以上（worktree機能が必要）
- Gitリポジトリ内で実行

## クリーンアップ

worktreeを削除する場合:

```bash
git worktree remove .git-worktrees/<branch-name>
```
