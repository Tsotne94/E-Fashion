//
//  ParameterItem.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 20.01.25.
//

protocol ParameterItem: Codable, Identifiable {
    var id: Int { get }
    var title: String { get }
}
