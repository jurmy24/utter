import assemblyai as aai
import keyboard
from dotenv import load_dotenv
import sounddevice as sd
from scipy.io.wavfile import write
import numpy as np
import tempfile
import os



load_dotenv()
aai.settings.api_key = os.getenv('AAI_API_KEY')

def record_audio_aai():
    # Recording audio with sounddevice
    fs = 44100  # Sample rate


    print("Press and hold the spacebar to start recording. Release to stop and transcribe. Press 'ctrl+c' to exit.")
    keyboard.wait("space")  # Wait until the spacebar is pressed

    print("Recording started. Release the spacebar to stop.")
    myrecording = []
    stream = sd.InputStream(samplerate=fs, channels=2)

    with stream:
        while True:
            if keyboard.is_pressed("space"):  # Check if spacebar is still held down
                audio_chunk, overflowed = stream.read(fs)  # Read an audio chunk
                myrecording.extend(audio_chunk)
            else:
                break  # Stop recording when the spacebar is released

    print("Recording done!")

    # Convert the list to a NumPy array
    myrecording = np.array(myrecording)

            # Create a temporary directory
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
        # Save the audio as a temporary WAV file
        write(temp_wav_path, fs, myrecording)

        # Whisper transcription
        transcriber = aai.Transcriber()
        transcript = transcriber.transcribe(temp_wav_path)
        print(transcript.text)
    return transcript.text
