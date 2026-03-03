#!/bin/bash
# Streaming chat completion with Cortex.
# Usage: CORTEX_API_KEY=your-key ./stream.sh

set -euo pipefail

if [ -z "${CORTEX_API_KEY:-}" ]; then
  echo "Error: CORTEX_API_KEY not set"
  echo "Usage: export CORTEX_API_KEY=your-key"
  exit 1
fi

curl -N https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "messages": [{"role": "user", "content": "Write a short poem about coding."}],
    "stream": true,
    "max_tokens": 200
  }'
