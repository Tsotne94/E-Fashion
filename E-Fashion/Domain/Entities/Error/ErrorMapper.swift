//
//  ErrorMapper.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 19.01.25.
//
import Foundation

public struct ErrorMapper {
    public static func map<T: MappableError>(_ error: Error) -> T {
        guard let nsError = error as? NSError else {
            return T.mapError(-1, message: "An unexpected error occurred.")
        }

        let message = nsError.localizedDescription
        return T.mapError(nsError.code, message: message)
    }
}
