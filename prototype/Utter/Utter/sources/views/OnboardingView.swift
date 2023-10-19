//
//  OnboardingView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI

struct OnboardingView: View {
    // Appstorage allows the onboarding value to persist when you exit the app too
    @AppStorage("onboarding") var onboarding = true
    
    var body: some View {
        ZStack {
            // Purple faded background
            Color.purple.opacity(0.9).edgesIgnoringSafeArea(.all)
            
            // Showing a speaker and Utter "logo"
            VStack {
                Text("Utter")
                    .foregroundColor(.white)  // Making the text white
                    .font(.largeTitle)
                Spacer()
                Button(action: {
                    onboarding = false
                }) {
                    HStack {
                        Text("Continue")
                        Image(systemName: "chevron.right")
                    }.foregroundColor(Color(.white))
                }
            }.padding()
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
