//
//  Reusable.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - Reusable Protocol
/// Protocol para identificadores reutilizables en celdas
protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

// MARK: - UITableViewCell Reusable
extension UITableViewCell: Reusable {}

// MARK: - UICollectionViewCell Reusable
extension UICollectionViewCell: Reusable {}
