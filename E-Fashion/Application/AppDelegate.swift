//
//  AppDelegate.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 09.01.25.
//
import UIKit
import FirebaseCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var appFlowCoordinator: AppFlowCoordinator?
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        DependencyContainer.root.registerUseCases()
        DependencyContainer.root.registerRepositories()
        DependencyContainer.root.registerViewModels()
    
        configureWindow()
        
        return true
    }
    
    func configureWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        let appFlowCoordinator = AppFlowCoordinator(window: window)
        self.appFlowCoordinator = appFlowCoordinator
        
        appFlowCoordinator.start()
        window.makeKeyAndVisible()
    }
}
