//
//  ProfileTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import UIKit

protocol ProfileTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
}

class DefaultProfileTabCoordinator: ProfileTabCoordinator {
    var rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    func start() {
        rootViewController.setViewControllers([UIViewController()], animated: false)
    }
}
