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
    @ObservedObject var chatGPTCaller = ChatGPTCaller()
    @ObservedObject var audioBox = AudioBox()
    
    @State private var isRecording = false
    @State var userTranscript = ""
    @State var botResponse = ""
    @State var models = [String]() // to eventually store the chat log
    @AppStorage("isInCall") var isInCall = false
    
    var body: some View {
        
        let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        let accentColor2 = #colorLiteral(red: 0.9183288813, green: 0.580676496, blue: 0.4868528843, alpha: 1)
        
        ZStack{
            SlidingBackgroundView()
            
            VStack(spacing: 20) {
                
                PartnerImage(size: 150.0).padding()
                Text("Tim").font(.headline)
                
                Spacer()
                
                Button(action: {
                    isInCall = false
                }) {
                    ZStack {
                        // The Circle view acts as the background of the button.
                        Circle()
                            .fill(Color(accentColor2)) // Changes color based on recording status.
                            .frame(width: 100, height: 100) // Specifies the size of the circle.
                        
                        Text("End talk")
                            .scaledToFill()
                            .frame(width: 114, height: 114)
                            .foregroundColor(Color.white)
                            .fontWeight(.bold)
                    }
                }.padding()
                
                ZStack {
                    // The Circle view acts as the background of the button.
                    Circle()
                        .fill(isRecording ? Color(accentColor) : Color.white) // Changes color based on recording status.
                        .frame(width: 150, height: 150) // Specifies the size of the circle.
                    
                    Image(isRecording ? "SpeakingIcon-White" : "SpeakingIcon-Blue")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 114, height: 114)
                    
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
            .padding()
            .onAppear{
                isInCall = true
                self.chatGPTCaller.setup()
            }.onDisappear{
                isInCall = false
            }
        }.navigationBarBackButtonHidden()
        
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
        guard !self.userTranscript.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        print("User: \(self.userTranscript)")
        self.chatGPTCaller.send(text: self.userTranscript){response in
            DispatchQueue.main.async{
                self.botResponse = response
                print("Tim: \(self.botResponse)")
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


