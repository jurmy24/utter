//
//  TandemListView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

import SwiftUI

struct TandemListView: View {
    let screenWidth = UIScreen.main.bounds.width
    
    var body: some View {
        
        NavigationView{
            ZStack{
                
                SlidingBackgroundView()
                
                VStack{
                    VStack {
                        Spacer()
                        
                        VStack{
                            NavigationLink(destination: ChatOrCallDirect()) {
                                LanguagePartnerRow()
                                    .padding(.horizontal, 15)
                            }
                            
                            Divider()
                                .padding(.horizontal, 15)
                            
                            Spacer()
                        }.background(Color.white)
                            .clipShape(UnevenRoundedRectangle(cornerRadii: .init(
                                topLeading: 30.0,
                                topTrailing: 30.0)))
                            .ignoresSafeArea()
                    }
                    .navigationTitle("Language partners")
                    .navigationBarTitleDisplayMode(.inline)
                    .navigationBarItems(trailing:
                                            Button(action: {
                        // Action for the "+" button
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundColor(.blue)
                    }
                    )
                }
                .frame(maxWidth: screenWidth)
            }
        }
        
    }
}

struct TandemListView_Previews: PreviewProvider {
    static var previews: some View {
        TandemListView()
    }
}
