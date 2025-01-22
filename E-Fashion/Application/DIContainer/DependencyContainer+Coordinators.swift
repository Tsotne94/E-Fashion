//
//  DependencyContainer+Coordinators.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
public extension DependencyContainer {
    func registerCoordinators() {
        let authCoordinator = DefaultAuthenticationCoordinator()
        let mainCoordinator = DefaultMainCoordinator()
        
        let homeCoordinator = DefaultHomeTabCoordinator()
        let shopCoordinator = DefaultShopTabCoordinator()
        let bagCoordinator = DefaultBagTabCoordinator()
        let favouritesCoordinator = DefaultFavouritesTabCoordinator()
        let profileCoordinator = DefaultProfileTabCoordinator()
    
        DependencyContainer.root.register {
            Module { DefaultOnboardingCoordinator() as OnboardingCoordinator }
            Module { authCoordinator as AuthenticationCoordinator }
            Module { mainCoordinator as MainCoordinator }
            Module { homeCoordinator as HomeTabCoordinator }
            Module { shopCoordinator as ShopTabCoordinator }
            Module { bagCoordinator as BagTabCoordinator }
            Module { favouritesCoordinator as FavouritesTabCoordinator }
            Module { profileCoordinator as ProfileTabCoordinator }
        }
    }
}
