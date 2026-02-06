//
//  UIView+Extensions.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - UIView Extensions
extension UIView {
    
    // MARK: - Reusable Protocol
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    // MARK: - XIB Loading
    static func loadFromNib() -> Self {
        let nibName = String(describing: self)
        let nib = UINib(nibName: nibName, bundle: nil)
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
    // MARK: - Corner Radius
    func roundCorners(radius: CGFloat) {
        layer.cornerRadius = radius
        layer.masksToBounds = true
    }
    
    // MARK: - Shadow
    func addShadow(opacity: Float = 0.2, radius: CGFloat = 4, offset: CGSize = .zero) {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = offset
        layer.masksToBounds = false
    }
}
