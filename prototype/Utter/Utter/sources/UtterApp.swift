//
//  UtterApp.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

/*
 This file deals with setting up the actual App. It's the main entry point.
 */

import SwiftUI // SwiftUI framework provides the tools for building the user interface.
import AVFoundation // AVFoundation framework provides the audio playback and recording capabilities.

// Declaring a class that inherits from NSObject and conforms to the UIApplicationDelegate protocol.
// NSObject is the root class of most Objective-C class hierarchies, from which subclasses inherit a basic interface to the runtime system and the ability to behave as Objective-C objects. It defines the basic object behavior (such as initialization, comparison, and memory management) in the Objective-C runtime. In Swift, NSObject is often used as a base class for interfacing with Objective-C APIs, including UIKit.

// UIApplicationDelegate protocol is a set of methods that are called in response to important events in the lifecycle of a UIApplication. It's where you manage application-level events and states. The delegate (conforming to this protocol) can respond to incoming notifications such as the app launching, entering the foreground, entering the background, terminations, and memory warnings, allowing appropriate adjustments to be made.

class AppDelegate: NSObject, UIApplicationDelegate {
    // This function is called after the application has finished launching to perform any final initialization.
    // It receives the application instance and launch options as parameters.
    @AppStorage("isOnboarding") var isOnboarding = true
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        // For now we set these to default values to see what it looks like
        isOnboarding = true
        isLoggedIn = false
        
        AudioManager.sharedAudio.setupAudioSession()
        
        // Returning true to indicate that the app has completed its launching processes successfully.
        return true
    }
}


@main
struct UtterApp: App {
    
    // Adapting the AppDelegate class for use with the new SwiftUI App lifecycle.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    // The scene property contains the windows and views for the app's user interface.
    var body: some Scene {
        // Creating a window group to host the app's content.
        
        WindowGroup {
            
            
            
            // The ContentView is the initial view loaded within the window.
            ContentView()
        }
    }
}
