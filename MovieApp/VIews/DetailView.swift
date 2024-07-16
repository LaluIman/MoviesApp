//
//  DetailView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct DetailView: View {
    let movie: Movie
    @Environment(\.presentationMode) var presentationMode
    @State private var trailerURL: URL? = nil
    @StateObject private var networkManager = NetworkManager()
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var dataController = DataController()
    @State private var isFavorite = false

    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    if let posterPath = movie.posterPath,
                       let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                        AsyncImage(url: url) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: 500)
                                    .clipped()
                                    .cornerRadius(10)
                                    .shadow(color: .white, radius: 2)
                            } else if phase.error != nil {
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .frame(height: 500)
                                    .clipped()
                                    .cornerRadius(10)
                            } else {
                                SkeletonView(width: 350, height: 500, cornerRadius: 30)
                                    .clipped()
                            }
                        }
                    }

                    Button(action: {
                        if let url = trailerURL {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "play.fill")
                            Text("Watch Trailer")
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red.opacity(0.7))
                        .cornerRadius(10)
                    }
                    .padding(.top, 16)
                    .onAppear {
                        fetchTrailerURL()
                    }

                    HStack {
                        Text(movie.title)
                            .font(.title)
                            .bold()
                            .padding(.top, 8)
                        
                        Spacer()

                        HStack {
                            Text("\(movie.voteAverage, specifier: "%.1f")")
                                .font(.title2).bold()
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        }

                        Button(action: {
                            if isFavorite {
                                removeFromFavorites()
                            } else {
                                addToFavorites()
                            }
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: isFavorite ? "heart.fill" : "heart")
                                .font(.title)
                                .foregroundColor(.red)
                                .padding()
                        }
                        .disabled(isFavorite)
                    }
                    .padding(.bottom)

                    Text("Release Date: \(movie.releaseDate)")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Text(movie.overview)
                        .font(.body)
                        .padding(.top, 8)

                    Spacer()
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("Back")
                        }
                        .font(.title3)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            checkIfFavorite()
        }
    }

    private func fetchTrailerURL() {
        networkManager.fetchVideos(for: movie.id) { videos in
            trailerURL = videos.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }).flatMap {
                URL(string: "https://www.youtube.com/watch?v=\($0.key)")
            }
        }
    }

    private func addToFavorites() {
        dataController.addFavoriteMovie(
            id: movie.id,
            title: movie.title,
            rating: movie.voteAverage,
            releaseDate: movie.releaseDate,
            overview: movie.overview,
            trailerURL: trailerURL?.absoluteString ?? "",
            posterPath: movie.posterPath ?? "",
            context: viewContext
        )
        isFavorite = true
    }


    private func removeFromFavorites() {
        dataController.removeFavoriteMovie(id: movie.id, context: viewContext)
        isFavorite = false
    }

    private func checkIfFavorite() {
        let favoriteMovies = dataController.fetchFavoriteMovies()
        if favoriteMovies.contains(where: { $0.id == Int32(movie.id) }) {
            isFavorite = true
        }
    }
}


struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(id: 1, title: "Sample Movie", posterPath: "/sample.jpg", releaseDate: "2024-01-01", voteAverage: 8.5, overview: "This is a sample movie description.")
        DetailView(movie: sampleMovie)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}



