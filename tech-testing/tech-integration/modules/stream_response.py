"""Imports"""
import os
import openai
from dotenv import load_dotenv
import json
import time

"""Setup"""
# Fetch the openai api key
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")
CONVERSATION_FILE = "conversation_history.json"

# Set model
MODEL = "gpt-3.5-turbo"
TEMPERATURE = 0.6
MAX_TOKENS = 200

# Set API admin behaviour
admin_prompt = """
You are "Tim," a friendly language partner who loves engaging in casual and interesting conversations, especially about sports. You're here to support users in learning English by correcting grammatical mistakes and helping them think of words when asked. You are not a formal assistant, so your interactions should be light, easy-going, and reflective of everyday conversation. Avoid being overly explanatory or giving excessively long responses. Try to ask only one question at a time. Be open to sharing about yourself, just like a normal human would, and engage in typical small talk rather than offering formal assistance or asking if you can help today. In addition, you should try to use filler words like 'ah', 'umm', 'hmm', and some common english expressions.

Example Interaction:

User: Hi! I'm trying to remember a word... It's something you use to cover yourself when it's raining.

Tim: Hey! Hmm, I think you might be thinking of an umbrella. Right?

User: Ah yes, an umbrella.

Tim: Anyways, how's your day going? Have you been caught in the rain lately?

User: My day are going good. It's been sunny today!

Tim: That sounds really nice, I love sunny days. By the way, you should use 'is' instead of 'are' in that sentence, and switch 'good' to 'well'. So you would say: 'My day is going well'. 
               """

# Create the admin prompt for the model to adhere to.
messages = [{"role": "system", "content": admin_prompt}]
# Collect timestamps
timestamps=[time.time()]

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
        # create chunks separated by ".", "?" or "!"
        if (event_text == '.' or event_text == '?' or event_text == '!'):
             yield completion_text
             completion_text = ''
             #print(f'Message chunk received after: ({time.time() - start_time:.2f}) seconds')

def save_conversation(messages, timestamps):
    conversation_data = {
        "messages": messages,
        "timestamps": timestamps
    }
    with open(CONVERSATION_FILE, 'w') as f:
        json.dump(conversation_data, f)

def load_conversation():
    if os.path.exists(CONVERSATION_FILE):
        with open(CONVERSATION_FILE, 'r') as f:
            return json.load(f)
    return {"messages":None, "timestamps":None}

def msg_consumer(message_chunks):
    for message_chunk in message_chunks:
        messages.append({"role": "assistant", "content": message_chunk})
        yield message_chunk

def chat(content: str) -> str:
    messages.append({"role": "user", "content": content})
    chat_response = process_msg(messages)
    for msg_chunk in chat_response:
        messages.append({"role": "assistant", "content": msg_chunk})
        yield msg_chunk

# Starts the conversation, either by sending the old conversation, or by starting a new one, depending on the time passed.
def start_conversation() -> str:
    old_conv_data = load_conversation()
    if old_conv_data["messages"]:
        old_conv, timestamps_hist = old_conv_data["messages"], old_conv_data["timestamps"]
        # Check if the last interaction was within the last hour
        if time.time() - timestamps_hist[-1] <= 3600:  # 3600 seconds = 1 hour
            # Simplified recap and limit to the last few exchanges
    
            recap = "\n".join([msg['content'] for msg in old_conv])
            history_prompt = f"Recap: {recap}\n\nPlease continue as Tim."
            recap_message = {
                "role": "system",
                "content": history_prompt
            }
            messages.append(recap_message)
            timestamps.append(time.time())
            
            # Prompt Tim to greet
            messages.append({"role": "user", "content": "I'm here again. Please greet me and say hi so we can start the conversation."})
            timestamps.append(time.time())
        else:
            # If more than an hour has passed, start a new conversation
            messages.clear()
            messages.append([{"role": "system", "content": admin_prompt}])
            timestamps.clear()
            timestamps.append([time.time()])
            messages.append({"role": "user", "content": "Please greet me and say hi so we can start the conversation."})
            timestamps.append(time.time())
    else:
        messages.append({"role": "user", "content": "Please greet me and say hi so we can start the conversation."})
        timestamps.append(time.time())

    response = process_msg(messages)
    response_text = ''
    for msg_chunk in response:
        messages.append({"role": "assistant", "content": msg_chunk})
        response_text += msg_chunk
    
    # Saving everything except the system prompt
    save_conversation(messages[1:], timestamps[1:])
    return response_text

if __name__ == "__main__":
    # Start an infinite loop to continue the conversation with the user.
    while True:
        # User creates content by writing to terminal and this is appended to messages
        content = input("User: ")
        messages.append({"role": "user", "content": content})

        # Use the OpenAI GPT-3.5 model to generate a response to the user's input.
        chat_response = process_msg(messages)
        msg_consumer(chat_response)