# Usage Monitoring

Track API usage per key, per user, and per model.

## Admin Dashboard

Go to **https://admin.nfinitmonkeys.com** → **Usage** tab.

The dashboard shows:
- **Total requests** and **total tokens** over a time period
- **Per-key breakdown** — which keys are consuming the most
- **Per-model breakdown** — usage by model
- **Per-user breakdown** — if Open WebUI user mapping is enabled

## Per-Key Usage

Each API key tracks:
- Total requests
- Total prompt tokens
- Total completion tokens
- Requests per minute (current rate)
- Tokens per minute (current rate)

## Rate Limits

Set per-key rate limits when creating or editing a key:

| Limit | Default | Description |
|-------|---------|-------------|
| Requests/minute | 60 | Max API calls per minute |
| Tokens/minute | 100,000 | Max total tokens (prompt + completion) per minute |

When a developer hits a limit, they get `HTTP 429 Too Many Requests` with a
`Retry-After` header.

## Usage Report API

Admins can pull usage data programmatically:

```bash
# Per-user, per-model breakdown
curl https://cortexapi.nfinitmonkeys.com/admin/usage-report \
  -H "Authorization: Bearer $ADMIN_API_KEY"
```

## Audit Log

Every API call is logged with:
- Timestamp
- API key used
- User (if mapped from Open WebUI)
- Model
- Prompt tokens / completion tokens
- Response time
- Status (success/error)

View in the Admin SPA → **Audit Log** tab, or via API:

```bash
curl https://cortexapi.nfinitmonkeys.com/admin/audit-log \
  -H "Authorization: Bearer $ADMIN_API_KEY"
```

## API Reference

Full admin API docs: **https://cortexapi.nfinitmonkeys.com/docs**
