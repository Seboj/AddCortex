# Pools

Pools group backends for routing, isolation, and failover.

## What Is a Pool?

A pool is a named group of inference backends. When a developer makes an API
call, it routes to a backend in their target pool. The default pool is
`default` — most developers never need to think about this.

## Why Use Pools?

- **Isolation**: Separate production traffic from experimentation
- **Priority**: Give VIP users a dedicated pool with dedicated hardware
- **Failover**: Multiple backends in a pool provide redundancy
- **Different models**: Different pools can serve different models

## Managing Pools

Go to **https://admin.nfinitmonkeys.com** → **Pools** tab.

### Create a Pool

Click **Create Pool**. Set:
- **Name**: Short identifier (e.g., "production", "batch", "experiment")
- **Description**: What this pool is for

### Assign Backends

In the Pools tab, click a pool → **Backends** → **Add Backend**.

Each backend has:
- **Endpoint URL**: The inference server address
- **Priority**: Lower number = preferred. Used for failover ordering.
- **Auth token**: Bearer token for the backend (if required)

### Grant Key Access

Keys must be granted access to non-default pools:
- **API Keys** → click a key → **Pool Access** → **Grant**

Or from the pool view:
- **Pools** → click a pool → **Key Access** → **Grant**

## How Routing Works

1. Developer sends request (optionally with `X-Cortex-Pool: pool-name` header)
2. If no pool header, routes to `default` pool
3. Cortex picks the best backend in the pool:
   - Only `active` backends are considered
   - Lower priority number = preferred
   - Health checks automatically mark unhealthy backends as unavailable
4. If a backend fails, Cortex retries on the next available backend in the pool

## Developer Usage

Developers target a pool with the `X-Cortex-Pool` header:

```python
response = client.chat.completions.create(
    messages=[{"role": "user", "content": "Hello"}],
    extra_headers={"X-Cortex-Pool": "high-priority"},
)
```

If they don't set the header, they get the `default` pool.

## Health Checks

Cortex probes each backend every 30 seconds (`GET /v1/models`). Three
consecutive failures mark a backend as unhealthy. One success restores it.

Health status is visible in the Admin SPA → **Backends** tab — look for the
status badge (Active / Unhealthy / Disabled).

## API Reference

Full admin API docs: **https://cortexapi.nfinitmonkeys.com/docs**
