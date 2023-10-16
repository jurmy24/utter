//
//  TandemListView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

import SwiftUI

struct TandemListView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: SpeakerView()) {
                    Text("Go to Speaker View")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .navigationTitle("First View")
        }
    }
}

struct TandemListView_Previews: PreviewProvider {
    static var previews: some View {
        TandemListView()
    }
}
