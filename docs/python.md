# Python SDK

Cortex works with the standard OpenAI Python SDK. No custom library needed.

## Install

```bash
pip install openai
```

## Setup

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)
```

## Chat Completion

```python
response = client.chat.completions.create(
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "Explain quantum computing in one paragraph."},
    ],
    max_tokens=300,
)
print(response.choices[0].message.content)
```

No `model` parameter needed — defaults to the server's available model (currently
`Qwen/Qwen3-14B`). List models with `client.models.list()`.

## Streaming

```python
stream = client.chat.completions.create(
    messages=[{"role": "user", "content": "Write a haiku about coding."}],
    stream=True,
    max_tokens=100,
)
for chunk in stream:
    delta = chunk.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)
print()
```

## Multi-Turn Conversation

```python
history = [{"role": "system", "content": "You are a concise assistant."}]

def chat(user_message: str) -> str:
    history.append({"role": "user", "content": user_message})
    response = client.chat.completions.create(
        messages=history,
        max_tokens=500,
    )
    reply = response.choices[0].message.content
    history.append({"role": "assistant", "content": reply})
    return reply

print(chat("What is Cortex?"))
print(chat("How does it handle auth?"))
```

## Targeting a Pool

```python
response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Hello"}],
    extra_headers={"X-Cortex-Pool": "high-priority"},
)
```

The default pool is `default` — you only need this if your admin has given you
access to a specific pool.

## Structured Output (JSON Mode)

```python
response = client.chat.completions.create(
    messages=[
        {"role": "system", "content": "Extract the name and age as JSON."},
        {"role": "user", "content": "Alice is 30 years old."},
    ],
    response_format={"type": "json_object"},
    max_tokens=100,
)
import json
data = json.loads(response.choices[0].message.content)
print(data)  # {"name": "Alice", "age": 30}
```

## Error Handling

```python
from openai import APIError, RateLimitError, APIConnectionError

try:
    response = client.chat.completions.create(
        messages=[{"role": "user", "content": "Hello"}],
    )
except RateLimitError:
    print("Rate limited — wait and retry")
except APIConnectionError:
    print("Cannot reach Cortex — check base_url")
except APIError as e:
    print(f"API error: {e.status_code} {e.message}")
```

## Async Usage

```python
import asyncio
from openai import AsyncOpenAI

async_client = AsyncOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

async def main():
    response = await async_client.chat.completions.create(
        messages=[{"role": "user", "content": "Hello"}],
        max_tokens=100,
    )
    print(response.choices[0].message.content)

asyncio.run(main())
```

## Parameters Reference

| Parameter | Default | Description |
|-----------|---------|-------------|
| `model` | Server's model | Currently `Qwen/Qwen3-14B`. Optional. |
| `messages` | — | Required. List of message dicts. |
| `max_tokens` | Model default | Max tokens to generate. |
| `temperature` | `1.0` | 0.0–2.0. Lower = more deterministic. |
| `top_p` | `1.0` | Nucleus sampling. |
| `stream` | `false` | Enable streaming. |
| `stop` | `None` | Stop sequences. |
| `response_format` | — | `{"type": "json_object"}` for JSON mode. |

## What's Different from OpenAI

Nothing in terms of SDK usage. You only change two things:

1. `base_url` → `https://cortexapi.nfinitmonkeys.com/v1`
2. `api_key` → your Cortex key

Everything else — message format, streaming, error types, response objects —
is identical.
