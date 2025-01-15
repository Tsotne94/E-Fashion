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

class AppFlowCoordinator: Coordinator {
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    private var subscriptions = Set<AnyCancellable>()
    
    @Inject private var viewModel: AppFlowViewModel
    private var appState = CurrentValueSubject<AppState, Never>(.onboarding)

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
        let onboardingCoordinator = OnboardingCoordinator(appState: appState)
        onboardingCoordinator.start()
        self.childCoordinators = [onboardingCoordinator]
        self.window.rootViewController = onboardingCoordinator.rootViewController
    }
    
    func startAuthentication() {
//        let authCoordinator = AuthenticationCoordinator(appState: appState)
//        authCoordinator.start()
//        self.childCoordinators = [authCoordinator]
//        self.window.rootViewController = authCoordinator.rootViewController
    }
    
    func startMainFlow() {
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        self.window.rootViewController = mainCoordinator.rootViewController
    }
}

