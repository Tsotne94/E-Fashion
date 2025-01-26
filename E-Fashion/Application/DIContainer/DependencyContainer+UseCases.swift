//
//  DependencyContainer+UseCases.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 15.01.25.
//

public extension DependencyContainer {
    func registerUseCases() {
        DependencyContainer.root.register {
            Module { DefaultLoadAppStateUseCase() as LoadAppStateUseCase }
            Module { DefaultUpdateAppStateUseCase() as UpdateAppStateUseCase }
            Module { DefaultHasSeenOnboardingUseCase() as HasSeenOnboardingUseCase }
            Module { DefaultSignInUseCase() as SignInUseCase }
            Module { DefaultSignUpUseCase() as SignUpUseCase }
            Module { DefaultSaveUserUseCase() as SaveUserUseCase }
            Module { DefaultGetCurrentUserUseCase() as GetCurrentUserUseCase }
            Module { DefaultSaveUserUseCase() as SaveUserUseCase }
            Module { DefaultFetchProductsUseCase() as FetchProductsUseCase }
            Module { DefaultFetchSingleProductUseCase() as FetchSingleProductUseCase }
            Module { DefaultFetchImageUseCase() as FetchImageUseCase }
            Module { DefaultRetriveCachedImageUseCase() as RetriveCachedImageUseCase }
            Module { DefaultAddToCartUseCase() as AddToCartUseCase }
            Module { DefaultFetchItemsInCartUseCase() as FetchItemsInCartUseCase }
            Module { DefaultRemoveOneFromCartUseCase() as RemoveOneFromCartUseCase }
            Module { DefaultRemoveWholeItemFromCartUseCase() as RemoveWholeItemFromCartUseCase }
            Module { DefaultAddToFavouritesUseCase() as AddToFavouritesUseCase }
            Module { DefaultFetchFavouriteItemsUseCase() as FetchFavouriteItemsUseCase }
            Module { DefaultRemoveFromFavouritesUseCase() as RemoveFromFavouritesUseCase }
        }
    }
}
