//
//  UIView+Toast.swift
//  IMDUMB
//
//  Created on 4/02/26.
//

import UIKit

// MARK: - UIView Toast Extension
extension UIView {
    
    /// Muestra un mensaje temporal tipo Toast
    func showToast(message: String, duration: TimeInterval = 2.0, position: ToastPosition = .bottom) {
        let toastLabel = UILabel()
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.8)
        toastLabel.textColor = .white
        toastLabel.font = UIFont.systemFont(ofSize: 14)
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.numberOfLines = 0
        toastLabel.alpha = 0.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        
        let maxWidth: CGFloat = self.bounds.width - 40
        let textSize = message.boundingRect(
            with: CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: toastLabel.font!],
            context: nil
        ).size
        
        toastLabel.frame = CGRect(
            x: 0,
            y: 0,
            width: textSize.width + 20,
            height: textSize.height + 20
        )
        
        // Posicionar el toast
        let yPosition: CGFloat
        switch position {
        case .top:
            yPosition = self.safeAreaInsets.top + 20
        case .center:
            yPosition = (self.bounds.height - toastLabel.frame.height) / 2
        case .bottom:
            yPosition = self.bounds.height - self.safeAreaInsets.bottom - toastLabel.frame.height - 20
        }
        
        toastLabel.center = CGPoint(x: self.bounds.width / 2, y: yPosition)
        self.addSubview(toastLabel)
        
        // Animación
        UIView.animate(withDuration: 0.3, animations: {
            toastLabel.alpha = 1.0
        }) { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toastLabel.alpha = 0.0
            }) { _ in
                toastLabel.removeFromSuperview()
            }
        }
    }
    
    enum ToastPosition {
        case top
        case center
        case bottom
    }
}
