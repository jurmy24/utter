import whisper
import os
import time

# load whisper model
model = whisper.load_model("base")

# open folder with English audio files and read file names
english_audio_folder = "English_Audio"
english_audio_files = os.listdir(english_audio_folder)

english_transcriptions = "English_Text/whisper-base-transcriptions.txt"

# transcribe audio files and write transcriptions to text document
with open(english_transcriptions, 'w', encoding='utf-8') as english_text_file:

    for english_audio_file in english_audio_files:
        english_file_path = os.path.join(english_audio_folder, english_audio_file)
        start_time = time.time()
        result = model.transcribe(english_file_path)
        english_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
        english_text_file.write(result["text"] + "\n")

# open folder with Swedish audio files and read file names
swedish_audio_folder = "Swedish_Audio"
swedish_audio_files = os.listdir(swedish_audio_folder)

swedish_transcriptions = "Swedish_Text/whisper-base-transcriptions.txt"

# transcribe audio files and write transcriptions to text document
with open(swedish_transcriptions, 'w', encoding='utf-8') as swedish_text_file:

    for swedish_audio_file in swedish_audio_files:
        swedish_file_path = os.path.join(swedish_audio_folder, swedish_audio_file)
        start_time = time.time()
        result = model.transcribe(swedish_file_path)
        swedish_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
        swedish_text_file.write(result["text"] + "\n")

# open folder with German audio files and read file names
german_audio_folder = "German_Audio"
german_audio_files = os.listdir(german_audio_folder)

german_transcriptions = "German_Text/whisper-base-transcriptions.txt"

# transcribe audio files and write transcriptions to text document
with open(german_transcriptions, 'w', encoding='utf-8') as german_text_file:

    for german_audio_file in german_audio_files:
        german_file_path = os.path.join(german_audio_folder, german_audio_file)
        start_time = time.time()
        result = model.transcribe(german_file_path)
        german_text_file.write(f"Time to transcribe: {time.time() - start_time} \n")
        german_text_file.write(result["text"] + "\n")

print("File writing completed")