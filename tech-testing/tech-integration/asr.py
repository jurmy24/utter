import whisper
import sounddevice as sd
from scipy.io.wavfile import write
import keyboard
import numpy as np


# Recording audio with sounddevice
fs = 44100  # Sample rate
recording = True  # Flag to control recording

def record_audio():
    global recording
    while recording:
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

        # Save the audio as a WAV file
        write('output.wav', fs, myrecording)

        # Whisper transcription
        model = whisper.load_model("base")
        result = model.transcribe("output.wav")
        print("Transcription:")
        print(result["text"])

if __name__ == "__main__":
    record_audio()