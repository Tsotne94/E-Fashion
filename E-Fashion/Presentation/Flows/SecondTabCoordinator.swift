//
//  SecondTabCoordinator.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 14.01.25.
//
import UIKit

class SecondTabCoordinator: NSObject, Coordinator {
    var rootViewController: UINavigationController
    let viewmodel = FirstTabViewModel()
    
    override init() {
        self.rootViewController = UINavigationController()
        rootViewController.navigationBar.prefersLargeTitles = true
        super.init()
        
        rootViewController.delegate = self
    }
    
    lazy var secondViewController: BagViewController = {
        let vc = BagViewController()
        vc.title = "Second"
        vc.viewModel = viewmodel
        vc.showDetailRequested = { [weak self] in
            self?.viewmodel.nname = "new new new new"
            self?.goToDetail()
        }
        return vc
    }()
    
    func start() {
        rootViewController.setViewControllers([secondViewController], animated: false)
    }
    
    func goToDetail() {
        rootViewController.pushViewController(FavouritesViewController(), animated: true)
    }
}

extension SecondTabCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        if (viewController as? FavouritesViewController) != nil {
            print("ehhehehhehehehehhehehehehheeh")
        }
    }
}
