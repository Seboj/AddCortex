# Recipe: Batch Processing

Process multiple items efficiently with concurrency control.

## Python (asyncio)

```python
import asyncio
import os
from openai import AsyncOpenAI

client = AsyncOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

async def process_one(item: str) -> dict:
    response = await client.chat.completions.create(
        messages=[
            {"role": "system", "content": "Summarize in one sentence."},
            {"role": "user", "content": item},
        ],
        max_tokens=100,
        temperature=0.3,
    )
    return {"input": item[:50], "summary": response.choices[0].message.content}

async def batch_process(items: list[str], concurrency: int = 5) -> list[dict]:
    semaphore = asyncio.Semaphore(concurrency)

    async def limited(item):
        async with semaphore:
            return await process_one(item)

    return await asyncio.gather(*[limited(item) for item in items])

# Process 20 items, 5 at a time
items = [f"Article about topic {i}" for i in range(20)]
results = asyncio.run(batch_process(items, concurrency=5))
for r in results:
    print(f"{r['input']}... → {r['summary']}")
```

## Node.js (p-limit)

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

async function batchProcess(items: string[], concurrency = 5) {
  const results: { input: string; output: string }[] = [];
  const queue = [...items];

  async function worker() {
    while (queue.length > 0) {
      const item = queue.shift()!;
      const response = await client.chat.completions.create({
        messages: [
          { role: "system", content: "Summarize in one sentence." },
          { role: "user", content: item },
        ],
        max_tokens: 100,
        temperature: 0.3,
      });
      results.push({
        input: item.slice(0, 50),
        output: response.choices[0].message.content!,
      });
    }
  }

  await Promise.all(Array.from({ length: concurrency }, () => worker()));
  return results;
}
```

## With Rate Limit Handling

```python
import asyncio
from openai import RateLimitError

async def process_with_retry(item: str, max_retries: int = 3) -> dict:
    for attempt in range(max_retries):
        try:
            return await process_one(item)
        except RateLimitError:
            wait = 2 ** attempt  # exponential backoff
            print(f"Rate limited, waiting {wait}s...")
            await asyncio.sleep(wait)
    raise Exception(f"Failed after {max_retries} retries: {item[:50]}")
```

## Tips

- **Concurrency**: Start with 5, increase to 10–20 if rate limits allow. Your admin
  sets per-key rate limits (default: 60 requests/minute).
- **Check limits first**: `GET /api/usage/limits` tells you your rate limits.
- **Exponential backoff**: Always handle `429 Too Many Requests` with backoff.
- **Progress tracking**: Print a counter (`processed 5/20...`) for long batches.
- **Pool targeting**: If you have access to a high-throughput pool, set
  `extra_headers={"X-Cortex-Pool": "batch"}` for better throughput.
