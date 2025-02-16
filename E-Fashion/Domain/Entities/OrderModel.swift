//
//  OrderModel.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

import Foundation

public struct OrderModel: Codable, Identifiable {
    public let id: String
    let timeStamp: Date
    let price: Double
    let deliveryFee: Double
    let totalPrice: Double
    let items: [ProductInCart]
    let deliveryProvider: DeliveryProviders
    let status: OrderStatus
    
    public init(price: Double, deliveryFee: Double, totalPrice: Double, items: [ProductInCart], deliveryProvider: DeliveryProviders, status: OrderStatus) {
        self.id = UUID().uuidString
        self.timeStamp = Date()
        self.price = price
        self.deliveryFee = deliveryFee
        self.totalPrice = totalPrice
        self.items = items
        self.deliveryProvider = deliveryProvider
        self.status = status
    }
}
