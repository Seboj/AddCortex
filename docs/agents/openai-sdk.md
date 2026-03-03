# OpenAI Agents SDK with Cortex

The [OpenAI Agents SDK](https://github.com/openai/openai-agents-python) works
with Cortex as a drop-in backend.

## Install

```bash
pip install openai-agents
```

## Setup

```python
import os
from agents import Agent, Runner
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

agent = Agent(
    name="Cortex Assistant",
    instructions="You are a helpful assistant powered by Cortex.",
    model="Qwen/Qwen3-14B",
)

result = Runner.run_sync(agent, "What is Cortex?", client=client)
print(result.final_output)
```

## Multi-Agent

```python
from agents import Agent, Runner

researcher = Agent(
    name="Researcher",
    instructions="You research topics thoroughly and provide detailed analysis.",
    model="Qwen/Qwen3-14B",
)

writer = Agent(
    name="Writer",
    instructions="You take research and write clear, concise summaries.",
    model="Qwen/Qwen3-14B",
)

# Chain agents
research = Runner.run_sync(researcher, "Analyze quantum computing trends", client=client)
summary = Runner.run_sync(writer, f"Summarize this research:\n{research.final_output}", client=client)
print(summary.final_output)
```

## With Tools

```python
from agents import Agent, Runner, function_tool

@function_tool
def get_weather(city: str) -> str:
    """Get the current weather for a city."""
    return f"Sunny, 72°F in {city}"

agent = Agent(
    name="Weather Bot",
    instructions="Help users check the weather.",
    model="Qwen/Qwen3-14B",
    tools=[get_weather],
)

result = Runner.run_sync(agent, "What's the weather in Austin?", client=client)
print(result.final_output)
```

## Notes

- Set `model` explicitly when using the Agents SDK — it doesn't auto-detect the
  server's default model.
- Tool calling support depends on your model's capabilities. Qwen3-14B supports
  basic function calling.
- Pass the `client` parameter to `Runner.run_sync()` to route through Cortex.
