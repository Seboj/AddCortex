# Models

## Available Models

Cortex serves whatever models your admin has configured on the backend. List
available models:

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/models \
  -H "Authorization: Bearer $CORTEX_API_KEY"
```

```python
models = client.models.list()
for m in models.data:
    print(m.id)
```

```typescript
const models = await client.models.list();
for (const m of models.data) {
  console.log(m.id);
}
```

## Default Model

You don't need to specify a `model` parameter. Cortex defaults to the server's
available model. Currently that's **Qwen/Qwen3-14B**.

If the server has multiple models, specify which one:

```python
response = client.chat.completions.create(
    model="Qwen/Qwen3-14B",
    messages=[{"role": "user", "content": "Hello"}],
)
```

## Model Capabilities

| Capability | Qwen3-14B | Qwen3-VL-32B (VLM pool) |
|-----------|-----------|--------------------------|
| Chat completions | Yes | Yes |
| Streaming | Yes | Yes |
| JSON mode | Yes | Yes |
| Tool/function calling | Yes | Yes |
| Vision (image input) | No | Yes |
| Context window | 32K tokens | 32K tokens |
| Languages | English, Chinese, multilingual | English, Chinese, multilingual |

## Model in Different Pools

Different pools may serve different models or different configurations of the
same model. Your admin configures which backends (and models) belong to each
pool. Check with your admin or use:

```bash
# List models available to you
curl https://cortexapi.nfinitmonkeys.com/v1/models \
  -H "Authorization: Bearer $CORTEX_API_KEY"
```

## OpenAI Model Names

If your existing code uses OpenAI model names like `gpt-4` or `gpt-3.5-turbo`,
you have two options:

1. **Remove the model parameter** — Cortex defaults to its available model.
2. **Change it to the actual model** — e.g., `model="Qwen/Qwen3-14B"`.

Cortex does not map OpenAI model names. If you send `model="gpt-4"`, you'll
get an error unless your admin has configured an alias.
