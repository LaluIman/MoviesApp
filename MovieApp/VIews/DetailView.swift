//
//  DetailView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct DetailView: View {
    let movie: Movie
    
    var body: some View {
        ScrollView {
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
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.gray)
                                .frame(height: 500)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            ProgressView()
                                .frame(width: 350,height: 500)
                        }
                    }
                }
                
                Text(movie.title)
                    .font(.title)
                    .bold()
                    .padding(.top, 8)

                Text("Release Date: \(movie.releaseDate)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text("Rating: \(movie.voteAverage, specifier: "%.1f")")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(movie.overview)
                    .font(.body)
                    .padding(.top, 8)
                
                Spacer()
            }
            .padding()
        }
        .navigationTitle(movie.title)
        .navigationBarTitleDisplayMode(.inline)
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


