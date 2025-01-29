//
//  FavouritesTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import UIKit
import SwiftUI

protocol FavouritesTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProductsDetails(productId: Int)
}

final class DefaultFavouritesTabCoordinator: NSObject, FavouritesTabCoordinator {
    var rootViewController: UINavigationController
    
    override init() {
        self.rootViewController = UINavigationController()
        rootViewController.isNavigationBarHidden = true
    }
    
    func start() {
        let hostingView = UIHostingController(rootView: FavoritesView())
        rootViewController.setViewControllers([hostingView], animated: false)
    }
    
    func goToProductsDetails(productId: Int) {
        let viewController = ProductDetailsViewController(id: productId)
        rootViewController.pushViewController(viewController, animated: true)
    }
}

extension DefaultFavouritesTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}

