//
//  LocationManager.swift
//  findfood
//
//  Created by Bertay Yönel on 14.01.2023.
//
import CoreLocation
import Foundation

// MARK: - GeoLocationManagerDelegate
protocol GeoLocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ geoLocationManager: GeoLocationManager, _ geoLocation: GeoLocation )
}
// MARK: - GeoLocationManager
class GeoLocationManager: NSObject {
    // MARK: Properties
    weak var delegate: GeoLocationManagerDelegate?
    
    private var locationManager: CLLocationManager?
    static let shard = GeoLocationManager()
    
    // MARK: init
    override init() {
        super.init()
        
        locationManager = CLLocationManager()
        locationManager?.delegate = self
    }
}
// MARK: - GeoLocationManager extension for Functions
extension GeoLocationManager {
    // MARK: Helpers
    /// Request location authorization from the user.
    func requestAuthorization() {
        locationManager?.requestAlwaysAuthorization()
    }
    /// Request the current location of the user.
    func requestCurrentLocation() {
        locationManager?.requestLocation()
    }
}
// MARK: - CLLocationManagerDelegate
extension GeoLocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let geoLocationModel = GeoLocation(lat: manager.location?.coordinate.latitude ?? .zero, lon: manager.location?.coordinate.longitude ?? .zero)
        self.delegate?.didUpdateLocation(self, geoLocationModel)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // TODO: - implement authorization change
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // TODO: - implement 
    }
}
