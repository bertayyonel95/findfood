//
//  HomeRouter.swift
//  findfood
//
//  Created by Bertay Yönel on 25.07.2023.
//

import UIKit

protocol HomeRouting {
    func navigateToLogin()
    func navigateToSideMenu()
    func navigateToUserMenu()
    var homeController: HomeController? { get set }
}

class HomeRouter: HomeRouting {
    private var slideInTransitioningDelegate = SlideInPresentationManager()
    var homeController: HomeController?
    
    func navigateToLogin() {
        let loginVC = LoginBuilder.build()
        self.slideInTransitioningDelegate.direction = .bottom
        loginVC.transitioningDelegate = slideInTransitioningDelegate
        loginVC.modalPresentationStyle = .custom
        homeController?.present(loginVC, animated: true)
    }
    
    func navigateToSideMenu() {
        let sideMenuVC = SideMenuBuilder.build()
        slideInTransitioningDelegate.direction = .left
        sideMenuVC.transitioningDelegate = slideInTransitioningDelegate
        sideMenuVC.modalPresentationStyle = .custom
        homeController?.present(sideMenuVC, animated: true, completion: nil)
    }
    
    func navigateToUserMenu() {
        let userMenuVC = UserMenuViewController()
        slideInTransitioningDelegate.direction = .left
        userMenuVC.transitioningDelegate = slideInTransitioningDelegate
        userMenuVC.modalPresentationStyle = .custom
        homeController?.present(userMenuVC, animated: true, completion: nil)
    }
    
    func setHomeController(with homeController: HomeController) {
        self.homeController = homeController
    }
}
