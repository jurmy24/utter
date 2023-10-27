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
    
    // Define an AVSpeechSynthesizer object and an utterance object
    var synthesizer: AVSpeechSynthesizer?
    var utterance: AVSpeechUtterance?
    var synthVoice: AVSpeechSynthesisVoice?
    var player: AVAudioPlayer?
        
    func generateUtterance(speechText: String) -> Void{
        
        self.synthesizer = AVSpeechSynthesizer()
        
        // Here I set up the audioSession for playing!
        AudioManager.sharedAudio.setupForPlaying()
        
        // See if this gets rid of some error messages
        AVSpeechSynthesisVoice.speechVoices()

        // Create an utterance.
        self.utterance = AVSpeechUtterance(string: speechText)
        
        // Choose a voice using a language code
        self.utterance?.voice = AVSpeechSynthesisVoice(language: "en-US")
        
        // Configure the utterance.
        self.utterance?.rate = AVSpeechUtteranceDefaultSpeechRate
        self.utterance?.pitchMultiplier = 1
        self.utterance?.volume = 1.0
        //        utterance.postUtteranceDelay = 0.2
        
        // Tell the synthesizer to speak the utterance.
        DispatchQueue.main.async {
            self.synthesizer?.speak(self.utterance!)
        }
    }
    
    func playRecordingEndedSound() {
        
        // Here I set up the audioSession for playing!
        AudioManager.sharedAudio.setupForPlaying()
        
        guard let url = Bundle.main.url(forResource: "water-drop-sound", withExtension: ".mp3") else {
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        }catch let error{
            print("Error playing sound. \(error.localizedDescription)")
        }
    }
    
}




