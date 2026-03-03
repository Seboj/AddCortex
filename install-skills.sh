#!/bin/bash
# Install Cortex Claude Code skills into your project.
#
# Usage:
#   From anywhere:
#     ~/Projects/AddCortex/install-skills.sh /path/to/your-project
#
#   Or from your project directory:
#     ~/Projects/AddCortex/install-skills.sh .

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/skills/.claude/commands"

# Target project
TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"
DEST="$TARGET/.claude/commands"

echo "Installing Cortex skills into: $TARGET"
echo ""

# Create .claude/commands if it doesn't exist
mkdir -p "$DEST"

# Copy skills (won't overwrite existing files without confirmation)
INSTALLED=0
for skill in "$SOURCE_DIR"/cortex-*.md; do
  filename="$(basename "$skill")"
  if [ -f "$DEST/$filename" ]; then
    echo "  SKIP  $filename (already exists)"
  else
    cp "$skill" "$DEST/$filename"
    echo "  ADDED $filename"
    INSTALLED=$((INSTALLED + 1))
  fi
done

echo ""
echo "Done. $INSTALLED skill(s) installed."
echo ""
echo "Available commands in Claude Code:"
echo "  /cortex-test    — verify your API connection"
echo "  /cortex-models  — list available models"
echo "  /cortex-chat    — send a chat message"
echo "  /cortex-usage   — check usage and rate limits"
echo ""
echo "Before using, set your API key:"
echo "  export CORTEX_API_KEY=\"your-key-here\""
