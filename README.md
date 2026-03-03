# AddCortex

Integrate Cortex into your application. It's an OpenAI-compatible API — change
two lines and you're live.

```python
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",  # ← line 1
    api_key="your-cortex-api-key",                       # ← line 2
)

response = client.chat.completions.create(
    model="Qwen/Qwen3-14B",   # or omit — defaults to server's model
    messages=[{"role": "user", "content": "Hello!"}],
)
print(response.choices[0].message.content)
```

That's it. Any OpenAI SDK (Python, Node, Go, Rust, etc.) works out of the box.

## What You Need

1. **API key** — get one from your Cortex admin
2. **Base URL** — `https://cortexapi.nfinitmonkeys.com/v1`
3. That's it

## Defaults

| Setting | Default | Override |
|---------|---------|---------|
| **Model** | Server's available model (currently Qwen3-14B) | `model` parameter |
| **Pool** | `default` | `X-Cortex-Pool` header |
| **Streaming** | Off | `stream: true` |

## Docs

| Guide | What it covers |
|-------|---------------|
| [Quick Start](docs/quick-start.md) | API key → first call → working in 2 minutes |
| [Python](docs/python.md) | OpenAI Python SDK integration |
| [Node.js](docs/node.md) | OpenAI Node.js/TypeScript SDK |
| [curl](docs/curl.md) | Raw HTTP examples |
| [Models](docs/models.md) | Available models, listing, capabilities |
| [Streaming](docs/streaming.md) | Server-sent events, chunk handling |
| [Auth & Keys](docs/auth.md) | API key format, rate limits, usage tracking |

## Recipes

Copy-paste patterns for common use cases:

| Recipe | Pattern |
|--------|---------|
| [Chatbot](docs/recipes/chatbot.md) | Multi-turn conversation with memory |
| [Summarize](docs/recipes/summarize.md) | Document/text summarization |
| [Extract](docs/recipes/extract.md) | Structured JSON extraction |
| [Classify](docs/recipes/classify.md) | Intent classification / routing |
| [RAG](docs/recipes/rag.md) | Retrieve + generate |
| [Batch](docs/recipes/batch.md) | Process N items efficiently |

## Agent Frameworks

| Framework | Guide |
|-----------|-------|
| [OpenAI Agents SDK](docs/agents/openai-sdk.md) | Drop-in Cortex backend |
| [LangChain](docs/agents/langchain.md) | ChatOpenAI with Cortex |
| [AutoGen](docs/agents/autogen.md) | Multi-agent conversations |

## Admin Guides

| Guide | For |
|-------|-----|
| [Onboard a Developer](docs/admin/onboard-developer.md) | Create key, set limits, share credentials |
| [Manage Keys](docs/admin/manage-keys.md) | Create, rotate, revoke, scope to pools |
| [Usage Monitoring](docs/admin/usage-monitoring.md) | Per-user tracking, limits, audit log |
| [Pools](docs/admin/pools.md) | Backend pools, routing, failover |

## Claude Code Skills

Add Cortex commands to any project's Claude Code session:

```bash
# From your project directory:
~/Projects/AddCortex/install-skills.sh .

# Or specify the path:
~/Projects/AddCortex/install-skills.sh /path/to/your-project
```

This copies the skill files into your project's `.claude/commands/` directory.
Then in Claude Code you get:

| Command | What it does |
|---------|-------------|
| `/cortex-test` | Verify your API connection |
| `/cortex-models` | List available models |
| `/cortex-chat` | Send a chat message |
| `/cortex-usage` | Check your usage and rate limits |

Before using, set your API key:
```bash
export CORTEX_API_KEY="your-key-here"
```

## API Reference

Full OpenAPI docs: **https://cortexapi.nfinitmonkeys.com/docs**

---

*Cortex by [InfiniteMonkeys](https://infinitemonkeys.com)*
