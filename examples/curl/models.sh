#!/bin/bash
# List available models on Cortex.
# Usage: CORTEX_API_KEY=your-key ./models.sh

set -euo pipefail

if [ -z "${CORTEX_API_KEY:-}" ]; then
  echo "Error: CORTEX_API_KEY not set"
  echo "Usage: export CORTEX_API_KEY=your-key"
  exit 1
fi

echo "Available models:"
curl -s https://cortexapi.nfinitmonkeys.com/v1/models \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  | python3 -c "import sys,json; data=json.load(sys.stdin); [print(f'  - {m[\"id\"]}') for m in data.get('data',[])]"
