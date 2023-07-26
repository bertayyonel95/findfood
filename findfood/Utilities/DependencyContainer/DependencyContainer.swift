//
//  DependencyContainer.swift
//  findfood
//
//  Created by Bertay Yönel on 24.07.2023.
//

import Foundation

class DependencyContainer {
    static let shared = DependencyContainer()
    private init() {}
    
    func networkManager() -> Networking {
        return NetworkManager(session: .shared)
    }
    
    func cityNameAPI() -> CityNameFetchable {
        return CityNameAPI(networkManager: self.networkManager())
    }
    
    func coordinateAPI() -> CoordinateFetchable {
        return CoordinateAPI(networkManager: self.networkManager())
    }
    
    func locationIDAPI() -> LocationIDFetchable {
        return LocationIDAPI(networkManager: self.networkManager())
    }
    
    func geoLocationManager() -> GeoLocationManager {
        return GeoLocationManager()
    }
}
