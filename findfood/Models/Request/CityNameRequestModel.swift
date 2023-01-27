//
//  CityNameRequestModel.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation

final class CityNameRequestModel: RequestModel {
    
    private let cityName: String
    
    init(cityName: String) {
        self.cityName = cityName
    }
    
    override var parameters: [String : Any?] {
        [
            "location": String(self.cityName)
        ]
    }
}
