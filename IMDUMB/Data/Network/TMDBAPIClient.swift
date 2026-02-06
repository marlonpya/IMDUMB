//
//  TMDBAPIClient.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation
import Alamofire

// MARK: - TMDB API Error
enum TMDBAPIError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int, String?)
    case unknown
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "URL inválida"
        case .networkError(let error):
            return "Error de red: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Error al procesar datos: \(error.localizedDescription)"
        case .serverError(let code, let message):
            return "Error del servidor (\(code)): \(message ?? "Desconocido")"
        case .unknown:
            return "Error desconocido"
        }
    }
}

// MARK: - TMDB API Client
class TMDBAPIClient {
    
    // Singleton
    static let shared = TMDBAPIClient()
    
    private let session: Session
    private var requestCounter = 0
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        self.session = Session(configuration: configuration)
    }
    
    // MARK: - Logging
    
    private func logRequest(endpoint: TMDBEndpoint, requestId: Int) {
        print("[\(requestId)] REQUEST ===================================")
        print("URL: \(endpoint.url)")
        print("Method: \(endpoint.method)")
        print("Parameters: \(endpoint.parameters)")
        print("Headers: Authorization Bearer ***...")
        print("========================================================")
    }
    
    private func logResponse<T>(endpoint: TMDBEndpoint, requestId: Int, result: Result<T, TMDBAPIError>, duration: TimeInterval) {
        switch result {
        case .success:
            print("[\(requestId)] SUCCESS (\(String(format: "%.2f", duration))s) ===================")
            print("URL: \(endpoint.url)")
            print("Type: \(T.self)")
            print("========================================================")
            
        case .failure(let error):
            print("[\(requestId)] ERROR (\(String(format: "%.2f", duration))s) =====================")
            print("URL: \(endpoint.url)")
            print("Error: \(error.localizedDescription)")
            print("========================================================")
        }
    }
    
    private func logRawResponse(data: Data?, response: HTTPURLResponse?, requestId: Int) {
        if let httpResponse = response {
            print("Status Code: \(httpResponse.statusCode)")
        }
        
        if let data = data {
            print("Data Size: \(data.count) bytes")
            
            // Log first 500 characters of JSON response (for debugging)
            if let jsonString = String(data: data, encoding: .utf8) {
                let preview = String(jsonString.prefix(500))
                print("Response Preview: \(preview)...")
            }
        }
    }
    
    // MARK: - Generic Request
    private func request<T: Decodable>(
        endpoint: TMDBEndpoint,
        completion: @escaping (Result<T, TMDBAPIError>) -> Void
    ) {
        requestCounter += 1
        let requestId = requestCounter
        let startTime = Date()
        
        // Log request
        logRequest(endpoint: endpoint, requestId: requestId)
        
        session.request(
            endpoint.url,
            method: .get,
            parameters: endpoint.parameters,
            headers: HTTPHeaders(TMDBConfiguration.defaultHeaders)
        )
        .validate(statusCode: 200..<300)
        .responseDecodable(of: T.self) { [weak self] response in
            let duration = Date().timeIntervalSince(startTime)
            
            // Log raw response
            self?.logRawResponse(data: response.data, response: response.response, requestId: requestId)
            
            switch response.result {
            case .success(let value):
                let result: Result<T, TMDBAPIError> = .success(value)
                self?.logResponse(endpoint: endpoint, requestId: requestId, result: result, duration: duration)
                completion(.success(value))
                
            case .failure(let error):
                var apiError: TMDBAPIError
                
                if let statusCode = response.response?.statusCode {
                    // Error del servidor
                    if let data = response.data,
                       let errorMessage = String(data: data, encoding: .utf8) {
                        apiError = .serverError(statusCode, errorMessage)
                    } else {
                        apiError = .serverError(statusCode, nil)
                    }
                } else if let underlyingError = error.underlyingError {
                    // Error de decodificación o red
                    if error.isResponseSerializationError {
                        apiError = .decodingError(underlyingError)
                    } else {
                        apiError = .networkError(underlyingError)
                    }
                } else {
                    apiError = .networkError(error)
                }
                
                let result: Result<T, TMDBAPIError> = .failure(apiError)
                self?.logResponse(endpoint: endpoint, requestId: requestId, result: result, duration: duration)
                completion(.failure(apiError))
            }
        }
    }
    
    // MARK: - API Methods
    
    /// Obtiene la lista de géneros
    func fetchGenres(completion: @escaping (Result<GenresResponse, TMDBAPIError>) -> Void) {
        request(endpoint: .genres, completion: completion)
    }
    
    /// Obtiene películas por género
    func fetchMovies(
        genreId: Int,
        page: Int = 1,
        completion: @escaping (Result<MoviesResponse, TMDBAPIError>) -> Void
    ) {
        request(endpoint: .moviesByGenre(genreId: genreId, page: page), completion: completion)
    }
    
    /// Obtiene el detalle de una película
    func fetchMovieDetail(
        movieId: Int,
        completion: @escaping (Result<MovieDetailResponse, TMDBAPIError>) -> Void
    ) {
        request(endpoint: .movieDetail(movieId: movieId), completion: completion)
    }
    
    /// Obtiene los créditos (actores y crew) de una película
    func fetchMovieCredits(
        movieId: Int,
        completion: @escaping (Result<MovieCreditsResponse, TMDBAPIError>) -> Void
    ) {
        request(endpoint: .movieCredits(movieId: movieId), completion: completion)
    }
    
    /// Obtiene las imágenes de una película
    func fetchMovieImages(
        movieId: Int,
        completion: @escaping (Result<MovieImagesResponse, TMDBAPIError>) -> Void
    ) {
        request(endpoint: .movieImages(movieId: movieId), completion: completion)
    }
}
