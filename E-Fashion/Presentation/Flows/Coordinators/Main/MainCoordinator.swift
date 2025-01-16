//
//  MainCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import UIKit

final class MainCoordinator: Coordinator {
    weak var parentCoordinator: AppFlowCoordinator?
    
    var rootViewController: UITabBarController
    var childCoordinators = [Coordinator]()
    
    init(parentCoordinator: AppFlowCoordinator) {
        self.rootViewController = MainTabBarController()
        self.parentCoordinator = parentCoordinator
    }
    
    func start() {
        let firstCoordinator = FirstTabCoordinator()
        firstCoordinator.start()
        self.childCoordinators.append(firstCoordinator)
        let firstController = firstCoordinator.rootViewController
        firstController.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 0)
        
        let secondCoordinator = SecondTabCoordinator()
        secondCoordinator.start()
        self.childCoordinators.append(secondCoordinator)
        let secondController = secondCoordinator.rootViewController
        secondController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        
        self.rootViewController.viewControllers = [
            firstCoordinator.rootViewController,
            secondCoordinator.rootViewController
        ]
        
    }
}

