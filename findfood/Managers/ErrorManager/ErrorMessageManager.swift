//
//  ErrorManager.swift
//  findfood
//
//  Created by Bertay Yönel on 7.07.2023.
//

import Foundation
import UIKit
// MARK: - ErrorMessageManager
final class ErrorMessageManager {
    // MARK: Singleton Decleration
    static let shared = ErrorMessageManager()
    private init() {
    }
}
// MARK: ErrorMessageManager Extension
extension ErrorMessageManager {
    // MARK: Functions
    /// Presents an alert view on the current view controller with given actions and message.
    /// Always adds default "cancel" action.
    ///
    /// - Parameters:
    ///    - viewController: view controller that the alert will be presented.
    ///    - title: alert window title to be shown.
    ///    - actions: UIAlertAction array that adds custom actions to the error message
    func showErrorMessage(in viewController: UIViewController, title: String, errorMessage: String, actions: [UIAlertAction]){
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        if !actions.isEmpty {
            for action in actions {
                alert.addAction(action)
            }
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        viewController.present(alert, animated: true, completion: nil)
    }
}
