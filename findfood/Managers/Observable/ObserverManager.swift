//
//  ObserverManager.swift
//  findfood
//
//  Created by Bertay Yönel on 10.07.2023.
//

import Foundation
// MARK: - ObserverManager
final class ObserverManager {
    // MARK: Properties
    var favouriteStatusChanged: Observable<Bool> = .init(false)
    var favouritesClicked: Observable<Bool> = .init(false)
    // MARK: init
    private init() {
    }
    static let shared = ObserverManager()
    // MARK: Functions
    /// Changes the favouriteStatusChanged boolean to opposite to trigger a notification.
    func changeStatus<T>(for observable: Observable<T>, with changedValue: T) {
        observable.value = changedValue
    }
    /// Removes observers from the observable
    func removeObservers<T>(for observable: Observable<T>) {
        observable.removeAllObservers()
    }
}
