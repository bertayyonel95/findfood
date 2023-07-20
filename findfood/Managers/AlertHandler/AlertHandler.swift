//
//  ErrorManager.swift
//  findfood
//
//  Created by Bertay Yönel on 7.07.2023.
//

import Foundation
import UIKit

// MARK: - ErrorMessageManager
final class AlertHandler {
    
    // MARK: Typealias
    typealias ConfirmButtonHandler = () -> Void
    typealias CancelButtonHandler = () -> Void
    
    // MARK: Properties
    static let shared = AlertHandler()
    var confirmButtonHandler: ConfirmButtonHandler?
    var loginButtonHandler: ConfirmButtonHandler?
    var cancelButtonHandler: CancelButtonHandler?
    
    // MARK: Init
    private init() {
    }
}

// MARK: - Helpers
extension AlertHandler {
    
    // MARK: Helpers
    /// Presents an alert view on the current view controller with given actions and message.
    /// Always adds default "cancel" action.
    ///
    /// - Parameters:
    ///    - viewController: view controller that the alert will be presented.
    ///    - title: alert window title to be shown.
    ///    - actions: UIAlertAction array that adds custom actions to the error message

    func show(errorMessage: String, in viewController: UIViewController, with title: String, actionType: [ActionButtonType]) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        
        actionType.forEach { action in
            let buttonAction = UIAlertAction(
                title: action.buttonTitle,
                style: action == .cancel ? .destructive : .default) { _ in
                action == .cancel ? self.cancelButtonHandler?() : self.confirmButtonHandler?()
            }
            alert.addAction(buttonAction)
        }
        
        // Present the alert controller
        viewController.present(alert, animated: true, completion: nil)
    }
}
