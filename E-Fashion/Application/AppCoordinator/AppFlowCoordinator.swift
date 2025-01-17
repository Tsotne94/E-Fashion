//
//  AppFlowCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine
import FirebaseAuth

protocol AppFlowCoordinator: Coordinator {
    var viewModel: AppFlowViewModel { get }
    func start()
    func startOnboarding()
    func startAuthentication()
    func startMainFlow()
}

final class DefaultAppFlowCoordinator: AppFlowCoordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    private var subscriptions = Set<AnyCancellable>()
    private var animatedTransition = false
    
    @Inject var viewModel: AppFlowViewModel

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
        let onboardingCoordinator = DefaultOnboardingCoordinator()
        onboardingCoordinator.start()
        self.childCoordinators = [onboardingCoordinator]
        self.window.rootViewController = onboardingCoordinator.rootViewController
        
        self.animatedTransition = true
    }
    
    func startAuthentication() {
        //        let authCoordinator = AuthenticationCoordinator()
        //        authCoordinator.start()
        //        self.childCoordinators = [authCoordinator]
        //        self.window.rootViewController = authCoordinator.rootViewController
    }
    
    func startMainFlow() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        
        self.window.setRootViewControllerWithPushTransition(mainCoordinator.rootViewController, animated: animatedTransition)
    }
}

#warning("add aplicaition logoooo")
