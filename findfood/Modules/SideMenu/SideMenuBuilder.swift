//
//  SideMenuBuilder.swift
//  findfood
//
//  Created by Bertay Yönel on 25.07.2023.
//

import Foundation

class SideMenuBuilder {
    static func build() -> SideMenuController {
        let sideMenuRouter = SideMenuRouter()
        let sideMenuViewModel = SideMenuViewModel(sideMenuRouter: sideMenuRouter)
        let sideMenuController = SideMenuController(viewModel: sideMenuViewModel)
        sideMenuRouter.sideMenuController = sideMenuController
        return sideMenuController
    }
}
