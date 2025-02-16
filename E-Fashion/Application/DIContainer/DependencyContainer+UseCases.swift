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
            Module { DefaultRemoveWholeItemFromCartUseCase() as RemoveWholeItemFromCartUseCase }
            Module { DefaultAddToFavouritesUseCase() as AddToFavouritesUseCase }
            Module { DefaultFetchFavouriteItemsUseCase() as FetchFavouriteItemsUseCase }
            Module { DefaultRemoveFromFavouritesUseCase() as RemoveFromFavouritesUseCase }
            Module { DefaultIsFavouriteUseCase() as IsFavouriteUseCase }
            Module { DefaultIsInCartUseCase() as IsInCartUseCase }
            Module { DefaultAddAddressUseCase() as AddAddressUseCase }
            Module { DefaultFetchDeliveryAddressUseCase() as FetchDeliveryAddressUseCase }
            Module { DefaultAddAddressUseCase() as AddAddressUseCase }
            Module { DefaultRemoveAddressUseCase() as RemoveAddressUseCase }
            Module { DefaultUpdateDefaultAddressUseCase() as UpdateDefaultAddressUseCase }
            Module { DefaultAddPaymentMethodUseCase() as AddPaymentMethodUseCase }
            Module { DefaultFetchPaymentMethodsUseCase() as FetchPaymentMethodsUseCase }
            Module { DefaultRemovePaymentMethodUseCase() as RemovePaymentMethodUseCase }
            Module { DefaultUpdateDefaultPaymentMethodUseCase() as UpdateDefaultPaymentMethodUseCase }
            Module { DefaultFetchDefaultDelieryLocationUseCase() as FetchDefaultDelieryLocationUseCase }
            Module { DefaultFetchDefaultPaymentMethodUseCase() as FetchDefaultPaymentMethodUseCase }
            Module { DefaultClearCartUseCase() as ClearCartUseCase }
            Module { DefaultUpdateUserInfoUseCase() as UpdateUserInfoUseCase }
            Module { DefaultFetchUserInfoUseCase() as FetchUserInfoUseCase }
            Module { DefaultUploadProfilePictureUseCase() as UploadProfilePictureUseCase }
            Module { DefaultSignOutUseCase() as SignOutUseCase }
            Module { DefaultFetchOrdersUseCase() as FetchOrdersUseCase }
            Module { DefaultPlaceOrderUseCase() as PlaceOrderUseCase }
            Module { DefaultFetchSingleOrderUseCase() as FetchSingleOrderUseCase }
        }
    }
}
