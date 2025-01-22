//
//  ReuseIdentifiable.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

protocol IdentifiableProtocol {
    static var reuseIdentifier: String { get }
}

extension IdentifiableProtocol {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}
