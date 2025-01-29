//
//  CustomHeaderView+Height.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 25.01.25.
//

import Foundation
import UIKit

extension CustomHeaderView {
    static func headerHeight() -> CGFloat {
        return UIScreen.main.bounds.height > 667 ? 100 : 60
    }
}
