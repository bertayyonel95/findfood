//
//  Business.swift
//  findfood
//
//  Created by Bertay Yönel on 13.12.2022.
//

import Foundation

struct Business: Decodable {
    let businesses: [LocationData]
}

struct LocationData: Decodable {
    let id: String
    let name: String
    let image_url: String
    let rating: Double?
    let categories : [LocationCategory]
    let price: String?
    let display_phone: String
    let location: LocationAddress
}

struct LocationCategory: Decodable {
    let alias: String
    let title: String
}

struct LocationAddress: Decodable {
    let display_address: [String]?
}
