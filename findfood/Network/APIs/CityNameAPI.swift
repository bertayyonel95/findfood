//
//  CityNameAPI.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation

protocol CityNameFetchable {
    func retrieveByCityName(request: CityNameRequest, completion: @escaping (Result<Business, APIError>) -> Void)
}

final class CityNameAPI: CityNameFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByCityName(request: CityNameRequest, completion: @escaping (Result<Business, APIError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
