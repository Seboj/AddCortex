# Onboard a Developer

Give a developer everything they need to start using Cortex.

## Steps

### 1. Create an API Key

Go to **https://admin.nfinitmonkeys.com** → **API Keys** → **Create Key**.

Set:
- **Name**: Developer's name or project (e.g., "alice-chatbot")
- **Rate limits**: Requests/minute (default 60) and tokens/minute (default 100,000)
- **Pool access**: Leave as `default` unless they need a specific pool

Copy the generated key — it's shown only once.

### 2. Share Credentials

Send the developer:

```
Base URL: https://cortexapi.nfinitmonkeys.com/v1
API Key:  <the key you just created>
Pool:     default (no need to set unless specific)
Model:    auto-detected (currently Qwen/Qwen3-14B)
Docs:     https://cortexapi.nfinitmonkeys.com/docs
```

### 3. Point Them to the Quick Start

Share the [Quick Start guide](../quick-start.md) — they'll be making API calls
in 2 minutes.

### 4. (Optional) Set Up Usage Monitoring

Go to **API Keys** → click the key → view usage stats. You can monitor:
- Requests per minute
- Tokens per minute
- Total requests and tokens over time

See [Usage Monitoring](usage-monitoring.md) for more details.

## Checklist

- [ ] API key created with appropriate rate limits
- [ ] Key and base URL shared with developer
- [ ] Developer confirmed connection with `GET /v1/models`
- [ ] Pool access granted (if non-default pool needed)
- [ ] Usage limits appropriate for their use case
