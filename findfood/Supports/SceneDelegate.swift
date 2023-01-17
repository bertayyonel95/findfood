//
//  SceneDelegate.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import UIKit
import CoreLocation

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        
        let networkManager = NetworkManager(session: .shared)
        let geoLocationManager = GeoLocationManager()

        let homeViewModel = HomeViewModel(networkManager: networkManager, geoLocationManager: geoLocationManager)
        let homeController = HomeController(viewModel: homeViewModel)
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = UINavigationController(rootViewController: homeController)
        window?.makeKeyAndVisible()
    }
}
