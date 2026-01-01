#!/bin/bash

# Web Search Script using Gemini CLI
# Usage: ./web-search.sh "<search query>"

if [ -z "$1" ]; then
    echo "Error: 検索クエリを指定してください"
    echo "Usage: $0 \"<search query>\""
    exit 1
fi

QUERY="$1"

PROMPT="以下の質問についてWebから情報を検索し、詳細に回答してください。

質問: ${QUERY}

回答の形式:
- Markdown形式で回答してください
- 重要なポイントは箇条書きにしてください
- 最後に参照したURLの一覧を記載してください"

gemini --yolo --output-format json -p "$PROMPT"
