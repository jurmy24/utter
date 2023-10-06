import sounddevice as sd
from scipy.io.wavfile import write
import keyboard
import numpy as np
import tempfile
import os
import soundfile as sf
from vosk import Model, KaldiRecognizer
import json
import wave


# Recording audio with sounddevice
fs = 44100  # Sample rate

def record_audio():
    """
    Recording audio when space is pressed down.
    Return audio as a numpy array
    """

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

    return myrecording

def get_user_audio_vosk():
    myrecording = record_audio()
    model = Model(lang="en-us")
    rec = KaldiRecognizer(model, fs)
    rec.SetWords(True)
    rec.SetPartialWords(True)

    with tempfile.TemporaryDirectory() as temp_dir:
        temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
        # Save the audio as a temporary WAV file
        write(temp_wav_path, fs, myrecording)

        wf = wave.open("test.wav", "rb")
        n = wf.getnframes()
        data = wf.readframes(n)

        if rec.AcceptWaveform(data):
            res = json.loads(rec.Result())
            print("Good!")
        else:
            res = json.loads(rec.PartialResult())

        text = res[list(res)[0]]
        print(text)
        print("Done")
    return(text)

if __name__ == "__main__":
    get_user_audio_vosk()
