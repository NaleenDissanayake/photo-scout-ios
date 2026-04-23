//
//  ActivityIndicator.swift
//  PhotoScout
//
//  Created by Naleen Dissanayake on 2026/04/23.
//

import Foundation
import RxCocoa
import RxSwift

private final class ActivityToken<E>: ObservableConvertibleType, Disposable {
    private let source: Observable<E>
    private let disposeAction: Cancelable

    init(source: Observable<E>, disposeAction: Cancelable) {
        self.source = source
        self.disposeAction = disposeAction
    }

    func dispose() {
        disposeAction.dispose()
    }

    func asObservable() -> Observable<E> {
        source
    }
}

final class ActivityIndicator: SharedSequenceConvertibleType {
    typealias Element = Bool
    typealias SharingStrategy = DriverSharingStrategy

    private let lock = NSRecursiveLock()
    private let relay = BehaviorRelay(value: 0)
    private let loading: Driver<Bool>

    init() {
        loading = relay
            .asDriver()
            .map { $0 > 0 }
            .distinctUntilChanged()
    }

    fileprivate func trackActivityOfObservable<O: ObservableConvertibleType>(_ source: O) -> Observable<O.Element> {
        Observable.using({ () -> ActivityToken<O.Element> in
            self.increment()
            return ActivityToken(source: source.asObservable(), disposeAction: Disposables.create(with: self.decrement))
        }, observableFactory: { token in
            token.asObservable()
        })
    }

    private func increment() {
        lock.lock()
        relay.accept(relay.value + 1)
        lock.unlock()
    }

    private func decrement() {
        lock.lock()
        relay.accept(relay.value - 1)
        lock.unlock()
    }

    func asSharedSequence() -> SharedSequence<DriverSharingStrategy, Bool> {
        loading
    }
}

extension ObservableConvertibleType {
    func trackActivity(_ activityIndicator: ActivityIndicator) -> Observable<Element> {
        activityIndicator.trackActivityOfObservable(self)
    }
}
