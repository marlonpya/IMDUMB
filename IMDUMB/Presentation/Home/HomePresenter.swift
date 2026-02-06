//
//  HomePresenter.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - HomePresenterProtocol
/// SOLID: SRP - El presenter solo coordina entre la vista y el interactor
protocol HomePresenterProtocol {
    func viewDidLoad()
    func numberOfCategories() -> Int
    func categoryAtIndex(_ index: Int) -> Category?
    func didSelectMovie(_ movie: Movie)
}

// MARK: - HomePresenter
class HomePresenter: HomePresenterProtocol {
    
    // MARK: - Properties
    weak var view: HomeViewProtocol?
    private let interactor: HomeInteractorProtocol
    private var categories: [Category] = []
    
    // MARK: - Init
    // SOLID: DIP - Depende de abstracciones (protocols)
    init(view: HomeViewProtocol, interactor: HomeInteractorProtocol) {
        self.view = view
        self.interactor = interactor
    }
    
    // MARK: - HomePresenterProtocol
    func viewDidLoad() {
        view?.displayLoading()
        
        interactor.fetchCategories { [weak self] result in
            self?.view?.dismissLoading()
            
            switch result {
            case .success(let categories):
                self?.categories = categories
                self?.view?.displayCategories()
            case .failure(let error):
                self?.view?.displayError(error)
            }
        }
    }
    
    func numberOfCategories() -> Int {
        return categories.count
    }
    
    func categoryAtIndex(_ index: Int) -> Category? {
        guard index >= 0 && index < categories.count else {
            return nil
        }
        return categories[index]
    }
    
    func didSelectMovie(_ movie: Movie) {
        print("Navigating to movie detail: \(movie.title)")
        // La navegación se maneja desde el ViewController
    }
    
    func getMovieAtIndex(_ index: Int) -> Movie? {
        let allMovies = categories.flatMap { $0.movies }
        guard index >= 0 && index < allMovies.count else { return nil }
        return allMovies[index]
    }
}
