//
//  OrderStatus.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 13.02.25.
//

public enum OrderStatus: String, Codable {
    case delivered
    case cancelled
    case proccessing
    
    var name: String {
        switch self {
        case .delivered:
            return "Delivered"
        case .cancelled:
            return "Canceled"
        case .proccessing:
            return "Proccessing"
        }
    }
}
