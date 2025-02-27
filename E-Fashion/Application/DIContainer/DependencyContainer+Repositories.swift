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
            Module { DefaultUserRepository() as UserRepository }
            Module { DefaultProductsRepository() as ProductsRepository }
            Module { DefaultCashRepository() as CacheRepository }
            Module { DefaultFirestoreCartRepository() as FirestoreCartRepository }
            Module { DefaultFirestoreFavouritesRepository() as FirestoreFavouritesRepository }
            Module { DefaultDeliveryRepository() as DeliveryRepository }
            Module { DefaultPaymentRepository() as PaymentRepository }
            Module { DefaultOrdersRepository() as OrdersRepository }
        }
    }
}
