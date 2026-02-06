//
//  RemoteMovieDataStore.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Remote Movie Data Store
class RemoteMovieDataStore: DataStore {
    
    private let apiClient = TMDBAPIClient.shared
    
    // MARK: - DataStore Protocol
    
    func fetchAppConfig(completion: @escaping (Result<AppConfig, Error>) -> Void) {
        // Por ahora retornamos una configuración básica
        print("[RemoteMovieDataStore] fetchAppConfig - Returning default config")
        let config = AppConfig(
            welcomeMessage: "Bienvenido a IMDUMB",
            apiBaseURL: TMDBConfiguration.baseURL,
            enableFeatureX: true
        )
        completion(.success(config))
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        print("[RemoteMovieDataStore] fetchCategories - Starting...")
        
        apiClient.fetchGenres { [weak self] result in
            switch result {
            case .success(let genresResponse):
                print("[RemoteMovieDataStore] fetchCategories - Received \(genresResponse.genres.count) genres")
                self?.fetchMoviesForGenres(genresResponse.genres, completion: completion)
                
            case .failure(let error):
                print("[RemoteMovieDataStore] fetchCategories - Error: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func fetchMovieDetail(id movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        print("🎥 [RemoteMovieDataStore] fetchMovieDetail - ID: \(movieId)")
        
        // Usamos DispatchGroup para hacer dos llamadas en paralelo
        let group = DispatchGroup()
        
        var movieDetail: MovieDetailResponse?
        var movieCredits: MovieCreditsResponse?
        var movieImages: MovieImagesResponse?
        var fetchError: Error?
        
        // Fetch movie detail
        group.enter()
        apiClient.fetchMovieDetail(movieId: movieId) { result in
            defer { group.leave() }
            switch result {
            case .success(let detail):
                movieDetail = detail
            case .failure(let error):
                fetchError = error
            }
        }
        
        // Fetch movie credits
        group.enter()
        apiClient.fetchMovieCredits(movieId: movieId) { result in
            defer { group.leave() }
            switch result {
            case .success(let credits):
                movieCredits = credits
            case .failure:
                // No es crítico si falla, continuamos
                break
            }
        }
        
        // Fetch movie images
        group.enter()
        apiClient.fetchMovieImages(movieId: movieId) { result in
            defer { group.leave() }
            switch result {
            case .success(let images):
                movieImages = images
            case .failure:
                break
            }
        }
        
        // Cuando todas las llamadas terminen
        group.notify(queue: .main) {
            if let error = fetchError {
                print("[RemoteMovieDataStore] fetchMovieDetail - Error: \(error)")
                completion(.failure(error))
                return
            }
            
            guard let detail = movieDetail else {
                print("[RemoteMovieDataStore] fetchMovieDetail - No detail found")
                completion(.failure(TMDBAPIError.unknown))
                return
            }
            
            print("[RemoteMovieDataStore] fetchMovieDetail - Mapping to Movie entity")
            print("Title: \(detail.title)")
            print("Credits: \(movieCredits?.cast.count ?? 0) actors")
            print("Images: \(movieImages?.backdrops?.count ?? 0) backdrops")
            
            // Convertir DTO a entidad Movie
            let movie = self.mapToMovie(
                detail: detail,
                credits: movieCredits,
                images: movieImages
            )
            
            print("[RemoteMovieDataStore] fetchMovieDetail - Movie mapped successfully")
            completion(.success(movie))
        }
    }
    
    // MARK: - Helper Methods
    
    private func fetchMoviesForGenres(_ genres: [GenreDTO], completion: @escaping (Result<[Category], Error>) -> Void) {
        let group = DispatchGroup()
        var categories: [Category] = []
        var fetchError: Error?
        
        // Limitamos a los primeros 5 géneros para no saturar la API
        let limitedGenres = Array(genres.prefix(5))
        print("[RemoteMovieDataStore] Fetching movies for \(limitedGenres.count) genres")
        
        for genre in limitedGenres {
            group.enter()
            
            apiClient.fetchMovies(genreId: genre.id, page: 1) { result in
                defer { group.leave() }
                
                switch result {
                case .success(let moviesResponse):
                    let movies = moviesResponse.results.prefix(10).map { self.mapToMovie(dto: $0) }
                    let category = Category(id: genre.id, name: genre.name, movies: movies)
                    categories.append(category)
                    
                case .failure(let error):
                    fetchError = error
                }
            }
        }
        
        group.notify(queue: .main) {
            if let error = fetchError {
                print("[RemoteMovieDataStore] fetchMoviesForGenres - Error: \(error)")
                completion(.failure(error))
                return
            }
            
            print("[RemoteMovieDataStore] fetchMoviesForGenres - Completed")
            print("   Categories: \(categories.count)")
            print("   Total Movies: \(categories.reduce(0) { $0 + $1.movies.count })")
            
            // Ordenar categorías por ID para mantener consistencia
            let sortedCategories = categories.sorted { $0.id < $1.id }
            completion(.success(sortedCategories))
        }
    }
    
    private func mapToMovie(dto: MovieDTO) -> Movie {
        let posterURL = TMDBConfiguration.imageURL(
            path: dto.posterPath,
            size: .poster_w342
        )
        
        let backdropURL = TMDBConfiguration.imageURL(
            path: dto.backdropPath,
            size: .w780
        )
        
        return Movie(
            id: dto.id,
            title: dto.title,
            posterURL: posterURL ?? "",
            overview: dto.overview ?? "Sin descripción disponible",
            rating: dto.voteAverage ?? 0.0,
            releaseDate: dto.releaseDate ?? "",
            backdropURL: backdropURL,
            actors: [] // Los actores se cargan en el detalle
        )
    }
    
    private func mapToMovie(
        detail: MovieDetailResponse,
        credits: MovieCreditsResponse?,
        images: MovieImagesResponse?
    ) -> Movie {
        let posterURL = TMDBConfiguration.imageURL(
            path: detail.posterPath,
            size: .poster_w500
        )
        
        // Para los backdrops, usar las imágenes adicionales si están disponibles
        var backdropURLs: [String] = []
        if let backdrops = images?.backdrops?.prefix(5) {
            backdropURLs = backdrops.compactMap {
                TMDBConfiguration.imageURL(path: $0.filePath, size: .backdrop_w1280)
            }
        }
        
        // Si no hay imágenes adicionales, usar el backdrop principal
        if backdropURLs.isEmpty, let backdropPath = detail.backdropPath {
            if let url = TMDBConfiguration.imageURL(path: backdropPath, size: .backdrop_w1280) {
                backdropURLs = [url]
            }
        }
        
        // Mapear actores (primeros 10)
        let actors = credits?.cast.prefix(10).map { castDTO -> Actor in
            let profileURL = TMDBConfiguration.imageURL(
                path: castDTO.profilePath,
                size: .w185
            )
            return Actor(
                id: castDTO.id,
                name: castDTO.name,
                profileURL: profileURL
            )
        } ?? []
        
        // Crear descripción con HTML
        var htmlDescription = ""
        if let tagline = detail.tagline, !tagline.isEmpty {
            htmlDescription += "<i>\"\(tagline)\"</i><br><br>"
        }
        htmlDescription += detail.overview ?? "Sin descripción disponible"
        
        if let runtime = detail.runtime {
            htmlDescription += "<br><br><b>Duración:</b> \(runtime) minutos"
        }
        
        if let genres = detail.genres, !genres.isEmpty {
            let genreNames = genres.map { $0.name }.joined(separator: ", ")
            htmlDescription += "<br><b>Géneros:</b> \(genreNames)"
        }
        
        return Movie(
            id: detail.id,
            title: detail.title,
            posterURL: posterURL ?? "",
            overview: htmlDescription,
            rating: detail.voteAverage ?? 0.0,
            releaseDate: detail.releaseDate ?? "",
            backdropURL: backdropURLs.first,
            backdropURLs: backdropURLs,
            actors: actors
        )
    }
}
