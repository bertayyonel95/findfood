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
    ///
    /// - Parameters:
    ///    - errorMessage: view controller that the alert will be presented.
    ///    - in: view in which the alert will be shown.
    ///    - with: title of the alert window.
    ///    - actionType: an array with possible types of actions. (see ActionButtonType for more deatils)
    func show(errorMessage: String, in viewController: UIViewController, with title: String, actionType: [ActionButtonType]) {
        let alert = UIAlertController(title: title, message: errorMessage, preferredStyle: .alert)
        actionType.forEach { action in
            let buttonAction = UIAlertAction(
                title: action.buttonTitle,
                style: action == .cancel ? .cancel : .default) { _ in
                action == .cancel ? self.cancelButtonHandler?() : self.confirmButtonHandler?()
            }
            alert.addAction(buttonAction)
        }
        viewController.present(alert, animated: true, completion: nil)
    }
}
