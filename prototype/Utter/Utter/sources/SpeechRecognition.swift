//
//  SpeechRecognition.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation
import Speech

// TODO: Create a SpeechBox class to handle these things in a way similar to AudioBox

// Function to request speech recognition permission from the user.
// The 'completion' parameter is a closure that is called after speech recognition, receiving the recognized string as its parameter.
func requestPermission(completion: @escaping (String) -> Void){
    print("Started request permission")
    
    // Requests the authorization for speech recognition.
    // The stuff in {} here is a completion handler, which is executed when the outer function is complete
    SFSpeechRecognizer.requestAuthorization{authStatus in
        // Check if the authorization status is 'authorized'
        if authStatus == .authorized {
            // FileManager.default.fileExists(atPath: urlForMemo.path)
            // If there's an audio file named "audio.mp3" in the app's main bundle, proceed with recognizing audio.
            if let path = Bundle.main.path(forResource: "audio", ofType: "mp3"){
                // Calls 'recognizeAudio' function, passing the URL of the audio file and the completion handler.
                recognizeAudio(url: URL(fileURLWithPath: path), completion: completion)
            }else{
                print("File does not exist")
            }
        } else{
            print("Speech failed")
        }
    }
}

// Function to perform speech recognition on an audio file.
// 'url' is the URL of the audio file, and 'completion' is a closure that receives the recognized string as its parameter.
func recognizeAudio(url: URL, completion: @escaping (String) -> Void){
    print("Entered Recognize Audio")
    
    // Creates a new speech recognizer.
    let recognizer = SFSpeechRecognizer()
    // Creates a new speech recognition request for the audio file at the specified URL.
    let request = SFSpeechURLRecognitionRequest(url: url)
    
    // Starts the speech recognition process.
    recognizer?.recognitionTask(with: request, resultHandler: {
        result, error in
        // Checks if there is a result.
        guard let result = result else{
            // If there's no result, print an error message and exit the closure.
            print("No results for speech recognition")
            return
        }
        print(result.bestTranscription.formattedString)
        // Calls the completion handler, passing the best transcription as the argument.
        completion(result.bestTranscription.formattedString)
    })
}
