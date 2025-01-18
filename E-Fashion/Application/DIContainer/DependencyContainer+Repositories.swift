//
//  DependencyContainer+Repositories.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
public extension DependencyContainer {
    func registerRepositories() {
        DependencyContainer.root.register {
            Module { DefaultAppStateRepository() as AppStateRepository }
            Module { DefaultAuthenticationRepository() as AuthenticationRepository } 
        }
    }
}
