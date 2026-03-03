"""Interactive chatbot with conversation history."""
import os
from openai import OpenAI

client = OpenAI(
    base_url="https://cortexapi.nfinitmonkeys.com/v1",
    api_key=os.environ["CORTEX_API_KEY"],
)

history = [{"role": "system", "content": "You are a friendly assistant."}]

print("Cortex Chatbot (type 'quit' to exit)")
print("-" * 40)

while True:
    user_input = input("\nYou: ")
    if user_input.lower() in ("quit", "exit"):
        break

    history.append({"role": "user", "content": user_input})

    stream = client.chat.completions.create(
        messages=history,
        stream=True,
        max_tokens=500,
    )

    print("Bot: ", end="")
    reply = ""
    for chunk in stream:
        delta = chunk.choices[0].delta.content
        if delta:
            print(delta, end="", flush=True)
            reply += delta
    print()

    history.append({"role": "assistant", "content": reply})
