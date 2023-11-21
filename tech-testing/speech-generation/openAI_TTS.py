from openai import OpenAI


your_openai_key = 'YOUR_KEY'
d = {
    'English': "Hi! My name is Tim, and I'll teach you some good old English! Hope you'll enjoy this as much as me!",
    # 'Spanish': '¡Hola! Esta es una prueba para ver qué tan bien suena cuando habla esta voz. ¡Los otros idiomas sonaban bien de todos modos!',
    'French': "Bonjour, je vois que t'as déjà fini ton travail donc je suis ici pour t'amuser. Ja m'appelle Gérard et j'aime faire des blagues.",
    'Swedish': 'Hej! Det här är ett test för att se hur bra det låter när den här rösten pratar. De andra språken lät bra i alla fall!'

}

client = OpenAI(api_key=your_openai_key)

voices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer']

for language in d:
    response = client.audio.speech.create(
        model="tts-1",
        voice='onyx',
        input=d[language]
    )

    response.stream_to_file(f'{language}.mp3')