//
//  DetailSeller.swift
//  E-Fashion
//
//  Created by Cotne Chubinidze on 21.01.25.
//

struct DetailSeller: Codable {
    let userId: Int
    let username: String
    let name: String?
    let birthday: String?
    let country: String
    let url: String
    let about: String?
    let image: String?
    let contacts: String?
    let gender: String?
    let itemCount: Int
    let followers: Int
    let following: Int
    let feedback: Feedback?
    let banned: Bool
    let online: Bool
    let lastSeen: String
    let bundleDiscounts: [BundleDiscount]?
}
