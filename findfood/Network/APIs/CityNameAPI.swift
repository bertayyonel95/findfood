//
//  CityNameAPI.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation

protocol CityNameFetchable {
    func retrieveByCityName(request: CityNameRequestModel, completion: @escaping (Result<[LocationModel], APIError>) -> Void)
}

final class CityNameAPI: CityNameFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByCityName(request: CityNameRequestModel, completion: @escaping (Result<[LocationModel], APIError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
