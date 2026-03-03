# AutoGen with Cortex

Microsoft's AutoGen framework supports OpenAI-compatible endpoints like Cortex.

## Install

```bash
pip install pyautogen
```

## Setup

```python
import os

config_list = [
    {
        "model": "Qwen/Qwen3-14B",
        "base_url": "https://cortexapi.nfinitmonkeys.com/v1",
        "api_key": os.environ["CORTEX_API_KEY"],
    }
]

llm_config = {"config_list": config_list, "temperature": 0.7}
```

## Two-Agent Conversation

```python
import autogen

assistant = autogen.AssistantAgent(
    name="assistant",
    llm_config=llm_config,
    system_message="You are a helpful AI assistant.",
)

user_proxy = autogen.UserProxyAgent(
    name="user",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=3,
)

user_proxy.initiate_chat(assistant, message="Explain how API gateways work.")
```

## Group Chat

```python
researcher = autogen.AssistantAgent(
    name="researcher",
    llm_config=llm_config,
    system_message="You research topics and present findings.",
)

critic = autogen.AssistantAgent(
    name="critic",
    llm_config=llm_config,
    system_message="You review research and point out gaps or errors.",
)

user_proxy = autogen.UserProxyAgent(
    name="user",
    human_input_mode="NEVER",
    max_consecutive_auto_reply=5,
)

group_chat = autogen.GroupChat(
    agents=[user_proxy, researcher, critic],
    messages=[],
    max_round=6,
)

manager = autogen.GroupChatManager(groupchat=group_chat, llm_config=llm_config)
user_proxy.initiate_chat(manager, message="Analyze the pros and cons of microservices.")
```

## With Pool Targeting

Add `default_headers` to the config to route through a specific pool:

```python
config_list = [
    {
        "model": "Qwen/Qwen3-14B",
        "base_url": "https://cortexapi.nfinitmonkeys.com/v1",
        "api_key": os.environ["CORTEX_API_KEY"],
        "default_headers": {"X-Cortex-Pool": "agents"},
    }
]
```

## Notes

- Set `model` explicitly in the config list.
- AutoGen makes multiple LLM calls per conversation turn — watch your rate limits.
- Use `max_consecutive_auto_reply` to prevent runaway conversations.
