# Recipe: Extract

Pull structured JSON from unstructured text.

## Python

```python
import json
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

def extract(text: str, schema_description: str) -> dict:
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"Extract structured data from the text. "
                           f"Return a JSON object with these fields: {schema_description}. "
                           "Only return valid JSON, no other text.",
            },
            {"role": "user", "content": text},
        ],
        response_format={"type": "json_object"},
        max_tokens=300,
        temperature=0.0,
    )
    return json.loads(response.choices[0].message.content)

# Example: extract contact info
text = "Hi, I'm Alice Chen. You can reach me at alice@example.com or 555-0123. I work at Acme Corp."
result = extract(text, "name, email, phone, company")
print(result)
# {"name": "Alice Chen", "email": "alice@example.com", "phone": "555-0123", "company": "Acme Corp"}
```

## Node.js

```typescript
import OpenAI from "openai";

const client = new OpenAI({
  baseURL: "https://cortexapi.nfinitmonkeys.com/v1",
  apiKey: process.env.CORTEX_API_KEY,
});

async function extract(text: string, schemaDescription: string): Promise<Record<string, unknown>> {
  const response = await client.chat.completions.create({
    messages: [
      {
        role: "system",
        content: `Extract structured data from the text. Return a JSON object with these fields: ${schemaDescription}. Only return valid JSON, no other text.`,
      },
      { role: "user", content: text },
    ],
    response_format: { type: "json_object" },
    max_tokens: 300,
    temperature: 0.0,
  });
  return JSON.parse(response.choices[0].message.content!);
}
```

## Extract a List

```python
text = """
Meeting attendees:
- Bob Smith (Engineering)
- Carol Jones (Marketing)
- Dave Lee (Finance)
"""
result = extract(text, "attendees (array of {name, department})")
# {"attendees": [{"name": "Bob Smith", "department": "Engineering"}, ...]}
```

## Tips

- **Use `response_format: {"type": "json_object"}`** to guarantee valid JSON output.
- **Temperature 0.0** for deterministic extraction.
- **Be specific** about field names and types in the schema description.
- **Handle edge cases**: add "If a field is not found, use null" to the prompt.
