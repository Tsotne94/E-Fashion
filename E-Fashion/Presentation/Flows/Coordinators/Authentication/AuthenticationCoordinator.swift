//
//  AuthenticationCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit
import Combine

class AuthenticationCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    
    init(parentCoordinator: AppFlowCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        
    }
}
