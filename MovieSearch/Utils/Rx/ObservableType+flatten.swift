//
//  ObservableType+flatten.swift
//  MovieSearch
//
//  Created by Nikita Rodin on 4.12.22.
//

import RxSwift
import RxCocoa

extension ObservableType where Element: Optionable {

    /// flattens sequence to non-optional observable
    ///
    /// - Returns: flattened observable
    func flatten() -> Observable<Element.Wrapped> {
        self.filter { e in
            switch e.value {
            case .some:
                return true
            default:
                return false
            }
        }
        .map { $0.value! }
    }

}

/// Optionable protocol exposes the subset of functionality required for flatten definition
protocol Optionable {
    associatedtype Wrapped
    var value: Wrapped? { get }
}

/// extension for Optional provides the implementations for Optional enum
extension Optional: Optionable {
    var value: Wrapped? { return self }
}

extension ObservableType {
    /// maps sequence to optional type to work with subscribers expecting optional type
    func toOptional() -> Observable<Element?> {
        self.map { $0 as Element? }
    }

}
