//
//  CityNameRequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation

final class CityNameRequest: RequestModel {
    // MARK: - Properties
    private let cityName: String
    
    init(cityName: String) {
        self.cityName = cityName
    }
    
    override var parameters: [String: Any?] {
        var parameters = super.parameters
        parameters["location"] = String(self.cityName)
        return parameters
    }
}
