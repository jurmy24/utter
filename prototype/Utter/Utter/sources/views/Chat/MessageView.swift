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
        HStack {
            if isUser {
                Spacer()
                Text(message)
                    .padding(10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .clipShape(ChatBubble(isUser: isUser))
            } else {
                Text(message)
                    .padding(10)
                    .background(Color.gray.opacity(0.2))
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
    MessageView(isUser: false, message: "Hello world")
}
