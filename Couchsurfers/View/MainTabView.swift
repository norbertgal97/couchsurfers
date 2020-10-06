//
//  MainTabView.swift
//  Couchsurfers
//
//  Created by Norbert Gál on 2020. 10. 01..
//

import SwiftUI

struct MainTabView: View {
    
    var body: some View {
        TabView {
            ExplorationView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text(NSLocalizedString("exploreTabItem", comment: "Explore"))
                }
            
            Text("Tab 2")
                .tabItem {
                    Image(systemName: "map")
                    Text(NSLocalizedString("mapTabItem", comment: "Map"))
                }
            
            Text("Tab 3")
                .tabItem {
                    Image(systemName: "bed.double")
                    Text(NSLocalizedString("couchesTabItem", comment: "Couches"))
                }
            
            Text("Tab 4")
                .tabItem {
                    Image(systemName: "message")
                    Text(NSLocalizedString("inboxTabItem", comment: "Inbox"))
                }
            
            Text("Tab 5")
                .tabItem {
                    Image(systemName: "person")
                    Text(NSLocalizedString("profileTabItem", comment: "Profile"))
                }
        }
        .accentColor(Color(#colorLiteral(red: 0.3333333333, green: 0.6509803922, blue: 0.1882352941, alpha: 1)))
    }
}
