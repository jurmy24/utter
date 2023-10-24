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
    
    // Use the @Published property wrapper to allow SwiftUI views to listen for changes to 'status'.
    // 'status' will hold the current state of audio recording/playback.
    @Published var status: AudioStatus = .stopped
    
    
    // Define optional AVAudioRecorder and AVAudioPlayer objects
    var audioRecorder: AVAudioRecorder?
    var audioPlayer: AVAudioPlayer? // This already exists in my Audio file
    var synthesizer: AVSpeechSynthesizer?
    
    
    // Computed property that generates a URL for storing audio memos. This URL points to the temporary directory, which is not backed up and can be cleared by the system at any time.
    var urlForMemo: URL {
        let fileManager = FileManager.default
        let tempDir = fileManager.temporaryDirectory
        let filePath = "TempMemo.caf"
        return tempDir.appendingPathComponent(filePath)
    }
    
    // Function to set up the audio recorder with specific settings.
    func setupRecorder(){
        // Define the recording settings. Here, we're specifying the audio format, sample rate, number of channels, and audio quality.
        let recordSettings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 44100.0,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // Try to create an AVAudioRecorder with the specified URL and settings.
        do {
            audioRecorder = try AVAudioRecorder(url: urlForMemo, settings: recordSettings)
            audioRecorder?.delegate = self // Set this class as the delegate to receive audio recorder events.
        } catch{
            print("Error creating audioRecorder")
        }
    }
    // Function to start recording audio.
    func record(){
        audioRecorder?.record()
        status = .recording
    }
    // Function to stop recording audio.
    func stopRecording(){
        audioRecorder?.stop()
        status = .stopped
    }
    
    // Method 'playSound' is defined to play a sound. It accepts two parameters: 'sound' of type String representing the name of the sound file, and 'type' of type String representing the file extension of the sound file.
    func playSound(fileName: String, type: String) -> Void {
        // Check if the sound file exists in the app bundle.
        // 'Bundle.main.path' is used to find the path for a resource (the sound file) in the main bundle of the app.
        
        if let path = Bundle.main.path(forResource: fileName, ofType: type){
            do{
                // Attempt to initialize 'audioPlayer' with the sound file located at the path.
                // 'AVAudioPlayer(contentsOf: URL)' is used here to create the audio player instance with the file located at the provided URL.
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                // If the audio player is successfully created, it starts playing the audio file.
                audioPlayer?.play()
            }catch let error{
                // If the audio player fails to be created (for reasons like the audio format not being supported, etc.),
                print(error)
            }
        } else {
            print("The file could not be found in the Bundle.")
        }
    }
    
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

// Extend AudioBox to conform to the AVAudioRecorderDelegate protocol. This protocol allows the class to respond to audioRecorder events.
extension AudioBox: AVAudioRecorderDelegate {
    // This method is called when the audioRecorder finishes recording.
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool){
        status = .stopped
    }
}





