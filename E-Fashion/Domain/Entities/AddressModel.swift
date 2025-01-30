//
//  AddressModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

struct AddressModel: Codable {
    let name: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let country: String
    let isDefault: Bool
}
