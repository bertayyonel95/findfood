//
//  LoginRouter.swift
//  findfood
//
//  Created by Bertay Yönel on 24.07.2023.
//

import UIKit

protocol LoginRouting {
    func navigateToLogin(_ view: UIViewController)
}

class LoginRouter: LoginRouting {
    private lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    
    func navigateToLogin(_ view: UIViewController) {
        let loginViewModel = LoginViewModel()
        let loginVC = LogInController(viewModel: loginViewModel)
        self.slideInTransitioningDelegate.direction = .bottom
        loginVC.transitioningDelegate = self.slideInTransitioningDelegate
        loginVC.modalPresentationStyle = .custom
        view.present(loginVC, animated: true)
    }
}
