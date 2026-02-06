//
//  ConfigRepositoryImpl.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - ConfigRepositoryImpl
/// Implementación del repositorio de configuración
class ConfigRepositoryImpl: ConfigRepository {
    private let dataStore: DataStore
    
    init(dataStore: DataStore) {
        self.dataStore = dataStore
    }
    
    func getAppConfig(completion: @escaping (AppConfig) -> Void) {
        dataStore.fetchAppConfig { result in
            switch result {
            case .success(let config):
                completion(config)
            case .failure:
                // En caso de error, retornar configuración por defecto
                let defaultConfig = AppConfig(
                    welcomeMessage: "Bienvenido a IMDUMB",
                    apiBaseURL: "https://api.themoviedb.org/3",
                    enableFeatureX: true
                )
                completion(defaultConfig)
            }
        }
    }
}
