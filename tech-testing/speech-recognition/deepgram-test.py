# https://github.com/deepgram/deepgram-python-sdk

from deepgram import Deepgram
from dotenv import load_dotenv
import os
import time

load_dotenv()

DEEPGRAM_API_KEY = os.getenv("DEEPGRAM_API_KEY")
deepgram = Deepgram(DEEPGRAM_API_KEY)

# open folder with English audio files and read file names
english_audio_folder = "English_Audio"
english_audio_files = os.listdir(english_audio_folder)

english_transcriptions = "English_Text/deepgram-transcriptions.txt"

# transcribe audio files and write to transcriptions text document
with open(english_transcriptions, 'w', encoding='utf-8') as english_text_file:

    for english_audio_file in english_audio_files:
        english_file_path = os.path.join(english_audio_folder, english_audio_file)
        with open(english_file_path, 'rb') as audio:
            source = {'buffer': audio, 'mimetype': 'audio/mp3'}
            start_time = time.time()
            response = deepgram.transcription.sync_prerecorded(source, {'punctuate': True, 'model': 'base','language': 'en'})
            transcription = response["results"]["channels"][0]["alternatives"][0]["transcript"]
            english_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
            english_text_file.write(transcription + '\n') 

# open folder with Swedish audio files and read file names
swedish_audio_folder = "Swedish_Audio"
swedish_audio_files = os.listdir(swedish_audio_folder)

swedish_transcriptions = "Swedish_Text/deepgram-transcriptions.txt"

# transcribe audio files and write to transcriptions text document
with open(swedish_transcriptions, 'w', encoding='utf-8') as swedish_text_file:

    for swedish_audio_file in swedish_audio_files:
        swedish_file_path = os.path.join(swedish_audio_folder, swedish_audio_file)
        with open(swedish_file_path, 'rb') as audio:
            source = {'buffer': audio, 'mimetype': 'audio/mp3'}
            start_time = time.time()
            response = deepgram.transcription.sync_prerecorded(source, {'punctuate': True, 'model': 'base','language': 'sv'})
            transcription = response["results"]["channels"][0]["alternatives"][0]["transcript"]
            swedish_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
            swedish_text_file.write(transcription + '\n') 

# open folder with German audio files and read file names
german_audio_folder = "German_Audio"
german_audio_files = os.listdir(german_audio_folder)

german_transcriptions = "German_Text/deepgram-transcriptions.txt"

# transcribe audio files and write to transcriptions text document
with open(german_transcriptions, 'w', encoding='utf-8') as german_text_file:

    for german_audio_file in german_audio_files:
        german_file_path = os.path.join(german_audio_folder, german_audio_file)
        with open(german_file_path, 'rb') as audio:
            source = {'buffer': audio, 'mimetype': 'audio/mp3'}
            start_time = time.time()
            response = deepgram.transcription.sync_prerecorded(source, {'punctuate': True, 'model': 'base', 'language': 'de'})
            transcription = response["results"]["channels"][0]["alternatives"][0]["transcript"]
            german_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
            german_text_file.write(transcription + '\n') 

print("File writing completed")
