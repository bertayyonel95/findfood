//
//  UIColor+Extension.swift
//  findfood
//
//  Created by Bertay Yönel on 15.03.2023.
//

import UIKit

extension UIColor {
    static var customBackgroundColor: UIColor {
        UIColor(named: "CustomBackground") ?? .white
    }
    
    static var customLabelColor: UIColor {
        UIColor(named: "CustomLabel") ?? .black
    }
    
    static var customSecondaryBackgroundColor: UIColor {
        UIColor(named: "CustomSecondaryBackground") ?? .gray
    }
}
