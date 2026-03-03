"""Extract structured JSON from unstructured text."""
import json
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

text = """
Hi, I'm Alice Chen. I work at Acme Corp as a Senior Engineer.
You can reach me at alice@acme.com or call 555-0123.
"""

response = client.chat.completions.create(
    messages=[
        {
            "role": "system",
            "content": "Extract contact information as JSON with fields: "
                       "name, company, title, email, phone. Use null for missing fields.",
        },
        {"role": "user", "content": text},
    ],
    response_format={"type": "json_object"},
    max_tokens=200,
    temperature=0.0,
)

data = json.loads(response.choices[0].message.content)
print(json.dumps(data, indent=2))
