import whisper
import sounddevice as sd
from scipy.io.wavfile import write
import keyboard
import numpy as np
import tempfile
import os
import soundfile as sf


# Recording audio with sounddevice
fs = 44100  # Sample rate

def record_audio() -> str:

    print("Press and hold the spacebar to start recording. Release to stop and transcribe. Press 'Escape' to exit.")
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
        model = whisper.load_model("base")
        result = model.transcribe(temp_wav_path)
        print("Transcription:")
        print(result["text"])

    return result["text"]



if __name__ == "__main__":
    record_audio()