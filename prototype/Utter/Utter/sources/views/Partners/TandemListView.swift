//
//  TandemListView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

import SwiftUI

struct TopRoundedRectangle: Shape {
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.size.width
        let height = rect.size.height
        
        path.move(to: CGPoint(x: 0, y: height))
        path.addLine(to: CGPoint(x: 0, y: radius))
        path.addArc(center: CGPoint(x: -radius, y: -radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: true)
        path.addLine(to: CGPoint(x: width - radius, y: 0))
        path.addArc(center: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: .degrees(0), endAngle: .degrees(0), clockwise: true)
        path.addLine(to: CGPoint(x: width, y: height - radius))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

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
                            NavigationLink(destination: ChatView()) {
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
