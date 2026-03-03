---
description: Send a chat message to Cortex
---

Send a quick chat completion to Cortex. Use the message from the user's argument, or default to "Hello! What model are you?".

```bash
curl -s https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "$ARGUMENTS"}],
    "max_tokens": 500
  }' | python3 -c "import sys,json; r=json.load(sys.stdin); print(r['choices'][0]['message']['content'])"
```

Replace `$ARGUMENTS` with the user's input. If no argument was provided, use "Hello! What model are you?".

Show the model's response. If there's an error, show the error and suggest checking the API key.
