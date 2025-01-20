//
//  DependencyContainer+Coordinators.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 17.01.25.
//
public extension DependencyContainer {
    func registerCoordinators() {
        let authCoordinator = DefaultAuthenticationCoordinator()
        
        DependencyContainer.root.register {
            Module {
                DefaultOnboardingCoordinator() as OnboardingCoordinator
            }
            Module {
                authCoordinator as AuthenticationCoordinator
            }
        }
    }
}
