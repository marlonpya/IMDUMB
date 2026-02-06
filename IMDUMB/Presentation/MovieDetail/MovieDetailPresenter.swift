//
//  MovieDetailPresenter.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - MovieDetailPresenterProtocol
protocol MovieDetailPresenterProtocol {
    func viewDidLoad()
    func recommendButtonTapped()
}

// MARK: - MovieDetailPresenter
class MovieDetailPresenter: MovieDetailPresenterProtocol {
    
    // MARK: - Properties
    weak var view: MovieDetailViewProtocol?
    private let interactor: MovieDetailInteractorProtocol
    private var currentMovie: Movie?
    
    // MARK: - Init
    init(view: MovieDetailViewProtocol, interactor: MovieDetailInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - MovieDetailPresenterProtocol
    func viewDidLoad() {
        view?.displayLoading()
        
        interactor.fetchMovieDetail { [weak self] result in
            self?.view?.dismissLoading()
            
            switch result {
            case .success(let movie):
                self?.currentMovie = movie
                self?.view?.displayMovie(movie)
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    
    func recommendButtonTapped() {
        print("Recommend button tapped for movie: \(currentMovie?.title ?? "")")
        // La presentación del modal se maneja desde el ViewController
    }
    
    func getCurrentMovie() -> Movie? {
        return currentMovie
    }
}
