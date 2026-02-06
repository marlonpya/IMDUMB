//
//  MovieRepository.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - MovieRepository Protocol
/// SOLID: DIP (Dependency Inversion Principle)
/// Las capas superiores dependen de esta abstracción, no de implementaciones concretas
protocol MovieRepository {
    func getCategories(completion: @escaping (Result<[Category], Error>) -> Void)
    func getMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void)
}
