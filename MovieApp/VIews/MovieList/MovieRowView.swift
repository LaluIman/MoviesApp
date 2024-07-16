//
//  MovieRowView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct MovieRowView: View {
    let movie: Movie
    
    var body: some View {
        HStack(alignment: .top) {
            if let posterPath = movie.posterPath,
               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                AsyncImage(url: url) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 150)
                            .clipped()
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .shadow(color:.white,radius: 1)
                    } else if phase.error != nil {
                        Image(systemName: "photo")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray)
                            .frame(width: 100, height: 100)
                    } else {
                        SkeletonView(width: 120, height: 150, cornerRadius: 30)
                            .clipped()
                    }
                }
            } else {
                Rectangle()
                    .fill(Color.gray)
                    .frame(width: 100, height: 150)
            }
            VStack(alignment: .leading, spacing: 5) {
                Text(movie.title)
                    .foregroundStyle(.white)
                    .font(.title3)
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)
                Text(movie.releaseDate)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    Text("\(movie.voteAverage, specifier: "%.1f")")
                        .font(.subheadline).bold()
                    .foregroundColor(.secondary)
                    Image(systemName: "star.fill")
                        .foregroundStyle(.yellow)
                }
                Spacer()
            }
            .padding(.leading, 8)
        }
        .padding(.vertical, 8)
    }
}

struct MovieRowView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(id: 1, title: "Sample Movie", posterPath: "/sample.jpg", releaseDate: "2024-01-01", voteAverage: 8.5, overview: "This is a sample movie description.")
        MovieRowView(movie: sampleMovie)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


