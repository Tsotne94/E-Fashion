//
//  UIButton+TitleAnimation.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.01.25.
//

import UIKit

extension UIButton {
    func setTitleWithAnimation(_ title: String, duration: TimeInterval = 0.3) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.setTitle(title, for: .normal)
        }
    }
}

extension UIButton {
    func dissapearWithAnimation(duration: TimeInterval = 0.2) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.isHidden = true
        }
    }
    
    func apearWithAnimation(duration: TimeInterval = 0.2) {
        UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve) {
            self.isHidden = false
        }
    }
}
