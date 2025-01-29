//
//  FavouritesTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import UIKit

protocol FavouritesTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
}

class DefaultFavouritesTabCoordinator: FavouritesTabCoordinator {
    var rootViewController: UINavigationController
    
    init() {
        self.rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    lazy var firstViewController: FavouritesViewController = {
        let vc = FavouritesViewController()
        vc.title = "haha i am the best"
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([firstViewController], animated: false)
    }
}
