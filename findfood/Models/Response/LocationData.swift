//
//  Business.swift
//  findfood
//
//  Created by Bertay Yönel on 13.12.2022.
//
// swiftlint:disable identifier_name

import Foundation

struct Business: Decodable {
    let businesses: [LocationData]
    let total: Int
}

struct LocationData: Decodable {
    let id: String
    let name: String?
    let imageUrl: String?
    let rating: Double?
    let categories: [LocationCategory]?
    let price: String?
    let displayPhone: String?
    let location: LocationAddress?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case imageUrl = "image_url"
        case rating
        case categories
        case price
        case displayPhone = "display_phone"
        case location
    }
}

struct LocationCategory: Decodable {
    let alias: String
    let title: String
}

struct LocationAddress: Decodable {
    let displayAddress: [String]?
    
    enum CodingKeys: String, CodingKey {
        case displayAddress = "display_address"
    }
}
