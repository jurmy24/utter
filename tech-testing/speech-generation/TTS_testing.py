import os
from dotenv import load_dotenv
import openai
import boto3
from TTS_testing_utils import *

####
load_dotenv()

# Sample text
text_samples = {
    "English": "Welcome to our language learning app. Today, we will explore the beautiful intricacies of the English language. From Shakespeare's poetic verses to modern-day colloquialisms, English is a language rich in history and diversity.",
    "French": "Bonjour et bienvenue dans notre application d'apprentissage des langues. Aujourd'hui, nous allons découvrir les subtilités charmantes de la langue française. De la prose de Victor Hugo aux expressions contemporaines, le français est une langue de romance et de finesse.",
    "German": "Willkommen in unserer Sprachlern-App. Heute beschäftigen wir uns mit der faszinierenden Komplexität der deutschen Sprache. Vom lyrischen Werk Goethes bis zu modernen Umgangssprachen ist Deutsch eine Sprache mit reicher Geschichte und Vielfalt.",
    "Spanish": "Bienvenidos a nuestra aplicación para aprender idiomas. Hoy, exploraremos las maravillosas peculiaridades del idioma español. Desde las obras de Cervantes hasta el español cotidiano, el español es un idioma lleno de historia y rica variedad.",
    "Swedish": "Välkommen till vår språkinlärningsapp. Idag ska vi utforska de underbara nyanserna i det svenska språket. Från August Strindbergs litterära verk till moderna uttryck, är svenska ett språk med en rik historia och mångfald."
}

# TTS service configurations (API keys, endpoints, etc.)
tts_services = {
    "OpenAI_TTS": {"function": openai_tts, "params": {'api_key':os.getenv('OPENAI_API_KEY')}},
    "Amazon_Polly": {"function": amazon_polly, "params": {'aws_access_key_id':os.getenv('AWS_ACC_KEY'), 'aws_secret_access_key':os.getenv('AWS_SEC_ACC_KEY')}},
    "ElevenLabs": {"function": elevenlabs, "params": {'api_key':os.getenv('ELEVENLABS_API_KEY')}}
   
}



# General function to test all services
def test_tts_services(text_samples, tts_services):
    for language, text in text_samples.items():
        for service_name, service_info in tts_services.items():
            audio_output = service_info["function"](text, service_info["params"], language)
            save_audio(audio_output, f"{service_name}_{language}.mp3")


if __name__ == "__main__":
    test_tts_services(text_samples, tts_services)