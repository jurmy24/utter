//
//  ContentView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

// NOTE: Toggle block command is cmd + on my keyboard

import SwiftUI

struct ContentView: View {
    // Appstorage allows the onboarding value to persist when you exit the app too
    @AppStorage("onboarding") var onboarding = true
    
    var body: some View {
        if onboarding {
            OnboardingView()
        } else{
            LoginView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
