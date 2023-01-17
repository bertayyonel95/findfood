//
//  LocationManager.swift
//  findfood
//
//  Created by Bertay Yönel on 14.01.2023.
//

import Foundation
import CoreLocation

protocol GeoLocationManagerDelegate {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocationModel )
}

class GeoLocationManager: NSObject {

    var delegate: HomeViewModel?
    private var locationManager: CLLocationManager?
    
    static let shared: GeoLocationManager = {
        let instance = GeoLocationManager()
        return instance
    }()
    
    override init() {
        super.init()
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
    
}

extension GeoLocationManager {
    func requestAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
}

extension GeoLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoLocationModel = GeoLocationModel(lat: manager.location?.coordinate.latitude ?? .zero, lon: manager.location?.coordinate.longitude ?? .zero)
        self.delegate?.didUpdateLocation(self, geoLocationModel)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("test error: \(error)")
    }
}

extension GeoLocationManager {
    func hasLocationPermission() -> Bool {
        var hasPermission = false
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                break
            }
        } else {
            hasPermission = false
        }
        return hasPermission
    }
}
