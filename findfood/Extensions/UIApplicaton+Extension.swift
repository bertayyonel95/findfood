//
//  UIApplicaton+Extension.swift
//  findfood
//
//  Created by Bertay Yönel on 12.06.2023.
//

import UIKit

extension UIApplication {
    var isKeyboardPresented: Bool {
        if let keyboardWindowClass = NSClassFromString("UIRemoteKeyboardWindow"), self.windows.contains(where: { $0.isKind(of: keyboardWindowClass) }) {
            return true
        } else {
            return false
        }
    }
}
