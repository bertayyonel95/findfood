//
//  Observer.swift
//  findfood
//
//  Created by Bertay Yönel on 10.07.2023.
//

import Foundation

final class Observer<T> {
    // MARK: Typealias
    typealias ObserverBlock = (T) -> Void
    
    // MARK: Properties
    weak var observer: AnyObject?
    
    var queue: DispatchQueue
    var block: ObserverBlock
    
    // MARK: init
    init(observer: AnyObject, queue: DispatchQueue, block: @escaping ObserverBlock) {
        self.observer = observer
        self.queue = queue
        self.block = block
    }
    // MARK: deinit
    deinit {
        print("Deinit - ONObserver: \(self)")
        observer = nil
    }
}
