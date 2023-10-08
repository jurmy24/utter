import whisper
import sounddevice as sd
from scipy.io.wavfile import write
import keyboard
import numpy as np
import tempfile
import os
import soundfile as sf

print("Press and hold the spacebar to start recording. Release to stop and transcribe. Press 'ctrl+c' to exit.")
keyboard.wait("space")  # Wait until the spacebar is pressed

myrecording = []
stream = sd.InputStream(samplerate=44100, channels=1)

print("Recording starting!")
with stream:
    counter=0
    while counter < 10:
        audio_chunk, overflowed = stream.read(44100)  # Read an audio chunk
        myrecording.extend(audio_chunk)
        counter += 1
        print(counter)
print("Recording done!")

# Convert the list to a NumPy array
myrecording = np.array(myrecording)
    
# Create a temporary directory
with tempfile.TemporaryDirectory() as temp_dir:
    temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
    # Save the audio as a temporary WAV file
    write(temp_wav_path, 44100, myrecording)

    """USE WHISPER"""
    model = whisper.load_model("base")

    result = model.transcribe(temp_wav_path)
    
print("Transcription:")
print(result["text"])

# # make log-Mel spectrogram and move to the same device as the model
# mel = whisper.log_mel_spectrogram(audio).to(model.device)

# # detect the spoken language
# _, probs = model.detect_language(mel)
# print(f"Detected language: {max(probs, key=probs.get)}")

# decode the audio
# options = whisper.DecodingOptions()
# result = whisper.decode(model, mel, options)

# print the recognized text
# print(result.text)