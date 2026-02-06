//
//  MovieDetailResponse.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Movie Detail Response
struct MovieDetailResponse: Codable {
    let id: Int
    let title: String
    let overview: String?
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double?
    let runtime: Int?
    let genres: [GenreDTO]?
    let tagline: String?
    let budget: Int?
    let revenue: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview, runtime, genres, tagline, budget, revenue
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
}
