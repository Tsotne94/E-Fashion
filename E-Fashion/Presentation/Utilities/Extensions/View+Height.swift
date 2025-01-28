//
//  View+Height.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 28.01.25.
//

import SwiftUI

extension View {
    static func headerHeight() -> CGFloat {
        UIScreen.main.bounds.height > 667 ? 100 : 60
    }
}
