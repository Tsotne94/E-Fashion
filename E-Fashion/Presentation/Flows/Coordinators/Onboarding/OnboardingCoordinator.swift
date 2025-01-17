//
//  OnboardingCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import Foundation
import UIKit
import Combine

protocol Onboa


class DefaultOnboardingCoordinator: Coordinator {
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
 
