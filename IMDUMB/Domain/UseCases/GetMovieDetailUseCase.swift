//
//  GetMovieDetailUseCase.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - GetMovieDetailUseCase
/// SOLID: SRP - Única responsabilidad: obtener el detalle de una película
class GetMovieDetailUseCase {
    private let repository: MovieRepository
    
    // SOLID: DIP - Depende de la abstracción
    init(repository: MovieRepository) {
        self.repository = repository
    }
    
    func execute(id: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        repository.getMovieDetail(id: id, completion: completion)
    }
}
