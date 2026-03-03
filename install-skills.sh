#!/bin/bash
# Install Cortex Claude Code skills into your project.
#
# Usage (from your project directory):
#
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash
#
# Or install into a specific directory:
#
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash -s /path/to/project

set -euo pipefail

REPO="Seboj/AddCortex"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/skills/.claude/commands"

SKILLS=(
  "cortex-test.md"
  "cortex-models.md"
  "cortex-chat.md"
  "cortex-usage.md"
)

# Target project
TARGET="${1:-.}"
TARGET="$(cd "$TARGET" && pwd)"
DEST="$TARGET/.claude/commands"

echo "Installing Cortex Claude Code skills into: $TARGET"
echo ""

# Create .claude/commands if it doesn't exist
mkdir -p "$DEST"

# Download skills from GitHub
INSTALLED=0
for skill in "${SKILLS[@]}"; do
  if [ -f "$DEST/$skill" ]; then
    echo "  SKIP  $skill (already exists)"
  else
    if curl -fsSL "$BASE_URL/$skill" -o "$DEST/$skill" 2>/dev/null; then
      echo "  ADDED $skill"
      INSTALLED=$((INSTALLED + 1))
    else
      echo "  FAIL  $skill (download failed — check repo access)"
    fi
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
echo ""
echo "Get a key from your Cortex admin, or see:"
echo "  https://github.com/$REPO/blob/$BRANCH/docs/auth.md"
