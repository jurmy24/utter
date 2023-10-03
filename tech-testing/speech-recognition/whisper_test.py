import whisper
import sounddevice as sd
from scipy.io.wavfile import write
import time


# Recording audio with sounddevice
fs = 44100  # Sample rate
seconds = 4  # Duration of recording

print("Talk in 3 seconds!")
time.sleep(2)
print("Talk now!")
time.sleep(1)
myrecording = sd.rec(int(seconds * fs), samplerate=fs, channels=2)
sd.wait()  # Wait until recording is finished
print("Recording done!")
write('output.mp3', fs, myrecording)  # Save as MP3 file 


# Whisper transcription
model = whisper.load_model("base")
result = model.transcribe("output.mp3")
print(result["text"])