//
//  MappableError.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//

import Foundation

public protocol MappableError: Error, CustomStringConvertible, Equatable {
    static func mapError(_ code: Int, message: String) -> Self
}
