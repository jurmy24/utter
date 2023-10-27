//
//  PartnerImage.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct PartnerImage: View {
//    var size: Int?
    var size: CGFloat = 65
    
    var body: some View {
        
        Image("Tim")
            .resizable()
            .scaledToFill()
            .frame(width: self.size, height: self.size)
            .background(.gray)
            .clipShape(Circle())
            .overlay(
                Image("US-flag")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Fills the frame with the image content
                    .frame(width: self.size*0.62, height: self.size*0.31)
                    .clipShape(Circle()) // Clips the view to a circle shape
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .offset(y: self.size/2) // This will position the flag below the main image frame
//                    .padding(.bottom, 25)
                , alignment: .center)
    }
}

#Preview {
    PartnerImage()
}
