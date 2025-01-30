//
//  String+CardNumberFormatting.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 30.01.25.
//

extension String {
    func formatCardNumber() -> String {
        let cleaned = self.replacingOccurrences(of: " ", with: "")
        var result = ""
        for (index, char) in cleaned.enumerated() {
            if index > 0 && index % 4 == 0 {
                result += " "
            }
            result += String(char)
        }
        return result
    }
    
    func secureCardNumber() -> String {
        let cleaned = self.replacingOccurrences(of: " ", with: "")
        let last4 = String(cleaned.suffix(4))
        return "•••• •••• •••• \(last4)"
    }
}
