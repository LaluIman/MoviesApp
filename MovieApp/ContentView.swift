//
//  ContentView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 0
    var body: some View {
        TabView(selection: $selectedTab) {
                       HomeView()
                        .tabItem {
                            Label("Home", systemImage: "house")
                        }
                        .tag(0)
                        .toolbarBackground(
                                Color.black,
                                for: .tabBar)
                        
                        SearchView()
                            .tabItem {
                                Label("Seacrh", systemImage: "magnifyingglass")
                            }
                            .tag(1)
                            .toolbarBackground(
                                    Color.black,
                                    for: .tabBar)
                        
                    }
                    .onAppear {
                        UITabBar.appearance().unselectedItemTintColor = .white
                    }
                    .accentColor(.white)
    }
}

#Preview {
    ContentView()
}
