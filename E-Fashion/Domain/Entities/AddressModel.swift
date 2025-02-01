//
//  AddressModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

import Foundation

public struct AddressModel: Codable, Equatable, Hashable {
    let id: String
    let timestamp: Date
    let name: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let country: String
    let isDefault: Bool
    
    init(name: String, address: String, city: String, state: String, zip: String, country: String, isDefault: Bool) {
        self.id = UUID().uuidString
        self.timestamp = Date()
        self.name = name
        self.address = address
        self.city = city
        self.state = state
        self.zip = zip
        self.country = country
        self.isDefault = isDefault
    }
}
