//
//  AudioStatus.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-17.
//

import Foundation

enum AudioStatus: Int, CustomStringConvertible {
    case stopped,
         playing,
         recording
    
    var audioName: String {
        let audioNames = ["Audio:Stopped", "Audio:Playing", "Audio:Recording"]
        return audioNames[rawValue]
    }
    
    var description: String {
        return audioName
    }
}
