//
//  Message.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-28.
//

import Foundation

// Set them as codable so that I can use them in JSON
struct Message: Codable {
    let content: String
    let sender: Sender
    let timestamp: Date
    let aiPartner: String // eg. Tim
    // Todo: Should add User as well later
}

enum Sender: String, Codable {
    case user
    case assistant
    case admin
}
