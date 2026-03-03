# Authentication & API Keys

## API Key Format

Cortex uses Bearer token authentication, identical to OpenAI:

```
Authorization: Bearer your-cortex-api-key
```

Keys are opaque strings. Treat them like passwords.

## Getting a Key

### From Your Admin
Your Cortex admin creates keys via the Admin SPA or API. They'll give you:
- **API key** — your Bearer token
- **Base URL** — `https://cortexapi.nfinitmonkeys.com/v1`
- **Pool** (optional) — defaults to `default`

### If You're the Admin
See [Onboard a Developer](admin/onboard-developer.md).

## Using Your Key

### In OpenAI SDKs
```python
client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key="your-cortex-api-key",
)
```

### In curl
```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer your-cortex-api-key" \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}'
```

### Environment Variable (Recommended)
```bash
export CORTEX_API_KEY="your-cortex-api-key"
```

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)
```

## Pools

Pools route your request to a specific group of backends. The default pool is
`default` — you don't need to set it unless your admin has given you access to
a specific pool.

To target a pool, add the `X-Cortex-Pool` header:

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer your-cortex-api-key" \
  -H "X-Cortex-Pool: high-priority" \
  -H "Content-Type: application/json" \
  -d '{"messages": [{"role": "user", "content": "Hello"}]}'
```

In Python:
```python
response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Hello"}],
    extra_headers={"X-Cortex-Pool": "high-priority"},
)
```

In Node.js:
```typescript
const response = await client.chat.completions.create(
  { messages: [{ role: "user", content: "Hello" }] },
  { headers: { "X-Cortex-Pool": "high-priority" } },
);
```

## Rate Limits

Your admin sets per-key rate limits:
- **Requests per minute** (default: 60)
- **Tokens per minute** (default: 100,000)

When you hit a limit, you'll get `HTTP 429 Too Many Requests` with a
`Retry-After` header.

## Checking Your Usage

```bash
# Current usage stats
curl https://cortexapi.nfinitmonkeys.com/api/usage \
  -H "Authorization: Bearer your-cortex-api-key"

# Usage limits
curl https://cortexapi.nfinitmonkeys.com/api/usage/limits \
  -H "Authorization: Bearer your-cortex-api-key"
```

## Key Security

- Never commit keys to git — use environment variables
- Rotate keys if compromised — ask your admin
- Each developer should have their own key (not shared)
- Usage is tracked per-key for audit
