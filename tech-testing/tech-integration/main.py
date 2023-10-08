from modules import chatbot, asr, synthesis
import time

if __name__ == "__main__":
    while True:
        # TODO: See if live transcription possible for faster responses
        
        recording = asr.record_audio()

        start_time = time.time()
        transcription = asr.transcribe_audio(recording, "whisper")
        end_time = time.time()
        print(f"Time taken to transcribe audio: {end_time - start_time:.4f} seconds")
        
        print(f'Transcription: {transcription}')

        # TODO: See if OpenAI can send back response quicker or on a rolling basis.
        
        start_time = time.time()
        assistant_msg = chatbot.chat(transcription)
        end_time = time.time()
        print(f"Time taken for chatbot to respond: {end_time - start_time:.4f} seconds")
        
        start_time = time.time()
        synthesis.synthesize_speech(assistant_msg)
        end_time = time.time()
        print(f"Time taken to synthesize speech: {end_time - start_time:.4f} seconds")
