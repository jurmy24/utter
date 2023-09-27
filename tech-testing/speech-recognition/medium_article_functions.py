import pyaudio
import os
import sounddevice as sd
import soundfile as sf
import openai
import time
import keyboard
import torch
import whisper
import sys
import tempfile
import threading
# import numpy as np
# from gtts import gTTS
# import pygame
# import audioread
# import pickle




def listen_for_keys():
    global recording, done_recording, stop_recording
    while True:
        if keyboard.is_pressed('space'):  # if key 'space' is pressed
            stop_recording = False
            recording = True
            done_recording = False
        elif keyboard.is_pressed('esc'):  # if key 'esc' is pressed
            stop_recording = True
            break  # Exit the thread
        elif recording:  # if key 'space' was released after recording
            recording = False
            done_recording = True
            break  # Exit the thread
        time.sleep(0.01)

def get_voice_command(args, q, audio_model):
    global done_recording, recording
    done_recording = False
    recording = False

    saved_file = press2record(q, filename="input_to_gpt.wav", subtype = args.subtype, channels = args.channels, samplerate = args.samplerate)
    
    if saved_file == -1:
        return -1
    # Transcribe the temporary WAV file using Whisper
    result = audio_model.transcribe(saved_file, fp16=torch.cuda.is_available())
    text = result['text'].strip()
    # Delete the temporary WAV file
    os.remove(saved_file)
    #print ("\033[A                             \033[A")
    print(f"\nYou: {text} \n")
    return text

def callback(indata, frames, time, status, q):
    """This is called (from a separate thread) for each audio block."""
    if recording:  # Only record if the recording flag is set
        if status:
            print(status, file=sys.stderr)
        q.put(indata.copy())

def press2record(q, filename, subtype, channels, samplerate=24000):

    def callback_with_q(indata, frames, time, status):
        return callback(indata, frames, time, status, q)
    
    global recording, done_recording, stop_recording
    stop_recording = False
    recording = False
    done_recording = False
    try:
        if samplerate is None:
            device_info = sd.query_devices(None, 'input')
            samplerate = int(device_info['default_samplerate'])
            print(int(device_info['default_samplerate']))
        if filename is None:
            filename = tempfile.mktemp(prefix='captured_audio',
                                       suffix='.wav', dir='')

        with sf.SoundFile(filename, mode='x', samplerate=samplerate,
                          channels=channels, subtype=subtype) as file:
            with sd.InputStream(samplerate=samplerate, device=None,
                                channels=channels, callback=callback_with_q, blocksize=4096) as stream:
                print('press Spacebar to start recording, release to stop, or press Esc to exit')
                listener_thread = threading.Thread(target=listen_for_keys)  # Start the listener on a separate thread
                listener_thread.start()
                while not done_recording and not stop_recording:
                    while recording and not q.empty():
                        file.write(q.get())

        if stop_recording:
            return -1

    except KeyboardInterrupt:
        print('Interrupted by user')

    return filename
