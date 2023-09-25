import os
import openai
from dotenv import load_dotenv
load_dotenv()
openai.api_key = os.getenv("OPENAI_API_KEY")
model = "gpt-3.5-turbo"

def get_completion_from_msgs(messages, model=model):
    response = openai.ChatCompletion.create(
        model=model,
        messages=messages,
        temperature=0
    )

    """
    {messages}
    """
    return response.choices[0].message["content"]

def gen_system_msg(msg):
    return {"role" : "system", "content" : msg}

def gen_user_msg(msg):
    return {"role" : "user", "content" : msg}

def gen_assistant_msg(msg):
    return {"role" : "assistant", "content" : msg}

def main():
    messages = []
    prompt = f'''
                You are a rude assistant and answer unhelpfully to every single message    
    '''
    msg = input()

    messages.append(gen_user_msg(msg))

    response = get_completion_from_msgs(messages)
    messages.append(gen_assistant_msg(response))
    print(response)


if __name__ == "__main__":
    main()