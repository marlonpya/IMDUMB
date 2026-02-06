//
//  ConfigRepository.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - ConfigRepository Protocol
/// SOLID: DIP - Abstracción para obtener configuración de la app
protocol ConfigRepository {
    func getAppConfig(completion: @escaping (AppConfig) -> Void)
}
