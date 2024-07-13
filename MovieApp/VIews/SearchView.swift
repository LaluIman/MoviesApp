//
//  SearchView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField("Search movies...", text: $searchText, onCommit: {
                        networkManager.searchMovies(query: searchText)
                    })
                    .tint(Color.white)
                }
                .padding()
                .background(.gray.opacity(0.5))
                .clipShape(Capsule())
            .padding()
                
                List(networkManager.searchedMovies) { movie in
                    NavigationLink(destination: DetailView(movie: movie)) {
                        MovieRowView(movie: movie)
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitle("Search")
        }
        .environment(\.colorScheme, .dark)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
