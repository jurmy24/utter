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
    
    var body: some View {
        
        NavigationView {
            VStack {
                Text("Login")
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.bottom, 20)
                    .foregroundColor(.accentColor)
                
                TextField("Username", text: $username)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                
                SecureField("Password", text: $password)
                    .padding()
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                NavigationLink(destination: TandemListView()){
                    Text("Log In")
                        .foregroundColor(.white)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 32)
                        .background(Color.purple)
                        .cornerRadius(8)
                }
                
            }
            .padding()
            .accentColor(.purple)  // Setting the VStack's accent color to white
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
