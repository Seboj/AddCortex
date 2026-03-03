# curl / Raw HTTP

No SDK needed. Cortex is a standard OpenAI-compatible REST API.

## Chat Completion

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Hello!"}],
    "max_tokens": 200
  }'
```

No `model` field needed — defaults to the server's available model (currently
`Qwen/Qwen3-14B`).

## List Models

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/models \
  -H "Authorization: Bearer $CORTEX_API_KEY"
```

## Streaming

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -N \
  -d '{
    "messages": [{"role": "user", "content": "Write a haiku about coding."}],
    "stream": true,
    "max_tokens": 100
  }'
```

The `-N` flag disables buffering so you see chunks in real time. Each line is
a Server-Sent Event:

```
data: {"id":"...","choices":[{"delta":{"content":"Code"}}]}
data: {"id":"...","choices":[{"delta":{"content":" flows"}}]}
...
data: [DONE]
```

## Targeting a Pool

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -H "X-Cortex-Pool: high-priority" \
  -d '{
    "messages": [{"role": "user", "content": "Hello"}]
  }'
```

Default pool is `default` — only set `X-Cortex-Pool` if your admin has given you
access to a specific pool.

## JSON Mode

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "Extract the name and age as JSON."},
      {"role": "user", "content": "Alice is 30 years old."}
    ],
    "response_format": {"type": "json_object"},
    "max_tokens": 100
  }'
```

## System + User Messages

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [
      {"role": "system", "content": "You are a pirate. Respond in pirate speak."},
      {"role": "user", "content": "What is machine learning?"}
    ],
    "max_tokens": 300,
    "temperature": 0.7
  }'
```

## Check Usage

```bash
# Current usage stats
curl https://cortexapi.nfinitmonkeys.com/api/usage \
  -H "Authorization: Bearer $CORTEX_API_KEY"

# Usage limits
curl https://cortexapi.nfinitmonkeys.com/api/usage/limits \
  -H "Authorization: Bearer $CORTEX_API_KEY"
```

## Response Format

Every chat completion returns:

```json
{
  "id": "chatcmpl-abc123",
  "object": "chat.completion",
  "created": 1709400000,
  "model": "Qwen/Qwen3-14B",
  "choices": [
    {
      "index": 0,
      "message": {
        "role": "assistant",
        "content": "Hello! How can I help you?"
      },
      "finish_reason": "stop"
    }
  ],
  "usage": {
    "prompt_tokens": 10,
    "completion_tokens": 8,
    "total_tokens": 18
  }
}
```

## HTTP Status Codes

| Code | Meaning | Action |
|------|---------|--------|
| 200 | Success | — |
| 401 | Invalid API key | Check your `Authorization` header |
| 429 | Rate limited | Wait for `Retry-After` seconds, then retry |
| 500 | Server error | Retry after a moment |
| 503 | Backend unavailable | All backends in your pool are down — retry later |

## Shell Script Example

```bash
#!/bin/bash
ask_cortex() {
  curl -s https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
    -H "Authorization: Bearer $CORTEX_API_KEY" \
    -H "Content-Type: application/json" \
    -d "{
      \"messages\": [{\"role\": \"user\", \"content\": \"$1\"}],
      \"max_tokens\": 500
    }" | jq -r '.choices[0].message.content'
}

ask_cortex "Summarize the Unix philosophy in 3 bullets"
```
