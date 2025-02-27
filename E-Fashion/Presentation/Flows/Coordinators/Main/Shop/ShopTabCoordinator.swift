//
//  ShopTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit
import SwiftUI

protocol ShopTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProducts(id: Int)
    func goToProductDetail(id: Int)
    func goBack(animated: Bool)
    func goToHomePage()
    func dismissPresented()
    func presentSortingViewController(nowSelected: OrderType, viewModel: DefaultProductsCatalogViewModel)
    func presentFilterViewController(nowSelectedParameters: SearchParameters, viewModel: DefaultProductsCatalogViewModel)
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
        let vc = ProductsCatalogViewController()
        vc.fetchProducts(id: id)
        rootViewController.pushViewController(vc, animated: true)
    }
    
    func goToProductDetail(id: Int) {
        let viewControler = ProductDetailsViewController(id: id) { [weak self] in
            self?.goBack(animated: true)
        }
        rootViewController.pushViewController(viewControler, animated: true)
    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func goToHomePage() {
        parentCoordinator.goToHomePage()
    }
    
    func presentSortingViewController(nowSelected: OrderType, viewModel: DefaultProductsCatalogViewModel) {
        let sortMenuVC = SortMenuViewController(selected: nowSelected, viewModel: viewModel)
        if let sheet = sortMenuVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false 
        }
        rootViewController.present(sortMenuVC, animated: true)
    }
    
    func presentFilterViewController(nowSelectedParameters: SearchParameters, viewModel: DefaultProductsCatalogViewModel) {
        let viewController = UIHostingController(rootView: FilterView(viewModel: viewModel))
        viewController.modalPresentationStyle = .fullScreen
        rootViewController.present(viewController, animated: true)
    }
    
    func dismissPresented() {
        rootViewController.dismiss(animated: true)
    }
}

extension DefaultShopTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
