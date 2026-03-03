# Quick Start

From zero to working API call in 2 minutes.

## 1. Get Your API Key

Ask your Cortex admin, or if you have admin access:
- Go to **https://admin.nfinitmonkeys.com** → API Keys → Create Key
- Or see [Onboard a Developer](admin/onboard-developer.md)

## 2. Test the Connection

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/models \
  -H "Authorization: Bearer YOUR_API_KEY"
```

You should see a list of available models. If the server has one model, that's
your default — you don't even need to specify it.

## 3. Make Your First Call

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "What is Cortex?"}],
    "max_tokens": 200
  }'
```

No `model` parameter needed — it defaults to the server's available model.

## 4. Use With Any OpenAI SDK

### Python
```bash
pip install openai
```

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key="YOUR_API_KEY",
)

response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Hello!"}],
    max_tokens=200,
)
print(response.choices[0].message.content)
```

### Node.js
```bash
npm install openai
```

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: "YOUR_API_KEY",
});

const response = await client.chat.completions.create({
  messages: [{ role: "user", content: "Hello!" }],
  max_tokens: 200,
});
console.log(response.choices[0].message.content);
```

## Defaults

You only **need** to set `base_url` and `api_key`. Everything else has sensible
defaults:

| Parameter | Default | Notes |
|-----------|---------|-------|
| `model` | Server's available model | Currently `Qwen/Qwen3-14B`. List with `GET /v1/models`. |
| Pool | `default` | Override with `X-Cortex-Pool` header if you have pool access. |
| `stream` | `false` | Set `true` for streaming responses. |
| `max_tokens` | Model default | Set explicitly to control response length. |
| `temperature` | `1.0` | Lower = more deterministic. |

## What's Next

- [Python SDK guide](python.md) — full integration patterns
- [Node.js SDK guide](node.md) — TypeScript examples
- [Recipes](recipes/chatbot.md) — copy-paste patterns for common use cases
- [Streaming](streaming.md) — real-time response handling
- [API Reference](https://cortexapi.nfinitmonkeys.com/docs) — full OpenAPI docs
