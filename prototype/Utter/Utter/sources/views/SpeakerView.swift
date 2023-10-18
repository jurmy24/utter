//
//  SpeakerView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI
import AVFoundation

struct SpeakerView: View {
    @State private var isTalking: Bool = false
    @State var lyrics = ""
    @ObservedObject var audioBox = AudioBox()
    @State var hasMicAccess = false
    @State var displayNotification = false
    
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
                    Text(isTalking ? "Speaking..." : "Connected")
                        .foregroundColor(isTalking ? .green : .gray)
                        .font(.subheadline)
                }
            }
            
            Button(action: {
                isTalking.toggle()
                if audioBox.status == .stopped {
                    if hasMicAccess{
                        audioBox.record()
                    }else{
                        requestMicrophoneAccess()
                    }
                    
                } else {
                    audioBox.stopRecording()
                    playSound(sound: "audio", type: "mp3")
                }
            }) {
                Text(isTalking ? "Release to End Talking" : "Press and Hold to Talk")
                    .foregroundColor(.white)
                    .padding()
                    .background(isTalking ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding()
            Text(lyrics).foregroundColor(.black)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
            
            
        )
        .padding()
        .onAppear{
            //playSound(sound: "audio", type: "mp3") // Currently not playing the audio so I don't confuse the recording
//            requestPermission { result in
//                lyrics = result
//            }
            audioBox.setupRecorder() // Initialize the recorder
        }
        .alert(isPresented: $displayNotification){
            Alert(title: Text("Requires microphone access"),
                  message: Text("You're screwed"),
                  dismissButton: .default(Text("OK")))
        }
        
        
        
    }
    
    
    private func requestMicrophoneAccess(){
        let session = AVAudioSession.sharedInstance()
        session.requestRecordPermission { granted in
            hasMicAccess = granted
            if granted {
                audioBox.record()
            }else{
                displayNotification = true
            }
            
        }
    }
    
    
    
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView()
    }
}
