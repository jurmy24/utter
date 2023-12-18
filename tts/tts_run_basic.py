from boto3 import Session
from botocore.exceptions import BotoCoreError, ClientError
from contextlib import closing
import os
import sys
import subprocess
from tempfile import gettempdir
from dotenv import load_dotenv

"""Setup"""
# Fetch the AWS keys
load_dotenv()
AWS_ACC_KEY = os.getenv("AWS_ACC_KEY")
AWS_SEC_ACC_KEY = os.getenv("AWS_SEC_ACC_KEY")

# Create a client using your AWS credentials
session = Session(
        aws_access_key_id=AWS_ACC_KEY,
        aws_secret_access_key=AWS_SEC_ACC_KEY,
        region_name='eu-west-3')
polly_client = session.client('polly')

# Speech synthesis function
def synthesize_speech(text):
    
    # Set up the response
    try:
        # Request speech synthesis
        response = polly_client.synthesize_speech(VoiceId='Matthew',
                                                  Engine='neural',
                                                  OutputFormat='mp3',
                                                  Text=text)
    except (BotoCoreError, ClientError) as error:
        # The service returned an error, exit gracefully
        print(error)
        return
    
    # Create and play the response
    if "AudioStream" in response:

        with closing(response["AudioStream"]) as stream:
            output = os.path.join(gettempdir(), "speech.mp3")
            
            try:
                # Open a file for writing the output as a binary stream
                with open(output, "wb") as audio_file:
                    audio_file.write(stream.read())
            except IOError as error:
                # Could not write to file, exit gracefully
                print(error)
                return
    
    else:
        # The response didn't contain audio data, exit gracefully
        print("Could not stream audio.")
        return
    
    # Play the audio using the platform's default player
    if sys.platform == "win32":
        os.startfile(output)
    else:
        # The following works on macOS and Linux. (Darwin = mac, xdg-open = linux).
        opener = "open" if sys.platform == "darwin" else "xdg-open"
        subprocess.call([opener, output])
    

if __name__ == "__main__":
    while True:
        # Prompt the user to enter the text
        text = input("Please enter the text you want to synthesize:\n")

        # Call the function to synthesize speech from text
        synthesize_speech(text)