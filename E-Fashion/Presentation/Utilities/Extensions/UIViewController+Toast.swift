//
//  UIViewController+Toast.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import UIKit

extension UIViewController {
    func showToast(message: String, duration: TimeInterval = 1.5, backgroundColor: UIColor = .customGreen, textColor: UIColor = .white, font: UIFont = UIFont(name: CustomFonts.nutinoBold, size: 14) ?? .systemFont(ofSize: 14)) {
        
        let toast = PaddedLabel()
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
        toast.contentInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        
        view.addSubview(toast)
        NSLayoutConstraint.activate([
            toast.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toast.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -250),
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

class PaddedLabel: UILabel {
    var contentInsets = UIEdgeInsets.zero
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: contentInsets)
        super.drawText(in: insetRect)
    }
    
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        return CGSize(
            width: size.width + contentInsets.left + contentInsets.right,
            height: size.height + contentInsets.top + contentInsets.bottom
        )
    }
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        let superSize = super.sizeThatFits(size)
        return CGSize(
            width: superSize.width + contentInsets.left + contentInsets.right,
            height: superSize.height + contentInsets.top + contentInsets.bottom
        )
    }
}
