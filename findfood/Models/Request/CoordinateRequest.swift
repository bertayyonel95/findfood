//
//  CoordinateRequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation
import CoreLocation

final class CoordinateRequest: RequestModel {
    // MARK: - Properties
    private let lat: CLLocationDegrees
    private let lon: CLLocationDegrees
    
    // MARK: - init
    init(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        self.lon = lon
        self.lat = lat
    }
    
    override var parameters: [String : Any?] {
        var parameters = super.parameters
        parameters["latitude"] = String(format: "%.2f", self.lat)
        parameters["longitude"] = String(format: "%.2f", self.lon)
        return parameters
    }
}
