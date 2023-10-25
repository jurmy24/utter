//
//  AudioBox.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation
import AVFoundation

// Define a class 'AudioBox' that inherits from NSObject and conforms to the ObservableObject protocol from SwiftUI, which will allow UI updates based on changes to its properties.
class AudioBox: NSObject, ObservableObject {
    
    // Define optional AVAudioRecorder and AVAudioPlayer objects
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer?
    var synthesizer: AVSpeechSynthesizer?
    
    func setupUtterance() -> Void {
        // Create a speech synthesizer.
        self.synthesizer = AVSpeechSynthesizer()
        self.synthesizer?.usesApplicationAudioSession = false
    }
    
    func generateUtterance(speechText: String) -> Void{
        // Create an utterance.
        let utterance = AVSpeechUtterance(string: speechText)
        
        // Choose a voice using a language code
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Choose a voice using an identifier
        utterance.voice = AVSpeechSynthesisVoice(identifier: AVSpeechSynthesisVoiceIdentifierAlex)
        
        // Configure the utterance.
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.pitchMultiplier = 1.5
        utterance.pitchMultiplier = 1
        utterance.volume = 2
        //        utterance.postUtteranceDelay = 0.2
        
        // Tell the synthesizer to speak the utterance.
        DispatchQueue.main.async {
            self.synthesizer?.speak(utterance)
        }
    }
}




