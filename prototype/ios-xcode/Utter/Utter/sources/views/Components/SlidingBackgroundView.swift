//
//  SwiftUIView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct SlidingBackgroundView: View {
    // State to control the sliding effect
    @State private var offset: CGFloat = 0
    let screenWidth = UIScreen.main.bounds.width

    var body: some View {
        // Using ZStack to ensure the image covers the entire background
        ZStack {
            Image("SlidingBackground")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: offset)
                .onAppear {
                    // Start the animation when the view appears
                    withAnimation(Animation.linear(duration: 10).repeatForever(autoreverses: true)) {
                        // Move the image by -200 points over 20 seconds. Adjust as needed.
                        offset -= screenWidth/2
                    }
                }
        }
        .edgesIgnoringSafeArea(.all) // Ensures the image covers the entire screen
    }
}


struct SlidingBackground_Previews: PreviewProvider {
    static var previews: some View {
        SlidingBackgroundView()
    }
}


//#Preview {
//    SlidingBackgroundView()
//}
