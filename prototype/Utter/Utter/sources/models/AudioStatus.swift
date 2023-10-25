//
//  AudioStatus.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation

// Defines an enumeration to represent different audio states.
enum AudioStatus: Int, CustomStringConvertible {
    // Three cases representing the states of audio: stopped, playing, or recording.
    case stopped,     // Represents a state where audio is not playing and not recording.
         playing,     // Represents a state where audio is currently playing.
         recording    // Represents a state where audio is currently being recorded.
    
    // Computed property to map each state to a string describing the state.
    var audioName: String {
        // An array of string descriptions corresponding to each case of the AudioStatus.
        let audioNames = ["Audio:Stopped", "Audio:Playing", "Audio:Recording"]
        
        // This returns the specific string that corresponds to the current case.
        // 'rawValue' is an inherent property of enums that have a type, in this case, Int,
        // and it represents the index of each case (0 for 'stopped', 1 for 'playing', and so on).
        return audioNames[rawValue]
    }
    
    // A computed property to provide a description of the enum case.
    // This is a requirement of the CustomStringConvertible protocol,
    // which allows the enum to present a human-readable description when converted to a string.
    var description: String {
        // The description is the same as the audioName for each state.
        return audioName
    }
}
