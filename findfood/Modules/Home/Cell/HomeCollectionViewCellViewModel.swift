//
//  HomeCollectionViewCellViewModel.swift
//  findfood
//
//  Created by Bertay Yönel on 12.12.2022.
//

import Foundation

struct HomeCollectionViewCellViewModel: Hashable, Codable {
    let uuid: UUID
    let id: String
    let name: String
    let image_url: String
    let rating: String
    let price: String
    let phone: String
    let address: [String]
    
    var lastVisited: String {
        do {
            let lastVisited = try UserDefaultsManager.shared.getObject(forKey: Constant.UserDefaults.lastVisitDate, castTo: [String:String].self)
            return lastVisited[id] ?? ""
        } catch {
            return ""
        }
    }
    
    var isLiked: Bool {
        false
    }
}
