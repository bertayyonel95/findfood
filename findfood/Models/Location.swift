//
//  LocationModel.swift
//  findfood
//
//  Created by Bertay Yönel on 13.12.2022.
//
// swiftlint:disable identifier_name
import Foundation

struct Location {
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
        URL(string: locatinImageLink)
    }
}

extension Location {
    // MARK: init
    init(with locationData: LocationData) {
        self.locationID = locationData.id
        self.locationName = locationData.name ?? .empty
        self.locationRating = String(locationData.rating ?? .zero)
        self.locatinImageLink = locationData.imageUrl ?? .empty
        self.locationPrice = locationData.price ?? .empty
        self.locationCategories = locationData.categories ?? []
        self.display_phone = locationData.displayPhone ?? .empty
        self.display_address = locationData.location?.displayAddress ?? []
    }
}
