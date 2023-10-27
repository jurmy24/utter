//
//  MessageView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct MessageView: View {
    let isUser: Bool
    let message: String
    
    var body: some View {
        let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        HStack {
            if isUser {
                Spacer()
                Text(message)
                    .padding(10)
                    .background(Color(accentColor))
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isUser: isUser))
            } else {
                Text(message)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(ChatBubble(isUser: isUser))
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
    MessageView(isUser: true, message: "Hello world")
}
