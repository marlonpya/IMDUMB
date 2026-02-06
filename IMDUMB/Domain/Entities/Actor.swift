//
//  Actor.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation

// MARK: - Actor Entity
/// Entidad del dominio que representa un actor
struct Actor {
    let id: Int
    let name: String
    let profileURL: String?
    
    init(id: Int, name: String, profileURL: String? = nil) {
        self.id = id
        self.name = name
        self.profileURL = profileURL
    }
}

// MARK: - Equatable
extension Actor: Equatable {
    static func == (lhs: Actor, rhs: Actor) -> Bool {
        return lhs.id == rhs.id
    }
}
