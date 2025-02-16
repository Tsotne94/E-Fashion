//
//  AssetsEnums.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 16.01.25.
//

enum Icons {
    static let addButton = "addButton"
    static let back = "back"
    static let cartBadge = "cartBage"
    static let cross = "cross"
    static let dualColumn = "dualColumn"
    static let filter = "filter"
    static let heart = "customHeart"
    static let heartFilled = "heartSelected"
    static let mail = "Mail"
    static let masterCard = "mastercard"
    static let visa = "Visa"
    static let amex = "Amex"
    static let card = "creditCard"
    static let pencil = "pencil"
    static let rectangle2 = "Rectangle 2"
    static let rectangle3 = "Rectangle 3"
    static let search = "search"
    static let selectableBox = "selectableBox"
    static let selectedBlack = "selectedBlack"
    static let selectedRed = "selectedRed"
    static let sendArrow = "sendArrow"
    static let share = "share"
    static let singleColumn = "singleColumn"
    static let sort = "sort"
    static let successfulPurchase = "successfullPurchase"
    static let eye = "eye"
    static let eyeSlashed = "eye.slash"
    static let banner = "banner"
    static let chip = "chip"
    static let smallRedHeart = "smallHeart"
}

enum GreetingImages {
    static let firstGreeting = "firstGreeting"
    static let secondGreeting = "secondGreeting"
    static let thirdGreeting = "thirdGreeting"
}

enum LoginSignup {
    static let apple = "apple"
    static let eye = "eye"
    static let facebook = "facebook"
    static let google = "google"
    static let lock = "lock"
    static let user = "user"
}

enum TabBar {
    static let bag = "bag"
    static let cart = "shopping_cart"
    static let favourites = "heart"
    static let home = "home"
    static let profile = "account_circle"
    
    static let bagSelected = "bagSelected"
    static let cartSelected = "cartSelected"
    static let favouritesSelected = "heartSelected"
    static let homeSelected = "homeSelected"
    static let profileSelected = "profileSellected"
}

enum KidsAssets {
    static let accessories = "kidAccessories"
    static let clothes = "kidClothes"
    static let new = "kidNew"
    static let shoes = "kidShoes"
}

enum MenAssets {
    static let accessories = "manAccessories"
    static let clothes = "manClothes"
    static let new = "manNew"
    static let shoes = "manShoes"
}

enum WomenAssets {
    static let accessories = "womanAccessories"
    static let clothes = "womanClothes"
    static let new = "womanNew"
    static let shoes = "womanShoes"
}

public enum DeliveryProviders: String, Codable, CaseIterable {
    case dhl = "dhl"
    case usps = "usps"
    case fedex = "fedex"
    
    func price() -> Double {
        switch self {
        case .dhl:
            5.99
        case .usps:
            8.99
        case .fedex:
            15.99
        }
    }
    
    func deliveryTime() -> String {
        switch self {
        case .dhl:
            "5-6 Days"
        case .usps:
            "3-4 Days"
        case .fedex:
            "1-2 Days"
        }
    }
}
