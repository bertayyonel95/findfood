//
//  Observable.swift
//  findfood
//
//  Created by Bertay Yönel on 10.07.2023.
//

import Foundation

final class Observable<T> {
    // MARK: Properties
    private var observers = [Observer<T>]()

    var value: T {
        didSet {
            notifyObservers()
        }
    }

    // MARK: init
    init(_ value: T) {
        self.value = value
    }
    // MARK: Functions
    
    /// Creates and adds an observer to the observable.
    ///
    /// - Parameters:
    ///    - observer: an object that is to be notified when a change in observable occurs.
    ///    - queue: which queue the code block will be ran on. Defaults to .main
    ///    - observerBlock: escaping block that runs a code when the observer is notified.
    func observe(
        on observer: AnyObject,
        queue: DispatchQueue = .main,
        observerBlock: @escaping Observer<T>.ObserverBlock
    ) {
        observers.append(
            Observer(
                observer: observer,
                queue: queue,
                block: observerBlock
            )
        )
    }
    /// Removes the observer from the observers list.
    ///
    /// - Parameters:
    ///    - observer: observer to be removed from the list.
    func remove(observer: AnyObject) {
        observers = observers.filter({ $0.observer !== observer })
    }
    /// Removes all the current observers of the observable.
    func removeAllObservers() {
        observers = []
    }
    /// Notift observers of a change in observable.
    /// Cycles through the observable list to notify each.
    func notifyObservers() {
        observers.forEach { observer in
            observer.queue.async {
                observer.block(self.value)
            }
        }
    }
    // MARK: deinit
    deinit {
        print("Deinit - Observable: \(self)")
        observers.removeAll()
    }
}
