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
    Recording audio with buffer when space is pressed down and returning audio as a numpy array
    """
    print("Press and hold the spacebar to start recording. Release to stop and transcribe.")
    
    buffer_seconds = 0.5
    buffer_len = int(FS * buffer_seconds * NUM_CHANS)
    rolling_buffer = np.zeros(buffer_len, dtype=np.float32)
    
    audio_rec = []
    post_release_buffer = []
    is_recording = False

    with sd.InputStream(samplerate=FS, channels=NUM_CHANS) as stream:
        while True:
            audio_chunk, _ = stream.read(FS)
            
            # Ensure audio_chunk is 2D, if not, reshape it
            if len(audio_chunk.shape) == 1:
                audio_chunk = audio_chunk.reshape(-1, NUM_CHANS)
            
            # Determine how much we need to roll and append
            roll_size = min(audio_chunk.size, buffer_len)
            
            # Roll the buffer and append the new chunk
            rolling_buffer = np.roll(rolling_buffer, -roll_size)
            rolling_buffer[-roll_size:] = audio_chunk.flatten()[:roll_size]
            
            if keyboard.is_pressed("space"):
                if not is_recording:
                    print("Recording started...")
                    audio_rec.extend(rolling_buffer)  # Append the buffer from before pressing
                    is_recording = True

                audio_rec.extend(audio_chunk.flatten())
            elif is_recording:  # If space was released and it was recording
                post_release_buffer.extend(audio_chunk.flatten())

                # If we've recorded enough post-release buffer, stop recording
                if len(post_release_buffer) >= buffer_len*3:
                    print("Recording done!")
                    audio_rec.extend(post_release_buffer[:buffer_len])  # Append the post-release buffer
                    break

    audio_rec = np.array(audio_rec).reshape(-1, NUM_CHANS)

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
    while True:
        recording = record_audio()
        transcription = transcribe_audio(recording, "whisper")
        print(transcription)