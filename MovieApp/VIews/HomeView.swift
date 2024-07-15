//
//  HomeView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var networkManager = NetworkManager()
    @State private var randomMovie: Movie? = nil
    @State private var isFullScreenPresented = false
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(showsIndicators: false){
                    VStack(alignment: .leading) {
                        VStack{
                            Text("✨Recommendation🎬")
                                .font(.title3)
                                .foregroundStyle(.red)
                                .fontWeight(.semibold)
                        }
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                        ZStack {
                            if let movie = randomMovie {
                                AsyncImage(url: URL(string: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")")) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 370, height: 500)
                                        .clipShape(RoundedRectangle(cornerRadius: 30))
                                        .shadow(color: .white, radius: 2)
                                } placeholder: {
                                    SkeletonView(width: 370, height: 500, cornerRadius: 30)
                                        .shadow(color: .white, radius: 2)
                                }
                            }
                            
                            Rectangle()
                                .fill(LinearGradient(colors: [Color.black.opacity(0.7), Color.clear], startPoint: .bottom, endPoint: .top))
                                .frame(width: 370, height: 500)
                                .clipShape(RoundedRectangle(cornerRadius: 30))
                            
                            VStack {
                                VStack {
                                    // Movie title
                                    if let movie = randomMovie {
                                        Text("'\(movie.title)'")
                                            .font(.title2)
                                            .fontWeight(.bold)
                                            .foregroundColor(.white)
                                            .padding(.top, 5)
                                            .multilineTextAlignment(.center)
                                            .shadow(radius: 1)
                                    }
                                    //button
                                    HStack {
                                        if let trailerURL = networkManager.trailerURL {
                                            HStack {
                                                Image(systemName: "play.fill")
                                                Link("Trailer", destination: trailerURL)
                                                    .tint(Color.white)
                                                    .font(.title2)
                                                    .bold()
                                            }
                                            .padding(.vertical, 5)
                                            .padding(.horizontal)
                                            .background(Color.red.opacity(0.7))
                                            .clipShape(RoundedRectangle(cornerRadius: 30))
                                        }
                                        
                                        if let movie = randomMovie {
                                            NavigationLink(destination: DetailView(movie: movie)) {
                                                HStack {
                                                    Text("Details")
                                                        .tint(Color.white)
                                                        .font(.title2)
                                                }
                                                .padding(.vertical, 5)
                                                .padding(.horizontal)
                                                .background(Color.gray.opacity(0.5))
                                                .clipShape(RoundedRectangle(cornerRadius: 30))
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 30)
                                                        .stroke(Color.white, lineWidth: 2)
                                                )
                                            }
                                        }
                                    }
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
                                .padding(.bottom)
                            }
                        }
                        
                        Section {
                            Text("Top Movies")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(networkManager.topMovies) { movie in
                                        NavigationLink(destination: DetailView(movie: movie)) {
                                            MovieCardView(movie: movie)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Text("Recent Movies")
                                .font(.title)
                                .fontWeight(.bold)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ForEach(networkManager.recentMovies) { movie in
                                        NavigationLink(destination: DetailView(movie: movie)) {
                                            MovieCardView(movie: movie)
                                        }
                                    }
                                }
                                .padding(.horizontal)
                            }
                            
                            Text("All Movies")
                                .font(.title).bold()
                                .padding(.horizontal)
                            
                            ForEach(networkManager.allMovies) { movie in
                                NavigationLink(destination: DetailView(movie: movie)) {
                                    MovieRowView(movie: movie)
                                }
                            }
                            .padding(.horizontal)
                        }
                        .onAppear {
                            loadMovies()
                        }
                    }
                    .refreshable {
                        await refreshMovies()
                    }
                }
                // Search button
                VStack {
                    Button(action: {
                        isFullScreenPresented = true
                    }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title3)
                            .foregroundColor(.white)
                            .padding()
                            .background(.gray.opacity(0.7))
                            .clipShape(Circle())
                            .shadow(radius: 10)
                    }
                    .sheet(isPresented: $isFullScreenPresented) {
                        SearchView()
                    }
                    .presentationCornerRadius(50)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.horizontal, 20)
            }
        }
        .accentColor(.white)
        .environment(\.colorScheme, .dark)
    }
    
    private func loadMovies() {
           networkManager.loadTopMovies()
           networkManager.loadRecentMovies()
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               randomMovie = (networkManager.topMovies + networkManager.recentMovies).randomElement()
           }
       }
       
       private func refreshMovies() async {
           networkManager.loadTopMovies()
           networkManager.loadRecentMovies()
           try? await Task.sleep(nanoseconds: 5_000_000_000)
           DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
               randomMovie = (networkManager.topMovies + networkManager.recentMovies).randomElement()
           }
       }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}







