//
//  OnboardingView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI

//struct OnboardingView: View {
//    // Appstorage allows the onboarding value to persist when you exit the app too
//    @AppStorage("onboarding") var onboarding = true
//
//    var body: some View {
//        ZStack {
//            // Purple faded background
//            Color.purple.opacity(0.9).edgesIgnoringSafeArea(.all)
//
//            // Showing a speaker and Utter "logo"
//            VStack {
//                Text("Utter")
//                    .foregroundColor(.white)  // Making the text white
//                    .font(.largeTitle)
//                Spacer()
//                Button(action: {
//                    onboarding = false
//                }) {
//                    HStack {
//                        Text("Continue")
//                        Image(systemName: "chevron.right")
//                    }.foregroundColor(Color(.white))
//                }
//            }.padding()
//        }
//    }
//}

struct OnboardingView: View {
    // Appstorage allows the onboarding value to persist when you exit the app too
    @AppStorage("isOnboarding") var isOnboarding = true
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        ZStack {
            // Background Gradient
            //            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.pink]), startPoint: .top, endPoint: .bottom)
            //                .edgesIgnoringSafeArea(.all)
            // Vertical Gradient
            
            SlidingBackgroundView()
            
            
            // Content
            VStack(spacing: 40) {
                
                Spacer()
                // Logo
                Image("UtterLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150) // adjust this as per your logo's aspect ratio
                
                Text("Get your artificial language partner to practice speaking.")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(maxWidth: screenWidth, alignment: .leading)
                
                Text("With our AI-powered language partner you can learn your language like a pro.")
                    .font(.headline)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                    .foregroundColor(.white)
                    .frame(maxWidth: screenWidth, alignment: .leading)
                
                Spacer()
                
                // Arrow/Button at the bottom (you can replace this with your custom button)
                
                Button(action: {
                    isOnboarding = false
                }) {
                    Image(systemName: "arrow.right.circle.fill")
                        .font(.system(size: 60))
                        .foregroundColor(.white)
                }.padding()
                
            }.frame(maxWidth: screenWidth, maxHeight: .infinity)
        }
    }
}


struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}





