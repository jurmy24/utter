//
//  AudioManager.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-25.
//
import Foundation
import AVFoundation

// This is a singleton class that will manage the audio session for the complete application

final class AudioManager {
    // Singleton instance
    static let sharedAudio = AudioManager()

    private init() { }

    func setupAudioSession() {
        // Getting the shared audio session instance, which allows configuration of audio behavior.
        let session = AVAudioSession.sharedInstance()
        do {
            // Attempting to set the audio session category to both play and record audio, with audio output defaulting to the device's speaker.
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker) //, options: .defaultToSpeaker
            // Activating the audio session, making the audio configurations active.
            try session.setActive(true)
        }catch{
            // If there's an error in the 'try' block, it's caught here, and we print the error description.
            print("AVAudioSession configuration error: \(error.localizedDescription)")
        }
    }
    
    // Any other audio-related utility functions can be added here.
    func setupForRecording() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .default, options: .duckOthers) //TODO: maybe set as .playandrecord
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        }catch{
            print("AVAudioSession configuration error when setting up recording: \(error.localizedDescription)")
        }
    }
    
    func setupForPlaying(){
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playAndRecord, options: .defaultToSpeaker)
            try session.setActive(true)
        }catch{
            print("AVAudioSession configuration error when setting up recording: \(error.localizedDescription)")
        }
    }
}

