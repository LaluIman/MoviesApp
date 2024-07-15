//
//  NetworkManager.swift
//  MovieApp
//
//  Created by Lalu Iman Abdullah on 12/07/24.
//

import Foundation

class NetworkManager: ObservableObject {
    private let apiKey = "ce1d7f06f6b40256df50aaff1946dcde"
    @Published var topMovies: [Movie] = []
    @Published var recentMovies: [Movie] = []
    @Published var allMovies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    @Published var randomMovie: Movie? = nil
    @Published var trailerURL: URL? = nil
    
    func fetchMovies(endpoint: String, hasQueryParameters: Bool = false, completion: @escaping ([Movie]) -> Void) {
        let urlString: String
        if hasQueryParameters {
            urlString = "https://api.themoviedb.org/3/\(endpoint)&api_key=\(apiKey)"
        } else {
            urlString = "https://api.themoviedb.org/3/\(endpoint)?api_key=\(apiKey)"
        }
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let movieResponse = try decoder.decode(MovieResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(movieResponse.results)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func loadTopMovies() {
        fetchMovies(endpoint: "movie/top_rated") { [weak self] movies in
            self?.topMovies = movies
            self?.updateAllMovies()
        }
    }
    
    func loadRecentMovies() {
        fetchMovies(endpoint: "movie/now_playing") { [weak self] movies in
            self?.recentMovies = movies
            self?.updateAllMovies()
        }
    }
    
    func searchMovies(query: String) {
        let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        fetchMovies(endpoint: "search/movie?query=\(query)", hasQueryParameters: true) { [weak self] movies in
            self?.searchedMovies = movies
        }
    }
    
    func fetchVideos(for movieID: Int, completion: @escaping ([Video]) -> Void) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieID)/videos?api_key=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let videoResponse = try decoder.decode(VideoResponse.self, from: data)
                    DispatchQueue.main.async {
                        completion(videoResponse.results)
                    }
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    private func updateAllMovies() {
        allMovies = (topMovies + recentMovies).shuffled()
        selectRandomMovie()
    }
    
    private func selectRandomMovie() {
        randomMovie = allMovies.randomElement()
        if let movieID = randomMovie?.id {
            fetchVideos(for: movieID) { [weak self] videos in
                self?.trailerURL = videos.first(where: { $0.type == "Trailer" && $0.site == "YouTube" }).flatMap {
                    URL(string: "https://www.youtube.com/watch?v=\($0.key)")
                }
            }
        }
    }
}





