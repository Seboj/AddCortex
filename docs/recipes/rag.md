# Recipe: RAG (Retrieve + Generate)

Feed relevant context into the prompt so the model answers from your data.

## Pattern

1. **Retrieve**: Search your data store for relevant documents/chunks.
2. **Augment**: Insert the retrieved text into the system prompt.
3. **Generate**: Let the model answer using only the provided context.

## Python

```python
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

def rag_answer(question: str, context_chunks: list[str]) -> str:
    context = "\n\n---\n\n".join(context_chunks)
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": "Answer the user's question using ONLY the provided context. "
                           "If the answer is not in the context, say 'I don't have enough "
                           "information to answer that.' Cite which section you used.",
            },
            {
                "role": "user",
                "content": f"Context:\n{context}\n\nQuestion: {question}",
            },
        ],
        max_tokens=500,
        temperature=0.2,
    )
    return response.choices[0].message.content

# Example: your retrieval step returns these chunks
chunks = [
    "Cortex is an OpenAI-compatible API gateway for self-hosted LLMs. "
    "It supports SGLang, vLLM, Ollama, and TGI backends.",

    "API keys are created via the Admin SPA. Each key has configurable "
    "rate limits: requests per minute and tokens per minute.",
]

answer = rag_answer("How do I get an API key for Cortex?", chunks)
print(answer)
```

## Node.js

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

async function ragAnswer(question: string, contextChunks: string[]): Promise<string> {
  const context = contextChunks.join("\n\n---\n\n");
  const response = await client.chat.completions.create({
    messages: [
      {
        role: "system",
        content:
          "Answer the user's question using ONLY the provided context. " +
          "If the answer is not in the context, say 'I don't have enough " +
          "information to answer that.' Cite which section you used.",
      },
      {
        role: "user",
        content: `Context:\n${context}\n\nQuestion: ${question}`,
      },
    ],
    max_tokens: 500,
    temperature: 0.2,
  });
  return response.choices[0].message.content!;
}
```

## With Streaming

```python
def rag_answer_stream(question: str, context_chunks: list[str]) -> str:
    context = "\n\n---\n\n".join(context_chunks)
    stream = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": "Answer using ONLY the provided context.",
            },
            {
                "role": "user",
                "content": f"Context:\n{context}\n\nQuestion: {question}",
            },
        ],
        stream=True,
        max_tokens=500,
        temperature=0.2,
    )
    reply = ""
    for chunk in stream:
        delta = chunk.choices[0].delta.content
        if delta:
            print(delta, end="", flush=True)
            reply += delta
    print()
    return reply
```

## Tips

- **Low temperature** (0.1–0.3) keeps answers grounded in context.
- **Chunk size**: 200–500 tokens per chunk works well. Overlap chunks by 10–20%.
- **Retrieval**: Use any vector DB (Chroma, Pinecone, pgvector) or keyword search.
  Cortex handles the generation step — pair it with any retrieval system.
- **Context window**: Qwen3-14B has a 32K context window. That's ~50 chunks of
  500 tokens each — plenty for most RAG tasks.
- **Grounding prompt**: Always tell the model to use "ONLY the provided context" to
  prevent hallucination.
