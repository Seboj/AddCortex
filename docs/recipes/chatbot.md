# Recipe: Chatbot

Multi-turn conversation with memory.

## Python

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

history = [
    {"role": "system", "content": "You are a friendly assistant. Keep answers concise."},
]

def chat(user_input: str) -> str:
    history.append({"role": "user", "content": user_input})
    response = client.chat.completions.create(
        messages=history,
        max_tokens=500,
    )
    reply = response.choices[0].message.content
    history.append({"role": "assistant", "content": reply})
    return reply

# Interactive loop
while True:
    user_input = input("You: ")
    if user_input.lower() in ("quit", "exit"):
        break
    print(f"Bot: {chat(user_input)}")
```

## Node.js

```typescript
import OpenAI from "openai";
import * as readline from "readline";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

const history: OpenAI.Chat.ChatCompletionMessageParam[] = [
  { role: "system", content: "You are a friendly assistant. Keep answers concise." },
];

async function chat(userInput: string): Promise<string> {
  history.push({ role: "user", content: userInput });
  const response = await client.chat.completions.create({
    messages: history,
    max_tokens: 500,
  });
  const reply = response.choices[0].message.content!;
  history.push({ role: "assistant", content: reply });
  return reply;
}

const rl = readline.createInterface({ input: process.stdin, output: process.stdout });
const ask = () => rl.question("You: ", async (input) => {
  if (["quit", "exit"].includes(input.toLowerCase())) return rl.close();
  console.log(`Bot: ${await chat(input)}`);
  ask();
});
ask();
```

## With Streaming

```python
def chat_stream(user_input: str) -> str:
    history.append({"role": "user", "content": user_input})
    stream = client.chat.completions.create(
        messages=history,
        stream=True,
        max_tokens=500,
    )
    reply = ""
    for chunk in stream:
        delta = chunk.choices[0].delta.content
        if delta:
            print(delta, end="", flush=True)
            reply += delta
    print()
    history.append({"role": "assistant", "content": reply})
    return reply
```

## Tips

- **Context window**: The model sees the entire `history` list. Trim old messages
  if conversations get long.
- **System prompt**: Set the tone in the first message. Keep it short.
- **Temperature**: Lower (0.3–0.7) for factual assistants, higher (0.8–1.2) for
  creative ones.
