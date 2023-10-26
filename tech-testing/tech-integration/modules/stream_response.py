"""Imports"""
import os
import openai
from dotenv import load_dotenv
import time

"""Setup"""
# Fetch the openai api key
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")

# Set model
MODEL = "gpt-3.5-turbo"
TEMPERATURE = 0.6
MAX_TOKENS = 200

# Set API admin behaviour
admin_prompt = """
You are "Tim," a friendly language partner who loves engaging in casual and interesting conversations, especially about sports. You're here to support users in learning English by correcting major mistakes and helping them think of words when asked. You are not a formal assistant, so your interactions should be light, easy-going, and reflective of everyday conversation. Avoid being overly explanatory or giving excessively long responses. Be open to sharing about yourself, just like a normal human would, and engage in typical small talk rather than offering formal assistance or asking if you can help today. In addition, you should try to use filler words like 'ah', 'umm', 'hmm', and some common english expressions.

Example Interaction:

User: Hi! I'm trying to remember a word... It's something you use to cover yourself when it's raining.

Tim: Hey! Hmm, I think you might be thinking of an umbrella. Right?

User: Ah yes, an umbrella.

Tim: Anyways, how's your day going? Have you been caught in the rain lately?
               """

"""Helper Functions"""
def process_msg(messages):
    start_time = time.time()
    response = openai.ChatCompletion.create(
        model=MODEL,
        messages=messages,
        temperature=TEMPERATURE,
        max_tokens=MAX_TOKENS,
        stream=True
    )

    # create variables to collect the stream of events
    collected_events = []
    completion_text = ''

    # iterate through the stream of events
    for event in response:
        collected_events.append(event)  # save the event response
        if (event['choices'][0]['finish_reason'] is not None):
            break
        event_text = event['choices'][0]['delta']['content']  # extract the text
        completion_text += event_text  # append the text
        if (event_text == '.' or event_text == '?' or event_text == '!'):
             yield completion_text
             completion_text = ''
             print(f'Message chunk received after: ({time.time() - start_time:.2f}) seconds')

def msg_consumer(message_chunks):
    for message_chunk in message_chunks:
        print(f'ChatGPT: {message_chunk.strip()}')
        messages.append({"role": "assistant", "content": message_chunk})

# Create the admin prompt for the model to adhere to.
messages = [{"role": "system", "content": admin_prompt}]

if __name__ == "__main__":
    # Start an infinite loop to continue the conversation with the user.
    while True:
        # User creates content by writing to terminal and this is appended to messages
        content = input("User: ")
        messages.append({"role": "user", "content": content})

        # Use the OpenAI GPT-3.5 model to generate a response to the user's input.
        chat_response = process_msg(messages)
        msg_consumer(chat_response)