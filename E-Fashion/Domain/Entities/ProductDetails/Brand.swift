//
//  Brand.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

struct Brand: Codable {
    let brandId: Int
    let name: String?
    let favourites: Int
    let itemCount: Int
    let luxury: Bool
    let url: String
}
