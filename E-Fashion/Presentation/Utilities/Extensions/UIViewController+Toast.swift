//
//  UIViewController+Toast.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 1.5, backgroundColor: UIColor = .customGreen.withAlphaComponent(0.7), textColor: UIColor = .white, font: UIFont = UIFont(name: CustomFonts.nutinoBold, size: 14) ?? .systemFont(ofSize: 14)) {
        
        let toast = UILabel()
        toast.backgroundColor = backgroundColor
        toast.textColor = textColor
        toast.textAlignment = .center
        toast.font = font
        toast.text = message
        toast.alpha = 0
        toast.layer.cornerRadius = 17
        toast.clipsToBounds = true
        toast.translatesAutoresizingMaskIntoConstraints = false
        toast.numberOfLines = 0
        toast.padding = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32),
            toast.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 20),
            toast.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -20),
            toast.heightAnchor.constraint(greaterThanOrEqualToConstant: 34)
        ])
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
            toast.alpha = 1
        }, completion: { _ in
            UIView.animate(withDuration: 0.3, delay: duration, options: .curveEaseOut, animations: {
                toast.alpha = 0
            }, completion: { _ in
                toast.removeFromSuperview()
            })
        })
    }
}

private extension UILabel {
    var padding: UIEdgeInsets {
        get {
            return UIEdgeInsets.zero
        }
        set {
            let paddingView = UIView()
            paddingView.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(paddingView)
            
            NSLayoutConstraint.activate([
                paddingView.topAnchor.constraint(equalTo: self.topAnchor, constant: newValue.top),
                paddingView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -newValue.bottom),
                paddingView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: newValue.left),
                paddingView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -newValue.right)
            ])
        }
    }
}
