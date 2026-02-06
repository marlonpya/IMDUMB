//
//  DataStore.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - DataStore Protocol
/// SOLID: DIP & OCP (Open/Closed Principle)
/// Protocol que permite múltiples implementaciones: Mock, Firebase, Remote
/// Abierto para extensión (nuevas implementaciones), cerrado para modificación
protocol DataStore {
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void)
    func fetchMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void)
    func fetchAppConfig(completion: @escaping (Result<AppConfig, Error>) -> Void)
}
