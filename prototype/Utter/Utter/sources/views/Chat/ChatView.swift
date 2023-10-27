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
    
    // Sample Data
    let messages: [(isUser: Bool, message: String)] = [
        (false, "Yes! It was sooo cool to see. It was awesome."),
        (true, "How are you feeling today, are you doing good?"),
        (false, "I am doing great, I went jogging outside."),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I am doing great, I went jogging outside. ipsum et lorem ipsum et lorem ipsum ipsum et lorem ipsum et Lorem ipsum"),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I have to go. Let’s talk soon again okay?"),
        (true, "Bye, see you soon!"),
        (false, "I am doing great, I went jogging outside."),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I am doing great, I went jogging outside. ipsum et lorem ipsum et lorem ipsum ipsum et lorem ipsum et Lorem ipsum"),
        (true, "Great, good job! What do you like about jogging the most?"),
        (false, "I have to go. Let’s talk soon again okay?"),
        (true, "Bye, see you soon!")
    ]
    
    var body: some View {
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
                        ForEach(messages, id: \.message) { messageData in
                            MessageView(isUser: messageData.isUser, message: messageData.message)
                        }
                    }
                    Divider()
                    HStack {
                        TextField("Type Something...", text: .constant(""))
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
//                    .edgesIgnoringSafeArea(.all)
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
