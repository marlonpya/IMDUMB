//
//  SplashInteractor.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - SplashInteractorProtocol
/// SOLID: SRP - El interactor solo contiene la lógica de negocio
protocol SplashInteractorProtocol {
    func loadConfig(completion: @escaping (AppConfig) -> Void)
}

// MARK: - SplashInteractor
class SplashInteractor: SplashInteractorProtocol {
    
    // MARK: - Properties
    private let configRepository: ConfigRepository
    
    // MARK: - Init
    // SOLID: DIP - Inyección de dependencias
    init(configRepository: ConfigRepository) {
        self.configRepository = configRepository
    }
    
    // MARK: - SplashInteractorProtocol
    func loadConfig(completion: @escaping (AppConfig) -> Void) {
        configRepository.getAppConfig(completion: completion)
    }
}
