//
//  ChatOrCallDirect.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-27.
//

import SwiftUI

struct ChatOrCallDirect: View {
    // Appstorage allows the onboarding value to persist when you exit the app too
    @AppStorage("isInCall") var isInCall = false
    
    var body: some View {
        if isInCall {
            SpeakerView()
        } else{
            ChatView()
        }
    }
}

struct ChatOrCallDirect_Previews: PreviewProvider {
    static var previews: some View {
        ChatOrCallDirect()
    }
}
