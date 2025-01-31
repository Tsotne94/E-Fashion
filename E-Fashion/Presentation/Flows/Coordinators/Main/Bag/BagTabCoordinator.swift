//
//  BagTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import UIKit
import SwiftUI

protocol BagTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToProductsDetails(productId: Int)
    func popToRoot()
    func goToCheckout()
    func orderPlaced()
    func changeCard()
    func goBack()
    func addCard(viewModel: PaymentMethodsViewModel)
    func dismissPresented()
    func changeDeliveryLocation()
    func addDeliveryLoaction(viewmodel: ShippingAddressesViewModel)
}

final class DefaultBagTabCoordinator: NSObject, BagTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
        let hostingView = UIHostingController(rootView: BagView())
        rootViewController.setViewControllers([hostingView], animated: false)
    }
    
    func goToProductsDetails(productId: Int) {
        let viewController = ProductDetailsViewController(id: productId) { [weak self] in
            self?.goBack()
        }
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    func goToCheckout() {
        let viewController = UIHostingController(rootView: CheckoutView())
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func orderPlaced() {
        let viewController = GreetingViewController()
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func popToRoot() {
        rootViewController.popToRootViewController(animated: true)
    }
    
    func changeCard() {
        let viewController = UIHostingController(rootView: PaymentMethodsView())
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func addCard(viewModel: PaymentMethodsViewModel) {
        let addCardView = UIHostingController(rootView: AddPaymentMethodView(viewModel: viewModel))
        if let sheet = addCardView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        rootViewController.present(addCardView, animated: true)
    }
    
    func changeDeliveryLocation() {
        let viewController = UIHostingController(rootView: ShippingAdressesView())
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func addDeliveryLoaction(viewmodel: ShippingAddressesViewModel) {
        let addCardView = UIHostingController(rootView: AddShippingAddressView(viewModel: viewmodel))
        if let sheet = addCardView.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        rootViewController.present(addCardView, animated: true)
    }
    
    func dismissPresented() {
        rootViewController.dismiss(animated: true)
    }
}

extension DefaultBagTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
    
