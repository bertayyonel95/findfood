//
//  Section.swift
//  findfood
//
//  Created by Bertay Yönel on 3.01.2023.
//

import Foundation


final class Section: Hashable {
    
    let location : HomeCollectionViewCellViewModel
    
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.location.name == rhs.location.name
    }
    
    public init(location: HomeCollectionViewCellViewModel) {
        self.location = location
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.name)
    }
}
