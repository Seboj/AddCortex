/**
 * Basic chat completion with Cortex.
 *
 * Run: npx tsx chat.ts
 */
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

const response = await client.chat.completions.create({
  messages: [
    { role: "system", content: "You are a helpful assistant." },
    { role: "user", content: "What is Cortex?" },
  ],
  max_tokens: 300,
});

console.log(response.choices[0].message.content);
