//
//  SpeechRecognition.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation
import Speech

func requestPermission(completion: @escaping (String) -> Void){
    print("Started request permission")
    SFSpeechRecognizer.requestAuthorization{authStatus in
        print("Here now")
        if authStatus == .authorized {
            if let path = Bundle.main.path(forResource: "audio", ofType: "mp3"){
                recognizeAudio(url: URL(fileURLWithPath: path), completion: completion)
            }else{
                print("File does not exist")
            }
        } else{
            print("Speech failed")
        }
    }
}
var counter = 0
func recognizeAudio(url: URL, completion: @escaping (String) -> Void){
    print("Entered Recognize Audio")
    let recognizer = SFSpeechRecognizer()
    let request = SFSpeechURLRecognitionRequest(url: url)
    recognizer?.recognitionTask(with: request, resultHandler: {
        result, error in
        guard let result = result else{
            print("No results for speech recognition")
            return
        }
        print(counter)
        print(result.bestTranscription.formattedString)
        completion(result.bestTranscription.formattedString)
    })
}
