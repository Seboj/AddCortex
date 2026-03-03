#!/bin/bash
# Basic chat completion with Cortex.
# Usage: CORTEX_API_KEY=your-key ./chat.sh

set -euo pipefail

if [ -z "${CORTEX_API_KEY:-}" ]; then
  echo "Error: CORTEX_API_KEY not set"
  echo "Usage: export CORTEX_API_KEY=your-key"
  exit 1
fi

curl -s https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "What is Cortex?"}],
    "max_tokens": 300
  }' | python3 -c "import sys,json; print(json.load(sys.stdin)['choices'][0]['message']['content'])"
