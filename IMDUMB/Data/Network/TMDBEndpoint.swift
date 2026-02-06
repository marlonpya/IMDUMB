//
//  TMDBEndpoint.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - TMDB Endpoints
enum TMDBEndpoint {
    case genres
    case moviesByGenre(genreId: Int, page: Int)
    case movieDetail(movieId: Int)
    case movieCredits(movieId: Int)
    case movieImages(movieId: Int)
    case movieVideos(movieId: Int)
    case movieRecommendations(movieId: Int)
    
    /// Path del endpoint
    var path: String {
        switch self {
        case .genres:
            return "/genre/movie/list"
        case .moviesByGenre:
            return "/discover/movie"
        case .movieDetail(let movieId):
            return "/movie/\(movieId)"
        case .movieCredits(let movieId):
            return "/movie/\(movieId)/credits"
        case .movieImages(let movieId):
            return "/movie/\(movieId)/images"
        case .movieVideos(let movieId):
            return "/movie/\(movieId)/videos"
        case .movieRecommendations(let movieId):
            return "/movie/\(movieId)/recommendations"
        }
    }
    
    /// URL completa del endpoint
    var url: String {
        return TMDBConfiguration.baseURL + path
    }
    
    /// Parámetros de la petición
    var parameters: [String: Any] {
        var params: [String: Any] = [
            "language": TMDBConfiguration.defaultLanguage
        ]
        
        switch self {
        case .moviesByGenre(let genreId, let page):
            params["with_genres"] = genreId
            params["page"] = page
            params["sort_by"] = "popularity.desc"
        case .movieRecommendations:
            params["page"] = 1
        default:
            break
        }
        
        return params
    }
    
    /// Método HTTP
    var method: String {
        return "GET"
    }
}
