#!/usr/bin/python3

from vosk import Model, KaldiRecognizer
import sys
import json
import sounddevice as sd
import queue




q = queue.Queue()
model = Model(lang="en-us")


def callback(indata, frames, time, status):
    """This is called (from a separate thread) for each audio block."""
    if status:
        print(status, file=sys.stderr)
    q.put(bytes(indata))

# wf = open(sys.argv[1], "rb")
# wf.read(44) # skip header
def vosk_recorder():
    try:
        allwords = ""
        
        device_info = sd.query_devices(None, "input")
        # soundfile expects an int, sounddevice provides a float:
        samplerate = int(device_info["default_samplerate"]) + 10000
        rec = KaldiRecognizer(model, samplerate)
        with sd.RawInputStream(samplerate=samplerate, blocksize = 8000, dtype="int16", channels=1, device=None, callback=callback):
            print("#" * 80)
            print("Press Ctrl+C to stop the recording")
            print("#" * 80)

            

            while True:
                data = q.get()
                if rec.AcceptWaveform(data):
                    res = json.loads(rec.Result())

                    # When it is here, the code understands that a sentence is finished! 
                    # At least if it is a pause long enough. This should mean that we can send the text from here to a text-generation part as soon as a sentence is finished

                    print (res)
                    allwords +=  " + " + res[list(res)[0]]
                    return res[list(res)[0]]
                else:
                    res = json.loads(rec.PartialResult())
                    print (res)
                    # allwords += " + " + res[list(res)[0]]

    
    except KeyboardInterrupt:
        res = json.loads(rec.FinalResult())
        print("--------------------------------")
        print(res)
        print(allwords)
