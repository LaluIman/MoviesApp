//
//  ContentView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct ContentView: View {
    @State private var tabSelection = 1
        var body: some View {
            TabView(selection: $tabSelection){
                HomeView()
                    .preferredColorScheme(.dark)
                    .tag(1)
                SearchView()
                    .preferredColorScheme(.dark)
                    .tag(2)
            }

            .overlay(alignment:.bottom){
                CustomTabView(tabSelection: $tabSelection)
            }
        }
}

#Preview {
    ContentView()
}
