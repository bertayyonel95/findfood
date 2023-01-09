//
//  LocationModel.swift
//  findfood
//
//  Created by Bertay Yönel on 13.12.2022.
//

import Foundation

struct LocationModel {
    let locationID: String
    let locationName: String
    let locationRating: String
    let locatinImageLink: String
    let locationPrice: String
    let locationCategories: [LocationCategory]
    let display_phone: String
    let display_address: [String]
    
    var locationImageURL: URL?{
        if let locationImageURL = URL(string: locatinImageLink) {
            return locationImageURL
        } else {
            return nil
        }
    }
}
