//
//  JSONParsingError.swift
//  findfood
//
//  Created by Bertay Yönel on 22.07.2023.
//

import Foundation

enum JSONParsingError: Error {
    case invalidData
    case decodingFailed
}
