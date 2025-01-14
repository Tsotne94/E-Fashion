//
//  OnboardingCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine

class OnboardingCoordinator: Coordinator {
    var rootViewController = UIViewController()
    
    var hasSeenOnboarding: CurrentValueSubject<Bool, Never>
    
    init(hasSeenOnboarding: CurrentValueSubject<Bool, Never>) {
        self.hasSeenOnboarding = hasSeenOnboarding
    }
    
    func start() {
        let view = OnboardingViewController { [weak self] in
            self?.hasSeenOnboarding.send(true)
        }
        rootViewController = view
    }
    
    
}
 
