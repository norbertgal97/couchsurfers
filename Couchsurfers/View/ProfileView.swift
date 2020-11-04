//
//  ProfileView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 11..
//

import Foundation
import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var env: GlobalEnvironment
    
    @ObservedObject var profileVM = ProfileViewModel()
    
    @State var name = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "bolt.fill")
                    .resizable()
                    .frame(width: 70, height: 70, alignment: .center)
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.green)
                    .clipShape(Circle())
                
                VStack {
                    Text(name)
                        .font(.custom("Pacifico-Regular", size: 22))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 10)
                        .padding(.top, 5)
                    
                    Button(action : {
                        //action
                    }) {
                        Text(NSLocalizedString("showProfile", comment: "Show profile"))
                            .font(.system(size: 15))
                            .foregroundColor(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
                            .frame(width: 115, height: 30)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray, lineWidth: 2)
                            .background(Color.white)
                    )
                    .cornerRadius(10)
                    .padding(.horizontal, 10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.all, 10)
            
            Divider()
            
            Spacer()
            
            VStack {
                Group {
                    Text(NSLocalizedString("aSettings", comment: "Account settings"))
                        .font(.custom("Pacifico-Regular", size: 30))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.all, 10)
                    
                    NavigationLink(destination: PersonalInformationView()) {
                        HStack {
                            Text(NSLocalizedString("pInformation", comment: "Personal information"))
                            Spacer()
                            Image(systemName: "person")
                        }
                        .foregroundColor(Color.black)
                        .padding(.all, 10)
                    }
                    
                    Divider()
                    
                    NavigationLink(destination: PersonalInformationView()) {
                        HStack {
                            Text(NSLocalizedString("notifications", comment: "Notifications"))
                            Spacer()
                            Image(systemName: "bell")
                        }
                        .foregroundColor(Color.black)
                        .padding(.all, 10)
                    }
                    
                    Divider()
                    
                }
                
                Text(NSLocalizedString("hosting", comment: "Hosting"))
                    .font(.custom("Pacifico-Regular", size: 30))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.all, 10)
                NavigationLink(destination: PersonalInformationView()) {
                    HStack {
                        Text(NSLocalizedString("listYourCouch", comment: "List your couch"))
                        Spacer()
                        Image(systemName: "list.dash")
                    }
                    .foregroundColor(Color.black)
                    .padding(.all, 10)
                }
                
                Divider()
                
                Spacer()
                
                Button(action: {
                    profileVM.logOut() { result in
                        if !result {
                            self.env.userLoggedIn = result
                        }
                    }
                }) {
                    Text(NSLocalizedString("logOut", comment: "Log out"))
                }
                Spacer()
            }
        }
        .onAppear {
            profileVM.loadUsername { name in
                self.name = name
            }
        }
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
