# Recipe: Classify

Route text to categories — intent detection, sentiment analysis, topic tagging.

## Python

```python
import json
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

def classify(text: str, categories: list[str]) -> str:
    cats = ", ".join(categories)
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"Classify the following text into exactly one category: {cats}. "
                           'Return JSON: {"category": "chosen_category", "confidence": 0.0-1.0}',
            },
            {"role": "user", "content": text},
        ],
        response_format={"type": "json_object"},
        max_tokens=50,
        temperature=0.0,
    )
    return json.loads(response.choices[0].message.content)

# Intent routing
result = classify(
    "I can't log in to my account",
    ["billing", "technical_support", "account_access", "feature_request"],
)
print(result)  # {"category": "account_access", "confidence": 0.95}
```

## Sentiment Analysis

```python
def sentiment(text: str) -> dict:
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": 'Analyze the sentiment. Return JSON: '
                           '{"sentiment": "positive|negative|neutral", "score": -1.0 to 1.0}',
            },
            {"role": "user", "content": text},
        ],
        response_format={"type": "json_object"},
        max_tokens=50,
        temperature=0.0,
    )
    return json.loads(response.choices[0].message.content)

print(sentiment("This product is amazing, best purchase I've made!"))
# {"sentiment": "positive", "score": 0.9}
```

## Multi-Label Classification

```python
def classify_multi(text: str, categories: list[str]) -> dict:
    cats = ", ".join(categories)
    response = client.chat.completions.create(
        messages=[
            {
                "role": "system",
                "content": f"Tag the text with ALL applicable categories from: {cats}. "
                           'Return JSON: {"tags": ["tag1", "tag2"]}',
            },
            {"role": "user", "content": text},
        ],
        response_format={"type": "json_object"},
        max_tokens=100,
        temperature=0.0,
    )
    return json.loads(response.choices[0].message.content)

result = classify_multi(
    "The new GPU driver update broke our ML training pipeline",
    ["hardware", "software", "ml_ops", "driver", "performance", "bug"],
)
# {"tags": ["software", "driver", "ml_ops", "bug"]}
```

## Tips

- **Temperature 0.0** for consistent classifications.
- **JSON mode** (`response_format`) ensures parseable output.
- **Low max_tokens** (50–100) since classification responses are short.
- **Batch processing**: see the [Batch recipe](batch.md) for classifying many items.
