//
//  LocatinIDRequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 13.07.2023.
//

import Foundation
import CoreLocation

final class LocationIDRequest: RequestModel {
    // MARK: - Properties
    override var parameters: [String: Any?] {
        var parameters = super.parameters
        parameters = [:]
        return parameters
    }
    // MARK: - init
    init(locationID: String) {
        super.init()
        super.locationID = locationID
    }
}
