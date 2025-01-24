//
//  UIView+Shadow.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 24.01.25.
//
import UIKit

extension UIView {
    func addShadow(color: UIColor = .black, opacity: Float = 0.2, offset: CGSize = CGSize(width: 0, height: 2), radius: CGFloat = 4) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    func removeShadow() {
        layer.shadowOpacity = 0
    }
}
