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
    weak var parentCoordinator: AppFlowCoordinator?
    @Inject var test: AppFlowViewModel
    
    init(parentCoordinator: AppFlowCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        rootViewController = OnboardingViewController(doneRequested: { [weak self] in
//            self?.parentCoordinator?.viewModel.startMainFlow()
            self?.test.startMainFlow()
        })
    }
}
 
