//
//  MessageView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct MessageView: View {
    let sender: Sender
    let message: String
    
    var body: some View {
        let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        HStack {
            if sender == .user{
                Spacer()
                Text(message)
                    .padding(10)
                    .background(Color(accentColor))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isUser: true))
            } else if sender == .assistant{
                Text(message)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(ChatBubble(isUser: false))
                    .foregroundColor(.black)
                Spacer()
            }
        }.padding(.horizontal)
    }
}



struct ChatBubble: Shape {
    let isUser: Bool

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: isUser ? [.topLeft, .topRight, .bottomLeft] : [.topLeft, .topRight, .bottomRight], cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}

#Preview {
    MessageView(sender: .user, message: "Hello world")
}
