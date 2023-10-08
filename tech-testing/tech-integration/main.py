from modules import chatbot, asr, synthesis

if __name__ == "__main__":
    while True:
        recording = asr.record_audio()
        transcription = asr.transcribe_audio(recording, "whisper")
        print(f'Transcription: {transcription}')
        assistant_msg = chatbot.chat(transcription)
        synthesis.synthesize_speech(assistant_msg)
