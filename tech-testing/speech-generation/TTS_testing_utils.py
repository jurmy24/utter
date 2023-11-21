import os
from dotenv import load_dotenv
from openai import OpenAI
import boto3
import requests
from elevenlabs import generate, set_api_key

# Function templates for each TTS service
def openai_tts(text, params, language):
    client = OpenAI(api_key=params['api_key'])
    response = client.audio.speech.create(
        model="tts-1",
        voice='onyx',
        input=text
    )
    return response


def amazon_polly(text, params, language):
    client = boto3.client('polly', 
                          aws_access_key_id=params['aws_access_key_id'], 
                          aws_secret_access_key=params['aws_secret_access_key'],
                          region_name='eu-west-3')
    voices = {'English':'Matthew', 'French':'Léa', 'German':'Daniel', 'Spanish':'Lucia', 'Swedish':'Elin'}
    response = client.synthesize_speech(VoiceId=voices[language],
                                        Engine='neural',
                                        OutputFormat='mp3', 
                                        Text=text)
    
    audio_data = response['AudioStream'].read()
    return audio_data

def elevenlabs(text, params, language):
    set_api_key(params['api_key'])

    audio = generate(
    text=text,
    voice="Bella",
    model="eleven_multilingual_v2"
    )
    return audio

def ibm_watson(text, params, language):
    pass

def microsoft_azure(text, params, language):
    pass

def murf_ai(text, params, language):
    pass

def play_ht(text, params, language):
    pass

def readspeaker(text, params, language):
    pass

def resemble_ai(text, params, language):
    pass

def speechify(text, params, language):
    pass

def meta_voicebox(text, params, language):
    pass

def google_tts(text, params, language): 
    pass

def save_audio(audio_data, filename):
    with open(filename, 'wb') as audio_file:
        audio_file.write(audio_data)
    print(f"Audio saved as {filename}")
