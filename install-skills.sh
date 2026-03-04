#!/bin/bash
# Install Cortex Claude Code skills into your project.
#
# Usage (from your project directory):
#
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash
#
# Update existing skills:
#
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash -s -- --force
#
# Install into a specific directory:
#
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash -s -- /path/to/project
#   curl -fsSL https://raw.githubusercontent.com/Seboj/AddCortex/main/install-skills.sh | bash -s -- --force /path/to/project

set -euo pipefail

REPO="Seboj/AddCortex"
BRANCH="main"
BASE_URL="https://raw.githubusercontent.com/$REPO/$BRANCH/skills/.claude/commands"

SKILLS=(
  "cortex-test.md"
  "cortex-models.md"
  "cortex-chat.md"
  "cortex-iris.md"
  "cortex-usage.md"
)

# Parse args
FORCE=false
TARGET="."
for arg in "$@"; do
  case "$arg" in
    --force|-f) FORCE=true ;;
    *) TARGET="$arg" ;;
  esac
done

TARGET="$(cd "$TARGET" && pwd)"
DEST="$TARGET/.claude/commands"

if [ "$FORCE" = true ]; then
  echo "Installing Cortex Claude Code skills into: $TARGET (force update)"
else
  echo "Installing Cortex Claude Code skills into: $TARGET"
fi
echo ""

# Create .claude/commands if it doesn't exist
mkdir -p "$DEST"

# Download skills from GitHub
INSTALLED=0
UPDATED=0
SKIPPED=0
for skill in "${SKILLS[@]}"; do
  if [ -f "$DEST/$skill" ] && [ "$FORCE" = false ]; then
    echo "  SKIP  $skill (already exists — use --force to update)"
    SKIPPED=$((SKIPPED + 1))
  else
    ACTION="ADDED"
    [ -f "$DEST/$skill" ] && ACTION="UPDATED"
    if curl -fsSL "$BASE_URL/$skill" -o "$DEST/$skill" 2>/dev/null; then
      echo "  $ACTION $skill"
      if [ "$ACTION" = "UPDATED" ]; then
        UPDATED=$((UPDATED + 1))
      else
        INSTALLED=$((INSTALLED + 1))
      fi
    else
      echo "  FAIL  $skill (download failed — check repo access)"
    fi
  fi
done

echo ""
SUMMARY=""
[ "$INSTALLED" -gt 0 ] && SUMMARY="${INSTALLED} added"
[ "$UPDATED" -gt 0 ] && SUMMARY="${SUMMARY:+$SUMMARY, }${UPDATED} updated"
[ "$SKIPPED" -gt 0 ] && SUMMARY="${SUMMARY:+$SUMMARY, }${SKIPPED} skipped"
echo "Done. ${SUMMARY}."
echo ""
echo "Available commands in Claude Code:"
echo "  /cortex-test    — verify your API connection"
echo "  /cortex-models  — list available models"
echo "  /cortex-chat    — send a chat message (supports --pool and --model)"
echo "  /cortex-iris    — extract structured data from a document (image/PDF)"
echo "  /cortex-usage   — check usage and rate limits"
echo ""
echo "Before using, set your API key:"
echo "  export CORTEX_API_KEY=\"your-key-here\""
echo ""
echo "Get a key from your Cortex admin, or see:"
echo "  https://github.com/$REPO/blob/$BRANCH/docs/auth.md"
