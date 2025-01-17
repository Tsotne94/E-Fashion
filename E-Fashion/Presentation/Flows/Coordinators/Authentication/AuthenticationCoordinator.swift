//
//  AuthenticationCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit
import Combine
import SwiftUI

protocol AuthenticationCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToSignUp(animated: Bool)
    func goToForgotPasswordView(animated: Bool)
    func goBack(animated: Bool)
    func popToRoot(animated: Bool)
}

final class DefaultAuthenticationCoordinator: NSObject, AuthenticationCoordinator {
    var rootViewController = UINavigationController()
    
    @Inject private var parentCoordinator: AppFlowCoordinator

    override init() {
        
    }
    
    func start() {
        let hostingView = UIHostingController(rootView: LoginView())
        rootViewController.setViewControllers([hostingView], animated: false)
    }

    func goToSignUp(animated: Bool) {
        let hostingView = UIHostingController(rootView: SignUpView())
        rootViewController.pushViewController(hostingView, animated: animated)
    }
    
    func goToForgotPasswordView(animated: Bool) {
        let hostingView = UIHostingController(rootView: ForgotPasswordView())
        rootViewController.pushViewController(hostingView, animated: animated)
    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
    
    func successfullLogin() {
        parentCoordinator.startMainFlow()
    }
    
    func popToRoot(animated: Bool) {
        rootViewController.popToRootViewController(animated: animated)
    }
}

extension DefaultAuthenticationCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        navigationController.isNavigationBarHidden = true
    }
}
