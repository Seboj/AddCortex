/**
 * Extract structured JSON from unstructured text.
 *
 * Run: npx tsx extract-json.ts
 */
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

const text = `
Hi, I'm Alice Chen. I work at Acme Corp as a Senior Engineer.
You can reach me at alice@acme.com or call 555-0123.
`;

const response = await client.chat.completions.create({
  messages: [
    {
      role: "system",
      content:
        "Extract contact information as JSON with fields: " +
        "name, company, title, email, phone. Use null for missing fields.",
    },
    { role: "user", content: text },
  ],
  response_format: { type: "json_object" },
  max_tokens: 200,
  temperature: 0.0,
});

const data = JSON.parse(response.choices[0].message.content!);
console.log(JSON.stringify(data, null, 2));
