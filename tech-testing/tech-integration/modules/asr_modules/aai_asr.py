import tempfile
import assemblyai as aai
from scipy.io.wavfile import write
import os

from utils import *



def get_user_audio_aai() -> str:
    myrecording = record_audio()
    # Create a temporary directory
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
        # Save the audio as a temporary WAV file
        write(temp_wav_path, fs, myrecording)

        # Assembly AI transcription
        transcriber = aai.Transcriber()
        transcript = transcriber.transcribe(temp_wav_path)
        print(transcript.text)
    return transcript.text