# LangChain with Cortex

LangChain's `ChatOpenAI` class works with Cortex out of the box.

## Install

```bash
pip install langchain-openai
```

## Setup

```python
import os
from langchain_openai import ChatOpenAI

llm = ChatOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
    model="Qwen/Qwen3-14B",
)
```

## Basic Chat

```python
from langchain_core.messages import HumanMessage, SystemMessage

response = llm.invoke([
    SystemMessage(content="You are a helpful assistant."),
    HumanMessage(content="What is Cortex?"),
])
print(response.content)
```

## Streaming

```python
for chunk in llm.stream([HumanMessage(content="Write a haiku about coding.")]):
    print(chunk.content, end="", flush=True)
print()
```

## With Prompt Templates

```python
from langchain_core.prompts import ChatPromptTemplate

prompt = ChatPromptTemplate.from_messages([
    ("system", "You are an expert in {topic}."),
    ("human", "{question}"),
])

chain = prompt | llm
response = chain.invoke({"topic": "machine learning", "question": "Explain gradient descent"})
print(response.content)
```

## RAG Chain

```python
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser

rag_prompt = ChatPromptTemplate.from_messages([
    ("system", "Answer using ONLY the provided context.\n\nContext:\n{context}"),
    ("human", "{question}"),
])

rag_chain = rag_prompt | llm | StrOutputParser()

answer = rag_chain.invoke({
    "context": "Cortex is an OpenAI-compatible API gateway for self-hosted LLMs.",
    "question": "What is Cortex?",
})
print(answer)
```

## With Pool Targeting

```python
llm_priority = ChatOpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
    model="Qwen/Qwen3-14B",
    default_headers={"X-Cortex-Pool": "high-priority"},
)
```

## Notes

- Set `model` explicitly — LangChain requires it.
- `ChatOpenAI` handles all the OpenAI compatibility automatically.
- All LangChain chains, agents, and tools work without modification.
