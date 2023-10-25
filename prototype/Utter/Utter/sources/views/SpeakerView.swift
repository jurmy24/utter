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
    
    @State var userTranscript = ""
    @State private var isRecording = false
    @State var botResponse = ""
    @State var models = [String]()
    
    var body: some View {
        
        VStack(spacing: 20) {
            
            HStack {
                Image(systemName: "person.fill")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .padding()
                VStack(alignment: .leading) {
                    Text("Tim")
                        .font(.headline)
                }
            }
            ZStack {
                // The Circle view acts as the background of the button.
                Circle()
                    .fill(isRecording ? Color.red : Color.green) // Changes color based on recording status.
                    .frame(width: 100, height: 100) // Specifies the size of the circle.
                
                // The Text view displays the button's label.
                Text(isRecording ? "Recording" : "Push to Talk")
                    .foregroundColor(.white) // Makes the text color white for better contrast.
            }.gesture(DragGesture(minimumDistance: 0) // Gesture to detect touch down and up
                .onChanged({ _ in
                    
                    if !self.isRecording {
                        self.startRecording()
                    }
                })
                    .onEnded({ _ in
                        self.endRecording()
                        self.sendMessage()
                    })
            )
            
            Text(self.botResponse).foregroundColor(.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
            
        )
        .padding()
        .onAppear{
            chatGPTCaller.setup()
            audioBox.setupUtterance()
        }.onDisappear{}
    }
    
    private func startRecording(){
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endRecording(){
        speechRecognizer.stopTranscribing()
        self.userTranscript = speechRecognizer.transcript
        isRecording = false
    }
    
    private func sendMessage(){
        guard !self.userTranscript.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        print(self.userTranscript)
        chatGPTCaller.send(text: self.userTranscript){response in
            DispatchQueue.main.async{
                self.botResponse = response
                self.speakResponse()
            }
        }
    }
    
    private func speakResponse(){
        audioBox.generateUtterance(speechText: self.botResponse)
    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView()
    }
}

