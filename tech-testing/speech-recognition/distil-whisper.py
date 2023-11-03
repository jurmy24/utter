import whisper
import sounddevice as sd
from scipy.io.wavfile import write
import keyboard
import numpy as np
import tempfile
import os
import torch
from transformers import AutoModelForSpeechSeq2Seq, AutoProcessor, pipeline

# Recording audio with sounddevice
fs = 44100  # Sample rate
device = "cuda:0" if torch.cuda.is_available() else "cpu"
torch_dtype = torch.float16 if torch.cuda.is_available() else torch.float32

# model_id = "distil-whisper/distil-large-v2"
model_id = "distil-whisper/distil-medium.en"

model = AutoModelForSpeechSeq2Seq.from_pretrained( model_id, torch_dtype=torch_dtype, low_cpu_mem_usage=True, use_safetensors=True
)
model.to(device)
processor = AutoProcessor.from_pretrained(model_id)
pipe = pipeline(
"automatic-speech-recognition",
model=model,
tokenizer=processor.tokenizer,
feature_extractor=processor.feature_extractor,
max_new_tokens=128,
torch_dtype=torch_dtype,
device=device,
)

def record_audio():

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

        # distil-whisper transcription




        result = pipe(temp_wav_path)
        print(result["text"])




if __name__ == "__main__":
    while True:
        record_audio()