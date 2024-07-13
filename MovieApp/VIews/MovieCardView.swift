//
//  MovieCardView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import SwiftUI

struct MovieCardView: View {
    let movie: Movie
    
    var body: some View {
        VStack {
            ZStack {
                if let posterPath = movie.posterPath,
                   let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 125, height: 200)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .clipped()
                                .shadow(color:.white,radius: 1)
                        } else if phase.error != nil {
                            Image(systemName: "photo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .foregroundColor(.gray)
                        } else {
                                SkeletonView(width: 130, height: 200, cornerRadius: 30)
                                .clipped()
                        }
                    }
                }
                VStack{
                    Text(movie.title)
                        .font(.subheadline).bold()
                        .foregroundStyle(.white)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(.black.opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 1)
                .frame(width:150,height: 200, alignment: .bottom)
                HStack{
                    Text("\(movie.voteAverage, specifier: "%.1f")")
                        .foregroundStyle(.white)
                        .font(.subheadline).bold()
                        .foregroundColor(.secondary)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.subheadline)
                }
                .padding(.horizontal)
                .padding(.vertical, 5)
                .background(.black.opacity(0.3))
                .shadow(radius: 1)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .frame(width: 150, height: 200, alignment: .topLeading)
            }
            .frame(width: 150)
            .padding(.vertical, 5)
        }
    }
}

struct MovieCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleMovie = Movie(id: 1, title: "Sample Movie", posterPath: "/sample.jpg", releaseDate: "2024-01-01", voteAverage: 8.5, overview: "This is a sample movie description.")
        MovieCardView(movie: sampleMovie)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}




