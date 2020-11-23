//
//  LoginView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 29..
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    @ObservedObject var loginVM = LoginViewModel()

    @Binding var isPresented: Bool
    @Binding var isShowingExplorationView: Bool

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, Color(#colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.1254901961, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Text("Log in")
                    .font(.custom("Pacifico-Regular", size: 40))
                    .padding(.vertical)
                
                VStack(spacing: 10) {
                    InputFieldWithImage(text: $loginVM.emailAddress, textFieldPlaceholder: NSLocalizedString("emailAddressPlaceholder", comment: "Email address"), imageSystemName:"envelope", isSecret: false)
                    InputFieldWithImage(text: $loginVM.password, textFieldPlaceholder: NSLocalizedString("passwordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
                }
                
                Spacer()
                
                Button(action : {
                    loginVM.signInUser(email: loginVM.emailAddress, password: loginVM.password) { result in
                        self.isPresented = !result
                        self.isShowingExplorationView = result
                        if result {
                            self.env.userLoggedIn = result
                        }
                    }
                }) {
                    Text(NSLocalizedString("logInButton", comment: "Login In"))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2)
                        .background(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
                )
                .cornerRadius(10)
                
                Button(action : {
                    // action
                }) {
                    Text(NSLocalizedString("forgotPasswordButton", comment: "Forgot password?"))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
                
                Spacer()
            }
            
        }
        .alert(isPresented: $loginVM.showingAlert, content: {
            Alert(title: Text(NSLocalizedString("alertTitle", comment: "Title")), message: Text(loginVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("dismissButtonText", comment: "Continue"))) {
                print("Dismiss button pressed")
            })
        })
    }
}

struct Login_Previews: PreviewProvider {
    @State static var value = true
    @State static var value2 = false
    
    static var previews: some View {
        LoginView(isPresented: $value, isShowingExplorationView: $value2)
    }
}
