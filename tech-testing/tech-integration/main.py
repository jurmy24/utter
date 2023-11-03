from modules import chatbot, asr, synthesis, stream_response
import time

if __name__ == "__main__":
    conversation_start = chatbot.start_conversation()
    synthesis.synthesize_speech(conversation_start)
    while True:
        # TODO: See if live transcription possible for faster responses
        
        recording = asr.record_audio()

        start_time = time.time()
        transcription = asr.transcribe_audio(recording, "whisper")
        end_time = time.time()
        print(f"Time taken to transcribe audio: {end_time - start_time:.4f} seconds")
        
        print(f'Transcription: {transcription}')

        # TODO: See if OpenAI can send back response quicker or on a rolling basis.
        
        # Using chatbot.py
        '''
        start_time = time.time()
        assistant_msg = chatbot.chat(transcription)
        end_time = time.time()
        print(f"Time taken for chatbot to respond: {end_time - start_time:.4f} seconds")
        
        start_time = time.time()
        synthesis.synthesize_speech(assistant_msg)
        end_time = time.time()
        print(f"Time taken to synthesize speech: {end_time - start_time:.4f} seconds")
        '''

        # Using stream_response.py
        start_time_chatbot = time.time()
        for msg_chunk in stream_response.chat(transcription):
            end_time_chatbot = time.time()
            print(f"Time taken for chatbot to respond: {end_time_chatbot - start_time_chatbot:.4f} seconds")
            start_time_synthesis = time.time()
            synthesis.synthesize_speech(msg_chunk)
            end_time_synthesis = time.time()
            print(f"Time taken to synthesize speech: {end_time_synthesis - start_time_synthesis:.4f} seconds")
