from modules import chatbot, asr, synthesis

if __name__ == "__main__":

    while True:
        user_msg = asr.record_audio()
        assistant_msg = chatbot.chat(user_msg)
        synthesis.synthesize_speech(assistant_msg)
