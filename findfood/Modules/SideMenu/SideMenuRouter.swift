//
//  SideMenuRouter.swift
//  findfood
//
//  Created by Bertay Yönel on 26.07.2023.
//

import Foundation

import UIKit

protocol SideMenuRouting {
    func navigateToLogin()
    var sideMenuController: SideMenuController? { get set }
}

class SideMenuRouter: SideMenuRouting {
    private var slideInTransitioningDelegate = SlideInPresentationManager()
    var sideMenuController: SideMenuController?
    
    func navigateToLogin() {
        let loginVC = LoginBuilder.build()
        self.slideInTransitioningDelegate.direction = .bottom
        loginVC.transitioningDelegate = slideInTransitioningDelegate
        loginVC.modalPresentationStyle = .custom
        sideMenuController?.present(loginVC, animated: true)
    }
    
    func setSideMenuController(with sideMenuController: SideMenuController) {
        self.sideMenuController = sideMenuController
    }
}
