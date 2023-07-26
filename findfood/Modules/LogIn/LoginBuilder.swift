//
//  LoginBuilder.swift
//  findfood
//
//  Created by Bertay Yönel on 25.07.2023.
//

import Foundation

class LoginBuilder {
    static func build() -> LogInController {
        let loginViewModel = LoginViewModel()
        return LogInController(viewModel: loginViewModel)
    }
}
