//
//  CoordinateRequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation
import CoreLocation

final class CoordinateRequestModel: RequestModel {
    
    private let lat: CLLocationDegrees
    private let lon: CLLocationDegrees
    
    init(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.lon = lon
        self.lat = lat
    }
    
    override var parameters: [String : Any?] {
        [
            "latitude": String(format: "%.2f", self.lat),
            "longitude": String(format: "%.2f", self.lon)
        ]
    }
}
