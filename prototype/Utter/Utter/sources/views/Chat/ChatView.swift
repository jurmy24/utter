//
//  ChatView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct ChatView: View {
    // Sample Data
    let messages: [(isUser: Bool, message: String)] = [
        (false, "Yes! It was sooo cool to see. It was awesome."),
        (true, "How are you feeling today, are you doing good?"),
        (false, "I am doing great, I went jogging outside."),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I am doing great, I went jogging outside. ipsum et lorem ipsum et lorem ipsum ipsum et lorem ipsum et Lorem ipsum"),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I have to go. Let’s talk soon again okay?"),
        (true, "Bye, see you soon!")
    ]
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(messages, id: \.message) { messageData in
                    MessageView(isUser: messageData.isUser, message: messageData.message)
                }
            }
            HStack {
                TextField("Type something...", text: .constant(""))
                Button(action: {}, label: {
                    Text("Send")
                })
            }
            .padding()
        }
        .padding()
        .navigationBarTitle("Tim", displayMode: .inline)
    }
}

#Preview {
    ChatView()
}
