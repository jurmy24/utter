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

# No exit key for now
# def check_exit_key():
#     global recording
#     keyboard.wait("esc")  # Wait for 'Escape' key to exit
#     recording = False  # Set the recording flag to False

if __name__ == "__main__":
    record_audio()


# The following code is the vosk_test code from before
    
#!/usr/bin/env python3

# prerequisites: as described in https://alphacephei.com/vosk/install and also python module `sounddevice` (simply run command `pip install sounddevice`)
# Example usage using Dutch (nl) recognition model: `python test_microphone.py -m nl`
# For more help run: `python test_microphone.py -h`

# import argparse
# import queue
# import sys
# import sounddevice as sd

# from vosk import Model, KaldiRecognizer
# import json

# q = queue.Queue()

# def int_or_str(text):
#     """Helper function for argument parsing."""
#     try:
#         return int(text)
#     except ValueError:
#         return text

# def callback(indata, frames, time, status):
#     """This is called (from a separate thread) for each audio block."""
#     if status:
#         print(status, file=sys.stderr)
#     q.put(bytes(indata))

# parser = argparse.ArgumentParser(add_help=False)
# parser.add_argument(
#     "-l", "--list-devices", action="store_true",
#     help="show list of audio devices and exit")
# args, remaining = parser.parse_known_args()
# if args.list_devices:
#     print(sd.query_devices())
#     parser.exit(0)
# parser = argparse.ArgumentParser(
#     description=__doc__,
#     formatter_class=argparse.RawDescriptionHelpFormatter,
#     parents=[parser])
# parser.add_argument(
#     "-f", "--filename", type=str, metavar="FILENAME",
#     help="audio file to store recording to")
# parser.add_argument(
#     "-d", "--device", type=int_or_str,
#     help="input device (numeric ID or substring)")
# parser.add_argument(
#     "-r", "--samplerate", type=int, help="sampling rate")
# parser.add_argument(
#     "-m", "--model", type=str, help="language model; e.g. en-us, fr, nl; default is en-us")
# args = parser.parse_args(remaining)

# try:
#     if args.samplerate is None:
#         device_info = sd.query_devices(args.device, "input")
#         # soundfile expects an int, sounddevice provides a float:
#         args.samplerate = int(device_info["default_samplerate"])
        
#     if args.model is None:
#         model = Model(lang="en-us")
#     else:
#         model = Model(lang=args.model)

#     if args.filename:
#         dump_fn = open(args.filename, "wb")
#     else:
#         dump_fn = None

#     allwords = ""
#     print(args.samplerate)
#     assert 1==0
#     with sd.RawInputStream(samplerate=args.samplerate, blocksize = 8000, device=args.device,
#             dtype="int16", channels=1, callback=callback):
#         print("#" * 80)
#         print("Press Ctrl+C to stop the recording")
#         print("#" * 80)

#         rec = KaldiRecognizer(model, args.samplerate)
       
#         while True:
#             data = q.get()
#             if rec.AcceptWaveform(data):
#                 print(rec.Result())
#                 temp = json.loads(rec.Result())
#             else:
#                 print(rec.PartialResult())
#             # if dump_fn is not None:
#             #     dump_fn.write(data)

# except KeyboardInterrupt:
#     print(allwords)
#     print("\nDone")
#     parser.exit(0)

# except Exception as e:
#     parser.exit(type(e).__name__ + ": " + str(e))