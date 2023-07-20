//
//  ActionButtonType.swift
//  findfood
//
//  Created by Bertay Yönel on 15.07.2023.
//

import Foundation

enum ActionButtonType: Int {
    case login
    case cancel
    case confirm
}

extension ActionButtonType {
    var buttonTitle: String {
        switch self {
        case .cancel:
            return "Cancel"
        case .login:
            return "Login"
        case .confirm:
            return "Confirm"
        }
    }
}
