//
//  UIResponder+Extensions.swift
//  findfood
//
//  Created by Bertay Yönel on 7.06.2023.
//

import UIKit

extension UIResponder {
    private struct Static {
        static weak var responder: UIResponder?
    }
    
    static func currentFirst() -> UIResponder? {
        Static.responder = nil
        UIApplication.shared.sendAction(#selector(UIResponder.fTrap), to: nil, from: nil, for: nil)
        return Static.responder
    }
    
    @objc func fTrap() {
        Static.responder = self
    }
}
