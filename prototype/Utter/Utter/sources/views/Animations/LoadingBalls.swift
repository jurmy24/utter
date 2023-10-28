//
//  LoadingBalls.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-27.
//

import SwiftUI

//struct LoadingBalls: View {
//    @State private var isAnimated = false
//    private var animationAmount = 0.5
//    
//    var body: some View {
//        let ballColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
//        
//        HStack {
//            Circle()
//                .fill(Color(ballColor))
//                .frame(width: 20, height: 20)
//                .scaleEffect(1.0 - animationAmount)
//            //                .animation(.easeInOut(duration: 0.5).repeatForever()
//            // value tells SwiftUI to render scale and opacity between 1.0 and 1.5
//            // SwiftUI determines how many frames to render based on duration
//                .animation(
//                    .easeInOut(duration: 0.5)
//                    .repeatForever(autoreverses: false),
//                    value: animationAmount
//                )
//            
//            Circle()
//                .fill(Color(ballColor))
//                .frame(width: 20, height: 20)
//                .scaleEffect(isAnimated ? 1.0 : 0.5)
//                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.3))
//            
//            Circle()
//                .fill(Color(ballColor))
//                .frame(width: 20, height: 20)
//                .scaleEffect(isAnimated ? 1.0 : 0.5)
//                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
//        }
//        .onAppear {
//            self.isAnimated = true
//            animationAmount = 1.5
//        }
//    }
//}

struct LoadingBalls: View {
    // Think of animationAmount as a light switch
    // The view has one look when value is 1.0 and a different look when value is 1.5
    @State private var animationAmount = 0.5
    var body: some View {
        
        let ballColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        
        HStack {
            Circle()
                .fill(Color(ballColor))
                .frame(width: 20, height: 20)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                        .repeatForever(autoreverses: true),
                    value: animationAmount
                )
            
            Circle()
                .fill(Color(ballColor))
                .frame(width: 20, height: 20)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true).delay(0.3),
                    value: animationAmount
                )

            
            Circle()
                .fill(Color(ballColor))
                .frame(width: 20, height: 20)
                .scaleEffect(animationAmount)
                .animation(
                    .easeInOut(duration: 1)
                    .repeatForever(autoreverses: true).delay(0.6),
                    value: animationAmount
                )
//                .animation(Animation.easeInOut(duration: 0.5).repeatForever().delay(0.6))
        }
        .onAppear {
            // Switch the value to 1.5
            // The view has a different look when the value is 1.5
            animationAmount = 1.3
        }
    }
}

#Preview {
    LoadingBalls()
}
