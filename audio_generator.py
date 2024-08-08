import requests
import json
from dotenv import load_dotenv
import os

from schema import ExerciseBlock, Story, StoryBlock

load_dotenv()


def get_audio_for_text(text: str, voice_id: str, name: str):

    # Define constants for the script
    XI_API_KEY = os.getenv("XI_API_KEY")
    CHUNK_SIZE = 1024  # Size of chunks to read/write at a time
    VOICE_ID = voice_id  # ID of the voice model to use
    TEXT_TO_SPEAK = text  # Text you want to convert to speech
    OUTPUT_PATH = f"voices/output-{name}.mp3"  # Path to save the output audio file

    # Construct the URL for the Text-to-Speech API request
    tts_url = f"https://api.elevenlabs.io/v1/text-to-speech/{VOICE_ID}/stream"

    # Set up headers for the API request, including the API key for authentication
    headers = {"Accept": "application/json", "xi-api-key": XI_API_KEY}

    # Set up the data payload for the API request, including the text and voice settings
    data = {
        "text": TEXT_TO_SPEAK,
        "model_id": "eleven_multilingual_v2",
        "voice_settings": {
            "stability": 0.5,
            "similarity_boost": 0.8,
            "style": 0.0,
            "use_speaker_boost": True,
        },
    }

    # Make the POST request to the TTS API with headers and data, enabling streaming response
    response = requests.post(tts_url, headers=headers, json=data, stream=True)

    # Check if the request was successful
    if response.ok:
        # Open the output file in write-binary mode
        with open(OUTPUT_PATH, "wb") as f:
            # Read the response in chunks and write to the file
            for chunk in response.iter_content(chunk_size=CHUNK_SIZE):
                f.write(chunk)
        # Inform the user of success
        print("Audio stream saved successfully.")
    else:
        # Print the error message if the request was not successful
        print(response.text)


def integrate_audio_into_story(story: Story) -> Story:
    for chapter in story.chapters:
        for block in chapter.blocks:
            if isinstance(block, StoryBlock):
                for line in block.lines:
                    if line.audio is None:
                        line.audio = get_audio_for_text(line.text)
            elif isinstance(block, ExerciseBlock):
                for exercise in block.exercise_options:
                    if exercise.type in {
                        "comp-listen",
                        "pronounce-rep",
                        "pronounce-deaf",
                        "speak-replace",
                    }:
                        if exercise.audio is None:
                            exercise.audio = get_audio_for_text(
                                exercise.query or exercise.affected_text
                            )
    return story


if __name__ == "__main__":
    # # An API key is defined here. You'd normally get this from the service you're accessing. It's a form of authentication.
    # XI_API_KEY = os.getenv("XI_API_KEY")

    # # This is the URL for the API endpoint we'll be making a GET request to.
    # url = "https://api.elevenlabs.io/v1/voices"

    # # Here, headers for the HTTP request are being set up.
    # # Headers provide metadata about the request. In this case, we're specifying the content type and including our API key for authentication.
    # headers = {
    #     "Accept": "application/json",
    #     "xi-api-key": XI_API_KEY,
    #     "Content-Type": "application/json",
    # }

    # # A GET request is sent to the API endpoint. The URL and the headers are passed into the request.
    # response = requests.get(url, headers=headers)

    # # The JSON response from the API is parsed using the built-in .json() method from the 'requests' library.
    # # This transforms the JSON data into a Python dictionary for further processing.
    # data = response.json()

    # # A loop is created to iterate over each 'voice' in the 'voices' list from the parsed data.
    # # The 'voices' list consists of dictionaries, each representing a unique voice provided by the API.
    # for voice in data["voices"]:
    #     # For each 'voice', the 'name' and 'voice_id' are printed out.
    #     # These keys in the voice dictionary contain values that provide information about the specific voice.
    #     print(f"{voice['name']}; {voice['voice_id']}")

    #####################################

    get_audio_for_text(
        "Fågeln sjunger i trädet. Flickan leker med sin docka. Bilen kör på vägen. Vi åkte båt över sjön. Klockan är halv fyra. Skärgården är vacker på sommaren.",
        "XB0fDUnXU5powFXDhCwa",
        name="Charlotte",
    )

# Sarah: Great, maybe Anna - EXAVITQu4vr4xnSDxMaL
# Laura: bad - FGY2WhTYpPnrIDTdsKH5
# Charlie: Great (narrator voice) - IKne3meq5aSn9XLyUdCD
# George: Great (maybe Karl) - JBFqnCBsd6RMkjVDRZzb
# Callum: Great (maybe narrator) - N2lVS1w4EtoT3dr4eOWO
# Liam: Quite good (better as Karl) - TX3LPaxmHKxFdv7VOQHJ
# Charlotte: Quite good (better as narrator) - XB0fDUnXU5powFXDhCwa
# Alice: Bad - Xb7hH8MSUJpSbSDYk0k2
# Matilda: Not great - XrExE9yKIg1WjnnlVkGX
# Will: Great (Karl) - bIHbv24MWmeRgasZH58o
# Jessica: Not great - cgSgspJ2msm6clMCkdW9
# Chris: Good (maybe Karl) - iP95p4xoKVk53GoZ742B
# Brian: Quite good (narrator) - nPczCjzI2devNBz1zQrb
# Daniel; Awesome (narrator) -  onwK4e9ZLuTAKqWW03F9
# Lily: Great (anna) - pFZP5JQG7iQjIQuC4Bku
# Bill: Great (maybe narrator) - pqHfZKP75CvOlQylNhV4
