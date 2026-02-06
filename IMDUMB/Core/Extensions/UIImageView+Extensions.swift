//
//  UIImageView+Extensions.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - UIImageView Extensions
extension UIImageView {
    
    // MARK: - Load Image from URL
    /// Carga una imagen desde una URL de forma asíncrona
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        guard let url = URL(string: urlString) else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                self?.image = UIImage(data: data)
            }
        }.resume()
    }
}
