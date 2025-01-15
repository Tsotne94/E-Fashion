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
    
    var appState: CurrentValueSubject<AppState, Never>
    
    init(appState: CurrentValueSubject<AppState, Never>) {
        self.appState = appState
    }
    
    func start() {
        let view = OnboardingViewController { [weak self] in
            self?.appState.send(.mainFlow)
        }
        rootViewController = view
    }
}
 
