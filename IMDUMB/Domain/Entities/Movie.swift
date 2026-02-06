//
//  Movie.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Movie Entity
/// Entidad del dominio que representa una película
/// SOLID: SRP - Esta clase tiene una única responsabilidad: representar los datos de una película
struct Movie {
    let id: Int
    let title: String
    let posterURL: String
    let overview: String
    let rating: Double
    let releaseDate: String
    let backdropURL: String?
    let backdropURLs: [String]
    let actors: [Actor]
    
    init(
        id: Int,
        title: String,
        posterURL: String,
        overview: String,
        rating: Double,
        releaseDate: String,
        backdropURL: String? = nil,
        backdropURLs: [String] = [],
        actors: [Actor] = []
    ) {
        self.id = id
        self.title = title
        self.posterURL = posterURL
        self.overview = overview
        self.rating = rating
        self.releaseDate = releaseDate
        self.backdropURL = backdropURL
        // Si no hay backdropURLs, usar el posterURL
        self.backdropURLs = backdropURLs.isEmpty ? [posterURL] : backdropURLs
        self.actors = actors
    }
}

// MARK: - Equatable
extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        return lhs.id == rhs.id
    }
}
