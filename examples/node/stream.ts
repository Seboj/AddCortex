/**
 * Streaming chat completion with Cortex.
 *
 * Run: npx tsx stream.ts
 */
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

const stream = await client.chat.completions.create({
  messages: [{ role: "user", content: "Write a short poem about coding." }],
  stream: true,
  max_tokens: 200,
});

for await (const chunk of stream) {
  const delta = chunk.choices[0]?.delta?.content;
  if (delta) process.stdout.write(delta);
}
console.log();
