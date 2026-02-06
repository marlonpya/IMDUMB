//
//  AppConfigurationManager.swift
//  IMDUMB
//
//  Created on 4/02/26.
//  Singleton para gestionar configuración de la app
//

import Foundation

// MARK: - App Configuration Manager
class AppConfigurationManager {
    
    // Singleton
    static let shared = AppConfigurationManager()
    
    // MARK: - Properties
    private(set) var remoteConfiguration: RemoteConfiguration = .default
    private(set) var isConfigurationLoaded = false
    
    private init() {
        print(" [AppConfigurationManager] Initialized with default configuration")
    }
    
    // MARK: - Public Methods
    
    /// Actualiza la configuración remota
    func updateConfiguration(_ config: RemoteConfiguration) {
        self.remoteConfiguration = config
        self.isConfigurationLoaded = true
        
        print("[AppConfigurationManager] Configuration updated")
        print("Welcome: \(config.welcomeMessage)")
        print("Maintenance: \(config.maintenanceMode)")
    }
    
    /// Resetea la configuración a valores por defecto
    func resetToDefault() {
        self.remoteConfiguration = .default
        self.isConfigurationLoaded = false
        print("[AppConfigurationManager] Configuration reset to default")
    }
    
    // MARK: - Computed Properties (para fácil acceso)
    
    var welcomeMessage: String {
        return remoteConfiguration.welcomeMessage
    }
    
    var apiTimeout: Int {
        return remoteConfiguration.apiTimeout
    }
    
    var recommendationsEnabled: Bool {
        return remoteConfiguration.recommendationsEnabled
    }
    
    var maintenanceMode: Bool {
        return remoteConfiguration.maintenanceMode
    }
    
    var categoriesLimit: Int {
        return remoteConfiguration.categoriesLimit
    }
    
    var moviesPerCategory: Int {
        return remoteConfiguration.moviesPerCategory
    }
}
