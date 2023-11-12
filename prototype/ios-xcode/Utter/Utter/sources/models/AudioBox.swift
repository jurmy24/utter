//
//  AudioBox.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation
import AVFoundation
//
//// Define a class 'AudioBox' that inherits from NSObject and conforms to the ObservableObject protocol from SwiftUI, which will allow UI updates based on changes to its properties.
//class AudioBox: NSObject, ObservableObject {
//    
//    // Define an AVSpeechSynthesizer object and an utterance object
//    var synthesizer: AVSpeechSynthesizer?
//    var utterance: AVSpeechUtterance?
//    var synthVoice: AVSpeechSynthesisVoice?
//    var player: AVAudioPlayer?
//        
//    func generateUtterance(speechText: String) -> Void{
//        
//        self.synthesizer = AVSpeechSynthesizer()
//        
//        // Here I set up the audioSession for playing!
//        AudioManager.sharedAudio.setupForPlaying()
//        
//        // See if this gets rid of some error messages
//        AVSpeechSynthesisVoice.speechVoices()
//
//        // Create an utterance.
//        self.utterance = AVSpeechUtterance(string: speechText)
//        
//        // Choose a voice using a language code
//        self.utterance?.voice = AVSpeechSynthesisVoice(language: "en-US")
//        
//        // Configure the utterance.
//        self.utterance?.rate = AVSpeechUtteranceDefaultSpeechRate
//        self.utterance?.pitchMultiplier = 1
//        self.utterance?.volume = 1.0
//        //        utterance.postUtteranceDelay = 0.2
//        
//        // Tell the synthesizer to speak the utterance.
//        DispatchQueue.main.async {
//            self.synthesizer?.speak(self.utterance!)
//        }
//    }
//    
//    func playRecordingEndedSound() {
//        
//        // Here I set up the audioSession for playing!
//        AudioManager.sharedAudio.setupForPlaying()
//        
//        guard let url = Bundle.main.url(forResource: "water-drop-sound", withExtension: ".mp3") else {
//            return
//        }
//        do {
//            player = try AVAudioPlayer(contentsOf: url)
//            player?.play()
//        }catch let error{
//            print("Error playing sound. \(error.localizedDescription)")
//        }
//    }
//    
//}


import AWSPolly // Import the Polly module from AWS SDK

class AudioBox: NSObject, ObservableObject {
    
    var player: AVAudioPlayer?
    
    // Configure your AWS credentials and region
    func setupAWS() {
        let credentialsProvider = AWSStaticCredentialsProvider(accessKey: "YOUR_ACCESS_KEY", secretKey: "YOUR_SECRET_KEY")
        let configuration = AWSServiceConfiguration(region: .USEast1, credentialsProvider: credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }
    
    func generateUtterance(speechText: String) {
        // Configure AWS if not already configured
        setupAWS()
        
        // Setup Polly client
        let pollyRequest = AWSPollySynthesizeSpeechURLBuilderRequest()
        pollyRequest.text = speechText
        pollyRequest.outputFormat = AWSPollyOutputFormat.mp3 // You can choose other formats like .ogg or .pcm
        pollyRequest.voiceId = AWSPollyVoiceId.joanna // You can choose other voices
        
        // Get the Polly Synthesize Speech URL Builder
        let builder = AWSPollySynthesizeSpeechURLBuilder.default().getPreSignedURL(pollyRequest)
    
//        // Request the URL for synthesis result
//        builder.continueOnSuccessWith(block: { (awsTask: AWSTask<NSURL>) -> Any? in
//            // The result of getPresignedURL task is NSURL.
//            // Again, we ignore the errors in the example.
//            let url = awsTask.result!
//
//            // Try playing the data using the system AVAudioPlayer
//            self.audioPlayer.replaceCurrentItem(with: AVPlayerItem(url: url as URL))
//            self.audioPlayer.play()
//
//            return nil
//        })
        
        builder.continueWith { (awsTask: AWSTask<NSURL>) -> Any? in
            // Error handling
            if let error = awsTask.error {
                print("Error occurred: \(error)")
                return nil
            }
            
            // Play the audio using AVAudioPlayer
            guard let url = awsTask.result else {
                print("No URL received from Polly")
                return nil
            }
            
            do {
                // Audio data is ready, set up player
                let audioData = try Data(contentsOf: url as URL)
                self.player = try AVAudioPlayer(data: audioData)
                self.player?.prepareToPlay()
                self.player?.play()
            } catch {
                print("Error playing audio: \(error)")
            }
            
            return nil
        }
    }
    
    // Other functions as needed...
}







