//
//  HomeBuilder.swift
//  findfood
//
//  Created by Bertay Yönel on 24.07.2023.
//

import Foundation

class HomeBuilder {
    static func build() -> HomeController {
        let dependencyContainer = DependencyContainer.shared
        let homeRouter = HomeRouter()
        let homeViewModel = HomeViewModel(
            cityNameAPI: dependencyContainer.cityNameAPI(),
            coordinateAPI: dependencyContainer.coordinateAPI(),
            geoLocationManager: dependencyContainer.geoLocationManager(),
            locationIDAPI: dependencyContainer.locationIDAPI(),
            homeRouter: homeRouter
        )
        let homeController = HomeController(viewModel: homeViewModel)
        homeRouter.homeController = homeController
        return homeController
    }
}
