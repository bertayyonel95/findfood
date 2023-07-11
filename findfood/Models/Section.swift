//
//  Section.swift
//  findfood
//
//  Created by Bertay Yönel on 3.01.2023.
//

import Foundation


final class Section: Hashable {
    // MARK: Properties
    let location : HomeCollectionViewCellViewModel
    static func == (lhs: Section, rhs: Section) -> Bool {
        lhs.location.name == rhs.location.name
    }
    // MARK: init
    public init(location: HomeCollectionViewCellViewModel) {
        self.location = location
    }
    // MARK: Functions
    func hash(into hasher: inout Hasher) {
        hasher.combine(location.name)
    }
}
