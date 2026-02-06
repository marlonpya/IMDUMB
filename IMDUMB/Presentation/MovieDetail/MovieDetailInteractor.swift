//
//  MovieDetailInteractor.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - MovieDetailInteractorProtocol
protocol MovieDetailInteractorProtocol {
    func fetchMovieDetail(completion: @escaping (Result<Movie, Error>) -> Void)
}

// MARK: - MovieDetailInteractor
class MovieDetailInteractor: MovieDetailInteractorProtocol {
    
    // MARK: - Properties
    private let getMovieDetailUseCase: GetMovieDetailUseCase
    private let movieId: Int
    
    // MARK: - Init
    // SOLID: DIP - Depende de abstracciones
    init(useCase: GetMovieDetailUseCase, movieId: Int) {
        self.getMovieDetailUseCase = useCase
        self.movieId = movieId
    }
    
    // MARK: - MovieDetailInteractorProtocol
    func fetchMovieDetail(completion: @escaping (Result<Movie, Error>) -> Void) {
        getMovieDetailUseCase.execute(id: movieId, completion: completion)
    }
}
