//
//  CouchListView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 11. 24..
//

import SwiftUI

struct CouchListView: View {
    @State private var couch: Couch?
    @State private var reversedPlaceId: String?
    
    @ObservedObject private var couchListVM = CouchListViewModel()
    
    var body: some View {
        VStack {
            CouchView(couch: $couch, cityName: $reversedPlaceId)
                .padding(.top, 5)
        }
        .navigationBarTitle(Text(NSLocalizedString("couchList", comment: "Couch list")), displayMode: .inline)
        .navigationBarItems(trailing: NavigationLink(destination: CouchDetailsView()) {
            Image(systemName: "square.and.pencil")
                .foregroundColor(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
        })
        .onAppear() {
            couchListVM.loadMyCouch { (couch, error, cityName) in
                if error != nil {
                    return
                }
                
                if let couch = couch, let cityName = cityName {
                    self.couch = couch
                    self.reversedPlaceId = cityName
                }
            }
        }
    }
}

struct CouchView: View {
    @Binding var couch: Couch?
    @Binding var cityName: String?
    
    var body: some View {
        if let couch = couch {
            VStack(spacing: 5) {
                Image("flat-image")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 350, height: 200, alignment: .center)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack {
                    Text(NSLocalizedString("about", comment: "About"))
                        .font(.custom("Pacifico-Regular", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                    
                    Text("\(couch.description)")
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    Text(NSLocalizedString("amenitiesLowerCase", comment: "Amenities"))
                        .font(.custom("Pacifico-Regular", size: 15))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 2)
                    
                    Text("\(couch.amenities)")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, 10)
                }
                .padding(.horizontal, 5)
                .frame(minWidth: 350, maxWidth: 350, minHeight: 150, maxHeight: .infinity, alignment: .center)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)), lineWidth: 1)
                    .background(Color(#colorLiteral(red: 0.9685322642, green: 0.9686941504, blue: 0.9685109258, alpha: 1)))
            )
            
            Spacer()
        } else {
            Text(NSLocalizedString("noSavedCouches", comment: "No saved couches"))
        }
    }
}
