//
//  Audio.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation // Foundation is used for base layer data manipulation
import AVFoundation // AVFoundation is used for working with audio.

// Global variable 'audioPlayer' of type 'AVAudioPlayer?' used for audio playback. It's optional because it's not initially assigned a value (nil until we load a sound file into it).
var audioPlayer: AVAudioPlayer?

// Function 'playSound' is defined to play a sound. It accepts two parameters: 'sound' of type String representing the name of the sound file, and 'type' of type String representing the file extension of the sound file.
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
