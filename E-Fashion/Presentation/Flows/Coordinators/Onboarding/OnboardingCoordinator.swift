//
//  OnboardingCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine

protocol OnboardingCoordinator: Coordinator {
    var rootViewController: UIViewController { get }
}

final class DefaultOnboardingCoordinator: OnboardingCoordinator {
    var rootViewController = UIViewController()
    @Inject private var parentCoordinator: AppFlowCoordinator
    
    init() {

    }
    
    func start() {
        rootViewController = OnboardingViewController(doneRequested: { [weak self] in
            self?.parentCoordinator.viewModel.startAuthentication()
        })
    }
}
 
