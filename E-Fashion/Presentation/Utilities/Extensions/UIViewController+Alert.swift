//
//  UIViewController+Alert.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String, buttonTitle: String = "OK", completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completion?()
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}
