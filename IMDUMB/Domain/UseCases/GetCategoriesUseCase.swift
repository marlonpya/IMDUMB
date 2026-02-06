//
//  GetCategoriesUseCase.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - GetCategoriesUseCase
/// SOLID: SRP - Única responsabilidad: obtener las categorías de películas
class GetCategoriesUseCase {
    private let repository: MovieRepository
    
    // SOLID: DIP - Depende de la abstracción (protocol), no de implementación concreta
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(completion: @escaping (Result<[Category], Error>) -> Void) {
        repository.getCategories(completion: completion)
    }
}
