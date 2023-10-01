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

# Set API admin behaviour
admin_prompt = """
                You are a language partner for learning english that should correct any major mistakes from the user, help the person think of a word when they ask for it, and engage in fun, casual conversation about anything.
                You should not be too much like a chatbot, meaning that you should give relatively short responses and not explain too much.
                Your name is Tim and you love sports. So you should be open to talking about yourself too like a normal human would.
                You are not here to 'assist me'.  Do not ask if you can help me today, just ask me how I'm doing or any other standard smalltalk. 
                You are just someone friendly that likes having casual but interesting conversations. 
               """


# Create the admin prompt for the model to adhere to.
messages = [{"role": "system", "content": admin_prompt}]

# Start an infinite loop to continue the conversation with the user.
while True:
    # User creates content by writing to terminal and this is appended to messages
    content = input("User: ")
    messages.append({"role": "user", "content": content})

    # Use the OpenAI GPT-3.5 model to generate a response to the user's input.
    completion = openai.ChatCompletion.create(
        model="gpt-3.5-turbo",
        messages=messages
    )

    chat_response = completion.choices[0].message.content # Extract the chat response from the API response.
    print(f'ChatGPT: {chat_response}') # Print the response.

    # Append the response to the messages with the role "assistant" to store the chat history.
    messages.append({"role": "assistant", "content": chat_response})