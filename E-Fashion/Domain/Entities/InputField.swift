//
//  InputField.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 18.01.25.
//
import Foundation

enum InputField: Hashable, Equatable {
    case name
    case email
    case password
    
    var labelWidth: CGFloat {
        switch self {
        case .email: return 60
        case .password: return 95
        case .name: return 60
        }
    }
}
