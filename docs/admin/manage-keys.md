# Manage API Keys

All key management is done through the Admin SPA at
**https://admin.nfinitmonkeys.com**.

## Create a Key

**API Keys** → **Create Key**

| Field | Description |
|-------|-------------|
| Name | Label for the key (e.g., "alice-chatbot", "prod-service") |
| Rate limit (RPM) | Requests per minute. Default: 60. |
| Rate limit (TPM) | Tokens per minute. Default: 100,000. |

The key is shown once after creation. Copy it immediately.

## View Keys

**API Keys** tab shows all active keys with:
- Name
- Created date
- Last used
- Request count
- Status (active/revoked)

## Revoke a Key

Click a key → **Revoke**. The key immediately stops working. This cannot be
undone — create a new key if needed.

**When to revoke:**
- Developer leaves the team
- Key is compromised or leaked
- Rotating keys as a security practice

## Rotate a Key

There's no "rotate" button. The process:
1. Create a new key with the same settings
2. Give the developer the new key
3. Developer updates their code
4. Revoke the old key

## Pool Access

Keys can be scoped to specific pools:
- **API Keys** → click a key → **Pool Access**
- **Grant**: Add access to a pool
- **Revoke**: Remove access to a pool

By default, all keys have access to the `default` pool. See [Pools](pools.md).

## API Reference

Full API docs for key management:
**https://cortexapi.nfinitmonkeys.com/docs** → Admin section
