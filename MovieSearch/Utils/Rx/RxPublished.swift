//
//  RxPublished.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import RxSwift

/// wraps a raw type property with BehaviourSubject, similar to Combine @Published
@propertyWrapper
class RxPublished<Value> {
    let projectedValue: BehaviorSubject<Value>
    var wrappedValue: Value {
        get {
            try! projectedValue.value()
        }
        set {
            projectedValue.onNext(newValue)
        }
    }

    init(wrappedValue: Value) {
        self.projectedValue = BehaviorSubject<Value>(value: wrappedValue)
    }
}
