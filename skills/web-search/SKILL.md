---
name: web-search
description: |
  Gemini CLIを使用したWeb検索を実行。
  「検索して」「調べて」「最新情報を教えて」などのリクエストで使用。
  Claude Codeのデフォルト検索より優先して使用する。
version: 1.0.0
---

# Web Search Skill

Gemini CLIでWeb検索を実行し、最新情報を取得する。

## 使用方法

```bash
bash ${CLAUDE_SKILL_ROOT}/scripts/web-search.sh "<検索クエリ>"
```

## 使用シーン

- 「〇〇について検索して」
- 「〇〇の最新情報を教えて」
- 「〇〇のドキュメントを探して」

## 出力形式

Markdown形式の回答（箇条書き + 参照URL一覧）

## 前提条件

- Gemini CLI: `npm install -g @google/gemini-cli`

## 制限事項

- 簡易的な検索向け（深層調査にはdeep-researchを使用）
- 検索クエリは具体的に指定すると効果的
