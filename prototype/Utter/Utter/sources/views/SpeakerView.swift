//
//  SpeakerView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI
import AVFoundation

struct SpeakerView: View {
    // @State private var isTalking: Bool = false
    @State var transcript = ""
    @ObservedObject var audioBox = AudioBox()
    @State var hasMicAccess = false
    @State var displayNotification = false
    @StateObject var speechRecognizer = SpeechRecognizer()
    @State private var isRecording = false
    @ObservedObject var chatGPTCaller = ChatGPTCaller()
    @State var text = ""
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
            
            Text(self.text).foregroundColor(.black)
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
        }.onDisappear{}
        //        .alert(isPresented: $displayNotification){
        //            Alert(title: Text("Requires microphone access"),
        //                  message: Text("You're screwed"),
        //                  dismissButton: .default(Text("OK")))
        //        }
    }
    
    private func startRecording(){
        speechRecognizer.resetTranscript()
        speechRecognizer.startTranscribing()
        isRecording = true
    }
    
    private func endRecording(){
        speechRecognizer.stopTranscribing()
        transcript = speechRecognizer.transcript
        isRecording = false
    }
    
    private func sendMessage(){
        guard !transcript.trimmingCharacters(in: .whitespaces).isEmpty else{
            return
        }
        print(transcript)
        chatGPTCaller.send(text: transcript){  response in
            DispatchQueue.main.async{
                self.text = response
                print(response)
            }
        }
    }
    
    //    private func requestMicrophoneAccess(){
    //        let session = AVAudioSession.sharedInstance()
    //        session.requestRecordPermission { granted in
    //            hasMicAccess = granted
    //            if granted {
    //                audioBox.record()
    //            }else{
    //                displayNotification = true
    //            }
    //
    //        }
    //    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView()
    }
}

