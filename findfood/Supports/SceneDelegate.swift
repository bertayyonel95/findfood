//
//  SceneDelegate.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import CoreLocation
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        FirebaseApp.configure()
        
//        let networkManager = NetworkManager(session: .shared)
//        let cityNameAPI = CityNameAPI(networkManager: networkManager)
//        let coordinateAPI = CoordinateAPI(networkManager: networkManager)
//        let locationIDAPI = LocationIDAPI(networkManager: networkManager)
//
//        let geoLocationManager = GeoLocationManager()
//
//        let homeViewModel = HomeViewModel(cityNameAPI: cityNameAPI, coordinateAPI: coordinateAPI, geoLocationManager: geoLocationManager, locationIDAPI: locationIDAPI)
        let homeController = HomeBuilder.build()
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: homeController)
        window?.makeKeyAndVisible()
    }
}
