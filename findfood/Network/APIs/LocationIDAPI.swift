//
//  LocationIDAPI.swift
//  findfood
//
//  Created by Bertay Yönel on 13.07.2023.
//

import Foundation

protocol LocationIDFetchable {
    func retrieveByLocationID(request: LocationIDRequest, completion: @escaping (Result<Location, APIError>) -> Void)
}

final class LocationIDAPI: LocationIDFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByLocationID(request: LocationIDRequest, completion: @escaping (Result<Location, APIError>) -> Void) {
        networkManager.requestWithLocationID(request: request, completion: completion)
    }
}
