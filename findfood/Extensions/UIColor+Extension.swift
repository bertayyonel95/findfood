//
//  UIColor+Extension.swift
//  findfood
//
//  Created by Bertay Yönel on 15.03.2023.
//

import UIKit

extension UIColor {
    static var customBackgroundColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor.black :
            UIColor.white
        }
    }
    static var customTextColor: UIColor {
        return UIColor { (traits) -> UIColor in
            return traits.userInterfaceStyle == .dark ?
            UIColor.white :
            UIColor.black
        }
    }
}
