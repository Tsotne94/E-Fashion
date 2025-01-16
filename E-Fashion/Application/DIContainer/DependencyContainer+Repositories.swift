//
//  DependencyContainer+Repositories.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//
import Foundation

public extension DependencyContainer {
    func registerRepositories() {
        DependencyContainer.root.register {
            Module { DefaultAppStateRepository() as AppStateRepository }
#warning("activate this in future")
//            Module { DefaultAuthenticationRepository() as AuthenticationRepository } #warning
        }
    }
}
