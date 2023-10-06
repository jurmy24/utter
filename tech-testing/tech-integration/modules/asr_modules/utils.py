import keyboard
import sounddevice as sd
import numpy as np


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
