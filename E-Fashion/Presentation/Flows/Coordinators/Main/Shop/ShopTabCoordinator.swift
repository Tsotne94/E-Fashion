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
    func goToProductDetail(id: Int)
    func goBack(animated: Bool)
    func goToHomePage()
}

class DefaultShopTabCoordinator:  NSObject, ShopTabCoordinator {
    @Inject private var parentCoordinator: MainCoordinator
    
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
    
    func goToProductDetail(id: Int) {
        let viewControler = ProductDetailsViewController(id: id)
        rootViewController.pushViewController(viewControler, animated: true)
    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func goToHomePage() {
        parentCoordinator.goToHomePage()
    }
}

extension DefaultShopTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
