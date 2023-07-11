//
//  LocationManager.swift
//  findfood
//
//  Created by Bertay Yönel on 14.01.2023.
//

import Foundation
import CoreLocation
// MARK: - GeoLocationManagerDelegate
protocol GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocationModel )
}
// MARK: - GeoLocationManager
class GeoLocationManager: NSObject {
    // MARK: Properties
    var delegate: HomeViewModel?
    private var locationManager: CLLocationManager?
    // MARK: Singleton Declaration
    static let shared: GeoLocationManager = {
        let instance = GeoLocationManager()
        return instance
    }()
    // MARK: init
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
}
// MARK: - GeoLocationManager extension for Functions
extension GeoLocationManager {
    // MARK: Functions
    /// Request location authorization from the user.
    func requestAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    /// Request the current location of the user.
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
}
// MARK: - GeoLocationManager extension for CLLocationManagerDelegate
extension GeoLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoLocationModel = GeoLocationModel(lat: manager.location?.coordinate.latitude ?? .zero, lon: manager.location?.coordinate.longitude ?? .zero)
        self.delegate?.didUpdateLocation(self, geoLocationModel)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
}
