import whisper
import tempfile
from scipy.io.wavfile import write
import os

from . import utils



def record_and_transcribe() -> str:
    myrecording = utils.record_audio()
    
    # Create a temporary directory
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_wav_path = os.path.join(temp_dir, "temp_output.wav")
        # Save the audio as a temporary WAV file
        write(temp_wav_path, utils.fs, myrecording)

        # Whisper transcription
        model = whisper.load_model("base")
        result = model.transcribe(temp_wav_path)
        print("Transcription:")
        print(result["text"])

    return result["text"]