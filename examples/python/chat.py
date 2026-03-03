"""Basic chat completion with Cortex."""
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

response = client.chat.completions.create(
    messages=[
        {"role": "system", "content": "You are a helpful assistant."},
        {"role": "user", "content": "What is Cortex?"},
    ],
    max_tokens=300,
)
print(response.choices[0].message.content)
