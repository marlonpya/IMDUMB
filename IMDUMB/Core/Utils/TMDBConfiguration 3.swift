//
//  TMDBConfiguration.swift
//  IMDUMB
//
//  Created on 4/02/26.
//  FASE 3 - Integración con TMDB API
//

import Foundation

// MARK: - TMDB Configuration
struct TMDBConfiguration {
    
    /// API Key de TMDB (Bearer Token)
    static let apiKey = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2YjU0MTJlNzExNjU0MGQwMjNlMDQ4YTVjMGUxNDJiMyIsIm5iZiI6MTYyMTYyMDA0MC43MzgsInN1YiI6IjYwYTdmNTQ4YzYwMDZkMDA1OTA3MzlhZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.R2GF3KGstIedWT3xyv1MU7pr--RrCX6A1Clr2mCAr8s"
    
    /// Base URL de la API v3 de TMDB
    static let baseURL = "https://api.themoviedb.org/3"
    
    /// Base URL para imágenes de TMDB
    static let imageBaseURL = "https://image.tmdb.org/t/p"
    
    /// Tamaños de imagen disponibles
    enum ImageSize: String {
        case poster_w92 = "/w92"
        case poster_w154 = "/w154"
        case poster_w185 = "/w185"
        case poster_w342 = "/w342"
        case poster_w500 = "/w500"
        case poster_w780 = "/w780"
        case poster_original = "/original"
        
        case backdrop_w300 = "/w300"
        case backdrop_w780 = "/w780"
        case backdrop_w1280 = "/w1280"
        case backdrop_original = "/original"
        
        case profile_w45 = "/w45"
        case profile_w185 = "/w185"
        case profile_h632 = "/h632"
        case profile_original = "/original"
    }
    
    /// Idioma por defecto para las peticiones
    static let defaultLanguage = "es-ES"
    
    /// Región por defecto
    static let defaultRegion = "ES"
    
    /// Headers comunes para todas las peticiones
    static var defaultHeaders: [String: String] {
        return [
            "Authorization": "Bearer \(apiKey)",
            "Content-Type": "application/json;charset=utf-8"
        ]
    }
    
    /// Construye una URL completa para una imagen
    /// - Parameters:
    ///   - path: Path de la imagen (ejemplo: "/abc123.jpg")
    ///   - size: Tamaño deseado de la imagen
    /// - Returns: URL completa de la imagen
    static func imageURL(path: String?, size: ImageSize) -> String? {
        guard let path = path else { return nil }
        return "\(imageBaseURL)\(size.rawValue)\(path)"
    }
}
