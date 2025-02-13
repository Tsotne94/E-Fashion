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
    let price: Int
    let deliveryFee: Int
    let totalPrice: Int
    let items: [ProductDetails]
    let deliveryProvider: DeliveryProviders
    let status: OrderStatus
    
    public init(price: Int, deliveryFee: Int, totalPrice: Int, items: [ProductDetails], deliveryProvider: DeliveryProviders, status: OrderStatus) {
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
