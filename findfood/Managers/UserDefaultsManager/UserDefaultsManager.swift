//
//  UserDefaultsManager.swift
//  findfood
//
//  Created by Bertay Yönel on 31.01.2023.
//

import Foundation

protocol ObjectSaveable {
    func setObject<Object>(_ object: Object, forKey: String) throws where Object: Encodable
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object: Decodable
}

class UserDefaultsManager: ObjectSaveable {
    
    static let shared: UserDefaultsManager = .init()
    
    func setObject<Object>(_ object: Object, forKey: String) throws where Object : Encodable {
        let encoder = JSONEncoder()
        
        do {
            let data = try encoder.encode(object)
            UserDefaults.standard.set(data,forKey: forKey)
        } catch {
            throw ObjectSaveableError.unableToEncode
        }
    }
    
    func getObject<Object>(forKey: String, castTo type: Object.Type) throws -> Object where Object : Decodable {
        guard let data = UserDefaults.standard.data(forKey: forKey) else { throw
            ObjectSaveableError.noValue
        }
        let decoder = JSONDecoder()
        do {
            let object = try decoder.decode(type, from: data)
            return object
        } catch {
            throw ObjectSaveableError.unableToDecode
        }
    }
    
    
}
