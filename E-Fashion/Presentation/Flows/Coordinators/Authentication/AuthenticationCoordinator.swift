//
//  AuthenticationCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation
import UIKit
import Combine

final class AuthenticationCoordinator: NSObject, Coordinator {
    var rootViewController = UINavigationController()
    @Inject private var parentCoordinator: AppFlowCoordinator
    
    override init() {
        
    }
    
    func start() {
        
    }
}

extension AuthenticationCoordinator: UINavigationControllerDelegate {
    
}
