# Recipe: Summarize

Condense long text into concise summaries.

## Python

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

def summarize(text: str, max_sentences: int = 3) -> str:
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"Summarize the following text in {max_sentences} sentences. "
                           "Be concise and capture the key points.",
            },
            {"role": "user", "content": text},
        ],
        max_tokens=300,
        temperature=0.3,
    )
    return response.choices[0].message.content

article = """
Quantum computing leverages quantum mechanical phenomena such as superposition
and entanglement to process information in fundamentally different ways than
classical computers. While classical bits exist as either 0 or 1, quantum bits
(qubits) can exist in multiple states simultaneously, enabling parallel
computation on an exponential scale. Recent advances by companies like Google
and IBM have demonstrated quantum supremacy for specific tasks, though
practical, general-purpose quantum computing remains years away.
"""

print(summarize(article))
```

## Node.js

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

async function summarize(text: string, maxSentences = 3): Promise<string> {
  const response = await client.chat.completions.create({
    messages: [
      {
        role: "system",
        content: `Summarize the following text in ${maxSentences} sentences. Be concise and capture the key points.`,
      },
      { role: "user", content: text },
    ],
    max_tokens: 300,
    temperature: 0.3,
  });
  return response.choices[0].message.content!;
}
```

## Bullet-Point Summary

```python
def summarize_bullets(text: str, num_bullets: int = 5) -> str:
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"Summarize the following text as {num_bullets} bullet points. "
                           "Start each bullet with a dash.",
            },
            {"role": "user", "content": text},
        ],
        max_tokens=400,
        temperature=0.3,
    )
    return response.choices[0].message.content
```

## Tips

- **Low temperature** (0.2–0.4) for factual summaries.
- **max_tokens**: Set proportional to desired summary length.
- **Long documents**: If the text exceeds the context window, split into chunks,
  summarize each, then summarize the summaries.
