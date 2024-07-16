//
//  FavoriteView.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 16/07/24.
//

import SwiftUI
import CoreData

struct FavoriteView: View {
    @FetchRequest(
        entity: FavoriteMovie.entity(),
        sortDescriptors: []
    ) var favoriteMovies: FetchedResults<FavoriteMovie>
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                ForEach(favoriteMovies) { movie in
                    NavigationLink(destination: FavoriteDetailView(favoriteMovie: movie)) {
                        HStack {
                            if let posterPath = movie.posterPath,
                               let url = URL(string: "https://image.tmdb.org/t/p/w500\(posterPath)") {
                                AsyncImage(url: url) { phase in
                                    if let image = phase.image {
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 60, height: 80)
                                            .cornerRadius(8)
                                    } else if phase.error != nil {
                                        Image(systemName: "photo")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.gray)
                                            .frame(width: 75, height: 85)
                                            .cornerRadius(5)
                                            .shadow(color: .white,radius: 2)
                                    } else {
                                        SkeletonView(width: 60, height: 75, cornerRadius: 5)
                                    }
                                }
                            }

                            VStack(alignment: .leading) {
                                Text(movie.title ?? "")
                                    .font(.title3).bold()
                                Text("\(movie.releaseDate ?? "")")
                                    .font(.subheadline)
                                HStack {
                                    Text("\(movie.rating, specifier: "%.1f")")
                                        .font(.subheadline)
                                    Image(systemName: "star.fill")
                                        .foregroundStyle(.yellow)
                                }
                            }
                        }
                    }
                }
                .onDelete(perform: deleteFavoriteMovie)
            }
            .listStyle(.plain)
            .navigationTitle("Favorite Movies")
        }
    }

    private func deleteFavoriteMovie(offsets: IndexSet) {
        withAnimation {
            offsets.map { favoriteMovies[$0] }.forEach(viewContext.delete)
            do {
                try viewContext.save()
            } catch {
                print("Failed to delete movie: \(error.localizedDescription)")
            }
        }
    }
}


struct FavoriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteView()
            .environment(\.managedObjectContext, DataController(inMemory: true).container.viewContext)
    }
}

