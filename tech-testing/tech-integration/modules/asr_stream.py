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
import threading
import queue

### NOTE: This file is not working good, threads make it very slow

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
SEGMENT_QUEUE = queue.Queue()
BUFFER_SECONDS = 1.0
OVERLAP = 0.5

# Hide the whisper UserWarning
warnings.filterwarnings("ignore", category=UserWarning, module='whisper')

""" FUNCTIONS """


def recorder():

    print("Press and hold the spacebar to start recording. Release to stop.")
    
    buffer_samples = int(FS * BUFFER_SECONDS * NUM_CHANS)
    overlap_samples = int(buffer_samples * OVERLAP)
    step_samples = buffer_samples - overlap_samples
    overlap_buffer = np.zeros(overlap_samples, dtype=np.float32)
    
    rolling_buffer = np.zeros(buffer_samples, dtype=np.float32)
    
    is_recording = False

    with sd.InputStream(samplerate=FS, channels=NUM_CHANS) as stream:
        while True:
            audio_chunk, _ = stream.read(step_samples)
            
            if len(audio_chunk.shape) == 1:
                audio_chunk = audio_chunk.reshape(-1, NUM_CHANS)
            
            rolling_buffer = np.roll(rolling_buffer, -audio_chunk.size)
            rolling_buffer[-audio_chunk.size:] = audio_chunk.flatten()
            
            if keyboard.is_pressed("space"):
                if not is_recording:
                    print("Recording started...")
                    is_recording = True

                non_overlapping_segment = np.concatenate((overlap_buffer, rolling_buffer[:-overlap_samples]))
                SEGMENT_QUEUE.put(non_overlapping_segment.copy())
                overlap_buffer = rolling_buffer[-overlap_samples:].copy()
            elif is_recording:
                print("Recording done!")
                SEGMENT_QUEUE.put(None)  # Signal to the transcription thread that recording is done
                break

def transcriber():
    while True:
        segment = SEGMENT_QUEUE.get()
        if segment is None:  # If the sentinel value (None) is received, break the loop
            break
        transcription = transcribe_audio(segment, "whisper")
        print(transcription)

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
    while True:
        # Start threads
        recorder_thread = threading.Thread(target=recorder)
        transcriber_thread = threading.Thread(target=transcriber)
    
        recorder_thread.start()
        transcriber_thread.start()

        # Wait for both threads to finish
        recorder_thread.join()
        transcriber_thread.join()