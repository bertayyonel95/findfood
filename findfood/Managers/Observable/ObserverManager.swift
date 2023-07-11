//
//  ObserverManager.swift
//  findfood
//
//  Created by Bertay Yönel on 10.07.2023.
//

import Foundation

final class ObserverManager {
    // MARK: Properties
    var favouriteStatusChanged: Observable<Bool> = .init(false)
    // MARK: init
    private init() {
    }
    static let shared = ObserverManager()
    // MARK: Functions
    /// Changes the favouriteStatusChanged boolean to opposite to trigger a notification.
    func changeStatus() {
        favouriteStatusChanged.value = !favouriteStatusChanged.value
    }
    /// Removes observers from the observable
    func removeObservers() {
        favouriteStatusChanged.removeAllObservers()
    }
}
