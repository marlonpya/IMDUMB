//
//  Category.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Category Entity
/// Entidad del dominio que representa una categoría de películas
struct Category {
    let id: Int
    let name: String
    let movies: [Movie]
    
    init(id: Int, name: String, movies: [Movie] = []) {
        self.id = id
        self.name = name
        self.movies = movies
    }
}

// MARK: - Equatable
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.id == rhs.id
    }
}
