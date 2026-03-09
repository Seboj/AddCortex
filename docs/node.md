# Node.js / TypeScript SDK

Cortex works with the standard OpenAI Node.js SDK. No custom library needed.

## Install

```bash
npm install openai
```

## Setup

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});
```

## Chat Completion

```typescript
const response = await client.chat.completions.create({
  messages: [
    { role: "system", content: "You are a helpful assistant." },
    { role: "user", content: "Explain quantum computing in one paragraph." },
  ],
  max_tokens: 300,
});
console.log(response.choices[0].message.content);
```

No `model` parameter needed — defaults to the server's available model (currently
`Qwen/Qwen3-14B`). List models with `client.models.list()`.

## Streaming

```typescript
const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Write a haiku about coding." }],
  stream: true,
  max_tokens: 100,
});

for await (const chunk of stream) {
  const delta = chunk.choices[0]?.delta?.content;
  if (delta) process.stdout.write(delta);
}
console.log();
```

## Multi-Turn Conversation

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

const history: OpenAI.Chat.ChatCompletionMessageParam[] = [
  { role: "system", content: "You are a concise assistant." },
];

async function chat(userMessage: string): Promise<string> {
  history.push({ role: "user", content: userMessage });
  const response = await client.chat.completions.create({
    messages: history,
    max_tokens: 500,
  });
  const reply = response.choices[0].message.content!;
  history.push({ role: "assistant", content: reply });
  return reply;
}

console.log(await chat("What is Cortex?"));
console.log(await chat("How does it handle auth?"));
```

## Targeting a Pool

```typescript
const response = await client.chat.completions.create(
  { messages: [{ role: "user", content: "Hello" }] },
  { headers: { "X-Cortex-Pool": "high-priority" } },
);
```

The default pool is `default` — you only need this if your admin has given you
access to a specific pool.

## Structured Output (JSON Mode)

```typescript
const response = await client.chat.completions.create({
  messages: [
    { role: "system", content: "Extract the name and age as JSON." },
    { role: "user", content: "Alice is 30 years old." },
  ],
  response_format: { type: "json_object" },
  max_tokens: 100,
});

const data = JSON.parse(response.choices[0].message.content!);
console.log(data); // { name: "Alice", age: 30 }
```

## Tool / Function Calling

Define tools the model can call. The model returns structured `tool_calls` —
your app executes the function and sends the result back.

```typescript
const tools: OpenAI.Chat.ChatCompletionTool[] = [{
  type: "function",
  function: {
    name: "get_weather",
    description: "Get current weather for a city",
    parameters: {
      type: "object",
      properties: {
        city: { type: "string", description: "City name" },
      },
      required: ["city"],
    },
  },
}];

// Step 1: Send message with tools
const response = await client.chat.completions.create({
  messages: [{ role: "user", content: "What's the weather in London?" }],
  tools,
});

// Step 2: Model returns a tool_call (finish_reason == "tool_calls")
const toolCall = response.choices[0].message.tool_calls![0];
console.log(toolCall.function.name);       // "get_weather"
console.log(toolCall.function.arguments);  // '{"city": "London"}'

// Step 3: Execute the function yourself
const weatherData = { temp: "12°C", condition: "Cloudy" }; // your logic here

// Step 4: Send the result back and get the final answer
const final = await client.chat.completions.create({
  messages: [
    { role: "user", content: "What's the weather in London?" },
    response.choices[0].message, // assistant message with tool_calls
    {
      role: "tool",
      tool_call_id: toolCall.id,
      content: JSON.stringify(weatherData),
    },
  ],
  tools,
});
console.log(final.choices[0].message.content);
// "The weather in London is 12°C and cloudy."
```

Use `tool_choice: "auto"` (default) to let the model decide, `"none"` to
prevent tool use, or `{ type: "function", function: { name: "get_weather" } }`
to force a specific function.

## Error Handling

```typescript
import OpenAI from "openai";

try {
  const response = await client.chat.completions.create({
    messages: [{ role: "user", content: "Hello" }],
  });
} catch (error) {
  if (error instanceof OpenAI.RateLimitError) {
    console.error("Rate limited — wait and retry");
  } else if (error instanceof OpenAI.APIConnectionError) {
    console.error("Cannot reach Cortex — check baseURL");
  } else if (error instanceof OpenAI.APIError) {
    console.error(`API error: ${error.status} ${error.message}`);
  }
}
```

## Express.js Integration

```typescript
import express from "express";
import OpenAI from "openai";

const app = express();
app.use(express.json());

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

app.post("/api/chat", async (req, res) => {
  const { message } = req.body;
  const response = await client.chat.completions.create({
    messages: [{ role: "user", content: message }],
    max_tokens: 500,
  });
  res.json({ reply: response.choices[0].message.content });
});

app.listen(3000);
```

## Parameters Reference

| Parameter | Default | Description |
|-----------|---------|-------------|
| `model` | Server's model | Currently `Qwen/Qwen3-14B`. Optional. |
| `messages` | — | Required. Array of message objects. |
| `max_tokens` | Model default | Max tokens to generate. |
| `temperature` | `1.0` | 0.0–2.0. Lower = more deterministic. |
| `top_p` | `1.0` | Nucleus sampling. |
| `stream` | `false` | Enable streaming. |
| `stop` | `null` | Stop sequences. |
| `response_format` | — | `{ type: "json_object" }` for JSON mode. |
| `tools` | `undefined` | Array of tool/function definitions. |
| `tool_choice` | `"auto"` | `"auto"`, `"none"`, or specific function. |

## What's Different from OpenAI

Nothing in terms of SDK usage. You only change two things:

1. `baseURL` → `https://cortexapi.nfinitmonkeys.com/v1`
2. `apiKey` → your Cortex key

Everything else — message format, streaming, error types, response objects —
is identical.
