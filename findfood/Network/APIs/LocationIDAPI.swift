//
//  LocationIDAPI.swift
//  findfood
//
//  Created by Bertay Yönel on 13.07.2023.
//

import Foundation

protocol LocationIDFetchable {
    func retrieveByLocationID(request: LocationIDRequestModel, completion: @escaping (Result<LocationModel, APIError>) -> Void)
}

final class LocationIDAPI: LocationIDFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByLocationID(request: LocationIDRequestModel, completion: @escaping (Result<LocationModel, APIError>) -> Void) {
        networkManager.requestWithLocationID(request: request, completion: completion)
    }
}
