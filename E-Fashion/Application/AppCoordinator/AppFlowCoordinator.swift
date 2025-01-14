//
//  AppFlowCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine

class AppFlowCoordinator: Coordinator {
    
    let window: UIWindow
    var childCoordinators = [Coordinator]()
    
    var hasSeenOnboarding = CurrentValueSubject<Bool, Never>(false)
    var subscriptions = Set<AnyCancellable>()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        setupOnboardingValue()
        hasSeenOnboarding
            .removeDuplicates()
            .sink { [weak self] hasSeen in
            if !hasSeen {
                let mainCoordinator = MainCoordinator()
                mainCoordinator.start()
                self?.childCoordinators = [mainCoordinator]
                
                self?.window.rootViewController = mainCoordinator.rootViewController
            } else if let hasSeenOnboarding = self?.hasSeenOnboarding {
                let onboardingCoordinator = OnboardingCoordinator(hasSeenOnboarding: hasSeenOnboarding)
                onboardingCoordinator.start()
                self?.childCoordinators = [onboardingCoordinator]
                
                self?.window.rootViewController = onboardingCoordinator.rootViewController
            }
        }.store(in: &subscriptions)
    }
    
    func setupOnboardingValue() {
        let key = "hasSeenOnboarding"
        let value = UserDefaults.standard.bool(forKey: key)
        hasSeenOnboarding.send(value)
        
        hasSeenOnboarding
            .filter({ $0 })
            .sink { value in
                UserDefaults.standard.setValue(value, forKey: key)
            }.store(in: &subscriptions)
    }
}
