//
//  MovieRepositoryImpl.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - MovieRepositoryImpl
/// Implementación concreta del MovieRepository
/// SOLID: SRP - Responsabilidad única: coordinar el acceso a datos de películas
class MovieRepositoryImpl: MovieRepository {
    private let dataStore: DataStore
    
    // SOLID: DIP - Inyección de dependencias por el constructor
    // No crea el dataStore, lo recibe como dependencia
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func getCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        dataStore.fetchCategories(completion: completion)
    }
    
    func getMovieDetail(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        dataStore.fetchMovieDetail(id: id, completion: completion)
    }
}
