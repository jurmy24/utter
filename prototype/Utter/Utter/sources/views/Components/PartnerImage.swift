//
//  PartnerImage.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-26.
//

import SwiftUI

struct PartnerImage: View {
    var body: some View {
        Image("Tim")
            .resizable()
            .scaledToFill()
            .frame(width: 65, height: 65)
            .background(.gray)
            .clipShape(Circle())
            .overlay(
                Image("US-flag")
                    .resizable()
                    .aspectRatio(contentMode: .fill) // Fills the frame with the image content
                    .frame(width: 40, height: 20)
                    .clipShape(Circle()) // Clips the view to a circle shape
                    .overlay(Circle().stroke(Color.white, lineWidth: 1))
                    .offset(y: 32) // This will position the flag below the main image frame
                    .padding(.bottom, 25)
                , alignment: .bottom)
    }
}

#Preview {
    PartnerImage()
}
