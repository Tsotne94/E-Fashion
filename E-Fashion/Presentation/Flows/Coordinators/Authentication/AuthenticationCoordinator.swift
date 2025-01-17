//
//  AuthenticationCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit
import Combine

protocol AuthenticationCoordinator: Coordinator {
    var rootViewController: UINavigationController { get }
    func goToSignUp()
    func goToForgotPasswordView()
    func goBack(animated: Bool)
}

final class DefaultAuthenticationCoordinator: NSObject, AuthenticationCoordinator {
    var rootViewController = UINavigationController()
    
    @Inject private var parentCoordinator: AppFlowCoordinator

    override init() {
        
    }
    
    func start() {
        rootViewController.setViewControllers([OnboardingViewController(doneRequested: { })], animated: false)
    }

    func goToSignUp() {
        
    }
    
    func goToForgotPasswordView() {
        
    }
    
    func goBack(animated: Bool) {
        rootViewController.popViewController(animated: animated)
    }
}

extension DefaultAuthenticationCoordinator: UINavigationControllerDelegate {
    
}
