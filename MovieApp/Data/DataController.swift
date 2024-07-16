//
//  DataController.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 16/07/24.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "MovieModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load Core Data stack: \(error.localizedDescription)")
                fatalError("Failed to load Core Data stack: \(error.localizedDescription)")
            }
        }
    }

    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }

    func addFavoriteMovie(id: Int, title: String, rating: Double, releaseDate: String, overview: String, trailerURL: String, posterPath: String, context: NSManagedObjectContext) {
        let favoriteMovie = FavoriteMovie(context: context)
        favoriteMovie.id = Int32(id)
        favoriteMovie.title = title
        favoriteMovie.rating = rating
        favoriteMovie.releaseDate = releaseDate
        favoriteMovie.overview = overview
        favoriteMovie.trailerURL = trailerURL
        favoriteMovie.posterPath = posterPath

        save(context: context)
    }


    func fetchFavoriteMovies() -> [FavoriteMovie] {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        do {
            return try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Failed to fetch favorite movies: \(error.localizedDescription)")
            return []
        }
    }

    func removeFavoriteMovie(id: Int, context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<FavoriteMovie> = FavoriteMovie.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        do {
            if let movieToDelete = try context.fetch(fetchRequest).first {
                context.delete(movieToDelete)
                save(context: context)
            }
        } catch {
            print("Failed to delete favorite movie: \(error.localizedDescription)")
        }
    }
}


