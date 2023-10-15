//
//  SpeakerView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-14.
//

import SwiftUI

struct SpeakerView: View {
    @State private var isTalking: Bool = false
    
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
            }) {
                Text(isTalking ? "Release to End Talking" : "Press and Hold to Talk")
                    .foregroundColor(.white)
                    .padding()
                    .background(isTalking ? Color.red : Color.green)
                    .cornerRadius(10)
            }
            .padding()
            
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color(.systemBackground))
                .shadow(radius: 10)
        )
        .padding()
    }
}

struct SpeakerView_Previews: PreviewProvider {
    static var previews: some View {
        SpeakerView()
    }
}
