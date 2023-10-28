//
//  SpeakerView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI
import AVFoundation

struct SpeakerView: View {
    @ObservedObject var speechRecognizer = SpeechRecognizer()
    @ObservedObject var audioBox = AudioBox()
    
    @State private var isRecording = false
    @State var userTranscript = ""
    @State var botResponse = ""
    @State var models = [String]() // to eventually store the chat log
    @State private var isLoading = false
    @AppStorage("isInCall") var isInCall = false
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    let sizeConversion = UIScreen.main.bounds.height / 852.0 // this is the size of the iphone 15 pro screen that I build the app on
    
    var body: some View {
        
        
        let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        let accentColor2 = #colorLiteral(red: 0.9183288813, green: 0.580676496, blue: 0.4868528843, alpha: 1)
        
        ZStack{
            SlidingBackgroundView()
            
            VStack(spacing: 15) {
                
                PartnerImage(size: 120.0*sizeConversion).padding()
//                Text("Tim").font(.headline)
                
                if isLoading {
                    Spacer()
                    LoadingBalls()
                    Spacer()
                } else {
                    Spacer()
                }
                
                Button(action: {
                    isInCall = false
                }) {
                    ZStack {
                        Circle()
                            .fill(Color(accentColor2))
                            .frame(width: 90*sizeConversion, height: 90*sizeConversion)
                        
                        Text("End talk")
                            .scaledToFill()
                            .frame(width: 110*sizeConversion, height: 110*sizeConversion)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                    }
                }
                
                ZStack {
                    // The Circle view acts as the background of the button.
                    Circle()
                        .fill(isRecording ? Color(accentColor) : Color.white) // Changes color based on recording status.
                        .frame(width: 120*sizeConversion, height: 120*sizeConversion) // Specifies the size of the circle.
                    
                    Image(isRecording ? "SpeakingIcon-White" : "SpeakingIcon-Blue")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100*sizeConversion, height: 100*sizeConversion)
                    
                }.gesture(DragGesture(minimumDistance: 0) // Gesture to detect touch down and up
                    .onChanged({ _ in
                        if !self.isRecording {
                            self.startRecording()
                        }
                    })
                        .onEnded({ _ in
                            self.endRecording()
                            audioBox.playRecordingEndedSound()
                            self.sendMessage()
                        })
                )
                Text("Push and hold to talk").foregroundStyle(.white).fontWeight(.bold)
            }
            .padding(.bottom, 60)
            .padding(.top, 20)
            .frame(width:screenWidth, alignment: .center)
            .onAppear{
                isInCall = true
                self.getIntroMessage()
            }.onDisappear{
                isInCall = false
            }
        }.navigationBarBackButtonHidden()
//            .navigationBarTitleDisplayMode(.hidden)
            .frame(width:screenWidth, height: screenHeight)
        
    }
    
    private func startRecording(){
        self.speechRecognizer.resetTranscript()
        self.speechRecognizer.startTranscribing()
        self.isRecording = true
    }
    
    private func endRecording(){
        self.speechRecognizer.stopTranscribing()
        self.userTranscript = speechRecognizer.transcript
        //        self.userTranscript = "Hello, you are a boss."
        self.isRecording = false
    }
    
    private func sendMessage(){
        isLoading = true
        guard !self.userTranscript.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        print("User: \(self.userTranscript)")
        ChatModel.chatModel.send(text: self.userTranscript){response in
            DispatchQueue.main.async{
                self.botResponse = response
                print("Tim: \(self.botResponse)")
                self.isLoading = false
                self.speakResponse()
                
            }
        }
    }
    
    private func getIntroMessage(){
        isLoading = true
        
        ChatModel.chatModel.send(text: "Hello. Greet me and suggest some topics to discuss or ask me if theres something I want to discuss.", save: false){response in
            DispatchQueue.main.async{
                self.botResponse = response
                print("Tim: \(self.botResponse)")
                self.isLoading = false
                self.speakResponse()
                
            }
        }
    }
    
    private func speakResponse(){
        self.audioBox.generateUtterance(speechText: self.botResponse)
    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView()
    }
}


