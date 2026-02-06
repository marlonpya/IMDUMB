//
//  String+HTML.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import Foundation
import UIKit

// MARK: - String HTML Extension
extension String {
    
    /// Convierte una cadena HTML a NSAttributedString
    func htmlAttributedString(fontSize: CGFloat = 16) -> NSAttributedString? {
        let modifiedFont = String(format: "<span style=\"font-family: '-apple-system', 'HelveticaNeue'; font-size: \(fontSize)px\">%@</span>", self)
        
        guard let data = modifiedFont.data(using: .utf8) else {
            return nil
        }
        
        do {
            return try NSAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
        } catch {
            print("Error converting HTML to AttributedString: \(error)")
            return nil
        }
    }
    
    /// Remueve todas las etiquetas HTML
    var stripHTML: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    /// Convierte HTML simple a texto con formato básico
    func simpleHTMLToAttributedString() -> NSAttributedString {
        // Si la conversión HTML falla, devolver texto plano
        return htmlAttributedString() ?? NSAttributedString(string: self)
    }
}
