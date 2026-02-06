//
//  UIImageView+Circular.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - UIImageView Circular Extension
extension UIImageView {
    
    /// Hace la imagen circular
    func makeCircular() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    /// Hace la imagen circular con un tamaño específico
    func makeCircular(size: CGFloat) {
        self.layer.cornerRadius = size / 2
        self.clipsToBounds = true
    }
    
    /// Añade borde a la imagen circular
    func addCircularBorder(width: CGFloat = 2, color: UIColor = .white) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
}
