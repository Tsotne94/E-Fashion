//
//  HomeTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit

protocol HomeTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func checkProductsUnderSale()
    func checkNewProducts()
    func goToProductsDetails(productId: Int)
}

class DefaultHomeTabCoordinator: NSObject, HomeTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
        let viewController = HomeViewController()
        rootViewController.setViewControllers([viewController], animated: false)
    }
    
    func checkProductsUnderSale() {
        
    }
    
    func checkNewProducts() {
        
    }
    
    func goToProductsDetails(productId: Int) {
        
    }
}

extension DefaultHomeTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
