"""Batch process multiple items with async concurrency."""
import asyncio
import os
from openai import AsyncOpenAI

client = AsyncOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

ITEMS = [
    "Explain quantum computing in one sentence.",
    "Explain machine learning in one sentence.",
    "Explain blockchain in one sentence.",
    "Explain cloud computing in one sentence.",
    "Explain edge computing in one sentence.",
]


async def process_one(item: str) -> str:
    response = await client.chat.completions.create(
        messages=[{"role": "user", "content": item}],
        max_tokens=100,
        temperature=0.3,
    )
    return response.choices[0].message.content


async def main():
    semaphore = asyncio.Semaphore(3)  # 3 concurrent requests

    async def limited(item):
        async with semaphore:
            return await process_one(item)

    results = await asyncio.gather(*[limited(item) for item in ITEMS])

    for item, result in zip(ITEMS, results):
        print(f"Q: {item}")
        print(f"A: {result}\n")


asyncio.run(main())
