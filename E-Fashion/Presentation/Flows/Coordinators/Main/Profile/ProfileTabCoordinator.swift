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

class DefaultProfileTabCoordinator: NSObject, ProfileTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
        rootViewController.setViewControllers([ProfileViewController()], animated: false)
    }
}

extension DefaultProfileTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
