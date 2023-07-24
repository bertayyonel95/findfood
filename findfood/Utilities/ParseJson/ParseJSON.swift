//
//  ParseJSON.swift
//  findfood
//
//  Created by Bertay Yönel on 22.07.2023.
//

import Foundation

class ParseJSON<T: Decodable> {
    func parseJSON(data: Data) throws -> T {
        let decoder = JSONDecoder()
        do {
            let parsedObject = try decoder.decode(T.self, from: data)
            return parsedObject
        } catch {
            throw JSONParsingError.decodingFailed
        }
    }
}
