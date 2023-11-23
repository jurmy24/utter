import os
from openai import OpenAI
import boto3
from elevenlabs import generate, set_api_key
from pyht import Client
import requests
import azure.cognitiveservices.speech as speechsdk

# Function templates for each TTS service
def openai_tts(text, params, language):
    client = OpenAI(api_key=params['api_key'])
    response = client.audio.speech.create(
        model="tts-1",
        voice='onyx',
        input=text
    )
    response.stream_to_file(f'audio_files/OpenAI_TTS_{language}.mp3')
    print(f"Audio saved as audio_files/OpenAI_TTS_{language}.mp3")
    return False


def amazon_polly(text, params, language):
    client = boto3.client('polly', 
                          aws_access_key_id=params['aws_access_key_id'], 
                          aws_secret_access_key=params['aws_secret_access_key'],
                          region_name='eu-west-3')
    voices = {'English':'Matthew', 'French':'Lea', 'German':'Daniel', 'Spanish':'Lucia', 'Swedish':'Elin'}
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
    # This example requires environment variables named "SPEECH_KEY" and "SPEECH_REGION"
    speech_config = speechsdk.SpeechConfig(subscription=params['api_key'], region=params['region'])
    
    # Specify the voice name
    voices = {'English':'en-US-JennyNeural', 'French':'fr-FR-JeromeNeural', 'German':'de-DE-KasperNeural', 'Spanish':'es-ES-LaiaNeural', 'Swedish':'sv-SE-HilleviNeural'}

    speech_config.speech_synthesis_voice_name=voices[language]

    speech_synthesizer = speechsdk.SpeechSynthesizer(speech_config=speech_config, audio_config=None)

    # Synthesize the text
    speech_synthesis_result = speech_synthesizer.speak_text_async(text).get()

    if speech_synthesis_result.reason == speechsdk.ResultReason.SynthesizingAudioCompleted:
        # Assuming the result contains the audio data
        audio_data = speech_synthesis_result.audio_data
        return audio_data
    else:
        print("Speech synthesis canceled, error, or no audio produced.")
        return None

def murf_ai(text, params, language):
    pass

# I still need to figure out how to handle voices. How do I add the voice that I want
def play_ht(text, params, language):
    '''
    PlayHT utilizies the voices of Google, IBM, Amazon Polly and Microsoft.
    Link to all available voices:
    https://github.com/playht/text-to-speech-api/blob/master/Voices.md
    '''


    url = "https://api.play.ht/api/v2/tts/stream"

    payload = {
        "text": text,
        "voice": 's3://voice-cloning-zero-shot/d9ff78ba-d016-47f6-b0ef-dd630f59414e/female-cs/manifest.json',
        "output_format": "mp3"
    }
    headers = {
        'Authorization': params['api_key'],
        'X-User-ID': params['user_id'],
        "accept": "audio/mpeg",
        "content-type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers)

    audio_data = response.content

    return audio_data

def readspeaker(text, params, language):
    pass

def resemble_ai(text, params, language):
    pass

def speechify(text, params, language):
    pass

def meta_voicebox(text, params, language):
    pass

def google_wavenet(text, params, language): 
    pass

def save_audio(audio_data, filename, folder="audio_files"):
    if not os.path.exists(folder):
        os.makedirs(folder)

    #Append the folder to the filename
    filepath = os.path.join(folder, filename)

    with open(filepath, 'wb') as audio_file:
        audio_file.write(audio_data)
    print(f"Audio saved as {filename}")

def save_results(results):
    with open("tts_performance_results.txt", "w") as file:
        for result in results:
            file.write(f"{result['service']} in {result['language']}: {result['duration']} seconds\n")
    print("Results saved to tts_performance_results.txt")
