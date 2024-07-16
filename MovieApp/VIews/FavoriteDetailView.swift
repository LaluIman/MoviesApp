//
//  FavoriteDetailView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 16/07/24.
//

import SwiftUI

struct FavoriteDetailView: View {
    let favoriteMovie: FavoriteMovie

    var body: some View {
        VStack(alignment: .leading) {
            if let posterPath = favoriteMovie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: 500)
                            .cornerRadius(10)
                            .shadow(color: .white, radius: 2)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(height: 500)
                            .cornerRadius(10)
                    } else {
                        SkeletonView(width: 350, height: 500, cornerRadius: 30)
                    }
                }
            }

            if let url = URL(string: favoriteMovie.trailerURL ?? "") {
                Button(action: {
                    UIApplication.shared.open(url)
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
            }

            Text(favoriteMovie.title ?? "")
                .font(.title)
                .bold()
                .padding(.top, 8)

            Text("Rating: \(favoriteMovie.rating, specifier: "%.1f")")
                .font(.title2).bold()
                .padding(.bottom)

            Text("Release Date: \(favoriteMovie.releaseDate ?? "")")
                .font(.headline)
                .foregroundColor(.secondary)

            Text(favoriteMovie.overview ?? "")
                .font(.body)
                .padding(.top, 8)

            Spacer()
        }
        .padding()
        .navigationTitle(favoriteMovie.title ?? "No Title")
    }
}

struct FavoriteDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = DataController(inMemory: true).container.viewContext
        let movie = FavoriteMovie(context: context)
        movie.id = 1
        movie.title = "Sample Movie"
        movie.rating = 8.5
        movie.releaseDate = "2024-01-01"
        movie.overview = "This is a sample movie description."
        movie.trailerURL = "https://www.youtube.com"
        movie.posterPath = "/samplePoster.jpg"

        return FavoriteDetailView(favoriteMovie: movie)
            .environment(\.managedObjectContext, context)
    }
}


