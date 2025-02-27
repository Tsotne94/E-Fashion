//
//  AppFlowCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine

protocol AppFlowCoordinator: Coordinator {
    var viewModel: AppFlowViewModel { get }
    func start()
    func startOnboarding()
    func startAuthentication()
    func startMainFlow()
    func signOut()
}

final class DefaultAppFlowCoordinator: AppFlowCoordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    private var subscriptions = Set<AnyCancellable>()
    private var animatedTransition = false
    
    @Inject var viewModel: AppFlowViewModel
    
    @Inject private var onboardingCoordinator: OnboardingCoordinator
    @Inject private var authenticationCoordinator: AuthenticationCoordinator
    @Inject private var mainCoordinator: MainCoordinator

    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        viewModel.output
            .sink { [weak self] action in
                switch action {
                case .startOnboarding:
                    self?.startOnboarding()
                case .startAuthentication:
                    self?.startAuthentication()
                case .startMainFlow:
                    self?.startMainFlow()
                }
            }
            .store(in: &subscriptions)
        
        viewModel.loadAppState()
    }
    
    func startOnboarding() {
        onboardingCoordinator.start()
        self.childCoordinators = [onboardingCoordinator]
        self.window.rootViewController = onboardingCoordinator.rootViewController
        
        self.animatedTransition = true
    }
    
    func startAuthentication() {
        authenticationCoordinator.start()
        self.childCoordinators = [authenticationCoordinator]
        self.window.setRootViewControllerWithPushTransition(authenticationCoordinator.rootViewController, animated: animatedTransition)
        
        self.animatedTransition = true
    }
    
    func startMainFlow() {
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        self.window.setRootViewControllerWithPushTransition(mainCoordinator.rootViewController, animated: animatedTransition)
    }
    
    func signOut() {
        viewModel.signOut()
    }
}

