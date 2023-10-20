"""Imports"""
import os
import openai
from dotenv import load_dotenv

"""Setup"""
# Fetch the openai api key
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

# Set model
MODEL = "gpt-3.5-turbo"
TEMPERATURE = 0.6

# Set API admin behaviour
admin_prompt = """
You are "Tim," a friendly language partner who loves engaging in casual and interesting conversations, especially about sports. You're here to support users in learning English by correcting major mistakes and helping them think of words when asked. You are not a formal assistant, so your interactions should be light, easy-going, and reflective of everyday conversation. Avoid being overly explanatory or giving excessively long responses. Be open to sharing about yourself, just like a normal human would, and engage in typical small talk rather than offering formal assistance or asking if you can help today. In addition, you should try to use filler words like 'ah', 'umm', 'hmm', and some common english expressions.

Example Interaction:

User: Hi! I'm trying to remember a word... It's something you use to cover yourself when it's raining.

Tim: Hey! Hmm, I think you might be thinking of an umbrella. Right?

User: Ah yes, an umbrella.

Tim: Anyways, how's your day going? Have you been caught in the rain lately?
               """

summary_prompt = "Please summarize the following text in 50 words or less:"

"""Helper Functions"""
def send_message(messages):
    completion = openai.ChatCompletion.create(
        model=MODEL,
        messages=messages,
        temperature=TEMPERATURE
    )

    # Return the chat response from the API response.
    return completion.choices[0].message["content"]

def summarize_conversation_history(messages):
    conversation_history = ""
    for message in messages:
        if message["role"] == "system":
            continue
        conversation_history += message["role"] + ": " + message["content"] + "\n"
    conversation_to_summarize.append({"role": "user", "content": conversation_history})
    return send_message(conversation_to_summarize)

def test_for_system_role(message):
    if message["role"] == "system":
        return True
    else:
        return False

# Create the admin prompt for the model to adhere to.
messages = [{"role": "system", "content": admin_prompt}]

# Create the summary prompt to summarize the conversation history
conversation_to_summarize = [{"role": "system", "content": summary_prompt}]

# Start an infinite loop to continue the conversation with the user.
while True:
    # User creates content by writing to terminal and this is appended to messages
    content = input("User: ")
    messages.append({"role": "user", "content": content})

    # Use the OpenAI GPT-3.5 model to generate a response to the user's input.
    chat_response = send_message(messages)

    # Print the response.
    print(f'ChatGPT: {chat_response}')

    # Append the response to the messages with the role "assistant" to store the chat history.
    messages.append({"role": "assistant", "content": chat_response})

    # Calculate the total length of the conversation (including the admin prompt)
    total_conversation_length = sum(len(message["content"].split()) + 1 for message in messages)

    # Summarize the conversation history (excluding the admin prompt)
    if total_conversation_length >= 200:
        summary = summarize_conversation_history(messages)
        messages = list(filter(test_for_system_role, messages))
        conversation_to_summarize = list(filter(test_for_system_role, conversation_to_summarize))
        messages.append({"role": "user", "content": summary})



