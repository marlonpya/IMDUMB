//
//  GenresResponse.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Genres Response
struct GenresResponse: Codable {
    let genres: [GenreDTO]
}

// MARK: - Genre DTO
struct GenreDTO: Codable {
    let id: Int
    let name: String
}
