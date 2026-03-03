"""Streaming chat completion with Cortex."""
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

stream = client.chat.completions.create(
    messages=[{"role": "user", "content": "Write a short poem about coding."}],
    stream=True,
    max_tokens=200,
)

for chunk in stream:
    delta = chunk.choices[0].delta.content
    if delta:
        print(delta, end="", flush=True)
print()
