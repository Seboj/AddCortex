# Streaming

Get responses token-by-token as they're generated.

## How It Works

Set `stream: true` and Cortex returns Server-Sent Events (SSE). Each event is a
JSON chunk with a `delta` containing the next piece of content.

## Python

```python
stream = client.chat.completions.create(
    messages=[{"role": "user", "content": "Tell me a story."}],
    stream=True,
    max_tokens=500,
)

for chunk in stream:
    delta = chunk.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)
print()
```

### Collecting the Full Response

```python
full_response = ""
stream = client.chat.completions.create(
    messages=[{"role": "user", "content": "Tell me a story."}],
    stream=True,
    max_tokens=500,
)

for chunk in stream:
    delta = chunk.choices[0].delta.content
    if delta:
        full_response += delta
        print(delta, end="", flush=True)
print()
print(f"\nFull response length: {len(full_response)} chars")
```

### Async Streaming

```python
from openai import AsyncOpenAI

async_client = AsyncOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

async def stream_response(prompt: str):
    stream = await async_client.chat.completions.create(
        messages=[{"role": "user", "content": prompt}],
        stream=True,
        max_tokens=500,
    )
    async for chunk in stream:
        delta = chunk.choices[0].delta.content
        if delta:
            print(delta, end="", flush=True)
    print()
```

## Node.js

```typescript
const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Tell me a story." }],
  stream: true,
  max_tokens: 500,
});

for await (const chunk of stream) {
  const delta = chunk.choices[0]?.delta?.content;
  if (delta) process.stdout.write(delta);
}
console.log();
```

## curl

```bash
curl https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -N \
  -d '{
    "messages": [{"role": "user", "content": "Tell me a story."}],
    "stream": true,
    "max_tokens": 500
  }'
```

## SSE Format

Each line looks like:

```
data: {"id":"chatcmpl-123","object":"chat.completion.chunk","created":1709400000,"model":"Qwen/Qwen3-14B","choices":[{"index":0,"delta":{"content":"Once"},"finish_reason":null}]}
```

The stream ends with:

```
data: [DONE]
```

## Web Frontend (fetch + ReadableStream)

```javascript
async function streamChat(message) {
  const response = await fetch("https://cortexapi.nfinitmonkeys.com/v1/chat/completions", {
    method: "POST",
    headers: {
      "Authorization": `Bearer ${apiKey}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      messages: [{ role: "user", content: message }],
      stream: true,
      max_tokens: 500,
    }),
  });

  const reader = response.body.getReader();
  const decoder = new TextDecoder();

  while (true) {
    const { done, value } = await reader.read();
    if (done) break;

    const text = decoder.decode(value);
    for (const line of text.split("\n")) {
      if (line.startsWith("data: ") && line !== "data: [DONE]") {
        const json = JSON.parse(line.slice(6));
        const content = json.choices[0]?.delta?.content;
        if (content) {
          document.getElementById("output").textContent += content;
        }
      }
    }
  }
}
```

## Tips

- **Use `-N` with curl** to disable buffering.
- **`flush=True`** in Python ensures immediate output.
- **Check `finish_reason`**: `"stop"` means the model finished, `"length"` means
  it hit `max_tokens`.
- **Streaming + pools**: Works the same — add `X-Cortex-Pool` header.
