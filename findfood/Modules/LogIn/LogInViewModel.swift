//
//  LogInViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 18.03.2023.
//
// swiftlint:disable identifier_name

import Foundation
// MARK: - LoginViewModelInput
protocol LoginViewModelInput {
    // MARK: Properties
    var output: LoginViewModelOutput? { get set }
    func logInUser(email: String, password: String)
    func registerUser(email: String, password: String)
}
// MARK: - LoginViewModelOutput
protocol LoginViewModelOutput: AnyObject {
    func popController()
    func showErrorMessage(errorMessage: String)
}
// MARK: - LoginViewModel
final class LoginViewModel: LoginViewModelInput {
    // MARK: Properties
    weak var output: LoginViewModelOutput?
    // MARK: init
    init() {
        FirebaseManager.shared.delegate = self
    }
    // MARK: Helpers
    func logInUser(email: String, password: String) {
        FirebaseManager.shared.userSignIn(withEmail: email, withPassword: password)
    }
    
    func registerUser(email: String, password: String) {
        FirebaseManager.shared.userSignUp(withEmail: email, withPassword: password)
    }
    
}
// MARK: - FirebaseAuthManagerDelegate
extension LoginViewModel: FirebaseAuthManagerDelegate {
    func Firebase(_ manager: FirebaseManager, didCompleteWith: Bool, error: Error?) {
        if error != nil {
            self.output?.showErrorMessage(errorMessage: error?.localizedDescription ?? .empty)
            return
        }
        output?.popController()
    }
}
