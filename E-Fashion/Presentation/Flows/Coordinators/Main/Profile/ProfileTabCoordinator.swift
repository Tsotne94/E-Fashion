//
//  ProfileTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

import Foundation
import UIKit
import SwiftUI

protocol ProfileTabCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToAddresses()
    func goToPaymentMethods()
    func goToSettings()
    func goBack()
    func addAddress(viewModel: ShippingAddressesViewModel)
    func addPaymentMethod(viewModel: PaymentMethodsViewModel)
    func dismissPresented()
}

final class DefaultProfileTabCoordinator: NSObject, ProfileTabCoordinator {
    var rootViewController = UINavigationController()
    
    override init() {
        super.init()
        rootViewController.delegate = self
    }
    
    func start() {
        rootViewController.setViewControllers([ProfileViewController()], animated: false)
    }
    
    func goToAddresses() {
        let viewController = UIHostingController(rootView: ShippingAdressesView(goBack: { [weak self] in
            self?.goBack()
        }))
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goToPaymentMethods() {
        let viewController = UIHostingController(rootView: PaymentMethodsView(goBack: { [weak self] in
            self?.goBack()
        }))
        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goToSettings() {
//        let viewController = UIHostingController(rootView: SettingsView())
//        rootViewController.pushViewController(viewController, animated: true)
    }
    
    func goBack() {
        rootViewController.popViewController(animated: true)
    }
    
    func addAddress(viewModel: ShippingAddressesViewModel) {
        let addAddressView = UIHostingController(rootView: AddShippingAddressView(viewModel: viewModel))
        if let sheet = addAddressView.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        rootViewController.present(addAddressView, animated: true)
    }
    
    func addPaymentMethod(viewModel: PaymentMethodsViewModel) {
        let addPaymentView = UIHostingController(rootView: AddPaymentMethodView(viewModel: viewModel))
        if let sheet = addPaymentView.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        rootViewController.present(addPaymentView, animated: true)
    }
    
    func dismissPresented() {
        rootViewController.dismiss(animated: true)
    }
}

extension DefaultProfileTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
        navigationController.navigationBar.isHidden = true
    }
}
