---
name: deep-research
description: |
  Gemini Deep Research APIを使用した深層調査を実行。
  [Deep Researchして」「Deep Research」「DeepResearch」「詳しく調べて」「深く調査して」「包括的なレポートを作成」などのリクエストで使用。
  数百のWebサイトを自動探索し、Markdown形式の詳細レポートを生成する。
version: 1.0.0
---

# Deep Research Skill

複雑なトピックについてGemini Deep Research APIで深層調査を行う。

## 使用方法

```bash
uv run ${CLAUDE_SKILL_ROOT}/scripts/deep-research.py "<調査トピック>"

# ストリーミングモード
uv run ${CLAUDE_SKILL_ROOT}/scripts/deep-research.py "<調査トピック>" --stream
```

## 使用シーン

- 「〇〇について詳しく調べて」
- 「〇〇の最新動向をレポートにまとめて」
- 「〇〇と△△を比較分析して」

## 出力形式

Markdown形式のレポート（概要、詳細分析、結論、参照URL一覧）

## 前提条件

- Python 3.10以上
- uv（依存関係は自動インストール）

## 認証

以下のいずれか:

1. **API Key**: `export GEMINI_API_KEY="your-key"`
2. **ADC**: `gcloud auth application-default login`

## 制限事項

- 調査に数分〜最大60分かかる
- web-searchより時間がかかるが、より包括的な結果を返す
