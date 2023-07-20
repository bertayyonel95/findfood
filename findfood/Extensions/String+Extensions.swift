//
//  String+Extensions.swift
//  findfood
//
//  Created by Bertay Yönel on 3.01.2023.
//

import Foundation



extension String {
    func urlEncoded(denying deniedCharacters: CharacterSet = .urlDenied) -> String? {
        return addingPercentEncoding(withAllowedCharacters: deniedCharacters.inverted())
    }
    static var empty: String {
        ""
    }
}
