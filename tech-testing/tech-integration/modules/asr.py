""" IMPORTS """
import whisper
import keyboard
import tempfile
import os
import warnings
import numpy as np
import sounddevice as sd
import assemblyai as aai
from dotenv import load_dotenv
from scipy.io.wavfile import write

""" DESCRIPTION """
# This file contains the code required for automatic speech recognition. It is flexible and can use
# any of the methods from the asr_modules folder

""" SETTINGS """
# Retrieving API key for Assembly AI
load_dotenv()
aai.settings.api_key = os.getenv('AAI_API_KEY')

# Store global constants and models
FS = 44100  # Sample rate
default_input_id, _ = sd.default.device # Get ID for default audio input channel
NUM_CHANS = sd.query_devices()[default_input_id]['max_input_channels'] # Retrieve default and get max num of channels
whisper_model = whisper.load_model("base")
aai_model = aai.Transcriber()

# Hide the whisper UserWarning
warnings.filterwarnings("ignore", category=UserWarning, module='whisper')

""" FUNCTIONS """
def record_audio() -> np.array:
    """
    Recording audio when space is pressed down and returning audio as a numpy array
    """

    print("Press and hold the spacebar to start recording. Release to stop and transcribe.")
    
    # Await spacebar press before continuing
    keyboard.wait("space")
    print("Recording started...")
    
    # Set up the recording, stored as a list
    audio_rec = []

    # Set up a sound device input stream on the computer 
    stream = sd.InputStream(samplerate=FS, channels=NUM_CHANS)

    # With ensures the stream input is properly managed to avoid issues like memory leaks
    with stream:
        # Put audio chunks into the recording while the keyboard is pressed
        while keyboard.is_pressed("space"):
            audio_chunk, _ = stream.read(FS)
            audio_rec.extend(audio_chunk)
    print("Recording done!")

    # Convert the list to a NumPy array
    audio_rec = np.array(audio_rec)

    return audio_rec

def transcribe_audio(recording: np.array, model: str) -> str:
    """
    Transcribing the input (recording) and returning the transcribed text as a string
    """
    # Create a temporary directory
    with tempfile.TemporaryDirectory() as temp_dir:
        # Create a temporary file temp_output.wav and store the recording in it
        temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
        write(temp_wav_path, FS, recording)

        # Transcribe the file using the chosen model
        if model == "whisper":
            transcript = whisper_model.transcribe(temp_wav_path)["text"]
        elif model == "assembly":
            transcript = aai_model.transcribe(temp_wav_path).text
    return transcript

if __name__ == "__main__":
    recording = record_audio()
    transcription = transcribe_audio(recording, "whisper")