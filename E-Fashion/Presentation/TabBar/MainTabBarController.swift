//
//  MainTabBarController.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//

import UIKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tintColor: UIColor = .accentRed
        tabBar.tintColor = tintColor
        tabBar.unselectedItemTintColor = .gray
        
        let attributes: [NSAttributedString.Key: Any] = [ .foregroundColor: tintColor ]
        UITabBarItem.appearance().setTitleTextAttributes(attributes, for: .selected)
        
        tabBar.backgroundColor = .white
    }
}
