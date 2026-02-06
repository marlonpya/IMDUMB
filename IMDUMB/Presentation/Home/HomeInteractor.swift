//
//  HomeInteractor.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - HomeInteractorProtocol
/// SOLID: SRP - El interactor solo contiene lógica de negocio
protocol HomeInteractorProtocol {
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void)
}

// MARK: - HomeInteractor
class HomeInteractor: HomeInteractorProtocol {
    
    // MARK: - Properties
    private let getCategoriesUseCase: GetCategoriesUseCase
    
    // MARK: - Init
    // SOLID: DIP - Inyección de dependencias por constructor
    init(useCase: GetCategoriesUseCase) {
        self.getCategoriesUseCase = useCase
    }
    
    // MARK: - HomeInteractorProtocol
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        getCategoriesUseCase.execute(completion: completion)
    }
}
