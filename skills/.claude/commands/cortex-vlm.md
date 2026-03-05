---
description: Send an image + prompt to Cortex VLM (vision-language model)
---

Send an image with a text prompt to the Cortex VLM pool (Qwen3-VL-32B-AWQ) for visual understanding.

Parse the arguments for:
- A file path or image URL (required) — the image to analyze
- The remaining text is the prompt (default: "Describe this image in detail")

Examples:
- `/cortex-vlm screenshot.png What does this UI show?`
- `/cortex-vlm diagram.jpg Extract all text from this diagram`
- `/cortex-vlm photo.png` — uses default prompt "Describe this image in detail"
- `/cortex-vlm https://example.com/image.jpg What is in this image?`

For a **local file**, base64-encode it and build a curl command like:

```bash
IMAGE_B64=$(base64 < FILE_PATH)
curl -s https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -H "X-Cortex-Pool: cortexvlm" \
  -d '{
    "messages": [{"role": "user", "content": [
      {"type": "image_url", "image_url": {"url": "data:image/png;base64,'"$IMAGE_B64"'"}},
      {"type": "text", "text": "THE_PROMPT"}
    ]}],
    "max_tokens": 1000
  }'
```

For an **image URL**, use it directly:

```bash
curl -s https://cortexapi.nfinitmonkeys.com/v1/chat/completions \
  -H "Authorization: Bearer $CORTEX_API_KEY" \
  -H "Content-Type: application/json" \
  -H "X-Cortex-Pool: cortexvlm" \
  -d '{
    "messages": [{"role": "user", "content": [
      {"type": "image_url", "image_url": {"url": "THE_IMAGE_URL"}},
      {"type": "text", "text": "THE_PROMPT"}
    ]}],
    "max_tokens": 1000
  }'
```

- Detect the MIME type from the file extension (png, jpg/jpeg, webp, gif).
- The `X-Cortex-Pool: cortexvlm` header is required — this routes to the vision model.
- Pool slug is case-insensitive.
- Max image size: 20MB.

Show the model's response. If there's an error, suggest:
- Check `CORTEX_API_KEY` is set
- Verify the file exists and is a supported image type (PNG, JPG, WEBP, GIF)
- The `cortexvlm` pool must be healthy (check with `/cortex-models`)

**Model**: QuantTrio/Qwen3-VL-32B-Instruct-AWQ (auto-resolved from pool)
