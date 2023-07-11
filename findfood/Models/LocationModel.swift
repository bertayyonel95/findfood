//
//  LocationModel.swift
//  findfood
//
//  Created by Bertay Yönel on 13.12.2022.
//
// swiftlint:disable identifier_name
import Foundation

struct LocationModel {
    // MARK: Properties
    let locationID: String
    let locationName: String
    let locationRating: String
    let locatinImageLink: String
    let locationPrice: String
    let locationCategories: [LocationCategory]
    let display_phone: String
    let display_address: [String]
    var locationImageURL: URL? {
        if let locationImageURL = URL(string: locatinImageLink) {
            return locationImageURL
        } else {
            return nil
        }
    }
}

extension LocationModel {
    // MARK: init
    init(with locationData: LocationData) {
        self.locationID = locationData.id
        self.locationName = locationData.name
        self.locationRating = String(locationData.rating ?? .zero)
        self.locatinImageLink = locationData.image_url
        self.locationPrice = locationData.price ?? ""
        self.locationCategories = locationData.categories
        self.display_phone = locationData.display_phone
        self.display_address = locationData.location.display_address ?? []
    }
}
