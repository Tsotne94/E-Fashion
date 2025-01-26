//
//  ShopTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit

protocol ShopTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProducts(id: Int)
    func goBack(animated: Bool)
}

class DefaultShopTabCoordinator:  NSObject, ShopTabCoordinator {
    var rootViewController: UINavigationController
    
    override init() {
        self.rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
    }
    
    lazy var firstViewController: ShopViewController = {
        let vc = ShopViewController()
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([firstViewController], animated: false)
    }
    
    func goToProducts(id: Int) {
        rootViewController.pushViewController(ProductsCatalogViewController(), animated: true)
    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
}

extension DefaultShopTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
