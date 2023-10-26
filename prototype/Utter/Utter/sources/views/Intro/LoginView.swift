//
//  LoginView.swift
//  Utter
//
//  Created by Victor Magnus Oldensand on 2023-10-10.
//

import SwiftUI

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    let screenWidth = UIScreen.main.bounds.width
    @AppStorage("isLoggedIn") var isLoggedIn = false
    
    var body: some View {
        
        let accentColor = #colorLiteral(red: 0.3529040813, green: 0.3529704213, blue: 1, alpha: 1)
        let fieldHeight: CGFloat = 50 // adjust this to control the height
        
        ZStack{
            
            SlidingBackgroundView()
            
            VStack {
                
                // Logo
                Image("UtterLogo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 150) // adjust this as per your logo's aspect ratio
                
                Text("Login")
                    .font(.title)
                    .padding(.bottom, 5)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
            
                TextField("Username", text: $username)
                    .padding(.leading, 10)
                    .frame(height: fieldHeight)
                    .background(
                        Rectangle()
                            .stroke(Color.white, lineWidth: 1)
                            .background(Color.white)
                            .cornerRadius(8)
                    )
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .padding(.vertical, 5)
                
                SecureField("Password", text: $password)
                    .padding(.leading, 10)
                    .frame(height: fieldHeight)
                    .background(
                        Rectangle()
                            .stroke(Color.white, lineWidth: 1)
                            .background(Color.white)
                            .cornerRadius(8)
                    )
                    .padding(.vertical, 10)
                    .frame(maxWidth: screenWidth)
                
                
                Button(action: {
                    isLoggedIn = true
                }){
                    Text("Login")
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .frame(maxWidth: screenWidth)
                        .background(Color(accentColor))
                        .cornerRadius(8)
                        .fontWeight(.bold)
                }
                HStack {
                    Text("Don't have an account? ")
                        .font(.caption)
                    + Text("Sign up")
                        .font(.caption)
                        .bold()
                        .underline()
                    + Text(" now!")
                        .font(.caption)
                }
                .padding(.top, 5)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .frame(maxWidth: screenWidth)
        }
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
