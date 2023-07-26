//
//  SideMenuViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 26.07.2023.
//

import Foundation

// MARK: - LoginViewModelInput
protocol SideMenuViewModelInput {
    // MARK: Properties
    func loginPressed()
    var output: SideMenuViewModelOutput? { get set }
}
// MARK: - LoginViewModelOutput
protocol SideMenuViewModelOutput: AnyObject {
    func showErrorMessage(errorMessage: String)
}

// MARK: - LoginViewModel
final class SideMenuViewModel: SideMenuViewModelInput {
    var output: SideMenuViewModelOutput?
    private var sideMenuRouter: SideMenuRouting
    
    init(sideMenuRouter: SideMenuRouting) {
        self.sideMenuRouter = sideMenuRouter
    }
    
    func loginPressed() {
        sideMenuRouter.navigateToLogin()
    }
    
}
