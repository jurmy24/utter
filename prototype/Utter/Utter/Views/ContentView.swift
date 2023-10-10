//
//  ContentView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

// NOTE: Toggle block command is cmd + on my keyboard

import SwiftUI

struct ContentView: View {
    @State var pushLoginView: Bool = false
    
    var body: some View {
        NavigationView{
            ZStack {
                // Purple faded background
                Color.purple.opacity(0.9).edgesIgnoringSafeArea(.all)
                
                NavigationLink(isActive: $pushLoginView) {
                    LoginView()
                } label: {
                
                    // Your original VStack
                    VStack {
                        Image(systemName: "speaker.fill")
                            .foregroundColor(.white)  // Changing accent color to white
                            .font(.largeTitle)
                        Text("Utter")
                            .foregroundColor(.white)  // Making the text white
                            .font(.largeTitle)
                    }
                    .accentColor(.white)  // Setting the VStack's accent color to white
                }
            }
        }.onAppear {
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { _ in
                pushLoginView = true
            }
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
