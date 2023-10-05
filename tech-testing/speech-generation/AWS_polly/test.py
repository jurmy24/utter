import boto3
from botocore.exceptions import BotoCoreError
import os
from dotenv import load_dotenv

"""Setup"""
# Fetch the openai api key
load_dotenv()
AWS_ACC_KEY = os.getenv("AWS_ACC_KEY")
AWS_SEC_ACC_KEY = os.getenv("AWS_SEC_ACC_KEY")

def synthesize_speech(text, output_file):
    # Create a client using your AWS credentials
    polly_client = boto3.Session(
        aws_access_key_id=AWS_ACC_KEY,
        aws_secret_access_key=AWS_SEC_ACC_KEY,
        region_name='eu-west-3').client('polly')
    
    try:
        # Request speech synthesis
        response = polly_client.synthesize_speech(VoiceId='Matthew',
                                                  Engine='neural',
                                                  OutputFormat='mp3',
                                                  Text=text)
    except (BotoCoreError) as error:
        print(error)
        return
    except Exception as error:
        print(f"An error occurred {error}")
        return
    
    # Save the synthesized speech to a file
    with open(output_file, 'wb') as audio_file:
        audio_file.write(response['AudioStream'].read())
    
    print(f"Speech has been synthesized and saved to {output_file}")


if __name__ == "__main__":
    # Prompt the user to enter the text
    text = input("Please enter the text you want to synthesize:\n")
    
    # Specify the output file
    output_file = 'output.mp3'
    
    # Call the function to synthesize speech from text
    synthesize_speech(text, output_file)

    # Play the generated audio
    os.system(f"start {output_file}")