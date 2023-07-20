//
//  CoordinateAPI.swift
//  findfood
//
//  Created by Bertay Yönel on 27.01.2023.
//

import Foundation

protocol CoordinateFetchable {
    func retrieveByCoordinate(request: CoordinateRequestModel, completion: @escaping (Result<[LocationModel], APIError>) -> Void)
}

final class CoordinateAPI: CoordinateFetchable {
    private let networkManager: Networking
    
    init(networkManager: Networking) {
        self.networkManager = networkManager
    }
    
    func retrieveByCoordinate(request: CoordinateRequestModel, completion: @escaping (Result<[LocationModel], APIError>) -> Void) {
        networkManager.request(request: request, completion: completion)
    }
}
