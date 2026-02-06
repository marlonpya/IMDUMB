//
//  FirebaseConfigService.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation
import FirebaseCore
import FirebaseRemoteConfig

// MARK: - Firebase Config Service
class FirebaseConfigService {
    
    // Singleton
    static let shared = FirebaseConfigService()
    
    private var remoteConfig: RemoteConfig
    
    private init() {
        remoteConfig = RemoteConfig.remoteConfig()
        setupRemoteConfig()
    }
    
    // MARK: - Setup
    private func setupRemoteConfig() {
        // Configuración de Remote Config
        let settings = RemoteConfigSettings()
        
        #if DEBUG
        // En desarrollo, fetch más frecuente (cada 10 segundos)
        settings.minimumFetchInterval = 10
        #else
        // En producción, fetch cada 12 horas
        settings.minimumFetchInterval = 43200
        #endif
        
        remoteConfig.configSettings = settings
        
        // Valores por defecto
        let defaults: [String: NSObject] = [
            RemoteConfiguration.ConfigKey.welcomeMessage.rawValue: "Bienvenido a IMDUMB" as NSObject,
            RemoteConfiguration.ConfigKey.apiTimeout.rawValue: 30 as NSObject,
            RemoteConfiguration.ConfigKey.recommendationsEnabled.rawValue: true as NSObject,
            RemoteConfiguration.ConfigKey.maintenanceMode.rawValue: false as NSObject,
            RemoteConfiguration.ConfigKey.categoriesLimit.rawValue: 5 as NSObject,
            RemoteConfiguration.ConfigKey.moviesPerCategory.rawValue: 10 as NSObject
        ]
        
        remoteConfig.setDefaults(defaults)
    
    }
    
    // MARK: - Fetch Configuration
    func fetchConfiguration(completion: @escaping (Result<RemoteConfiguration, Error>) -> Void) {
        
        remoteConfig.fetch { [weak self] status, error in
            guard let self = self else { return }
            
            if let error = error {
                // Retornar valores por defecto en caso de error
                completion(.success(RemoteConfiguration.default))
                return
            }
            
            
            // Activar los valores fetcheados
            self.remoteConfig.activate { changed, error in
                if let error = error {
                    print("[FirebaseConfigService] Activation failed: \(error.localizedDescription)")
                    completion(.success(RemoteConfiguration.default))
                    return
                }
                
                // Obtener valores
                let config = self.getCurrentConfiguration()
                self.logConfiguration(config)
                completion(.success(config))
            }
        }
    }
    
    // MARK: - Get Current Configuration
    func getCurrentConfiguration() -> RemoteConfiguration {
        let welcomeMessage = remoteConfig[RemoteConfiguration.ConfigKey.welcomeMessage.rawValue].stringValue
        
        let apiTimeout = remoteConfig[RemoteConfiguration.ConfigKey.apiTimeout.rawValue].numberValue.intValue
        
        let recommendationsEnabled = remoteConfig[RemoteConfiguration.ConfigKey.recommendationsEnabled.rawValue].boolValue
        
        let maintenanceMode = remoteConfig[RemoteConfiguration.ConfigKey.maintenanceMode.rawValue].boolValue
        
        let categoriesLimit = remoteConfig[RemoteConfiguration.ConfigKey.categoriesLimit.rawValue].numberValue.intValue
        
        let moviesPerCategory = remoteConfig[RemoteConfiguration.ConfigKey.moviesPerCategory.rawValue].numberValue.intValue
        
        return RemoteConfiguration(
            welcomeMessage: welcomeMessage,
            apiTimeout: apiTimeout,
            recommendationsEnabled: recommendationsEnabled,
            maintenanceMode: maintenanceMode,
            categoriesLimit: categoriesLimit,
            moviesPerCategory: moviesPerCategory
        )
    }
    
    // MARK: - Logging
    private func logConfiguration(_ config: RemoteConfiguration) {
        print("   [FirebaseConfigService] Current Configuration:")
        print("   Welcome Message: \(config.welcomeMessage)")
        print("   API Timeout: \(config.apiTimeout)s")
        print("   Recommendations: \(config.recommendationsEnabled ? "Enabled" : "Disabled")")
        print("   Maintenance Mode: \(config.maintenanceMode ? "Active" : "Inactive")")
        print("   Categories Limit: \(config.categoriesLimit)")
        print("   Movies Per Category: \(config.moviesPerCategory)")
    }
}
