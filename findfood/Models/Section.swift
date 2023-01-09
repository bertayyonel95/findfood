//
//  Section.swift
//  findfood
//
//  Created by Bertay Yönel on 3.01.2023.
//

import Foundation


final class Section: Hashable {
    
    var id = UUID()
    let title : String
    let location : HomeCollectionViewCellViewModel
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.id == rhs.id
    }
    
    public init(title: String, location: HomeCollectionViewCellViewModel) {
        self.title = title
        self.location = location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
