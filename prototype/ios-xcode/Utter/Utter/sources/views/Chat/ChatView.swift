//
//  ChatView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct ChatView: View {
    
    @AppStorage("isInCall") var isInCall = false
    
    var body: some View {
        
        if isInCall{
            SpeakerView()
        } else{
            Chat()
        }
    }
}

struct Chat: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @State private var text = ""
    @State private var chatMessages = ChatModel.chatModel.chatHistory
    
    var btnBack : some View { Button(action: {
        
        self.presentationMode.wrappedValue.dismiss()
    }) {
        let backColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        HStack {
            Image(systemName: "chevron.left") // set image here
                .aspectRatio(contentMode: .fit)
                .foregroundColor(Color(backColor))
        }
    }
    }
    
    
    let screenWidth = UIScreen.main.bounds.width
    @AppStorage("isInCall") var isInCall = false
    
    var body: some View {
        
        // Sample Data
//        let messages: [Message] = ChatModel.chatModel.chatHistory
        
        VStack (spacing: 0){
            
            let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
            Rectangle()
                .frame(height: 90)
                .foregroundStyle(.white)
                .ignoresSafeArea()
            
            ZStack{
                
                Image("ChatBackground")  // Replace "backgroundImage" with the name of your image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ScrollView {
                        VStack(spacing: 10) {
                            ForEach(chatMessages, id: \.timestamp) { messageData in
                                MessageView(sender: messageData.sender, message: messageData.content)
                            }
                        }
                        .padding()
                    }
                    Divider()
                    HStack {
                        TextField("Type Something...", text: $text)
                        .padding(.leading, 10)
                        .frame(height: 60)
                        .background(
                            Rectangle()
                                .stroke(Color.white, lineWidth: 1)
                                .background(Color.white)
                                .cornerRadius(20)
                        )
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .onSubmit{
                            // Action to perform when finished typing
                            ChatModel.chatModel.send(text: text){response in
                                DispatchQueue.main.async{
                                    print("Tim responded textually.")
                                    chatMessages = ChatModel.chatModel.chatHistory // update chatmessages
                                }
                            }
                            text = ""
                            chatMessages = ChatModel.chatModel.chatHistory // update chatmessages
                        }
                        
                        NavigationLink(destination: SpeakerView()) {
                            Button(action: {
                                isInCall = true
                            }) {
                                ZStack {
                                    // The Circle view acts as the background of the button.
                                    Circle()
                                        .fill(Color(accentColor)) // Changes color based on recording status.
                                        .frame(width: 100, height: 100) // Specifies the size of the circle.
                                    
                                    Text("Join talk")
                                        .scaledToFill()
                                        .frame(width: 114, height: 114)
                                        .foregroundColor(Color.white)
                                        .fontWeight(.bold)
                                }
                            }
                        }
                    }
                    .frame(height: 100, alignment: .center)
                    .padding(.top, 5)
                }
                .padding()
                .navigationBarTitle("Tim", displayMode: .inline)
                .navigationBarBackButtonHidden(true)
                .navigationBarItems(leading: btnBack)
                .toolbar {
                    PartnerImage(size: 30)
                }
                .frame(width:screenWidth)
                
            }.padding(.top, -80).edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview {
    ChatView()
}
