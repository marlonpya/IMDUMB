//
//  FirebaseDataStore.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Firebase Data Store
/// DataStore que obtiene configuración desde Firebase Remote Config
/// Para películas, delega a RemoteMovieDataStore
class FirebaseDataStore: DataStore {
    
    private let firebaseService = FirebaseConfigService.shared
    private let remoteDataStore = RemoteMovieDataStore()
    
    // MARK: - DataStore Protocol
    
    func fetchAppConfig(completion: @escaping (Result<AppConfig, Error>) -> Void) {
        print("[FirebaseDataStore] fetchAppConfig - Loading from Firebase Remote Config")
        
        firebaseService.fetchConfiguration { result in
            switch result {
            case .success(let remoteConfig):
                print("[FirebaseDataStore] Remote Config fetched successfully")
                
                // Guardar en AppConfigurationManager
                AppConfigurationManager.shared.updateConfiguration(remoteConfig)
                
                // Convertir RemoteConfiguration a AppConfig
                let appConfig = AppConfig(
                    welcomeMessage: remoteConfig.welcomeMessage,
                    apiBaseURL: TMDBConfiguration.baseURL,
                    enableFeatureX: remoteConfig.recommendationsEnabled
                )
                
                completion(.success(appConfig))
                
            case .failure(let error):
                print("[FirebaseDataStore] Remote Config fetch failed: \(error)")
                
                // Usar configuración por defecto
                let appConfig = AppConfig(
                    welcomeMessage: RemoteConfiguration.default.welcomeMessage,
                    apiBaseURL: TMDBConfiguration.baseURL,
                    enableFeatureX: true
                )
                
                completion(.success(appConfig))
            }
        }
    }
    
    func fetchCategories(completion: @escaping (Result<[Category], Error>) -> Void) {
        print("[FirebaseDataStore] fetchCategories - Delegating to RemoteMovieDataStore")
        
        // Verificar modo mantenimiento
        if AppConfigurationManager.shared.maintenanceMode {
            print("[FirebaseDataStore] Maintenance mode is active")
            let error = NSError(
                domain: "FirebaseDataStore",
                code: 503,
                userInfo: [NSLocalizedDescriptionKey: "La aplicación está en mantenimiento. Por favor intenta más tarde."]
            )
            completion(.failure(error))
            return
        }
        
        // Delegar a RemoteMovieDataStore
        remoteDataStore.fetchCategories(completion: completion)
    }
    
    func fetchMovieDetail(id movieId: Int, completion: @escaping (Result<Movie, Error>) -> Void) {
        print("[FirebaseDataStore] fetchMovieDetail - Delegating to RemoteMovieDataStore")
        
        // Verificar modo mantenimiento
        if AppConfigurationManager.shared.maintenanceMode {
            print("[FirebaseDataStore] Maintenance mode is active")
            let error = NSError(
                domain: "FirebaseDataStore",
                code: 503,
                userInfo: [NSLocalizedDescriptionKey: "La aplicación está en mantenimiento. Por favor intenta más tarde."]
            )
            completion(.failure(error))
            return
        }
        
        // Delegar a RemoteMovieDataStore
        remoteDataStore.fetchMovieDetail(id: movieId, completion: completion)
    }
}
