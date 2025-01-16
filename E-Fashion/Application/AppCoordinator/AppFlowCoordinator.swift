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

final class AppFlowCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    private var subscriptions = Set<AnyCancellable>()
    
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
        let onboardingCoordinator = OnboardingCoordinator(parentCoordinator: self)
        onboardingCoordinator.start()
        self.childCoordinators = [onboardingCoordinator]
        self.window.rootViewController = onboardingCoordinator.rootViewController
    }
    
    func startAuthentication() {
//        let authCoordinator = AuthenticationCoordinator()
//        authCoordinator.start()
//        self.childCoordinators = [authCoordinator]
//        self.window.rootViewController = authCoordinator.rootViewController
    }
    
    func startMainFlow() {
        let mainCoordinator = MainCoordinator(parentCoordinator: self)
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        self.window.setRootViewControllerWithPushTransition(mainCoordinator.rootViewController)
    }
}

#warning("add aplicaition logoooo")
