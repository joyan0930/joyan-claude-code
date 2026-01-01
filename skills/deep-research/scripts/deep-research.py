#!/usr/bin/env python3
# /// script
# requires-python = ">=3.10"
# dependencies = [
#     "google-genai>=1.0.0",
# ]
# ///
"""
Deep Research Script using Gemini Deep Research API
Usage: uv run deep-research.py "<research topic>" [--stream]
"""

import sys
import os
import time
import argparse

from google import genai


def _create_client():
    """
    Gemini APIクライアントを作成
    優先順位:
    1. GEMINI_API_KEY 環境変数
    2. Application Default Credentials (ADC)
    """
    api_key = os.environ.get("GEMINI_API_KEY")

    if api_key:
        print("認証: API Key を使用", file=sys.stderr)
        return genai.Client(api_key=api_key)

    # ADCを使用（gcloud auth application-default login が必要）
    # Vertex AI経由の場合は GOOGLE_GENAI_USE_VERTEXAI=True を設定
    print("認証: Application Default Credentials (ADC) を使用", file=sys.stderr)
    return genai.Client()


def deep_research(topic: str, stream: bool = False) -> str:
    """
    Gemini Deep Research APIを使用して深層調査を実行
    """
    client = _create_client()

    prompt = f"""以下のトピックについて詳細に調査し、包括的なレポートを作成してください。

トピック: {topic}

レポートの形式:
- Markdown形式で回答
- 概要、詳細分析、結論のセクションを含める
- 重要なポイントは箇条書きにする
- 最後に参照した情報源のリストを記載"""

    print(f"調査を開始しています: {topic}", file=sys.stderr)
    print("(これには数分かかる場合があります...)", file=sys.stderr)

    if stream:
        return _run_with_streaming(client, prompt)
    else:
        return _run_with_polling(client, prompt)


def _run_with_streaming(client, prompt: str) -> str:
    """ストリーミングモードで調査を実行"""
    stream = client.interactions.create(
        input=prompt,
        agent="deep-research-pro-preview-12-2025",
        background=True,
        stream=True,
        agent_config={
            "type": "deep-research",
            "thinking_summaries": "auto"
        }
    )

    result_text = []
    for chunk in stream:
        if hasattr(chunk, 'event_type') and chunk.event_type == "content.delta":
            if hasattr(chunk, 'delta') and hasattr(chunk.delta, 'text'):
                text = chunk.delta.text
                print(text, end="", flush=True)
                result_text.append(text)

    print()  # 最後に改行
    return "".join(result_text)


def _run_with_polling(client, prompt: str) -> str:
    """ポーリングモードで調査を実行"""
    interaction = client.interactions.create(
        input=prompt,
        agent="deep-research-pro-preview-12-2025",
        background=True,
    )

    interaction_id = interaction.id
    print(f"調査ID: {interaction_id}", file=sys.stderr)

    # ポーリングして完了を待つ
    max_wait = 3600  # 最大60分
    elapsed = 0
    poll_interval = 10

    while elapsed < max_wait:
        result = client.interactions.get(interaction_id)

        if result.status == "completed":
            if result.outputs:
                return result.outputs[-1].text
            return "調査完了しましたが、出力がありませんでした。"

        if result.status == "failed":
            error_msg = getattr(result, 'error', '不明なエラー')
            raise RuntimeError(f"調査が失敗しました: {error_msg}")

        print(f"調査中... ({elapsed}秒経過)", file=sys.stderr)
        time.sleep(poll_interval)
        elapsed += poll_interval

    raise TimeoutError("調査がタイムアウトしました（60分）")


def main():
    parser = argparse.ArgumentParser(
        description="Gemini Deep Research APIを使用して深層調査を実行"
    )
    parser.add_argument("topic", help="調査するトピック")
    parser.add_argument(
        "--stream",
        action="store_true",
        help="ストリーミングモードで実行（リアルタイム出力）"
    )

    args = parser.parse_args()

    try:
        result = deep_research(args.topic, stream=args.stream)
        if not args.stream:
            print(result)
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
