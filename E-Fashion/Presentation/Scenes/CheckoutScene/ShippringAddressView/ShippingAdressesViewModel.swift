//
//  ShippingAdressesViewModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Combine

protocol ShippingAdressesViewModel {
}

protocol ShippingAdressesViewModelInput {
    
}

protocol ShippingAdressesViewModelOutput {
    
}

enum ShippingAdressesViewModelOutputAction {
    case shippingAddressesFetched
    case shippingAddressAdded
    case shippingAddressRemoved
    case newDefaultAddress
}

