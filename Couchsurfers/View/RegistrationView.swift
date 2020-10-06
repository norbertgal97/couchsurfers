//
//  RegistrationView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 09. 27..
//

import SwiftUI

struct RegistrationView: View {
    @State private var isShowingSheet = false
    @State private var isShowingExplorationView = false
    
    @ObservedObject var registrationVM = RegistrationViewModel()
    
    @EnvironmentObject var env: GlobalEnvironment
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.white, Color(#colorLiteral(red: 0.9333333333, green: 0.937254902, blue: 0.1254901961, alpha: 1))]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 10) {
                Text("Couchsurfers")
                    .font(.custom("Pacifico-Regular", size: 60))
                    .padding(.vertical)
                
                VStack(spacing: 10) {
                    InputFieldWithImage(text: $registrationVM.firstName, textFieldPlaceholder: NSLocalizedString("firstNamePlaceholder", comment: "First Name"), imageSystemName:"person", isSecret: false)
                    InputFieldWithImage(text: $registrationVM.lastName, textFieldPlaceholder: NSLocalizedString("lastNamePlaceholder", comment: "Last Name"), imageSystemName:"person", isSecret: false)
                    InputFieldWithImage(text: $registrationVM.emailAddress, textFieldPlaceholder: NSLocalizedString("emailAddressPlaceholder", comment: "Email address"), imageSystemName:"envelope", isSecret: false)
                    InputFieldWithImage(text: $registrationVM.password, textFieldPlaceholder: NSLocalizedString("passwordPlaceholder", comment: "Password"), imageSystemName:"lock", isSecret: true)
                }
                
                Spacer()
                
                Button(action : {
                    registrationVM.createNewFirebaseUser(email: registrationVM.emailAddress, password: registrationVM.password)
                }) {
                    Text(NSLocalizedString("signUpButton", comment: "Sign up"))
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2)
                        .background(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
                )
                .cornerRadius(10)
                
                DividerWithText(text: NSLocalizedString("dividerText", comment: "or you can"))
                
                Button(action : {
                    // action
                }) {
                    Text(NSLocalizedString("facebookButton", comment: "Log in with Facebook"))
                        .foregroundColor(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
                        .fontWeight(.bold)
                        .frame(width: 350, height: 50)
                }
                .background(
                    RoundedRectangle(cornerRadius: 10).stroke(Color.gray, lineWidth: 2)
                        .background(Color.white)
                )
                .cornerRadius(10)
                
                Spacer()
                
                Button(action : {
                    self.isShowingSheet.toggle()
                }) {
                    Text(NSLocalizedString("alreadyMemberButton", comment: "I am already a member"))
                        .foregroundColor(.black)
                        .fontWeight(.bold)
                }
            }
        }
        .onAppear {
            registrationVM.attachStateDidChangeListenerToFirebaseAuth()
        }
        .onDisappear {
            registrationVM.detachStateDidChangeListenerFormFirebaseAuth()
        }
        .alert(isPresented: $registrationVM.showingAlert, content: {
            Alert(title: Text("Information"), message: Text(registrationVM.alertDescription), dismissButton: .default(Text(NSLocalizedString("dismissButtonText", comment: "Continue"))) {
                print("Dismiss button pressed")
            })
        })
        .sheet(isPresented: $isShowingSheet) {
            LoginView(isPresented: $isShowingSheet, isShowingExplorationView: $isShowingExplorationView)
        }
    }
}

struct DividerWithText: View {
    let color: Color = .gray
    let width: CGFloat = 2
    let text: String
    
    var body: some View {
        HStack {
            Rectangle()
                .fill(color)
                .frame(height: width)
            Text(text)
                .foregroundColor(color)
            Rectangle()
                .fill(color)
                .frame(height: width)
        }
    }
}

struct Registration_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
