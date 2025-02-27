//
//  UIWindow+Transition.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.01.25.
//

import UIKit

extension UIWindow {
    func setRootViewControllerWithPushTransition(_ viewController: UIViewController, duration: TimeInterval = 0.4, animated: Bool = true) {
        
        if animated {
            let transition = CATransition()
            transition.type = .push
            transition.subtype = .fromRight
            transition.duration = duration
            self.layer.add(transition, forKey: kCATransition)
            
            self.rootViewController = viewController
        } else {
            self.rootViewController = viewController
        }
    }
}
